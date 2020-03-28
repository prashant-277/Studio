import { Injectable, Output} from '@angular/core';
import { BehaviorSubject, Observable, Subscriber } from 'rxjs';
import { environment } from '../../environments/environment'
import { Course, Subject, Note } from '../_models';
import { LocalDB } from './local-db';
import { SubjectComponent } from '../items/subject/subject.component';
import { Question } from '../_models/question';

@Injectable({
  providedIn: 'root'
})

export class StudioIOService {
  private coursesSubject: BehaviorSubject<Array<Course>>;
  public currentCourses: Observable<Array<Course>>;

  private subjectsSubject: BehaviorSubject<Array<Subject>>;
  public currentSubjects: Observable<Array<Subject>>;

  public firebase: any;
  public db: any;
  public userId: string;

  private localDb: LocalDB;

  public currentCourse: Course;
  public currentSubject: Subject;

  constructor() {
    // Initialize Firebase
    //this.firebase = window['firebase'];
    //this.firebase.initializeApp(environment.firebaseConfig);
    //this.firebase.analytics();

    this.db = new LocalDB();
    // this.db = this.firebase.firestore();

    this.coursesSubject =  new BehaviorSubject<Array<Course>>(new Array<Course>());
    this.currentCourses = this.coursesSubject.asObservable();

    this.subjectsSubject =  new BehaviorSubject<Array<Subject>>(new Array<Subject>());
    this.currentSubjects = this.subjectsSubject.asObservable();
  }

  clearCurrentSubject() {
    this.currentSubject = null;
  }

  get courses(): Array<Course> {
    return this.coursesSubject.value;
  }

  get subjects(): Array<Subject> {
    return this.subjectsSubject.value;
  }

  getQuestions(courseId: string) {
    return new Promise<Array<Question>>( (resolve, reject) => {
      this.db.collection('items').where('courseId', '==', courseId).get().then( list => {
        const questions = new Array<Question>();
        list.forEach(item => {
          const data = item.data();
          if (data.type == 'question') {
            const question = new Question();
            question.id = item.id;
            question.answer = data.answer;
            question.text = data.text;
            question.courseId = data.courseId;
            question.subjectId = data.subjectId;
            questions.push(question);
          }
        });
        resolve(questions);
      }).catch(e => {
        reject(e);
      });
    });
  }

  saveNote(note: Note) {
    return new Promise( (resolve, reject) => {
      let promise = null;
      if (note.id) {
        note.modified = new Date();
        promise = this.db.collection('items').doc(note.id).set(Object.assign({}, note));
      } else {
        note.userId = this.userId;
        promise = this.db.collection('items').add(Object.assign({}, note))
      }
      promise.then( data => {
        this.currentSubject = null;
        resolve(data);
      }).catch(e => {
        reject(e);
      });
    });
  }

  deleteNote(id: string) {
    return new Promise( (resolve, reject) => {
      this.db.collection('items').doc(id).delete().then( data => {
        this.currentSubject = null;
        resolve(data);
      }).catch(e => {
        reject(e);
      });
    });
  }

  addQuestion(question: Question) {
    return new Promise( (resolve, reject) => {
      question.userId = this.userId;
      this.db.collection('items')
            .add(Object.assign({}, question)).then( data => {
              resolve(data);
            }).catch(e => {
              reject(e);
            });
    });
  }

  deleteCourse(course: Course) {
    return new Promise( (resolve, reject) => {
      const ref = this.db.collection('courses').doc(course.id);
      ref.delete().then( () => {
        this.currentCourse = null;
        this.refreshCourses().then( () => {
          resolve();
        });
      }).catch(e => {
        reject(e);
      });
    });
  }

  deleteSubject(id: string) {
    return new Promise( (resolve, reject) => {
      const ref = this.db.collection('subjects').doc(id);
      ref.delete().then( () => {
        this.refreshCourses().then( () => {
          resolve();
        });
      }).catch(e => {
        reject(e);
      });
    });
  }

  getCourse(id: string) {
    return new Promise<Course>( (resolve, reject) => {
      if (this.currentCourse && this.currentCourse.id === id) {
        resolve(this.currentCourse);
      } else {
        this.db.collection('courses').doc(id).get().then(ss => {
          const data = ss.data();
          const course = new Course();
          course.id = ss.id;
          course.color = data.color;
          course.icon = data.icon;
          course.name = data.name;
          course.userId = this.userId;
          this.currentCourse = course;
          resolve(course);
        }).catch(e => {
          reject(e);
        });
      }
    });
  }

  getSubject(subjectId: string) {
    return new Promise<Subject>( (resolve, reject) => {
      if (this.currentSubject && this.currentSubject.id === subjectId) {
        resolve(this.currentSubject);
      } else {
        this.db.collection('subjects').doc(subjectId).get()
          .then( ss => {
            const data = ss.data();
            const subject = new Subject();
            subject.id = ss.id;
            subject.courseId = data.courseId;
            subject.name = data.name;
            subject.items = new Array<any>();

            this.db.collection('items').where('subjectId', '==', subjectId)
              .orderBy('created', 'desc').get().then( list => {
                list.forEach(ii => {
                  const itemData = ii.data();
                  if ( itemData.type === 'note' ) {
                    const note = new Note();
                    note.text = itemData.text;
                    note.id = ii.id;
                    subject.items.push(note);
                  }
                  if ( itemData.type === 'question' ) {
                    const question = new Question();
                    question.text = itemData.text;
                    question.answer = itemData.answer;
                    question.id = ii.id;
                    subject.items.push(question);
                  }
                });
                this.currentSubject = subject;
                
                resolve(subject);
            }).catch(e => {
              reject(e);
            });
          }).catch(e => {
            reject(e);
          });
        }
    });
  }

  getNote(id: string) {
    return new Promise<Note>( (resolve, reject) => {
      this.db.collection('items').doc(id).get()
        .then( ss => {
          const data = ss.data();
          const note = new Note();
          note.id = ss.id;
          note.text = data.text;
          note.courseId = data.courseId;
          note.subjectId = data.subjectId;
          resolve(note);
        }).catch(e => {
          reject(e);
        });
    });
  }

  getQuestion(id: string) {
    return new Promise<Question>( (resolve, reject) => {
      this.db.collection('items').doc(id).get()
        .then( ss => {
          const data = ss.data();
          const question = new Question();
          question.id = ss.id;
          question.text = data.text;
          question.answer = data.answer;
          question.courseId = data.courseId;
          question.subjectId = data.subjectId;
          resolve(question);
        }).catch(e => {
          reject(e);
        });
    });
  }

  refreshCourses() {
    return new Promise<Array<Course>>( (resolve, reject) => {
      this.db.collection('courses').where('userId', '==', this.userId).orderBy('name')
        .get().then(result => {
          const courses = [];
          result.forEach( item => {
            const data = item.data();
            const course = new Course();
            course.id = item.id;
            course.color = data.color;
            course.icon = data.icon;
            course.name = data.name;
            course.userId = this.userId;
            courses.push(course);
          });
          this.coursesSubject.next(courses);
          resolve(courses);
        }).catch( e => {
          reject(e);
      });
    });
  }

  refreshSubjects(courseId: string) {
    return new Promise<Array<Subject>>( (resolve, reject) => {
      this.db.collection('subjects')
                .where('courseId', '==', courseId)
                .orderBy('name').get()
                .then( (result: any[]) => {
                  const items = new Array<Subject>();
                  result.forEach(element => {
                    const data = element.data();
                    const subject = new Subject();
                    subject.id = element.id;
                    subject.name = data.name;
                    subject.items = new Array<any>();
                    items.push(subject);
                  });
                  this.subjectsSubject.next(items);
                  resolve(items);
      }).catch(e => {
        reject(e);
      });
    });
  }

  saveSubject(subject: Subject) {
    subject.userId = this.userId;

    return new Promise( (resolve, reject) => {
      let promise = null;
      if (!subject.id) {
        promise = this.db.collection('subjects').add(Object.assign({}, subject));
      } else {
        subject.modified = new Date();
        promise = this.db.collection('subjects').doc(subject.id).set(Object.assign({}, subject));
      }
      promise.then( data => {
        resolve(data);
      }).catch(e => {
        reject(e);
      });
    });
  }

  saveCourse(course: Course) {
    course.userId = this.userId;

    return new Promise( (resolve, reject) => {
      let promise = null;
      if (!course.id) {
        promise = this.db.collection('courses').add(Object.assign({}, course));
      } else {
        course.modified = new Date();
        promise = this.db.collection('courses').doc(course.id).set(Object.assign({}, course));
      }
      promise.then( data => {
        resolve(data);
      }).catch(e => {
        reject(e);
      });
    });
  }
}

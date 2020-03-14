import { Injectable, Output} from '@angular/core';
import { BehaviorSubject, Observable, Subscriber } from 'rxjs';
import { environment } from '../../environments/environment'
import { Course, Subject, Note } from '../_models';
import { LocalDB } from './local-db';

@Injectable({
  providedIn: 'root'
})

export class StudioIOService {

  private coursesSubject: BehaviorSubject<Array<Course>>;
  public currentCourses: Observable<Array<Course>>;

  public firebase: any;
  public db: any;
  public userId: string;

  private _currentCourse: Course;
  private _currentSubject: Subject;

  private localDb: LocalDB;

  constructor() {
    // Initialize Firebase
    this.firebase = window["firebase"];
    this.firebase.initializeApp(environment.firebaseConfig);
    this.firebase.analytics();

    this.db = new LocalDB();
    //this.db = this.firebase.firestore();

    this.coursesSubject =  new BehaviorSubject<Array<Course>>(new Array<Course>());
    this.currentCourses = this.coursesSubject.asObservable();
  }

  set currentCourse(course: Course) {
    this._currentCourse = course;
  }

  get currentCourse() {
    return this._currentCourse;
  }

  set currentSubject(subject: Subject) {
    this._currentSubject = subject;
  }

  get currentSubject() {
    return this._currentSubject;
  }

  get courses(): Array<Course> {
    return this.coursesSubject.value;
  }

  addNote(note: Note) {
    return new Promise( (resolve, reject) => {
      note.userId = this.userId;
      this.db.collection('items')
            .add(Object.assign({}, note)).then( data => {
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
      this.db.collection('courses').doc(id).get().then(ss => {
        const data = ss.data();
        const course = new Course();
        course.id = ss.id;
        course.color = data.color;
        course.icon = data.icon;
        course.name = data.name;
        course.userId = this.userId;
        course.subjects = new Array<Subject>();

        this.db.collection('subjects')
                .where('courseId', '==', course.id)
                .orderBy('name').get()
                .then( result => {
                  result.forEach(element => {
                    const data = element.data();
                    const subject = new Subject();
                    subject.id = element.id;
                    subject.name = data.name;
                    subject.items = new Array<any>();
                    course.subjects.push(subject);
                  });

                  resolve(course);
                }).catch(e => {
                  reject(e);
                });
      }).catch(e => {
        reject(e);
      });
    });
  }

  getSubject(subjectId: string) {
    return new Promise<Subject>( (resolve, reject) => {
      this.db.collection('subjects').doc(subjectId).get()
        .then( ss => {
          const data = ss.data();
          const subject = new Subject();
          subject.id = ss.id;
          subject.name = data.name;
          subject.items = new Array<any>();

          this.db.collection('items').where('subjectId', '==', subjectId)
            .orderBy('created', 'desc').get().then( list => {
              list.forEach(ii => {
                const itemData = ii.data();
                if( itemData.type === 'note' ) {
                  const note = new Note(itemData.note);
                  note.id = ii.id;
                  subject.items.push(note);
                }
              });
            resolve(subject);
          }).catch(e => {
            reject(e);
          });
        }).catch(e => {
          reject(e);
        });
    });
  }

  refreshCourses() {
    return new Promise<Array<Course>>( (resolve, reject) => {
      this.db.collection("courses").where('userId', '==', this.userId).orderBy('name')
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

  addSubject(subject: Subject) {
    subject.userId = this.userId;

    return new Promise( (resolve, reject) => {
      this.db.collection("subjects").add(Object.assign({}, subject)).then( data => {
        resolve(data);
      }).catch(e => {
        reject(e);
      });
    });
  }

  addCourse(course: Course) {
    course.userId = this.userId;

    return new Promise( (resolve, reject) => {
      this.db.collection("courses").add(Object.assign({}, course)).then( data => {
        resolve(data);
      }).catch(e => {
        reject(e);
      });
    });
  }
}

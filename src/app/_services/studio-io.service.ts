import { Injectable, Output} from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { environment } from '../../environments/environment'
import { Course } from '../_models';

@Injectable({
  providedIn: 'root'
})
export class StudioIOService {
  
  private coursesSubject: BehaviorSubject<[Course]>;
  public currentCourses: Observable<[Course]>;

  public firebase: any;
  public db: any;

  constructor() { 
    // Initialize Firebase
    this.firebase = window["firebase"];
    this.firebase.initializeApp(environment.firebaseConfig);
    this.firebase.analytics();

    this.db = this.firebase.firestore();

    this.coursesSubject = new BehaviorSubject<[Course]>([]);
    this.currentCourses = this.coursesSubject.asObservable();
  }

  public get courses(): [Course] {
    return this.coursesSubject.value;
  }

  deleteCourse(course: Course) {
    return new Promise( (resolve, reject) => {
      let ref = this.db.collection("users").doc(course.userId)
            .collection("courses").doc(course.id);

      ref.delete().then( () => {
        resolve();
      }).catch(e => {
        reject(e);
      });
    });
  }

  refreshCourses(userId: string) {
    return new Promise( (resolve, reject) => { 
      this.db.collection("users").doc(userId)
        .collection("courses").orderBy("name").get().then(data => {
          const courses = [];
          data.forEach( item => {
            const data = item.data();
            const course = new Course();
            course.id = item.id;
            course.color = data.color;
            course.icon = data.icon;
            course.name = data.name;
            course.userId = userId;
            course.subjects = data.subjects;
            courses.push(course);
          });
          this.coursesSubject.next(courses);
          resolve(courses);
        }).catch( e => {
          console.log(e)
          reject(e);
      });
    });
  }



  async addCourse() {

  }
}

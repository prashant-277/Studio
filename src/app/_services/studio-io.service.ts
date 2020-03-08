import { Injectable, Output} from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { environment } from '../../environments/environment'
import { User } from '../_models/user';

@Injectable({
  providedIn: 'root'
})
export class StudioIOService {

  private currentUserSubject: BehaviorSubject<User>;
  public currentUser: Observable<User>;


  public firebase: any;
  public db: any;

  private courses = null;

  constructor() { 
    // Initialize Firebase
    this.firebase = window["firebase"];
    this.firebase.initializeApp(environment.firebaseConfig);
    this.firebase.analytics();

    this.db = this.firebase.firestore();
  }

  listCourses(userId: string, force: boolean) {
    return new Promise( (resolve, reject) => {
      if(force) {
        this.courses = null;
      }

      if (this.courses != null) {
        resolve(this.courses);
      }

      this.db.collection("users").doc(userId)
      .collection("courses").orderBy("name").get().then(data => {
        this.courses = [];
        data.forEach( item => {
          const course = item.data();
          course.id = item.id;
          this.courses.push(course);
        });
        resolve(this.courses);
      }).catch( e => {
        console.log(e)
        reject(e);
      });
    });
  }



  async addCourse() {

  }
}

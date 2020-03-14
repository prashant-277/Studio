import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { StudioIOService } from './studio-io.service'
import { User } from '../_models/user';

@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {

  private currentUserSubject: BehaviorSubject<User>;
  private currentUser: Observable<User>;

  constructor(public io: StudioIOService) {
    this.currentUserSubject = new BehaviorSubject<User>(JSON.parse(localStorage.getItem('currentUser')));
    this.currentUser = this.currentUserSubject.asObservable();

    this.io.firebase.auth().onAuthStateChanged((user) => {
      if (user) {
        this.setUser(user);
      }
    });
  }

  public setUser(user: any) {
    const u = new User();
    u.id = user.uid;
    u.email = user.email;
    u.avatar = user.avatar;
    u.displayName = user.displayName;

    localStorage.setItem('currentUser', JSON.stringify(u));
    this.currentUserSubject.next(u);
    this.io.userId = u.id;
    //this.io.refreshCourses();
    this.checkDbUser();
  }

  checkDbUser() {
    let v = this.io.db.collection("users").doc(this.currentUserValue.id);
    v.get().then( doc => {
      if( doc.exists ) {
        console.log("user exists");
      } else {
        v.set({
          email: this.currentUserValue.email,
          avatar: this.currentUserValue.avatar ? this.currentUserValue.avatar : null,
          name: this.currentUserValue.displayName,
          courses: []
        }).then( () => {
          console.log("user created");
        }).catch(error => {
          console.error("Error writing document: ", error);
        });
      }
    });
  }

  public get currentUserValue(): User {
    return this.currentUserSubject.value;
  }



  logout() {
      localStorage.removeItem('currentUser');
      this.currentUserSubject.next(null);
  }
}

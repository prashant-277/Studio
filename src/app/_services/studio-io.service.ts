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

  constructor() { 
    // Initialize Firebase
    this.firebase = window["firebase"];
    this.firebase.initializeApp(environment.firebaseConfig);
    this.firebase.analytics();

    this.db = this.firebase.firestore();
  }



  async addCourse() {

  }
}

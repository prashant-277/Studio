import { Component, OnInit } from '@angular/core';
import { StudioIOService, AuthenticationService } from '../_services';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {

  constructor(private io: StudioIOService,
              private auth: AuthenticationService,
              private router: Router) { }

  signIn() {
    const provider = new this.io.firebase.auth.GoogleAuthProvider();
    this.io.firebase.auth().signInWithRedirect(provider).then( () =>{
      return this.io.firebase.auth().getRedirectResult();
    }).then((result) => {
      // This gives you a Google Access Token.
      // You can use it to access the Google API.
      var token = result.credential.accessToken;
      // The signed-in user info.
      var user = result.user;
      this.auth.setUser(user);
      // ...
    }).catch((error) => {
      // Handle Errors here.
      var errorCode = error.code;
      var errorMessage = error.message;
      alert(error);
    });
  }

  ngOnInit() {}

}

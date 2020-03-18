import { Component, OnInit } from '@angular/core';

import { Platform } from '@ionic/angular';
import { SplashScreen } from '@ionic-native/splash-screen/ngx';
import { StatusBar } from '@ionic-native/status-bar/ngx';
import { StudioIOService } from './_services/studio-io.service';
import { AuthenticationService } from './_services/authentication.service';
import { Router } from '@angular/router';
import { User } from './_models/user';
import { Course } from './_models';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss']
})
export class AppComponent implements OnInit {
  public selectedIndex = 0;
  public appPages = [
    {
      title: 'My courses',
      url: '/courses',
      icon: 'book'
    }
  ];
  user: User;
  courses: Array<Course>;

  constructor(
    private platform: Platform,
    private splashScreen: SplashScreen,
    private statusBar: StatusBar,
    private io: StudioIOService,
    private router: Router,
    private auth: AuthenticationService,
  ) {
    this.initializeApp();
    this.io.currentCourses.subscribe(data => {
      this.courses = data;
      console.log(data)
      this.courses.forEach(c => {
        this.appPages.push({
          title: c.name,
          url: '/courses/load/' + c.id,
          icon: ''
        });
      });
    });
    //this.user = auth.currentUserValue;
  }

  initializeApp() {
    this.platform.ready().then(() => {
      this.statusBar.styleLightContent();
      this.splashScreen.hide();
    });
  }

  logout() {
    this.auth.logout();
    this.router.navigate(['/login']);
  }

  ngOnInit() {
    const path = window.location.pathname.split('folder/')[1];
    if (path !== undefined) {
      this.selectedIndex = this.appPages.findIndex(page => page.title.toLowerCase() === path.toLowerCase());
    }
  }
}

import { Component, OnInit } from '@angular/core';

import { Platform } from '@ionic/angular';
import { SplashScreen } from '@ionic-native/splash-screen/ngx';
import { StatusBar } from '@ionic-native/status-bar/ngx';
import { StudioIOService } from './_services/studio-io.service';
import { AuthenticationService } from './_services/authentication.service';
import { Router, ActivatedRoute, NavigationEnd } from '@angular/router';
import { User } from './_models/user';
import { Course } from './_models';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss']
})
export class AppComponent implements OnInit {
  public selectedIndex = 0;
  public appPages = [];
  user: User;
  courses: Array<Course>;

  constructor(
    private platform: Platform,
    private splashScreen: SplashScreen,
    private statusBar: StatusBar,
    private io: StudioIOService,
    private router: Router,
    private auth: AuthenticationService,
    private route: ActivatedRoute
  ) {
    this.initializeApp();
  }

  initializeApp() {
    this.platform.ready().then(() => {
      this.statusBar.styleLightContent();
      this.splashScreen.hide();

      this.router.events.subscribe(e => {
        if(e instanceof NavigationEnd) {
          console.log('URL', e.url);
          this.buildMenu(e);
        }
      });

      this.io.currentCourses.subscribe(data => {
        this.courses = data;
      });
      this.io.refreshCourses();
    });
  }

  buildMenu(e: any) {
    console.log(e);
    this.appPages = [];
    if (e.url.startsWith('/courses')) {
      this.appPages = [];
      this.courses.forEach(c => {
        this.appPages.push({
          title: c.name,
          url: '/course/' + c.id,
          icon: 'library',
          detail: true
        });
      });
    } else if (e.url.match(/course\/(\w+)/)) {
      let m = e.url.match(/course\/(\w+)/);
      this.appPages.push({
        title: 'Test',
        url: '/course/' + m[1] + '/test',
        icon: 'library',
        detail: true
      });
    } else if (e.url.match(/subject\/(\w+)/)) {
      this.appPages = [{
        title: 'Notes',
        url: e.url + '/notes',
        icon: 'create',
        detail: false
      }, {
        title: 'Questions',
        url: e.url + '/questions',
        icon: 'help',
        detail: false
      }, {
        title: 'Mind map',
        url: '',
        icon: 'git-network',
        detail: false
      }];
    }
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

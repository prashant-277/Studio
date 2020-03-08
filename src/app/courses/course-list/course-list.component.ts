import { Component, OnInit } from '@angular/core';
import { AuthenticationService, StudioIOService } from '../../_services';
import { User, Course } from '../../_models';
import { NavController } from '@ionic/angular';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-course-list',
  templateUrl: './course-list.component.html',
  styleUrls: ['./course-list.component.scss'],
})
export class CourseListComponent implements OnInit {

  private user: User;
  private items: [Course];
  private aaa: string;

  constructor(private auth: AuthenticationService,
              public io: StudioIOService,
              public navCtrl: NavController) {
    this.user = auth.currentUserValue;
    this.io.currentCourses.subscribe(data => {
      this.items = data;
    });
  }

  ngOnInit() {
  }

  ionViewWillEnter() {
    this.io.refreshCourses(this.auth.currentUserValue.id);
  }
}

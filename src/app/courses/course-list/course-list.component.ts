import { Component, OnInit } from '@angular/core';
import { AuthenticationService, StudioIOService } from '../../_services';
import { User } from '../../_models';
import { NavController } from '@ionic/angular';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-course-list',
  templateUrl: './course-list.component.html',
  styleUrls: ['./course-list.component.scss'],
})
export class CourseListComponent implements OnInit {

  private user: User;
  public items;

  constructor(private auth: AuthenticationService,
              public io: StudioIOService,
              public navCtrl: NavController) {
    this.user = auth.currentUserValue;
  }

  ionViewWillEnter() {
    this.io.listCourses(this.auth.currentUserValue.id, true).then( data => {
      this.items = data;
    });
  }
}

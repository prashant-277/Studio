import { Component, OnInit, Output, EventEmitter } from '@angular/core';
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

  items: Array<Course>;
  @Output() open: EventEmitter<any> = new EventEmitter();

  constructor(public io: StudioIOService,
              public navCtrl: NavController) {
    this.io.currentCourses.subscribe(data => {
      this.items = data;
    });
  }

  ngOnInit() {
    this.io.refreshCourses().then(data => {
      this.items = data;
    }).catch(e => {
      console.log(e);
    });
  }
}

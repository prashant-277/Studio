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
  public items: any[];

  constructor(private auth: AuthenticationService,
              public io: StudioIOService,
              public navCtrl: NavController) {
    this.user = auth.currentUserValue;
        
    this.io.db.collection("users").doc(this.auth.currentUserValue.id)
      .collection("courses").orderBy("name").get().then(data => {
        this.items = [];
        data.forEach( item => {
          this.items.push({
            name: item.data().name
          });
        });
      }).catch( e => {
        console.log(e)
      });
  }

  ngOnInit() {}
}

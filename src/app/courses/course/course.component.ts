import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { ModalController } from '@ionic/angular';
import { AddSubjectComponent } from '../add-subject/add-subject.component';

@Component({
  selector: 'app-course',
  templateUrl: './course.component.html',
  styleUrls: ['./course.component.scss'],
})
export class CourseComponent implements OnInit {

  course;

  constructor(private route: ActivatedRoute,
              private io: StudioIOService,
              public modalController: ModalController,
              private auth: AuthenticationService) {}

  ngOnInit() {
    
  }

  ionViewWillEnter() {
    this.route.paramMap.subscribe(pdata => {
      this.io.listCourses(this.auth.currentUserValue.id).then( data => {
        this.course = data.find(c => c.id == pdata.params.id);
      });
    });
  }

  async presentNewSubject() {
    const modal = await this.modalController.create({
      component: AddSubjectComponent,
      componentProps: this.course
    });
    return await modal.present();
  }

}

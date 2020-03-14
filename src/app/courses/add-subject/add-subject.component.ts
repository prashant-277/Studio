import { Component, OnInit } from '@angular/core';
import { NavParams, ModalController, ToastController, LoadingController } from '@ionic/angular';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Subject, Course } from 'src/app/_models';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-add-subject',
  templateUrl: './add-subject.component.html',
  styleUrls: ['./add-subject.component.scss'],
})
export class AddSubjectComponent implements OnInit {

  course: Course;
  subject: string;

  constructor(public io: StudioIOService,
              private navParams: NavParams,
              public auth: AuthenticationService,
              public loadingController: LoadingController,
              public toastController: ToastController,
              public modalController: ModalController) {

  }

  async save() {
    this.subject = this.subject.trim();
    if (this.subject === '') {
      this.presentToast('Insert a valid name');
      return;
    }
    const loading = await this.loadingController.create({
      message: 'Please wait...'
    });
    await loading.present();

    const s = new Subject();
    s.name = this.subject;
    s.courseId = this.course.id;

    this.io.addSubject(s).then( () => {
      this.io.refreshCourses().then( () => {
        loading.dismiss();
        this.dismiss();
      });
    });
  }

  async presentToast(text) {
    const toast = await this.toastController.create({
      message: text,
      duration: 2000
    });
    toast.present();
  }

  dismiss() {
    this.modalController.dismiss();
  }

  ngOnInit() {
    this.course = this.navParams.get('course');
  }

}

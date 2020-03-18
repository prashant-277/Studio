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
  subject: Subject;

  constructor(public io: StudioIOService,
              private navParams: NavParams,
              public auth: AuthenticationService,
              public loadingController: LoadingController,
              public toastController: ToastController,
              public modalController: ModalController) {
    this.subject = new Subject();
  }

  ionViewWillEnter() {
    this.course = this.navParams.get('course');
    if (this.navParams.get('subject')) {
      this.subject = this.navParams.get('subject');
    }
    this.subject.courseId = this.course.id;
  }

  async save() {
    this.subject.name = this.subject.name.trim();
    if (this.subject.name === '') {
      this.presentToast('Insert a valid name');
      return;
    }
    const loading = await this.loadingController.create({
      message: 'Please wait...'
    });
    await loading.present();

    this.io.saveSubject(this.subject).then( () => {
      this.io.refreshSubjects(this.course.id).then( data => {
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

  ngOnInit() {}

}

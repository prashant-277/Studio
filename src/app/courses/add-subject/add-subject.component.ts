import { Component, OnInit } from '@angular/core';
import { NavParams, ModalController, ToastController, LoadingController } from '@ionic/angular';
import { StudioIOService, AuthenticationService } from 'src/app/_services';

@Component({
  selector: 'app-add-subject',
  templateUrl: './add-subject.component.html',
  styleUrls: ['./add-subject.component.scss'],
})
export class AddSubjectComponent implements OnInit {

  course;
  subject: string;

  constructor(private navParams: NavParams,
              public io: StudioIOService,
              public auth: AuthenticationService,
              public loadingController: LoadingController,
              public toastController: ToastController,
              public modalController: ModalController) {
    this.course = navParams.data;
    this.subject = '';
  }

  save() {
    this.subject = this.subject.trim();
    if(this.subject === '') {
      this.presentToast('Insert a valid name');
      return;
    }
    this.presentLoading();

    if (! this.course.subjects) {
      this.course.subjects = [];
    }
    
    this.course.subjects.push(this.subject);
    this.io.db.collection("users").doc(this.auth.currentUserValue.id)
        .collection("courses").doc(this.course.id).set({
          subjects: this.course.subjects
        }, { merge: true }).then( () => {
            this.io.listCourses(this.auth.currentUserValue.id, true).then( () => {
              this.dismiss();
            });
          }).catch(e => {
              console.log(e);
              this.presentToast(e);
      });
  }

  async presentLoading() {
    const loading = await this.loadingController.create({
      message: 'Please wait...',
      duration: 2000
    });
    await loading.present();

    const { role, data } = await loading.onDidDismiss();
  }

  async presentToast(text) {
    const toast = await this.toastController.create({
      message: text,
      duration: 2000
    });
    toast.present();
  }

  dismiss() {
    this.modalController.dismiss({
      'dismissed': true
    });
  }

  ngOnInit() {}

}

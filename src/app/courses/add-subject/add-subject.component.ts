import { Component, OnInit } from '@angular/core';
import { NavParams, ModalController, ToastController, LoadingController } from '@ionic/angular';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Subject } from 'src/app/_models';

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
    this.course.subjects.push(s);
    this.io.db.collection("users").doc(this.auth.currentUserValue.id)
        .collection("courses").doc(this.course.id)
        .collection("subjects").add({
          name: this.subject
        }).then( () => {
            this.io.refreshCourses(this.auth.currentUserValue.id).then( () => {
              loading.dismiss();
              this.dismiss();
            });
          }).catch(e => {
              console.log(e);
              this.presentToast(e);
      });
  }

  async presentToast(text) {
    const toast = await this.toastController.create({
      message: text
    });
    toast.present();
  }

  dismiss() {
    this.modalController.dismiss();
  }

  ngOnInit() {}

}

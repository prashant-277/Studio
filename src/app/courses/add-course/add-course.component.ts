import { Component, OnInit } from '@angular/core';
import { ToastController } from '@ionic/angular';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Router } from '@angular/router';

@Component({
  selector: 'app-add-course',
  templateUrl: './add-course.component.html',
  styleUrls: ['./add-course.component.scss'],
})
export class AddCourseComponent implements OnInit {

  name;

  constructor(public toastController: ToastController,
              public router: Router,
              public io: StudioIOService,
              public auth: AuthenticationService) {
    this.name = '';
  }

  save() {
    this.name = this.name.trim();
    if (this.name.length === 0) {
      this.presentToast('Enter the name of your course');
    } else {
      this.io.db.collection("users").doc(this.auth.currentUserValue.id)
              .collection("courses").add({
                name: this.name,
                created: new Date()
              }).then( () => {
                this.presentToast('Course saved!');
                this.router.navigate(['/courses']);
              }).catch(e => {
                console.log(e);
                this.presentToast(e);
              });
    }
  }

  async presentToast(text) {
    const toast = await this.toastController.create({
      message: text,
      duration: 2000
    });
    toast.present();
  }

  ngOnInit() {}

}

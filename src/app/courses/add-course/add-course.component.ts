import { Component, OnInit } from '@angular/core';
import { ToastController } from '@ionic/angular';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Router } from '@angular/router';
import { icons } from '../../_helpers/icons';

@Component({
  selector: 'app-add-course',
  templateUrl: './add-course.component.html',
  styleUrls: ['./add-course.component.scss'],
})
export class AddCourseComponent implements OnInit {

  name;
  icons;
  selectedIcon;
  colors;

  constructor(public toastController: ToastController,
              public router: Router,
              public io: StudioIOService,
              public auth: AuthenticationService) {
    this.name = '';
    this.selectedIcon = '';
    this.icons = icons;
    this.colors = ['#f4d1d0', '#bdd2ed', '#c9ecf2', '#dce9e9'];
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

  selectIcon(icon) {
    this.selectedIcon = icon;
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

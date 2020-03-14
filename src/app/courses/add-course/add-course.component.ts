import { Component, OnInit } from '@angular/core';
import { ToastController, LoadingController, ModalController } from '@ionic/angular';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Router } from '@angular/router';
import { icons } from '../../_helpers/icons';
import { AddSubjectComponent } from '../add-subject/add-subject.component';
import { Course } from 'src/app/_models';

@Component({
  selector: 'app-add-course',
  templateUrl: './add-course.component.html',
  styleUrls: ['./add-course.component.scss'],
})
export class AddCourseComponent implements OnInit {

  name: string;
  icons;
  selectedIcon: string;
  selectedColor: string;
  colors;
  loading;

  constructor(public toastController: ToastController,
              public router: Router,
              public io: StudioIOService,
              public auth: AuthenticationService,
              public loadingController: LoadingController) {
    this.name = '';
    this.selectedIcon = '';
    this.icons = icons;
    this.colors = ['pink', 'blue', 'green', 'aqua'];
  }

  save() {
    this.name = this.name.trim();
    if (this.name.length === 0) {
      this.presentToast('Enter the name of your course');
    } else if(this.selectedColor === '' || this.selectedIcon === '') {
      this.presentToast('Choose an icon and a color');
    } else {
      this.presentLoading();

      const course = new Course();
      course.name = this.name;
      course.icon = this.selectedIcon;
      course.color = this.selectedColor;

      this.io.addCourse(course).then( () => {
          this.io.refreshCourses().then( () => {
            this.loading.dismiss();
            this.router.navigate(['/courses']);
          });
        }).catch(e => {
          this.loading.dismiss();
          console.log(e);
          this.presentToast(e);
      });
    }
  }

  selectIcon(icon) {
    this.selectedIcon = icon;
  }

  selectColor(color) {
    this.selectedColor = color;
  }

  async presentLoading() {
    this.loading = await this.loadingController.create({
      message: 'Please wait...'
    });
    await this.loading.present();
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

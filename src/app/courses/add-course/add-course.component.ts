import { Component, OnInit } from '@angular/core';
import { ToastController, LoadingController, ModalController } from '@ionic/angular';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Router, ActivatedRoute } from '@angular/router';
import { icons } from '../../_helpers/icons';
import { AddSubjectComponent } from '../add-subject/add-subject.component';
import { Course } from 'src/app/_models';

@Component({
  selector: 'app-add-course',
  templateUrl: './add-course.component.html',
  styleUrls: ['./add-course.component.scss'],
})
export class AddCourseComponent implements OnInit {

  icons;
  course: Course;
  colors;
  loading;

  constructor(public toastController: ToastController,
              public router: Router,
              private route: ActivatedRoute,
              public io: StudioIOService,
              public auth: AuthenticationService,
              public loadingController: LoadingController) {
    this.icons = icons;
    this.colors = ['pink', 'blue', 'green', 'aqua'];
    this.course = new Course();
  }

  ionViewWillEnter() {
    this.route.paramMap.subscribe(pdata => {
      if(pdata.get('id')) {
        this.io.getCourse(pdata.get('id')).then(course => {
          this.course = this.io.currentCourse;
        }).catch(e => {
          alert(e);
        });
      }
    });
  }

  save() {
    this.course.name = this.course.name.trim();
    if (this.course.name.length === 0) {
      this.presentToast('Enter the name of your course');
    } else if(this.course.color === '' || this.course.icon === '') {
      this.presentToast('Choose an icon and a color');
    } else {
      this.presentLoading();

      this.io.saveCourse(this.course).then( () => {
          this.io.refreshCourses().then( () => {
            this.loading.dismiss();
            this.router.navigate(['/courses']);
          });
        }).catch(e => {
          this.presentToast(e);
          this.loading.dismiss();
      });
    }
  }

  selectIcon(icon) {
    this.course.icon = icon;
  }

  selectColor(color) {
    this.course.color = color;
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

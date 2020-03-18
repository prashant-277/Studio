import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Route, Router } from '@angular/router';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { ModalController, AlertController, LoadingController, ActionSheetController } from '@ionic/angular';
import { AddSubjectComponent } from '../add-subject/add-subject.component';
import { Subject, Course } from 'src/app/_models';

@Component({
  selector: 'app-course',
  templateUrl: './course.component.html',
  styleUrls: ['./course.component.scss'],
})
export class CourseComponent implements OnInit {

  course: Course;
  subjects: Array<Subject>;

  constructor(private route: ActivatedRoute,
              private io: StudioIOService,
              public router: Router,
              public modalController: ModalController,
              public loadingController: LoadingController,
              public actionSheetController: ActionSheetController,
              public alertController: AlertController) {
    this.io.currentSubjects.subscribe(data => {
      this.subjects = data;
    });
  }

  ngOnInit() {
    this.route.paramMap.subscribe(pdata => {
      this.io.refreshSubjects(pdata.get('id'));
      this.io.getCourse(pdata.get('id')).then( data => {
        this.course = data;
      }).catch(e => {
        alert(e);
      });
    });
  }

  async presentActionSheet() {
    const actionSheet = await this.actionSheetController.create({
      header: this.course.name,
      buttons: [{
        text: 'Delete',
        role: 'destructive',
        icon: 'trash',
        handler: () => {
          this.askDelete();
        }
      }, {
        text: 'Edit',
        icon: 'pencil-outline',
        handler: () => {
          this.router.navigateByUrl('/courses/edit/' + this.course.id);
        }
      },
      {
        text: 'Cancel',
        icon: 'close',
        role: 'cancel',
        handler: () => {
          console.log('Cancel clicked');
        }
      }]
    });
    await actionSheet.present();
  }

  ionViewWillEnter() {}

  async askDelete() {
    const alert = await this.alertController.create({
      header: this.course.name,
      message: 'Delete this course and all its content?',
      buttons: [{
        text: 'Cancel',
        role: 'cancel',
        cssClass: 'secondary'
      }, {
        text: 'Delete',
        handler: async () => {
          const loading = await this.loadingController.create({
            message: 'Please wait...'
          });
          await loading.present();
          this.io.deleteCourse(this.course).then( () => {
            loading.dismiss();
            this.router.navigate(['/courses']);
          });
        }
      }]
    });

    await alert.present();
  }

  async presentNewSubject() {
    const modal = await this.modalController.create({
      component: AddSubjectComponent,
      componentProps: { course: this.course }
    });
    return await modal.present();
  }

  async presentEditSubject() {
    const modal = await this.modalController.create({
      component: AddSubjectComponent,
      componentProps: { course: this.course }
    });
    return await modal.present();
  }

}

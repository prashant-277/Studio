import { Component, OnInit } from '@angular/core';
import { Course, Subject } from 'src/app/_models';
import { ActivatedRoute, Router } from '@angular/router';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { AlertController, LoadingController, NavController, ToastController, ActionSheetController } from '@ionic/angular';
import { Question } from 'src/app/_models/question';

@Component({
  selector: 'app-question',
  templateUrl: './question.component.html',
  styleUrls: ['./question.component.scss'],
})
export class QuestionComponent implements OnInit {
  course: Course;
  subject: Subject;
  question: Question;
  edit: boolean;

  constructor(
    private route: ActivatedRoute,
    public router: Router,
    private io: StudioIOService,
    private toastController: ToastController,
    private loadingController: LoadingController,
    private alertController: AlertController,
    private actionSheetController: ActionSheetController,
    private auth: AuthenticationService,
    public navCtrl: NavController
  ) {
    this.question = new Question();
    this.edit = false;
  }

  async save() {
    this.question.text = this.question.text.trim();
    if (this.question.text.length === 0) {
      this.presentToast('Enter some text');
      return;
    }

    const loading = await this.loadingController.create({
      message: 'Please wait...'
    });
    await loading.present();
    this.question.courseId = this.course.id;
    this.question.subjectId = this.subject.id;

    this.io.saveQuestion(this.question).then( () => {
      this.io.clearCurrentSubject();
      loading.dismiss();
      this.close();
    }).catch(e => {
      alert(e);
    });
  }

  close() {
    this.navCtrl.back();
  }

  async presentToast(text) {
    const toast = await this.toastController.create({
      message: text,
      duration: 2000
    });
    toast.present();
  }

  async askDelete() {
    const alert = await this.alertController.create({
      header: this.subject.name,
      message: 'Delete this question?',
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
          this.io.deleteQuestion(this.question.id).then( () => {
            loading.dismiss();
            this.router.navigate(['/questions/' + this.subject.id ]);
          });
        }
      }]
    });

    await alert.present();
  }

  async presentActionSheet() {
    const actionSheet = await this.actionSheetController.create({
      header: this.subject.name,
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
          this.edit = true;
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

  ngOnInit() {
    if (! this.io.currentCourse) {
      this.router.navigate(['/']);
      return;
    }

    this.course = this.io.currentCourse;
    this.subject = this.io.currentSubject;

    this.route.paramMap.subscribe(pdata => {
      if (!pdata.get('id')) {
        this.edit = true;
        return;
      }

      this.io.getQuestion(pdata.get('id')).then(question => {
        this.question = question;
      }).catch(e => {
        console.log(e);
        alert(e);
      });
    });
  }

}

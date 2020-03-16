import { Component, OnInit } from '@angular/core';
import { Course, Subject } from 'src/app/_models';
import { ActivatedRoute, Router } from '@angular/router';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { AlertController, LoadingController, NavController, ToastController } from '@ionic/angular';
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

  constructor(
    private route: ActivatedRoute,
    public router: Router,
    private io: StudioIOService,
    private toastController: ToastController,
    private loadingController: LoadingController,
    private auth: AuthenticationService,
    public navCtrl: NavController
  ) { 
    this.question = new Question();
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

    this.io.addQuestion(this.question).then( () => {
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

  ngOnInit() {
    if (! this.io.currentCourse) {
      this.router.navigate(['/']);
      return;
    }

    this.course = this.io.currentCourse;
    this.subject = this.io.currentSubject;

    this.route.paramMap.subscribe(pdata => {
      if (!pdata.get('id')) {
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

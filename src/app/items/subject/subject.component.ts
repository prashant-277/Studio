import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { StudioIOService } from 'src/app/_services';
import { Course, Subject, Note } from 'src/app/_models';
import { strictEqual } from 'assert';
import { ModalController, AlertController, LoadingController, NavController, IonNav, ActionSheetController } from '@ionic/angular';
import { NoteComponent } from '../note/note.component';
import { Question } from 'src/app/_models/question';
import { AddSubjectComponent } from 'src/app/courses/add-subject/add-subject.component';

@Component({
  selector: 'app-subject',
  templateUrl: './subject.component.html',
  styleUrls: ['./subject.component.scss'],
})
export class SubjectComponent implements OnInit {

  course: Course;
  subject: Subject;
  noteList: Array<Note>;
  questions: Array<Question>;
  currentView: string;
  slider: boolean;

  constructor(
    private route: ActivatedRoute,
    public router: Router,
    private io: StudioIOService,
    private alertController: AlertController,
    private loadingController: LoadingController,
    private actionSheetController: ActionSheetController,
    private modalController: ModalController,
    public navCtrl: NavController
  ) {
    this.questions = new Array<Question>();
    this.currentView = 'notes';
  }

  filter(ev) {
    this.currentView = ev.detail.value;
  }

  itemTrack(index, item) {
    return item.id;
  }

  toggleSlider() {
    this.slider = ! this.slider;
  }

  ngOnInit() {
    this.route.paramMap.subscribe(pdata => {
      this.io.getSubject(pdata.get('id')).then( subject => {
        this.subject = subject;
        this.subject.courseId = subject.courseId;
        this.subject.id = subject.id;
        this.subject.name =subject.name;
        this.noteList = new Array<Note>();
        this.questions = new Array<Question>();

        subject.items.forEach(item => {
          console.log(item.text);
          if (item.type === 'note') {
            this.noteList.push(item);
          }
          if (item.type === 'question') {
            this.questions.push(item);
          }
        });

        this.io.getCourse(this.subject.courseId).then(course => {
          this.course = course;
        }).catch(e => {
          console.log(e);
          alert(e);
        });
      }).catch(e => {
        console.log(e);
        alert(e);
      });
    });
  }

  async askDelete() {
    const alert = await this.alertController.create({
      header: this.subject.name,
      message: 'Delete this subject and all its content?',
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
          this.io.deleteSubject(this.subject.id).then( () => {
            loading.dismiss();
            this.router.navigate(['/courses/load/' + this.course.id ]);
          });
        }
      }]
    });

    await alert.present();
  }

  /*openNote(note: Note) {
    this.navCtrl.navigateForward('/note/' + note.id);
  }*/

  newNote() {
    this.navCtrl.navigateForward('/subject/' + this.subject.id + '/note');
  }

  newQuestion() {
    this.navCtrl.navigateForward('/subject/' + this.subject.id + '/question');
  }

  async presentEditSubject() {
    const modal = await this.modalController.create({
      component: AddSubjectComponent,
      componentProps: { course: this.course, subject: this.subject }
    });
    return await modal.present();
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
          this.presentEditSubject();
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
}

import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Course, Subject, Note } from 'src/app/_models';
import { strictEqual } from 'assert';
import { ModalController, AlertController, LoadingController, NavController, IonNav, ActionSheetController } from '@ionic/angular';
import { NoteComponent } from '../note/note.component';
import { Question } from 'src/app/_models/question';

@Component({
  selector: 'app-subject',
  templateUrl: './subject.component.html',
  styleUrls: ['./subject.component.scss'],
})
export class SubjectComponent implements OnInit {

  course: Course;
  subject: Subject;
  notes: Array<Note>;
  questions: Array<Question>;
  currentView: string;

  constructor(
    private route: ActivatedRoute,
    public router: Router,
    private io: StudioIOService,
    private alertController: AlertController,
    private loadingController: LoadingController,
    private actionSheetController: ActionSheetController,
    private auth: AuthenticationService,
    public navCtrl: NavController
  ) {
    this.notes = new Array<Note>();
    this.questions = new Array<Question>();
    this.currentView = 'notes';
  }

  filter(ev) {
    console.log(ev);
  }

  ionViewWillEnter() {
    console.log("subject ionViewWillEnter");
    this.notes = new Array<Note>();
    this.questions = new Array<Question>();

    this.route.paramMap.subscribe(pdata => {
      this.io.getCourse(pdata.get('courseid')).then(course => {
        this.course = course;
        this.io.getSubject(pdata.get('id')).then( subject => {
          this.subject = subject;
          this.subject.items.forEach(item => {
            if (item.type === 'note') {
              this.notes.push(item);
            }
            if (item.type === 'question') {
              this.questions.push(item);
            }
          })
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

  ngOnInit() {}

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

  openNote(note: Note) {
    this.navCtrl.navigateForward('/note/' + note.id);
  }

  newNote() {
    this.navCtrl.navigateForward('/note');
  }

  newQuestion() {
    this.navCtrl.navigateForward('/question');
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
          console.log('Edit clicked');
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

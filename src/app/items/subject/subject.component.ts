import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Course, Subject, Note } from 'src/app/_models';
import { strictEqual } from 'assert';
import { ModalController, AlertController, LoadingController } from '@ionic/angular';
import { NoteComponent } from '../note/note.component';

@Component({
  selector: 'app-subject',
  templateUrl: './subject.component.html',
  styleUrls: ['./subject.component.scss'],
})
export class SubjectComponent implements OnInit {

  course: Course;
  subject: Subject;

  constructor(
    private route: ActivatedRoute,
    public router: Router,
    private io: StudioIOService,
    private alertController: AlertController,
    private loadingController: LoadingController,
    private auth: AuthenticationService,
    public modalController: ModalController,
  ) { }

  ionViewWillEnter() {
    this.route.paramMap.subscribe(pdata => {
      this.io.getCourse(pdata.get('courseid')).then(course => {
        this.course = course;
        this.io.getSubject(pdata.get('id')).then( subject => {
          this.subject = subject;
          console.log(this.subject);
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

  async openNote(note: Note) {
    const modal = await this.modalController.create({
      component: NoteComponent,
      componentProps: { course: this.course, subject: this.subject, note }
    });
    return await modal.present();
  }

  async newNote() {
    const modal = await this.modalController.create({
      component: NoteComponent,
      componentProps: { course: this.course, subject: this.subject }
    });
    return await modal.present();
  }
}

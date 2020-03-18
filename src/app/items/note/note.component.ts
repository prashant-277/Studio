import { Component, OnInit } from '@angular/core';
import { Subject, Course, Note } from 'src/app/_models';
import { NavParams, ModalController, LoadingController, ToastController, NavController, ActionSheetController, AlertController } from '@ionic/angular';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Camera, CameraOptions } from '@ionic-native/camera/ngx';
import { ActivatedRoute, Router } from '@angular/router';


@Component({
  selector: 'app-note',
  templateUrl: './note.component.html',
  styleUrls: ['./note.component.scss'],
})
export class NoteComponent implements OnInit {

  course: Course;
  subject: Subject;
  note: Note;
  edit: boolean;

  constructor(private loadingController: LoadingController,
              private route: ActivatedRoute,
              private alertController: AlertController,
              private actionSheetController: ActionSheetController,
              private router: Router,
              private toastController: ToastController,
              private io: StudioIOService,
              private camera: Camera,
              private navCtrl: NavController) {
    this.note = new Note();
    this.edit = false;
  }

  ionViewWillEnter() {
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

      this.io.getNote(pdata.get('id')).then(note => {
        this.note = note;
      }).catch(e => {
        console.log(e);
        alert(e);
      });
    });
  }

  ngOnInit() {}

  async save() {
    this.note.text = this.note.text.trim();
    if (this.note.text.length === 0) {
      this.presentToast('Enter some text');
      return;
    }

    const loading = await this.loadingController.create({
      message: 'Please wait...'
    });
    await loading.present();
    this.note.courseId = this.course.id;
    this.note.subjectId = this.subject.id;

    this.io.saveNote(this.note).then( () => {
      loading.dismiss();
      this.close();
    }).catch(e => {
      alert(e);
    });
  }

  close() {
    this.navCtrl.navigateBack('/subjects/load/' + this.course.id + '/' + this.subject.id);
  }

  async presentToast(text) {
    const toast = await this.toastController.create({
      message: text,
      duration: 2000
    });
    toast.present();
  }

  takePhoto() {
    const options: CameraOptions = {
      quality: 100,
      destinationType: this.camera.DestinationType.FILE_URI,
      encodingType: this.camera.EncodingType.JPEG,
      mediaType: this.camera.MediaType.PICTURE,
      sourceType: this.camera.PictureSourceType.PHOTOLIBRARY
    };

    this.camera.getPicture(options).then((imageData) => {
     // imageData is either a base64 encoded string or a file URI
     // If it's base64 (DATA_URL):
     let base64Image = 'data:image/jpeg;base64,' + imageData;
    }, (err) => {
     // Handle error
    });
  }

  async askDelete() {
    const alert = await this.alertController.create({
      header: this.subject.name,
      message: 'Delete this note?',
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
          this.io.deleteNote(this.note.id).then( () => {
            loading.dismiss();
            this.router.navigate(['/subjects/load/' + this.course.id + '/' + this.subject.id ]);
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
}

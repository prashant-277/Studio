import { Component, OnInit } from '@angular/core';
import { Subject, Course, Note } from 'src/app/_models';
import { NavParams, ModalController, LoadingController, ToastController } from '@ionic/angular';
import { StudioIOService, AuthenticationService } from 'src/app/_services';
import { Camera, CameraOptions } from '@ionic-native/camera/ngx';


@Component({
  selector: 'app-note',
  templateUrl: './note.component.html',
  styleUrls: ['./note.component.scss'],
})
export class NoteComponent implements OnInit {

  course: Course;
  subject: Subject;
  note: Note;

  constructor(private navParams: NavParams,
              private loadingController: LoadingController,
              private toastController: ToastController,
              private io: StudioIOService,
              private camera: Camera,
              private modalController: ModalController) {
  }

  async save() {
    this.note.note = this.note.note.trim();
    if (this.note.note.length === 0) {
      this.presentToast('Enter some text');
      return;
    }

    const loading = await this.loadingController.create({
      message: 'Please wait...'
    });
    await loading.present();
    this.note.courseId = this.course.id;
    this.note.subjectId = this.subject.id;

    this.io.addNote(this.note).then( () => {
      loading.dismiss();
      this.close();
    }).catch(e => {
      alert(e);
    });
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

  close() {
    this.modalController.dismiss();
  }

  ngOnInit() {
    if (! this.note) {
      this.note = new Note('');
    }
  }

}

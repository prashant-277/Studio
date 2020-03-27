import { Component, OnInit } from '@angular/core';
import { Course, Note, Subject } from 'src/app/_models';
import { ActivatedRoute, Router } from '@angular/router';
import { StudioIOService } from 'src/app/_services';
import { NavController } from '@ionic/angular';

@Component({
  selector: 'app-notes',
  templateUrl: './notes.component.html',
  styleUrls: ['./notes.component.scss'],
})
export class NotesComponent implements OnInit {

  course: Course;
  subject: Subject;
  title: string;
  type: string;

  constructor(private route: ActivatedRoute,
              public router: Router,
              public navCtrl: NavController,
              private io: StudioIOService
    ) { }

  newNote() {
    this.navCtrl.navigateForward('/subject/' + this.subject.id + '/note');
  }

  newQuestion() {
    this.navCtrl.navigateForward('/subject/' + this.subject.id + '/question');
  }

  ngOnInit() {
    this.route.paramMap.subscribe(pdata => {
      this.type = pdata.get('type');

      this.title = this.type === 'notes' ? 'Notes' : 'Questions';

      this.io.getSubject(pdata.get('subjectid')).then( subject => {
        this.subject = subject;

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

}

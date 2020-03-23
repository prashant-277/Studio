import { Component, OnInit } from '@angular/core';
import { Course, Note, Subject } from 'src/app/_models';
import { ActivatedRoute, Router } from '@angular/router';
import { StudioIOService } from 'src/app/_services';

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
              private io: StudioIOService
    ) { }

  ngOnInit() {
    this.route.paramMap.subscribe(pdata => {
      this.type = pdata.get('type');

      this.title = this.type == 'notes' ? 'Notes' : 'Questions';

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

import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { StudioIOService } from 'src/app/_services';
import { Course, Subject, Item } from 'src/app/_models';

@Component({
  selector: 'app-test-start',
  templateUrl: './test-start.component.html',
  styleUrls: ['./test-start.component.scss'],
})
export class TestStartComponent implements OnInit {

  course: Course;
  subjects: Array<Subject>;
  selected: any;
  all: boolean;
  canMakeTests: boolean;
  questions: Array<Item>;

  constructor(private route: ActivatedRoute,
              private router: Router,
              private io: StudioIOService) {
                this.subjects = null;
                this.all = true;
                this.canMakeTests = false;
                this.selected = {};
                this.questions = new Array();
              }

  checkTestConditions() {
    let count = 0;
    for (const subjectId in this.selected) {
      if (this.selected[subjectId]) {
        count += this.questions.filter(q => q.subjectId === subjectId).length;
      }
    }
    this.canMakeTests = count >= 3;
  }

  questionsOf(subjectId: string) {
    return this.questions.filter(q => q.subjectId === subjectId).length;
  }

  selectAll() {
    this.subjects.forEach(s => {
      this.selected[s.id] = true;
    });
    this.checkTestConditions();
  }

  toggle($event: CustomEvent, id: string) {
    if (! this.selected[id]) {
      this.all = false;
    }
    this.checkTestConditions();
  }

  toggleAll() {
    this.subjects.forEach(s => {
      this.selected[s.id] = this.all;
    });
    this.checkTestConditions();
  }

  start() {
    this.router.navigateByUrl('/course/' + this.course.id + '/test');
  }

  ngOnInit() {
    this.route.paramMap.subscribe(pdata => {
      this.io.refreshSubjects(pdata.get('id'));
      this.io.getCourse(pdata.get('id')).then( data => {
        this.course = data;
        this.io.currentSubjects.subscribe(subjects => {
          this.io.getQuestions(this.course.id).then(questions => {
            this.questions = questions;

            subjects.forEach(s => {
              s.items = questions.filter(q => q.subjectId === s.id);
            });

            this.subjects = subjects;
            this.selectAll();
            this.checkTestConditions();
          });
        });
      }).catch(e => {
        alert(e);
      });
    });
  }

}

import { Component, OnInit } from '@angular/core';
import { Course, Item, Subject } from 'src/app/_models';
import { StudioIOService } from 'src/app/_services';
import { ActivatedRoute, Router } from '@angular/router';
import { GlobalDataService } from 'src/app/_services/global-data.service';

@Component({
  selector: 'app-test',
  templateUrl: './test.component.html',
  styleUrls: ['./test.component.scss'],
})
export class TestComponent implements OnInit {

  course: Course;
  selected: Array<Subject>;
  questions: Array<Item>;
  current: number;
  answerVisible: boolean;
  correct: number;
  progress: number;
  isTesting: boolean;
  result: string;

  constructor(private route: ActivatedRoute,
              private router: Router,
              private global: GlobalDataService,
              private io: StudioIOService) {
                this.questions = new Array();
                this.current = -1;
                this.answerVisible = false;
                this.correct = 0;
                this.progress = 0;
                this.isTesting = true;
              }


  back() {
    this.router.navigateByUrl('/course/' + this.course.id + '/test-start');
  }

  showResult() {
    this.result = Math.round( (this.correct / this.questions.length) * 100) + '%';
  }

  next() {
    if (this.current + 1 === this.questions.length) {
      this.isTesting = false;
      this.showResult();
    } else {
      this.answerVisible = false;
      this.current++;
    }
  }

  wasCorrect() {
    this.correct++;
    this.next();
  }

  wasIncorrect() {
    this.next();
  }

  start() {
    this.questions = [];
    this.selected.forEach(s => {
      this.questions = this.questions.concat(s.getQuestions());
    });
    this.current = 0;
    console.log(this.questions);
  }

  showAnswer() {
    this.answerVisible = true;
  }

  getSubject(subjectId: string) {
    return this.selected.find(s => s.id == subjectId).name;
  }

  ngOnInit() {
    this.route.paramMap.subscribe(pdata => {
      this.io.getCourse(pdata.get('id')).then( data => {
        this.course = data;
        if (! this.global.data) {
          this.back();
          return;
        }

        this.selected = this.global.data;
        this.progress = 1 / this.selected.length;
        this.start();
      }).catch(e => {
        alert(e);
      });
    });
  }

}

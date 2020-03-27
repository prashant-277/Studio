import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { StudioIOService } from 'src/app/_services';
import { Course, Subject } from 'src/app/_models';

@Component({
  selector: 'app-test',
  templateUrl: './test.component.html',
  styleUrls: ['./test.component.scss'],
})
export class TestComponent implements OnInit {

  course: Course;
  subjects: Array<Subject>;
  selected: any;
  all: boolean;

  constructor(private route: ActivatedRoute,
              private io: StudioIOService) {
                this.subjects = null;
                this.all = true;
                this.selected = {}
                this.io.currentSubjects.subscribe(data => {
                  this.subjects = data;
                  this.selectAll();
                });
              }

  selectAll() {
    this.subjects.forEach(s => {
      this.selected[s.id] = true;
    })
  }

  toggle(id: string) {
    if (! this.selected[id]) {
      this.all = false;
    }
  }

  toggleAll() {
    if (this.all) {
      this.subjects.forEach(s => {
        this.selected[s.id] = true;
      })
    }
  }

  ngOnInit() {
    this.route.paramMap.subscribe(pdata => {
      this.io.refreshSubjects(pdata.get('id'));
      this.io.getCourse(pdata.get('id')).then( data => {
        this.course = data;
        console.log(this.course)
      }).catch(e => {
        alert(e);
      });
    });
  }

}

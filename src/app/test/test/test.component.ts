import { Component, OnInit } from '@angular/core';
import { Course } from 'src/app/_models';
import { StudioIOService } from 'src/app/_services';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-test',
  templateUrl: './test.component.html',
  styleUrls: ['./test.component.scss'],
})
export class TestComponent implements OnInit {

  course: Course;

  constructor(private route: ActivatedRoute,
              private router: Router,
              private io: StudioIOService) { }


  back() {
    this.router.navigateByUrl('/course/' + this.course.id + '/test-start');
  }

  ngOnInit() {
    this.route.paramMap.subscribe(pdata => {
      this.io.refreshSubjects(pdata.get('id'));
      this.io.getCourse(pdata.get('id')).then( data => {
        this.course = data;
      }).catch(e => {
        alert(e);
      });
    });
  }

}

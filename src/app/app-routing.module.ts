import { NgModule } from '@angular/core';
import { AuthGuard } from './_helpers';
import { PreloadAllModules, RouterModule, Routes } from '@angular/router';
import { CourseListComponent } from './courses/course-list/course-list.component';
import { LoginComponent } from './login/login.component';
import { AddCourseComponent } from './courses/add-course/add-course.component';
import { CourseComponent } from './courses/course/course.component';
import { SubjectComponent } from './items/subject/subject.component';
import { NoteComponent } from './items/note/note.component';
import { QuestionComponent } from './items/question/question.component';

const routes: Routes = [
  /*{ path: '', component: CourseListComponent }, canActivate: \[AuthGuard\]*/
  { path: '', component: CourseListComponent },
  { path: 'courses/add', component: AddCourseComponent },
  { path: 'courses/edit/:id', component: AddCourseComponent },
  { path: 'courses/load/:id', component: CourseComponent },
  { path: 'subjects/load/:courseid/:id', component: SubjectComponent },
  { path: 'note', component: NoteComponent },
  { path: 'note/:id', component: NoteComponent },
  { path: 'question', component: QuestionComponent },
  { path: 'question/:id', component: QuestionComponent },
  { path: 'login', component: LoginComponent },
  { path: '**', redirectTo: '' }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes, { preloadingStrategy: PreloadAllModules })
  ],
  exports: [RouterModule]
})
export class AppRoutingModule {}

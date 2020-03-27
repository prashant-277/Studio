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
import { TestComponent } from './test/test/test.component';
import { NotesComponent } from './items/notes/notes.component';

const routes: Routes = [
  /*{ path: '', component: CourseListComponent }, canActivate: \[AuthGuard\]*/
  { path: '', component: CourseListComponent },
  { path: 'courses/add', component: AddCourseComponent },
  { path: 'courses/edit/:id', component: AddCourseComponent },
  { path: 'course/:id', component: CourseComponent },
  { path: 'course/:id/test', component: TestComponent },
  { path: 'subject/:id', component: SubjectComponent },
  { path: 'subject/:subjectid/note', component: NoteComponent },
  { path: 'subject/:subjectid/question', component: QuestionComponent },
  { path: 'subject/:subjectid/:type', component: NotesComponent },
  { path: 'note/:id', component: NoteComponent },
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

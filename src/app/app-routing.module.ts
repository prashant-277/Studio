import { NgModule } from '@angular/core';
import { AuthGuard } from './_helpers';
import { PreloadAllModules, RouterModule, Routes } from '@angular/router';
import { CourseListComponent } from './courses/course-list/course-list.component';
import { LoginComponent } from './login/login.component';
import { AddCourseComponent } from './courses/add-course/add-course.component';
import { CourseComponent } from './courses/course/course.component';

const routes: Routes = [
  { path: '', component: CourseListComponent, canActivate: [AuthGuard] },
  { path: 'courses/add', component: AddCourseComponent, canActivate: [AuthGuard] },
  { path: 'courses/load/:id', component: CourseComponent, canActivate: [AuthGuard] },
  { path: 'login', component: LoginComponent },
  { path: '**', redirectTo: '', canActivate: [AuthGuard] }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes, { preloadingStrategy: PreloadAllModules })
  ],
  exports: [RouterModule]
})
export class AppRoutingModule {}

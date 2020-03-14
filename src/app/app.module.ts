import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouteReuseStrategy } from '@angular/router';

import { IonicModule, IonicRouteStrategy } from '@ionic/angular';
import { SplashScreen } from '@ionic-native/splash-screen/ngx';
import { StatusBar } from '@ionic-native/status-bar/ngx';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { CourseListComponent } from './courses/course-list/course-list.component';
import { LoginComponent } from './login/login.component';
import { AddCourseComponent } from './courses/add-course/add-course.component';
import { FormsModule } from '@angular/forms';
import { CourseComponent } from './courses/course/course.component';
import { AddSubjectComponent } from './courses/add-subject/add-subject.component';
import { SubjectComponent } from './items/subject/subject.component';
import { NoteComponent } from './items/note/note.component';
import { Camera } from '@ionic-native/camera/ngx';

@NgModule({
  declarations: [
    AppComponent,
    CourseListComponent,
    LoginComponent,
    AddCourseComponent,
    CourseComponent,
    AddSubjectComponent,
    SubjectComponent,
    NoteComponent
  ],
  entryComponents: [
    AddSubjectComponent,
    NoteComponent
  ],
  imports: [
    BrowserModule,
    IonicModule.forRoot(),
    AppRoutingModule,
    FormsModule
  ],
  providers: [
    StatusBar,
    SplashScreen,
    Camera,
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy }
  ],
  bootstrap: [AppComponent]
})
export class AppModule {}

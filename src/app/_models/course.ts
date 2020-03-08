import { Subject } from './subject';

export class Course {
  id: string;
  userId: string;
  name: string;
  icon: string;
  color: string;
  subjects: [Subject];
}
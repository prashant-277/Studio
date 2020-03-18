import { Subject } from './subject';
import { DbItem } from './db-item';

export class Course extends DbItem {
  userId: string;
  name: string;
  icon: string;
  color: string;
  subjects: Array<Subject>;

  constructor() {
    super();
  }
}
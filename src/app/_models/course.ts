import { Subject } from './subject';
import { DbItem } from './db-item';

export class Course extends DbItem {
  id: string;
  userId: string;
  name: string;
  icon: string;
  color: string;
  subjects: Array<Subject>;
  created: Date;
  modified: Date;

  constructor() {
    super();
    this.created = new Date();
  }
}
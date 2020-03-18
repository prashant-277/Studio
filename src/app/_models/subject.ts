import { DbItem } from './db-item';

export class Subject extends DbItem {
  userId: string;
  courseId: string;
  name: string;
  items: Array<any>;

  constructor() {
    super();
  }
}
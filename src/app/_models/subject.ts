import { DbItem } from './db-item';

export class Subject extends DbItem {
  userId: string;
  courseId: string;
  name: string;
  items: Array<any>;

  constructor() {
    super();
  }

  getNotes(): Array<any> {
    if (this.items) {
      return this.items.filter(e => e.type == 'note');
    }

    return new Array<any>();
  }

  getQuestions(): Array<any> {
    if (this.items) {
      return this.items.filter(e => e.type === 'question');
    }

    return new Array<any>();
  }
}
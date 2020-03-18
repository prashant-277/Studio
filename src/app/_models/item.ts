import { DbItem } from './db-item';

export class Item extends DbItem {
  public type: string;
  public courseId: string;
  public subjectId: string;
  public userId: string;

  constructor(type: string) {
    super();
    this.type = type;
  }
}
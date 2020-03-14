export class Item {
  public id: string;
  public created: Date;
  public type: string;
  public courseId: string;
  public subjectId: string;
  public userId: string;

  constructor(type: string) {
    this.created = new Date();
    this.type = type;
  }
}
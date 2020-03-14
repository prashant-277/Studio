export class Subject {
  id: string;
  userId: string;
  courseId: string;
  name: string;
  created: Date;
  items: Array<any>;

  constructor() {
    this.created = new Date();
  }
}
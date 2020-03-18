export class DbItem {
  created: Date;
  modified: Date;
  private _data: any;
  public id: string;

  constructor() {
    this.created = new Date();
  }

  data(data: any) {
    if (data) {
      this._data = data;
    }
    return this._data;
  }
}
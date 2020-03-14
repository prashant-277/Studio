export class DbItem {
  private _data: any;
  public id: string;

  data(data: any) {
    if (data) {
      this._data = data;
    }
    return this._data;
  }
}
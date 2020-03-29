import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class GlobalDataService {

  private _data: any;

  constructor() { }

  public set data(value: any) {
    this._data = value;
  }

  public get data() {
    return this._data;
  }
}

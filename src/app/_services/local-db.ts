import { Storage } from '@ionic/storage';
import { Injectable } from '@angular/core';
import { DbItem } from '../_models/db-item';

class WhereCondition {
  field: string;
  condition: string;
  value: string;

  constructor(field: string, condition: string, value: string) {
    this.field = field;
    this.condition = condition;
    this.value = value;
  }
}

class Collection {
  prefix: string;
  orderField: string;
  orderDir = 'asc';
  storage: Storage;
  docId: string;
  condition: WhereCondition;

  makeId() {
    return Math.random().toString(36).substring(2, 15);
  }

  constructor(name: string, storage: Storage) {
    this.storage = storage;
    this.prefix = name + '-';
  }

  doc(id: string) {
    this.docId = id;
    return this;
  }

  delete() {
    return this.storage.remove(this.prefix + this.docId);
  }

  get() {
    if (this.docId) {
      return new Promise( (resolve, reject) => {
        this.storage.get(this.prefix + this.docId).then(data => {
          const item = new DbItem();
          item.id = data.id;
          item.data(data);
          resolve(item);
        }).catch(e => {
          reject(e);
        });
      });
    }

    return new Promise( (resolve, reject) => {
      const items = [];
      this.storage.forEach( (value, key) => {
        if (key.startsWith(this.prefix)) {
          if (this.condition) {
            /** TODO: dynamic condition (==, >, <, etc.) */
            if (value[this.condition.field] !== this.condition.value) {
              return;
            }
          }
          const item = new DbItem();
          item.id = value.id;
          item.data(value);
          items.push(item);
        }
      }).then( () => {
        resolve(items);
      }).catch(e => {
        reject(e);
      });
    });
  }

  set(item) {
    return this.storage.set(this.prefix + item.id, item);
  }

  add(item: any) {
      item.id = this.makeId();
      return this.storage.set(this.prefix + item.id, item);
  }

  orderBy(field: string, dir: string) {
    this.orderField = field;
    if (dir) {
      this.orderDir = dir;
    }
    return this;
  }

  where(field: string, condition: string, value: string) {
    this.condition = new WhereCondition(field, condition, value);
    return this;
  }
}

export class LocalDB {

  storage: Storage;

  public collection(c: string) {
    this.storage = new Storage({
      name: 'studio-db',
      size: 4980736,
      driverOrder: ['sqlite', 'websql', 'indexeddb']
    });
    return new Collection(c, this.storage);
  }
}
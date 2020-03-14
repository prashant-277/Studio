import { Item } from './item';

export class Note extends Item {
  note: string;

  constructor(note: string) {
    super('note');
    this.note = note;
  }
}
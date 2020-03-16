import { Item } from './item';

export class Note extends Item {
  text: string;

  constructor() {
    super('note');
  }
}
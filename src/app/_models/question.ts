import { Item } from './item';

export class Question extends Item {
  text: string;
  answer: string;

  constructor() {
    super('question');
  }
}
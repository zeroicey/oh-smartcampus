import { Message } from 'ets/models/tempModel/DataModel/Message'

export class DataSet {
  id: string;
  uid: string;
  topicId: number;
  messages: Message[];

  constructor(id: string, uid: string, topicId: number, messages: Message[] ) {
    this.id = id;
    this.uid = uid;
    this.topicId = topicId;
    this.messages = messages;
  }
}
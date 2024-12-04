
import { Message } from 'ets/models/tempModel/DataModel/Message'

//submit
export interface chatData {
  chatId: string;
  stream: boolean;
  detail: boolean;
  messages: Message[];
}

//response
export interface chatResponseData {

  id: string;
  model: string;
  usage: Usage;
  choices: Choice[];

}

class Usage {
  prompt_tokens: number;
  completion_tokens: number;
  total_tokens: number;

  constructor(prompt_tokens: number, completion_tokens: number, total_tokens: number) {
    this.prompt_tokens = prompt_tokens;
    this.completion_tokens = completion_tokens;
    this.total_tokens = total_tokens;
  }
}

class Choice {
  message: Message;
  finish_reason: string;
  index: number;

  constructor(message: Message, finish_reason: string, index: number) {
    this.message = message;
    this.finish_reason = finish_reason;
    this.index = index;
  }
}



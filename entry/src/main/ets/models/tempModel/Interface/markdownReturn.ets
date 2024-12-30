

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

class Message {
  role: string;
  content: string;

  constructor(role: string, content: string) {
    this.role = role;
    this.content = content;
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

export class markdownResponse {
  id: string;
  model: string;
  usage: Usage;
  choices: Choice[];

  constructor(id: string, model: string, usage: Usage, choices: Choice[]) {
    this.id = id;
    this.model = model;
    this.usage = usage;
    this.choices = choices;
  }
}
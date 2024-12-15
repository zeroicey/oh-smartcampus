export class ResponseMindMapData {
  message: string;
  result: Result;
  status: number;

  constructor(message: string, result: Result, status: number) {
    this.message = message;
    this.result = result;
    this.status = status;
  }
}

class Result {
  conversation_id: string;
  history_id: string;
  output: Output[];

  constructor(conversation_id: string, history_id: string, output: Output[]) {
    this.conversation_id = conversation_id;
    this.history_id = history_id;
    this.output = output;

  }
}

class Output {
  content: Content[];
  others: string; // 代替“一堆废话字段”
  apiName:string
  other:string// 代替“废话字段”
  constructor(content: Content[], others: string, apiName:string, other:string) {
    this.content = content;
    this.others = others;
    this.apiName=apiName
    this.other=other
  }
}

interface ToolCalls {
  arguments: string;
  name: string;
}

interface Content {
  tool_calls: ToolCalls;
  type: string;
  content: string;
}



export interface mindMapPostData{
  assistant_id: string;
  prompt:string;
}
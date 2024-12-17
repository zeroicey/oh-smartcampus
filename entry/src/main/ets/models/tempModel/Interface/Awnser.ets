import { chatResponseData } from "./Chat";
import { QuestionAnswer } from "./ChatQandA";


interface ResponseData {
  moduleName: string;
  moduleType: string;
  totalPoints: number;
  query: string;
  model: string;
  tokens: number;
  limit: number;
  searchMode:string;
  searchUsingRerank:boolean;
  quoteList: QuestionAnswer[];
  extensionModel: string;
  extensionResult: string;
  runningTime: number;
}

export interface AiChatResponse {
  rsponse:ResponseData[]
  data:chatResponseData
}
import { DataSet } from '../DataModel/DataSet'

export interface KeepAIChat {
  name:string
  type:number//   1 or 2  ->  1：保存 AI 笔记 , 2：保存 AI 聊天记录
  DataSet:DataSet
}

export interface KeepAIChatResponse {
  word:string
  img:Array<string>
}
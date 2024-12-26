import { Message } from "../DataModel/Message"


export interface AINotePropmtType{
  topicId:number
  topicName:string
  chatArray:Array<Message>
}

export interface NoteEditPropmtType{
  topicId:number
  topicName:string
  url:string
}

export interface ChatHistoryPropmtType{
  topicId:number
  topicName:string
}
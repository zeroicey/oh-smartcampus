interface Message {
  role: string ;
  content: string ;
}

interface AiHistory {
  _id: string;
  uid: string;
  topicId: string;
  messages: Message[];
}

export interface HistoryDetialResponse {
  success: boolean | null;
  errorCode: number | null;
  errorMsg: string | null;
  data: AiHistory;
}
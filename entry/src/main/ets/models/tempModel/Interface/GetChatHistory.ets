

export interface GotChatHistoryData{
  page?: number | null
  size?: number | null
  uid?: string | null
  topicId?: string | null
}

interface Topic {
  id: number;
  name: string;
  avatar: string;
}

export interface historyListDataItem {
  mid: string;
  topic: Topic;
  induction: string;
}

export interface GetChatHistory {
  success: boolean | null;
  errorCode: number | null;
  errorMsg: string | null;
  data: historyListDataItem[];
}
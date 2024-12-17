export interface TopicAtHome {
  success: boolean;
  errorMsg: null;
  data: Array<DataItem>;
  total: number;
}

export interface DataItem {
  id: number;
  name: string;
  attractTitle: string;
}
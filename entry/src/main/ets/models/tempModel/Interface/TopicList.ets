export interface TopicListResponse {
  success: boolean;
  errorMsg: string | null;
  data: Array<TopicItem>;
  total: number | null;
}

export interface TopicItem {
  id: number;
  name: string;
  attractTitle: string;
}
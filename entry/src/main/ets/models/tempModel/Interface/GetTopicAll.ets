export interface TopicAll {
  id: number;
  name: string;
  introduce: string;
  isSelected: boolean;
}

export interface GotTopicAll {
  success: boolean;
  data: TopicAll[];
}
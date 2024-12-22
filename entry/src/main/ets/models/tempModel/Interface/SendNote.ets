

export interface SendNoteData {
  topicId: string;
  circleId: string;
  uid: string;
  pictures: string[];
  title: string;
  word: string;
  createTime?: null | string; // 可以是 null 或字符串
}
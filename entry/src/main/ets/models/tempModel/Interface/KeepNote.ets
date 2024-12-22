


interface Context {
  pictures: string[];
  title: string;
  word: string;
}

interface CreateTime {
  $date: string;
}

interface UpdateTime {
  $date: string;
}

interface Comment {
  context: string;
  uName: string;
}

export interface keepNoteData {
  context: Context;
  uid: string;
  topicId: string;
  createTime: CreateTime;
  updateTime: UpdateTime;
  comments: Comment[];
  type: string;
  _class: string;
  circleId: string;
}
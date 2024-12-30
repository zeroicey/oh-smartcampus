export interface reEditResponse {
  success: boolean;
  errorCode: null;
  errorMsg: null;
  data: DataObject;
}

interface DataObject {
  circleId: null;
  id: string;
  pictures: string[];
  title: string;
  word: string;
  uid: string;
  topicId: string;
  createTime: string;
  updateTime: string;
  comments: null;
}
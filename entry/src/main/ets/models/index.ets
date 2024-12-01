// 输入框枚举
export enum Type {
  name = 'name',
  email = 'email',
  birth = 'birth',
  gender = 'gender',
  signature = 'signature',
  number = 'number',
  password = 'password'
}

export interface TextType {
  title: string
  type: Type
}

// 单个笔记所有内容包括信息
export interface IPublisherData {
  circleId: string;
  context: IContext;
  createTime: null;
  id: string;
  topic: Topic;
  user: IPublisher;
}

// 笔记发布者信息
export interface IPublisher {
  attendance: number; //签到
  avatar: string;
  introduction: string;
  name: string;
  praise: number; //点赞
  referral: number; //发光
  studyProgress: number; //课程进度
  uid: string;
}

// 笔记的内容
export interface IContext {
  pictures: string[];
  title: string;
  word: string;
}

// 话题
export interface Topic {
  attractTitle: string;
  id: number;
  name: string;
}

export interface IAllPublisherNotes {
  circleId: string;
  context: IContext;

  /**
   * 创建时间
   */
  createTime: string;
  id: string;

  /**
   * 话题完整对象，话题Id同时也是AI的Id，会通过他来跳转AI
   */
  topic: Topic;
}
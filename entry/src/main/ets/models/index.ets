// 用户信息
export interface User {
  address?: string;
  avatar: string;
  birthday: string;
  collegeName?: null;
  email: string;
  introduction: string;
  name: string;
  phone?: null;
  sex: number;
  token: string;
  uid: string;
}

// 笔记WaterFlow组件枚举
export enum WaterFlowType {
  message = 0, //资讯
  circle = 1, //知识圈
  myNotes = 2, //发布的笔记
  collection = 3, //收藏的笔记
  draft = 4 //草稿
}

// 输入框枚举
export enum ITextType {
  name = 'name',
  email = 'email',
  password = 'password'
}

export interface TextType {
  title: string
  type: ITextType
}

// 单个笔记所有内容包括信息
export interface IPublisherData {
  circleId: string;
  context: IContext;
  createTime: null;
  id: string;
  topic: ITopic;
  user: IPublisher;
}

// 笔记发布者信息
export interface IPublisher {
  attendance?: number; //签到
  avatar: string;
  introduction?: string;
  name: string;
  praise: number; //点赞
  referral?: number; //发光
  studyProgress?: number; //课程进度
  uid: string;
}

// 笔记的内容
export interface IContext {
  pictures: string[];
  title: string;
  word: string;
}

// 话题
export interface ITopic {
  attractTitle: string;
  id: number;
  name: string;
}

export interface IAllPublisherNotes {
  circleId: string;
  context: IContext;
  user: IPublisher
  /**
   * 创建时间
   */
  createTime: string;
  id: string;

  /**
   * 话题完整对象，话题Id同时也是AI的Id，会通过他来跳转AI
   */
  topic: ITopic;
}

export interface IAllCircle {
  circleId: string
  name: string
}

// 根据科目id获取章节
export interface IChapter {
  id: number; //章节id
  name: string; //章节名称
  questionNum: number; //题目数量
}

// 每个章节对应的题目
export interface ISubject {
  id: number, //题目id
  chapterId: string, //章节id
  content: string, //题干
  answer: string, //答案
  explanation: string, //解析
  optionsList: string[] //选项
}
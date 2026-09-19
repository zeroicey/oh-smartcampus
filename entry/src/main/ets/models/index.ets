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

// 个人中心信息
export interface IInformation {
  attendance: number; //签到数
  brightTotal: number; //获亮数
  likeTotal: number; //获赞数
  noteTotal: number; //发过的笔记数
  studyTime: string; //学习时长
}

export interface TextType {
  title: string
  type: ITextType
}

// 单个笔记所有内容包括信息
export interface IPublisherData {
  collectTotal: number; //收藏数
  commentTotal: number; //评论数
  creatorAvatar: string; //发布者头像
  creatorId: string;
  creatorName: string;
  id: string; //笔记id
  isCollect: boolean; //是否收藏
  isLike: boolean;
  likeTotal: number;
  pictures: string[]; //发布的图片
  title: string; //标题
  topicId: string;
  topicName: string;
  word: string; //内容
  isFollowingCreator: boolean //是否充电
}

// 笔记发布者信息
export interface IPublisher {
  attendance: number; //签到
  avatar: string;
  brightTotal: number; //发光
  introduction: string; //介绍
  likeTotal: number; //点赞
  name: string;
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
export interface ITopic {
  attractTitle: string;
  id: number;
  name: string;
}

// 单个话题下的所有笔记
export interface IAllPublisherNotes {
  /**
   * 页码
   */
  page: number;

  /**
   * 条数
   */
  pageSize: number;

  /**
   * 内容
   */
  rows: Rows[];

  /**
   * 总的数据条目
   */
  total: number;
}

export interface Rows {
  /**
   * 作者头像
   */
  creatorAvatar: string;

  /**
   * 作者ID
   */
  creatorId: string;

  /**
   * 作者昵称
   */
  creatorName: string;

  /**
   * 笔记ID
   */
  id: string;

  /**
   * 封面
   */
  picture: string;

  /**
   * 标题
   */
  title: string;

  /**
   * 点赞数
   */
  likeTotal: number
}

export interface IAllCircle {
  circleId: string
  name: string
  avatar: string
}

// 根据科目id获取章节
export interface IChapter {
  id: number; //章节id
  name: string; //章节名称
  questionNum: number; //题目数量
  completed: boolean; //是否完成
  lastTime: number | null; //最近练习时间
  totalStudyTime: number; //练习时间
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

// 刷题学习时间上报参数
export interface IAnswerRequest {
  answerDetails: AnswerDetail[];
  chapterId: string;
  subjectId: string;
}

// 刷题学习时间
export interface AnswerDetail {
  endTimestamp: number; //结束时间
  questionId: number; //题目id
  startTimestamp: number; //开始时间
  userAnswer: string | null; //用户答案
}

// 根据知识圈查询旗下话题AI
export interface TopicAiList {
  /**
   * ID
   */
  id: number;

  /**
   * 简介
   */
  introduce: string;

  /**
   * 话题 AI 名称
   */
  name: string;
}

// ---------------------------------------------------------------------------
// 子模块统一出口
// ---------------------------------------------------------------------------

export * from './tempModel/Interface/PageResult'

export * from './tempModel/Interface/Settings'

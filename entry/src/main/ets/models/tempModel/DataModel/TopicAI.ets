
export class TopicAI {
  id: number;
  name: string;
  introduce: string;
  attractTitle: string;
  avatar: string;
  circleId: string;
  aiKey: string;
  chapter: string;
  weight: number;
  isSelect:number
  constructor(id: number, name: string, introduce: string,attractTitle: string, avatar: string, circleId: string, aiKey: string,
    chapter: string, weight: number,isSelect:number) {
    this.id = id;
    this.name = name;
    this.introduce = introduce;
    this.attractTitle = attractTitle;
    this.avatar = avatar;
    this.circleId = circleId;
    this.aiKey = aiKey;
    this.chapter = chapter;
    this.weight = weight;
    this.isSelect = isSelect;
  }
}
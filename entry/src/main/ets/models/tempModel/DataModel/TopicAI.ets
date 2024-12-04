
export class TopicAI {
  id: number;
  title: string;
  introduce: string;
  avatar: string;
  circleId: string;
  aiKey: string;
  chapter: string;
  weight: number;

  constructor(id: number, title: string, introduce: string, avatar: string, circleId: string, aiKey: string,
    chapter: string, weight: number) {
    this.id = id;
    this.title = title;
    this.introduce = introduce;
    this.avatar = avatar;
    this.circleId = circleId;
    this.aiKey = aiKey;
    this.chapter = chapter;
    this.weight = weight;
  }
}
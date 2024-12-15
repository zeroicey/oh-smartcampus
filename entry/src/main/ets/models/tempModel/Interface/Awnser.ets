interface CQItem {
  value: string;
  key: string;
}

export interface ResponseData {
  moduleName: string;
  moduleType: string;
  totalPoints: number;
  model: string;
  query: string;
  tokens: number;
  cqList: CQItem[];
  cqResult: string;
  contextTotalLen: number;
  runningTime: number;
}
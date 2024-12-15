

interface IScore {
  type: 'embedding' | 'rrf' | 'fullText';
  value: number;
  index: number;
}

export interface QuestionAnswer {
  id: string;
  q: string;
  a: string;
  chunkIndex: number;
  datasetId: string;
  collectionId: string;
  sourceName: string;
  sourceId: string;
  score: IScore[];
}
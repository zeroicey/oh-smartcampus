



export interface QuestionAnswer {
  id:string
  q:string
  a:string
  chunkindex:number
  datasetId:string
  collectionId:string
  sourceName:string
  sourceId:string
  score:scoreItem[]
}

interface scoreItem{
  type:string
  value:number
  index:number
}

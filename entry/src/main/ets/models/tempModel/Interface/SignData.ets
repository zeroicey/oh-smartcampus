


export interface SignData{
  success:boolean
  data:data
}
interface data{
  id:string
  uid:string
  gotPoints:string
  date:string
  isFinish:string
}

export interface SignedDay{
  success:boolean
  errorCode:null
  errorMsg:null
  data:number
}
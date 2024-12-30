

export interface TokenRequest{
  api_key:string,
  api_secret:string
}

export interface GotToken{
  message:string
  result:result
  status:number
}

interface result{
  access_token:string
  expires_in:number
  token_expires:string
}
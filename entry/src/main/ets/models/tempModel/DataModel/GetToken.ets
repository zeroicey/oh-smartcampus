import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';

class GetToken {
  success: boolean;
  result: Result;
  status: number;
  constructor(success: boolean, result: Result, status: number) {
    this.success = success;
    this.result = result;
    this.status = status;
  }
}

class Result {
  access_token: string;
  expires_in: number;
  token_expires: number;

  constructor(access_token: string, expires_in: number, token_expires: number) {
    this.access_token = access_token;
    this.expires_in = expires_in;
    this.token_expires = token_expires;
  }
}

interface TokenRequest {
  apiKey: string;
  apiSecret: string;
}


export function getToken(){
     axios({
      method: 'POST',
      url: "https://chatglm.cn/chatglm/assistant-api/v1/get_token",
      data: {
        apiKey: "0c2aef874ee6de79",
        apiSecret: "c68185c59c2197017eaad9ca1ecd7c1e",
      } as TokenRequest,
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        //'Authorization':''
        'Content-Type': 'application/json'
      }
    })
      .then((response: AxiosResponse<GetToken>) => {
        console.log('GOT_Response data:', response.data.result.access_token);
        return response.data.result.access_token;
      })
      .catch((error: BusinessError) => {
        console.log('Request failed:', error)
        return error.message;
      })
}
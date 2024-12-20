import axios ,{ AxiosResponse } from "@ohos/axios";
import { BusinessError } from "@kit.BasicServicesKit";
import { Message } from "../models/tempModel/DataModel/Message";
import { DataSet } from "../models/tempModel/DataModel/DataSet";
import { AiChatResponse } from "../models/tempModel/Interface/Awnser";
import { QuestionAnswer } from "../models/tempModel/Interface/ChatQandA";
import { chatData, chatResponseData } from "../models/tempModel/Interface/Chat";
import { GetToken, TokenRequest } from "../models/tempModel/DataModel/GetToken";
import { markdownResponse } from "../models/tempModel/Interface/markdownReturn";
import { mindMapPostData, ResponseMindMapData } from "../models/tempModel/DataModel/Mindmap";
import { KeepAIChat, KeepAIChatResponse } from "../models/tempModel/Interface/KeepAIChat";
//共用Obj
let obj:chatData = {
  chatId:'',//对话id//传参
  stream: false,
  detail: true,
  messages: [new Message('','')]//对话内容//传参
} as chatData
//共用interface
interface urlObj{ url:string } //提取url用的临时对象
//共用参数
export const token :string = ''


//接口函数
//对话接口函数 //v1
export async function httpChat_axios_v1(message:string,chatId:string):Promise<Message> {
  //console.log('GOT_message:  '+message)//
  obj.chatId = chatId
  obj.messages = [new Message('user', message)]
  try {
    const response: AxiosResponse<chatResponseData> = await axios({
      method: 'POST',
      url: "http://117.72.36.183:3000/api/v1/chat/completions",
      data: obj,
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json'
      }
    });
    return response.data.choices[0].message; // 返回响应中的消息
  } catch (error) {
    console.error('Request failed:', error);
    return new Message('system', 'Error occurred during request');
  }
}
//对话接口函数 //v2
export async function httpChat_axios_v2(message:string,chatId:string): Promise<Array<QuestionAnswer>>{
  //console.log('GOT_message:  '+message)//debug
  obj.chatId = chatId
  obj.detail = true
  obj.messages = [new Message('user', message)]
  try {
    const response: AxiosResponse<AiChatResponse> = await axios({
      method: 'POST',
      url: "http://117.72.36.183:3000/api/v1/chat/completions",
      data: obj,
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json'
      }
    });
    return response.data.rsponse[0].quoteList;
  } catch (error) {
    console.error('Request failed:', error);
    return []
  }

}
//保存聊天记录/对话接口函数
export function httpKeepChat_axios(type:number,chatArray:Array<Message>,Array:Array<Message>,accessToken:string) {
  let Obj:Array<Message> = []
  if(type==1){
    Obj = chatArray//选择聊天记录
  } else if(type == 2) {
    Obj = Array//所有聊天记录
  }
  axios({
    method: 'POST',
    url: "http://117.72.36.183:3000/api/v1/chat/completions",
    data: {
      name:'heiye',
      type:1,
      DataSet:new DataSet(
        '',//id
        '',//uid
        1,//topicId
        Obj
      )
    } as KeepAIChat,
    headers: {
      'Authorization':'Bearer ' + accessToken
    }
  })
    .then((response: AxiosResponse<KeepAIChatResponse>) => {
      //TODO
      console.log('word:  '+response.data.word)
      console.log('img:  '+response.data.img)
    })
    .catch((error: BusinessError) => {
      console.error('Request failed:', error);
    })
}
//获取token接口函数
export async function httpGetToken_axios(api_key:string,api_secret:string):Promise<string> {
  try {
    const response: AxiosResponse<GetToken> = await axios({
      method: 'POST',
      url: "https://chatglm.cn/chatglm/assistant-api/v1/get_token",
      data: {
        api_key: api_key,
        api_secret: api_secret,
      } as TokenRequest,
      // headers: {
      //   // 'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
      //   // 'Authorization':'',
      //   'Content-Type': 'application/json'
      // }
    });
    return response.data.result.access_token;
  } catch (error) {
    console.error('Request failed:', error);
    // if (error.response) {
    //   // 请求已发出，但服务器响应的状态码不在2xx范围内
    //   console.error('Server responded with status:', error.response.status);
    //   console.error('Response data:', error.response.data);
    // } else if (error.request) {
    //   // 请求已发出，但未收到响应
    //   console.error('No response received:', error.request);
    // } else {
    //   // 设置请求时发生了一些事情，触发了异常
    //   console.error('Error setting up request:', error.message);
    return 'error'
  }
}
//Markdown生成接口函数
export async function httpMarkdown_axios( message:Array<Message>,chatId:string ):Promise<string>{
  obj.chatId = chatId
  obj.messages = message
  try {
    const response: AxiosResponse<markdownResponse> = await axios({
      method: 'POST',
      url: "http://117.72.36.183:3000/api/v1/chat/completions",
      data: obj,
      headers: {
        'Authorization':'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json'
      }
    })
    if(response.data.choices[0].message.content==null||response.data.choices[0].message.content==undefined){
      return '<Get null or undefined / 请求失败，请重试>'
    } else {
      return trimKnownBackticks(response.data.choices[0].message.content)
    }
  } catch (error) {
    console.log('Request failed:', error)
    return '<Get null or undefined / 请求失败，请重试>'
  }
}
//思维导图生成接口函数
export async function httpGetImg_axios(text:string,token:string):Promise<string> {
  //console.log('GOT_token: '+await getToken())
  try {
    const response: AxiosResponse<ResponseMindMapData> = await axios({
      method: 'POST',
      url: 'https://chatglm.cn/chatglm/assistant-api/v1/stream_sync',
      data: {
        assistant_id: "671cede7c216fe0625154b75",
        prompt: text
      } as mindMapPostData,
      headers: {
        'Authorization': 'Bearer ' + token
      }
    })
    return extractUrlFromJsonString(response.data.result.output[1].content[0].content)
    // this.isLoading = false//TODO
    // this.imageItems.push(url)//TODO
  } catch (error){
    console.log('ERROR_GOT_TOKEN:'+ token);
    console.log('GOT_ImgReqErr:'+ error)
    return ''
  }
}



//依赖处理方法
//消除markdown代码中的多余信息
export function trimKnownBackticks(str: string): string {
  // 定义正则表达式，匹配开头的三个反引号后跟换行符、markdown 和另一个换行符
  const startPattern = /^```\s*markdown\s*\n/;
  // 匹配结尾的三个反引号前可能有的空白字符或换行符
  const endPattern = /\n\s*```\s*$/;
  // 使用正则表达式替换方法去除指定的开头和结尾部分
  return str.replace(startPattern, '').replace(endPattern, '');
}
//从json字符串中提取url
function extractUrlFromJsonString(jsonString: string): string {
  try {
    // 尝试解析 JSON 字符串
    const jsonObject: urlObj = JSON.parse(jsonString);
    console.log('GOT_JsonObj_url:'+jsonObject.url)
    // 检查 'url' 属性是否存在并且不是空值
    if (jsonObject.url) {
      return jsonObject.url;
    } else {
      console.error("JSON 对象中不存在 'url' 属性或其值为空");
      return 'null';
    }
  } catch (error) {
    console.error("解析 JSON 字符串时出错:", error);
    return 'null';
  }
}



//公布数据
//AccessToken


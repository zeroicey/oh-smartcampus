import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { AINote_foot,AINote_content } from 'ets/views/AINote/index'
import {  ResponseMindMapData,mindMapPostData } from '../models/tempModel/DataModel/Mindmap';
import { router } from '@kit.ArkUI';
import { Message } from '../models/tempModel/DataModel/Message';
import { chatData } from '../models/tempModel/Interface/Chat';
import { markdownResponse } from '../models/tempModel/Interface/markdownReturn';
import { CustomNavBar } from '../commons/components';
import { AINotePropmtType } from '../models/tempModel/Interface/PropmtInterfaces';
import { UserInfo } from '../commons/utils';
import { User } from '../models';
import { GotToken, TokenRequest } from '../models/tempModel/Interface/AccessToken';


@Entry
@Component
export struct AINote {
  @StorageProp(UserInfo) user: User = {} as User
  @State gotPropmt:AINotePropmtType = {} as AINotePropmtType
  @State isLoading:boolean = true
  @State Text:string = ' wait for response...'//markdown
  @State ChatArray:Array<Message> = []
  @State ImageUrl:string = ''//url
  @State finishFlag:boolean = false
  @State imageItems:Array<string> = []
  @State tokenGot:string = ''
  aboutToAppear(): void {
    this.gotPropmt = router.getParams() as AINotePropmtType
    this.ChatArray = this.gotPropmt.chatArray
    this.httpGetToken_axios_beta()
  }

  build() {
    Column(){
      CustomNavBar({
          title: 'AI笔记',
          showRightIcon: false,
        })
      AINote_content({
        Text:$Text,
        TargetAI_TopicId:this.gotPropmt.topicId,
        TargetAI_circleId:this.gotPropmt.circleId,
        isLoading:$isLoading,
        ImageUrl:$ImageUrl,
        finishFlag:$finishFlag,
        imageItems:$imageItems
      })
      AINote_foot({
        url:this.ImageUrl,
        finishFlag:this.finishFlag,
        topicId:this.gotPropmt.topicId,
        topicName:this.gotPropmt.topicName
      })
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#fffcf3')
  }

  httpGetToken_axios_beta(){
    axios({
      method: 'POST',
      url: "https://chatglm.cn/chatglm/assistant-api/v1/get_token",
      data: {
        api_key: "0c2aef874ee6de79",
        api_secret: "c68185c59c2197017eaad9ca1ecd7c1e",
      } as TokenRequest,
      // headers: {
      //   // 'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
      //   // 'Authorization':'',
      //   'Content-Type': 'application/json'
      // }
    }).then((response: AxiosResponse<GotToken>) => {
      console.log('GOT_Response data:', response.data.result.access_token);
      this.tokenGot = response.data.result.access_token;
    })
      .catch((error: BusinessError) => {
        console.log('Request failed:', error)
      })
      .then(()=>{
        this.httpMarkdown_axios(this.ChatArray)
      })
  } //获取Token

  httpMarkdown_axios( message:Array<Message> ){
    axios({
      method: 'POST',
      url: "http://117.72.36.183:3000/api/v1/chat/completions",
      data: {
        chatId:'Markdown1',
        stream:false,
        detail:false,
        messages:message
      } as chatData,
      headers: {
        'Authorization':'Bearer fastgpt-jvyZtwZ4IpClMwUwAnUuOM3UE6PvM1mRlG2FYT3UDe3morn8Tsvv0h0nV',
        'Content-Type': 'application/json'
      }
    }).then((response: AxiosResponse<markdownResponse>) => {
        if(response.data.choices[0].message.content==null){
          this.Text = '<Get null or undefined / 请求失败，请重试>'
        } else if (response.data.choices[0].message.content==undefined) {
          this.Text = '输入的内容意义不明，无法生成ai笔记。'
        } else {
          this.Text = trimKnownBackticks(response.data.choices[0].message.content)
        }
      })
      .catch((error: BusinessError) => {
        console.error('Request failed:', error);
        this.Text = '<Get null or undefined / 请求失败，请重试>'
      })
      .then(()=>{
        this.httpGetImg_axios(this.Text)
      })

  } //请求生成Markdown
  httpGetImg_axios(text:string) {
    //console.log('GOT_token: '+await getToken())
    axios({
      method: 'POST',
      url: 'https://chatglm.cn/chatglm/assistant-api/v1/stream_sync',
      data:{
        assistant_id:"671cede7c216fe0625154b75",
        prompt:text
      } as mindMapPostData,
      headers: {
        'Authorization':'Bearer ' + this.tokenGot
      }
    })
      .then((response: AxiosResponse<ResponseMindMapData>) => {
        this.ImageUrl = extractUrlFromJsonString(response.data.result.output[1].content[0].content)
        this.isLoading = false
        this.imageItems.push(this.ImageUrl)
      })
      .catch((err:BusinessError)=>{
        console.log('GOT_ImgReqErr:'+err.message)
      })
  } //依据获取的Token和Markdown，请求图片
}
interface urlObj{ url:string } //提取url用的临时对象
function trimKnownBackticks(str: string): string {
  // 定义正则表达式，匹配开头的三个反引号后跟换行符、markdown 和另一个换行符
  const startPattern = /^```\s*markdown\s*\n/;
  // 匹配结尾的三个反引号前可能有的空白字符或换行符
  const endPattern = /\n\s*```\s*$/;
  // 使用正则表达式替换方法去除指定的开头和结尾部分
  return str.replace(startPattern, '').replace(endPattern, '');
} //去除markdown中的多余信息
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
} //截取url
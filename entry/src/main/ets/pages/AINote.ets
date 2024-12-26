import {SpinKit,SpinType} from '@pura/spinkit'

import axios, { AxiosResponse } from '@ohos/axios';
import { GetToken, TokenRequest } from 'ets/models/tempModel/DataModel/GetToken'
import { BusinessError } from '@kit.BasicServicesKit';
import { AINote_foot } from 'ets/views/AINote/AINote_foot'
import { AINote_content } from 'ets/views/AINote/AINote_content'
import {  ResponseMindMapData,mindMapPostData } from '../models/tempModel/DataModel/Mindmap';
import { router } from '@kit.ArkUI';
import { Message } from '../models/tempModel/DataModel/Message';
import { chatData } from '../models/tempModel/Interface/Chat';
import { markdownResponse } from '../models/tempModel/Interface/markdownReturn';
import { lvMarkdownIn, lvText, lvTitle } from '@luvi/lv-markdown-in'
import { CustomNavBar } from '../commons/components';
import { httpGetImg_axios, httpGetToken_axios, httpMarkdown_axios } from '../views/HttpRequests';
//import { TopicAll } from '../models/tempModel/Interface/GetTopicAll';
import { AINotePropmtType } from '../models/tempModel/Interface/PropmtInterfaces';

lvText.setTextSize(20)
lvTitle.setLevel1Title(25)
lvTitle.setLevel2Title(23)
lvText.setTextColor('#ffffff')



@Entry
@Component
export struct AINote {
  @State gotPropmt:AINotePropmtType = {} as AINotePropmtType
  //@State gotItem:TopicAll = {} as TopicAll
  @State isLoading:boolean = true
  @State Text:string = ' wait for response...'//markdown
  @State ChatArray:Array<Message> = []
  @State TargetAI_topic:string = 'TOPIC'
  @State ImageUrl:string = ''//url
  @State tokenGot:string = ''//token
  @State finishFlag:boolean = false
  @State imageItems:Array<string> = []

  aboutToAppear(): void {
    this.gotPropmt = router.getParams() as AINotePropmtType
    this.ChatArray = this.gotPropmt.chatArray
    this.httpGetToken_axios_beta()
  }

  build() {
    Column(){
      //AINote_head()
        CustomNavBar({
          title: 'AI笔记',
          showRightIcon: false,
          // onClickBack:()=>{
          //   //
          //   //console.log('GOT_onClickBack_Response')//debug
          // }
        })

      AINote_content({
        Text:$Text,
        TargetAI_topic:$TargetAI_topic,
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
    .backgroundColor('#353242')
  }

    // request(){
    //    httpGetToken_axios('0c2aef874ee6de79','c68185c59c2197017eaad9ca1ecd7c1e')
    //      .then((value)=>{
    //        this.tokenGot = value
    //        console.log('GOT_token: '+this.tokenGot)
    //      })
    //        .then(()=>{
    //          httpMarkdown_axios(this.ChatArray,'Markdown1').then((value)=>{
    //            this.Text = value
    //            console.log('GOT_Text: '+this.Text)
    //          })
    //        })
    //          .then(()=>{
    //            httpGetImg_axios(this.Text,this.tokenGot).then((value)=>{
    //              this.ImageUrl = value
    //              console.log('GOT_ImgUrl_content:'+this.ImageUrl)
    //            })
    //              .then(()=>{
    //                this.isLoading = false
    //                this.imageItems.push(this.ImageUrl)
    //              })
    //          })


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
    }).then((response: AxiosResponse<GetToken>) => {
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
          //console.log('GOT_DealedText: ' + this.Text)
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
        console.log('GOT_ImgUrl_content:'+this.ImageUrl)
        this.isLoading = false
        this.imageItems.push(this.ImageUrl)
      })
      .catch((err:BusinessError)=>{
        console.log('ERROR_GOT_TOKEN:'+this.tokenGot);
        console.log('ERROR_GOT_Text:'+this.Text)
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
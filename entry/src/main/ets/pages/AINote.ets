import {SpinKit,SpinType} from '@pura/spinkit'

import axios, { AxiosResponse } from '@ohos/axios';
import { getToken } from 'ets/models/tempModel/DataModel/GetToken'
import { BusinessError } from '@kit.BasicServicesKit';
import { AINote_head } from 'ets/views/AINote/AINote_head'
import { AINote_foot } from 'ets/views/AINote/AINote_foot'
import { AINote_content } from 'ets/views/AINote/AINote_content'
import {  ResponseMindMapData,mindMapPostData } from '../models/tempModel/DataModel/Mindmap';
import { router } from '@kit.ArkUI';
import { Message } from '../models/tempModel/DataModel/Message';
import { chatData } from '../models/tempModel/Interface/Chat';
import { markdownResponse } from '../models/tempModel/Interface/markdownReturn';
import { lvMarkdownIn, lvText, lvTitle } from '@luvi/lv-markdown-in'
lvText.setTextSize(20)
lvTitle.setLevel1Title(25)
lvTitle.setLevel2Title(23)
lvText.setTextColor('#ffffff')
@Entry
@Component
export struct AINote {
  @State isLoading:boolean = true
  @State Text:string = ' wait for response...'//markdown
  @State ChatArray:Array<Message> = (router.getParams() as Array<Message> )['chatArray']
    // 'SpinKit 是一个适用于OpenHarmony/HarmonyOS的加载动画库。\n' +
    // '\n' +
    // 'harmony-utils 一款功能丰富且极易上手的HarmonyOS工具库，借助众多实用工具类，致力于助力开发者迅速构建鸿蒙应用。\n' +
    // '\n' +
    // 'harmony-dialog 一款极为简单易用的零侵入弹窗，仅需一行代码即可轻松实现，无论在何处都能够轻松弹出。'
  @State TargetAI_topic:string = 'TOPIC'
  @State ImageUrl:string = ''//url

  aboutToAppear(): void {
    console.log('GOT_Text: ' + this.Text)
    //console.log('GOT_Inf:'+(router.getParams() as string)['chatArray_string'])//未接收到传值
    this.httpMarkdownCrater_axios(this.ChatArray)//markdown生成

    console.log('GOT_Text: ' + this.Text)
  }

  build() {
    Column(){
      AINote_head()
      AINote_content({
        Text:$Text,
        TargetAI_topic:$TargetAI_topic,
        isLoading:$isLoading,
        ImageUrl:$ImageUrl,
      })
      AINote_foot()
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#353242')
  }
  async httpGetImg_axios(text:string) {
    //console.log('GOT_token: '+await getToken())
      axios({
        method: 'POST',
        url: 'https://chatglm.cn/chatglm/assistant-api/v1/stream_sync',
        data:{
          assistant_id:"671cede7c216fe0625154b75",
          prompt:text
        } as mindMapPostData,
        headers: {
          'Authorization':'Bearer' + await getToken()
        }
      })
        .then((response: AxiosResponse<ResponseMindMapData>) => {
          this.ImageUrl = response.data.result.output[0].content[0].content
          this.isLoading = false
        })
        .catch((err:BusinessError)=>{
          console.log(err.message)
        })
  }

  httpMarkdownCrater_axios( message:Array<Message> ){
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
    })
      .then((response: AxiosResponse<markdownResponse>) => {
        if(response.data.choices[0].message.content==null||response.data.choices[0].message.content==undefined){
          this.Text = '<Get null or undefined / 请求失败，请重试>'
        } else {
          this.Text = trimKnownBackticks(response.data.choices[0].message.content)
        }
      })
      .catch((error: BusinessError) => {
        this.Text = JSON.stringify(error);
        console.error('Request failed:', error);
      })
      .then(() => {
        this.httpGetImg_axios(this.Text)
      })
  }

}


function trimKnownBackticks(str: string): string {
  // 已知每个字符串以 ``` 开头和结尾，所以直接切片去掉开头和结尾的三个字符
  return str.length > 6 ? str.slice(3, -3) : '';
}
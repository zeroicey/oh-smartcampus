import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
//数据模型
import { Message } from 'ets/models/tempModel/DataModel/Message';
import { DataSet } from 'ets/models/tempModel/DataModel/DataSet'
import { TopicAI } from 'ets/models/tempModel/DataModel/TopicAI'
//接口
import { chatData , chatResponseData } from 'ets/models/tempModel/Interface/Chat';
import { AIhttpReq } from '../../../utils/AIhttp';
import { logger } from '../../../utils';
import { http } from '@kit.NetworkKit';
import { stream } from '@kit.ArkTS';

@Component
export struct TypeIn_box {
  @Link isVisible_CheckBox: boolean
  @Link Array: Array<Message>
  @Link message: string
  @Link isVisible_head: boolean
  @Link tail_height: number
  @Link Tail_height: number

  build() {
    Row({ space: 20 }) {
      Blank().width(0)

      TextInput({ placeholder: 'Enter any message>', text: $$this.message })
        .width('70%')
        .height(40)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#eae8f6')

      Image($rawfile('icon/send.png'))
        .width(30)
        .onClick(() => {
          if (this.message == '') {
            promptAction.showToast({ message: "输入内容不可为空" })
          } else {
            this.Array.push(new Message('user', this.message))//将对象填入渲染数组
            this.httpData_axios(this.message)
            this.message = "" // 清空输入框里的内容
          }
        })
    }
    .backgroundColor('#9893b1')
    .borderRadius(30)
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
  }

  // async httpData_axios(chatData: chatData): Promise<void> {
  //   try {
  //     let res=await AIhttpReq.request<chatResponseData[],chatData>({
  //       url: 'http://117.72.36.183:3000/api/v1/chat/completions',
  //       method: 'POST',
  //       data: chatData,
  //       headers: {
  //         'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
  //         'Content-Type': 'application/json'
  //       }
  //     })
  //     promptAction.showToast({message:'1111111111111111'})
  //     // let Return = res
  //     // const In: Message = new Message('assistant', Return.choices[0].message.content);
  //     // this.Array.push(In);
  //   } catch (error) {
  //     console.log(error)
  //   }
  // }

  // async httpData_axios(chatData: chatData): Promise<void> {
  //   axios({
  //     method: 'POST',
  //     url: "http://117.72.36.183:3000/api/v1/chat/completions",
  //     data: chatData,
  //     headers: {
  //       'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
  //       'Content-Type': 'application/json'
  //     }
  //   })
  //     .then((response: AxiosResponse<chatResponseData>) => {
  //       this.Array.push(response.data.choices[0].message);//填入渲染数组
  //     })
  //     .catch((error: BusinessError) => {
  //       console.error('Request failed:', error);
  //     })
  // }

  httpData_axios(message:string): void {
    console.log('GOT_message:  '+message)//
    let obj: chatData = {
      chatId:'sbsbsbsbsbsb',
      stream: false,
      detail: false,
      messages: [new Message('user', message)]
    } as chatData
    console.log('GOT_RUN_HERE1')//
    axios({
      method: 'POST',
      url: "http://117.72.36.183:3000/api/v1/chat/completions",
      data: obj,
      //responseType: 'json',
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json',
        //'Upgrade':'websocket'
      },

    })
      .then((response: AxiosResponse<chatResponseData>) => {
        console.log(JSON.stringify(response.data))
        this.Array.push(response.data.choices[0].message); //填入渲染数组
      })
      .catch((error: BusinessError) => {
        console.error('Request failed:', error);
      })
  }
}




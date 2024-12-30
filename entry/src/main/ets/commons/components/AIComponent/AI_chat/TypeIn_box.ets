import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { Message } from 'ets/models/tempModel/DataModel/Message';
import { chatData } from 'ets/models/tempModel/Interface/Chat';
import { QuestionAnswer } from '../../../../models/tempModel/Interface/ChatQandA';
import { AiChatResponse } from '../../../../models/tempModel/Interface/Awnser';


@Component
export struct TypeIn_box {
  @Link isVisible_CheckBox: boolean
  @Link Array: Array<Message>
  @Link message: string
  @Link isVisible_head: boolean
  @Link tail_height: number
  @Link Tail_height: number
  @Link sourceArr: Array<QuestionAnswer>

  build() {
    Row({ space: 20 }) {
      Blank().width(0)

      TextInput({ placeholder: '输入点什么试试 >', text: $$this.message })
        .width('70%')
        .height(40)
        .fontSize(20)
        .fontColor('#16151a')
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#eae8f6')

      Image($rawfile('icon/send.png'))
        .width(30)
        .onClick(async () => {
          if (this.message == '') {
            promptAction.showToast({ message: "输入内容不可为空" })
          } else {
            this.Array.push(new Message('user', this.message)) //将对象填入渲染数组
            this.httpChat_axios_v2(this.message, 'sbsbsbsb')
            this.message = "" // 清空输入框里的内

          }
        })
    }
    .backgroundColor('#313035')
    .borderRadius(30)
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
  }

  httpChat_axios_v2(message: string, chatId: string): void {
    axios({
      method: 'POST',
      url: "http://117.72.36.183:3000/api/v1/chat/completions",
      data: {
        chatId: chatId, //对话id//传参
        stream: false,
        detail: true,
        messages: [new Message('user', message)]//对话内容//传参
      } as chatData,
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json'
      }
    }).then((response: AxiosResponse<AiChatResponse>) => {
      this.Array.push(response.data.choices[0].message) //填入渲染
      this.sourceArr = response.data.rsponse[0].quoteList //获取source以及q&a
    }).catch((error: BusinessError) => {
      console.error('Request failed:', error);
    })
  }

  //TODO(webSocket数据传输，后续开发加入)
  // webSocketChatData(sendMessage: string,ip:string) {
  //   let defaultIpAddress = "ws://" + ip;
  //   let ws = webSocket.createWebSocket();
  //   //链接服务
  //   ws.connect(defaultIpAddress, (err: BusinessError, value: boolean) => {
  //     if (!err) {
  //       console.log("Connected successfully");
  //     } else {
  //       console.log("Connection failed. Err:" + JSON.stringify(err));
  //     }
  //   });
  //
  //   ws.on('open', (err: BusinessError, value: Object) => {
  //     console.log("on open, status:" + JSON.stringify(value));
  //     // 当收到on('open')事件时，可以通过send()方法与服务器进行通信
  //     ws.send(sendMessage, (err: BusinessError, value: boolean) => {
  //       if (!err) {
  //         console.log("Message sent successfully");
  //       } else {
  //         console.log("Failed to send the message. Err:" + JSON.stringify(err));
  //       }
  //     });
  //   });
  //   //订阅消息事件
  //   ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
  //     console.log("on message, message:" + value);
  //     this.Array.push(new Message('assistant', value.toString()))
  //     // 当收到服务器的`bye`消息时（此消息字段仅为示意，具体字段需要与服务器协商），主动断开连接
  //     if (value === 'bye') {
  //       ws.close((err: BusinessError, value: boolean) => {
  //         if (!err) {
  //           console.log("Connection closed successfully");
  //         } else {
  //           console.log("Failed to close the connection. Err: " + JSON.stringify(err));
  //         }
  //       });
  //     }
  //   });
  //   //订阅关闭事件
  //   ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
  //     console.log("on close, code is " + value.code + ", reason is " + value.reason);
  //   });
  //   //订阅错误
  //   ws.on('error', (err: BusinessError) => {
  //     console.log("on error, error:" + JSON.stringify(err));
  //   });
  // }
}



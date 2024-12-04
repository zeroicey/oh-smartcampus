import { roseChart } from 'ets/commons/utils/chart'
import { chatData,chatResponseData } from 'ets/models/tempModel/Interface/Chat';
import { lvMarkdownIn, lvText, lvTitle } from '@luvi/lv-markdown-in';
import { Message } from 'ets/models/tempModel/DataModel/Message';
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import WebSocket from '@ohos.net.webSocket';
@Entry
@Component
export struct App {
  @State currentTxt: string = ''
  @State re: Message= new Message('', '')
  @State message :string=''
  build() {

    Column({space:30}) {
      Column(){
        lvMarkdownIn({ text: this.re.content })
      }
      .width('90%')
      .height('50%')
      .backgroundColor('#9893b1')

      TextInput({ placeholder: 'Enter any message>', text: $$this.message })
        .width('70%')
        .height(40)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#eae8f6')
        .onChange((value)=>{
          this.message=value
        })

        Button('enter')
          .onClick(()=>{
            this.httpData_axios(this.message)
          })
    }
    .width('100%')
    .height('100%')
  }

  async httpData_axios(message:string): Promise<void> {
    //console.log('GOT_message:  '+message)//
    let obj: chatData = {
      chatId:'',
      stream: true,
      detail: true,
      messages: [new Message('user', message)]
    } as chatData
    //console.log('GOT_RUN_HERE1')//
    axios({
      method: 'POST',
      url: "http://117.72.36.183:3000/api/v1/chat/completions",
      data: obj,
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json'
      }
    })
      .then((response: AxiosResponse<chatResponseData>) => {
        this.re=response.data.choices[0].message; //填入渲染数组
      })
      .catch((error: BusinessError) => {
        console.error('Request failed:', error);
      })
  }

}



// // 假设你有一个类或模块来管理 WebSocket 连接
// class WebSocketClient {
//   private socket: WebSocket;
//   private messageArray: any[] = []; // 用于存储接收到的消息
//
//   constructor() {
//     this.initializeWebSocket();
//   }
//
//   private initializeWebSocket() {
//     // 创建 WebSocket 连接
//     this.socket = new WebSocket('ws://117.72.36.183:3000/api/v1/chat/completions');
//
//     // 当连接打开时触发
//     this.socket.onopen = (event) => {
//       console.log('WebSocket connection opened');
//       this.sendMessageToServer();
//     };
//
//     // 当从服务器接收到消息时触发
//     this.socket.onmessage = (event) => {
//       const data = event.data;
//       console.log('Received chunk:', data);
//       // 处理接收到的数据块
//       this.messageArray.push(data); // 将数据块添加到渲染数组中
//       // 你可以在这里更新 UI 或进行其他处理
//     };
//
//     // 当连接关闭时触发
//     this.socket.onclose = (event) => {
//       console.log('WebSocket connection closed');
//     };
//
//     // 当发生错误时触发
//     this.socket.onerror = (error) => {
//       console.error('WebSocket error:', error);
//     };
//   }
//
//   private sendMessageToServer(message: string = 'Hello, Server!') {
//     // 发送初始消息到服务器
//     const obj: chatData = {
//       chatId: 'sbsbsbsbsbsb',
//       stream: true,
//       detail: false,
//       messages: [{
//         role: 'user',
//         content: message
//       }]
//     };
//
//     this.socket.send(JSON.stringify(obj));
//   }
// }
//
// // 使用 WebSocketClient 类
// const client = new WebSocketClient();


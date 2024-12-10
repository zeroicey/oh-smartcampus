


@Entry
@Component
export struct Scan {
  build() {
    Column() {//debug
      Blank().height('45%')
      Text('扫描Scan-Scan')
        .fontSize(40)
        .fontColor('#5effea')
    }
    .width('100%')
    .height('100%')
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


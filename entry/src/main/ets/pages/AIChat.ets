
//引用库方法
import { image } from '@kit.ImageKit';
import { curves,router} from '@kit.ArkUI';
import {SpinKit,SpinType} from '@pura/spinkit'
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
//数据模型
import { Message } from 'ets/models/tempModel/DataModel/Message';
import { DataSet } from 'ets/models/tempModel/DataModel/DataSet'
import { TopicAI } from 'ets/models/tempModel/DataModel/TopicAI'
//接口
import { chatData,chatResponseData } from 'ets/models/tempModel/Interface/Chat';

import { UserItem } from 'ets/commons/components/AIComponent/AI_chat/AI_chat_ListItem/User_Item'
import { AI_Item } from 'ets/commons/components/AIComponent/AI_chat/AI_chat_ListItem/AI_item';//AI聊天项
import { TypeIn_box } from 'ets/commons/components/AIComponent/AI_chat/TypeIn_box'//底部输入框
import { OperateBox } from 'ets/commons/components/AIComponent/AI_chat/Operate_box'//底部操作框
//import { UploadWindow } from 'ets/components/AI_chat/Upload_window'//上传窗口组件
//import { chatData ,DataSet,returnData} from 'ets/model/ChatData';

//数据测试：给我一串简单的java代码
@Entry
@Component
export struct Chat {

  //@State firstMessage: TopicAI = (router.getParams() as Record<number, Object>)['item'] as TopicAI
  @State firstMessage: TopicAI = new TopicAI(1, 'java', 'java', 'avator', '1', 'java', 'java', 1)//Mock
  @State firstText: string = this.firstMessage.title//话题的ai介绍
  @State time: string = new Date().toLocaleString()//get//debug//这里目前引用当前时间
  @State Array: Array<Message> = []//渲染对象数组
  @State message: string = ''//输入框输入的内容
  @StorageLink('userAvatar')
  pic:Resource|image.PixelMap = $rawfile('other/Mock/Enpty.png')//get
  //隐藏控制
  @State isVisible_head: boolean = false
  @State isVisible_CheckBox: boolean = true
  @State textAuto:boolean = false
  @State checkCount: number = 0//勾选框勾选计数
  @State chatArray: Array<Message> = []//勾选对象数组
  @State onClickUpload:number=1//点击上传
  @State allchecked: boolean = false//checkbox全选
  //动画
  @State head_height:number = 0
  @State tail_height:number = 200
  @State Tail_height:number = 0
  //滚动到最下
  private scrollerForScroll: Scroller = new Scroller()
  //ai对话回答等待加载
  //@State lastItemRole:string|undefined = this.Array[this.Array.length - 1].role//判断最后一位的角色

  aboutToAppear(): void {
    this.onClickUpload=1
  }

  // //标题头动画：出现
  // animation_head_appear(): void {
  //   animateTo({ duration: 500, curve: Curve.Smooth }, () => {
  //     this.head_height = 0
  //   })
  // }
  //
  // //标题头动画：消失
  // animation_head_disappear(): void {
  //   animateTo({ duration: 500, curve: Curve.Smooth }, () => {
  //     this.head_height = -400
  //   })
  // }


  //底部动画：出现
  animation_Tail_appear(): void {
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.Tail_height = 0
    })
  }

  build() {
    Stack() {
      Column() {
        Blank().height(50)
        Row({space: 20}){
          Blank().width(10)
          Image($rawfile('icon/backIcon.png'))
            .width(30)
            .height(40)
            .onClick(()=>{
              router.back()
            })
          Text(this.firstMessage.title)
            .fontColor(Color.White)
            .fontSize(25)
            .fontWeight(FontWeight.Bolder)
          Image($rawfile('icon/DealAIChat.png'))
            .width(30)
            .height(30)
            .margin({ left: 140 })
            .onClick(()=>{
              this.tail_height = 200
              this.Tail_height = 200
              this.isVisible_CheckBox = !this.isVisible_CheckBox
              this.isVisible_head = true
              this.animation_Tail_appear()
            })
          Blank().width(30)
        }
        .width('100%')

        Blank().height(10)
        Divider()
          .width('100%')
          .color('#ff9996')
          .strokeWidth(0.8)
        // 1.显示聊天的内容

        Scroll(this.scrollerForScroll) {
          // 1.2 对话显示区
          Column() {

            Blank().height(10)

            Text(this.time)
              .fontColor(Color.White)
              .fontSize(15)
              .opacity(0.6)
            Blank().height(10)
            // 1.2.1 List列表 循环渲染消息数组
            List() {
              // 1.2.1.1 默认AI方先发送一句话
              ForEach(this.Array, (item: Message, index: number) => {
                ListItem() {
                  if (item.role == "user") {
                    UserItem({
                      item: item,
                      isVisible_CheckBox: $isVisible_CheckBox,
                      chatArray: $chatArray,
                      checkCount: $checkCount,
                      checkAll: this.allchecked
                    })
                  } else if (item.role == "assistant") {
                    AI_Item({
                      item: item,
                      isVisible_CheckBox: $isVisible_CheckBox,
                      chatArray: $chatArray,
                      checkCount: $checkCount,
                      checkAll: $allchecked,
                      AITopic: this.firstMessage.title,
                    })
                  }
                }
                .padding({ bottom: 50 })
                .onAppear(() => {
                  this.scrollerForScroll.scrollEdge(Edge.Bottom) //
                })
              })
              //对话加载动画出现逻辑
              if (this.Array.length == 0 || this.Array[this.Array.length-1].role == "user") {
                ListItem() {
                  Row() {
                    Image($rawfile('other/Mock/Enpty.png'))
                      .backgroundColor(Color.White)
                      .objectFit(ImageFit.Fill)
                      .width(30)
                      .height(30)
                      .borderRadius(100)
                      .margin({ right: 8 })
                    Blank().width(10)
                    SpinKit({
                      spinType: SpinType.spinF,
                      spinColor: Color.White, //
                      spinSize: 25,
                    })
                  }

                  //.margin({ right: 100 })
                }
                .onAppear(() => {
                  this.scrollerForScroll.scrollEdge(Edge.Bottom)
                })
              }
            }
            .onAppear(() => {
              this.httpData_axios('什么是' + this.firstMessage.title + '？80字以内解答。')
            })

          }
          .borderRadius('5%')
          .height('100%')
          .width('100%')
          .padding({ top: 12, bottom: 12 })
          .onClick(() => {
            this.head_height = 0//头部移动距离
            //this.animation_head_disappear()//头部隐藏动画
            this.chatArray = [] //清空对象数组
            this.isVisible_head = true//隐藏头部
            if (this.isVisible_CheckBox === false)
              this.isVisible_CheckBox = true//隐藏勾选框
            this.onClickUpload = 1
            this.animation_Tail_appear()//输入框出现动画
          })
        }
        .width("85%")
        .padding({ bottom: 40 })
        .opacity(this.onClickUpload)
        .layoutWeight(1) //铺满剩余空间
        .height('90%')

        // 2.发送消息 + 返回按钮
        Row() {
          if (this.isVisible_CheckBox === true) {
            Column() {
              TypeIn_box({
                isVisible_CheckBox: $isVisible_CheckBox,
                Array: $Array,
                message: $message,
                isVisible_head: $isVisible_head,
                tail_height: $tail_height,
                Tail_height: $Tail_height
              })
            }
            .margin({
              top:this.Tail_height
            })
          } else {
            Column() {
              OperateBox({
                checkAll: $allchecked,
                onClickUpload: $onClickUpload,
                checkCount: $checkCount,
                isVisible_head: $isVisible_head,
                isVisible_CheckBox: $isVisible_CheckBox,
                ChatAIObj: $Array
                //chatArray: $chatArray
              })
            }
            .margin({
              top:this.Tail_height
            })
          }
        }
        .width('100%')
        .height('10%')

      }
      .width("100%")
      .height("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      //.backgroundImage($r('app.media.background'))
      //.backgroundImageSize(ImageSize.FILL)
      .backgroundColor('#353242')
      .transition( //入场
        TransitionEffect.translate({ y: 1000 })
          .animation({ curve: curves.springMotion(0.6, 0.8) })
      )
      if(this.onClickUpload!=1) {
        //UploadWindow()
      }
    }

    // .sharedTransition("AIChatPage",{
    //   duration:600,
    //   curve:Curve.Smooth
    // })
  }




  //转场效果
  pageTransition() {
    // PageTransitionEnter({duration:600})
    //   .slide(SlideEffect.Bottom)//侧划入
    PageTransitionExit({ duration:600 })
      // .slide(SlideEffect.START)//侧划入
      .slide(SlideEffect.Bottom)//侧划入
      .opacity(0)
      .scale({x:0,y:0})//缩放
  }


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
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json'
      }
    })
      .then((response: AxiosResponse<chatResponseData>) => {
        this.Array.push(response.data.choices[0].message); //填入渲染数组
      })
      .catch((error: BusinessError) => {
        console.error('Request failed:', error);
      })
  }

  // async httpSubmit_axios(chatArray:Array<Message>){
  //   //console.log('GOT_message:  '+message)//
  //   let obj: chatData = new chatData(
  //     'heiye',
  //     1,
  //     new DataSet(
  //       '1',
  //       '1000001',
  //       this.firstMessage.id,
  //       chatArray
  //     )
  //   )
  //
  //   //console.log('GOT_RUN_HERE1')//
  //   axios({
  //     method: 'POST',
  //     url: "http://127.0.0.1:4523/m1/4414785-4059781-default/ai/save",
  //     data: obj,
  //     headers: {
  //       'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
  //       'Content-Type': 'application/json'
  //     }
  //   })
  //     .then((response: AxiosResponse<returnData>) => {
  //       //console.log('GOT_RUN_HERE2') //
  //       let Return: returnData = response.data
  //       console.log("Return.word:"+Return.word+'\n'+"Return.word:"+Return.word)
  //     })
  //     .catch((error: BusinessError) => {
  //       console.error('Request failed:', error);
  //     })
  // }

}


// 全选点击事件
// .onClick(() => {
//   if (this.allchecked === false) {
//     this.allchecked = true
//   } else {
//     this.allchecked = false
//     this.chatArray = []
//     this.checkCount = 0
//   }
// })
import { curves, promptAction, router } from '@kit.ArkUI';
import { SpinKit, SpinType } from '@pura/spinkit';
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { Message } from 'ets/models/tempModel/DataModel/Message';
import { TopicAI } from 'ets/models/tempModel/DataModel/TopicAI';
import { UserItem } from 'ets/commons/components/AIComponent/AI_chat/AI_chat_ListItem/User_Item';
import { AI_Item } from 'ets/commons/components/AIComponent/AI_chat/AI_chat_ListItem/AI_item'; //AI聊天项
import { TypeIn_box } from 'ets/commons/components/AIComponent/AI_chat/TypeIn_box'; //底部输入框

import { QuestionAnswer } from 'ets/models/tempModel/Interface/ChatQandA';
import { AIChatNavBar } from '../commons/components/AIComponent/AI_chat/AIChatNavBar';
import { UserInfo } from '../commons/utils';
import { User } from '../models';
import { ChatHistoryPropmtType } from '../models/tempModel/Interface/PropmtInterfaces';
import { IRouterParamsAIChat } from './TopicList';


interface ChatData_DS {
  uid:string,
  message: string
}

interface chatResponseData_DS {
  uid:string,
  message: string
}

@Entry
@Component
export struct Chat {
  //变量
  @StorageProp(UserInfo) user: User = {} as User
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State firstMessage: TopicAI = {} as TopicAI
  @State messageOfTopic: TopicAI = {} as TopicAI
  @State idGet: IRouterParamsAIChat = {} as IRouterParamsAIChat
  @State time: string = new Date().toLocaleString() //get//debug//这里目前引用当前时间
  @State Array: Array<Message> = [] //渲染对象数组
  @State message: string = '' //输入框输入的内容
  @State AccessToken: string = '' //token
  @State QandA: Array<QuestionAnswer> = []
  //动画
  @State isVisible_head: boolean = false
  @State isVisible_CheckBox: boolean = true
  @State checkCount: number = 0 //勾选框勾选计数
  @State chatArray: Array<Message> = [] //勾选对象数组
  @State onClickUpload: number = 1 //点击上传
  @State allchecked: boolean = false //checkbox全选
  @State head_height: number = 0
  @State tail_height: number = 200
  @State Tail_height: number = 0
  private scrollerForScroll: Scroller = new Scroller()

  async aboutToAppear() {}
  @Builder
  TypeInBox(){
    Row({ space: 20 }) {
      TextInput({ placeholder: '输入点什么试试 >', text: $$this.message })
        .width('70%')
        .height(40)
        .fontSize(20)
        .fontColor('#16151a')
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#eae8f6')
        .margin({left:20})
      Image($rawfile('icon/send.png'))
        .width(30)
        .margin({left:20})
        .onClick(async () => {
          if (this.message == '') {
            promptAction.showToast({ message: "输入内容不可为空" })
          } else {
            this.Array.push(new Message('user', this.message)) //将对象填入渲染数组
            //this.httpChat_axios_v2(this.message, 'sbsbsbsb')
            //await this.chatrequest(this.message,this.user.uid)
            await this.chatrequest(this.message,'100009')
            this.message = "" // 清空输入框里的内
          }
        })
    }
    .backgroundColor('#fce9a2')
    .borderRadius(30)
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
  }
  //底部动画：出现
  animation_Tail_appear(): void {
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.Tail_height = 0
    })
  }

  build() {
    Stack() {
      Column() {
        AIChatNavBar({
          title: "Deepseek",
          leftIcon: $rawfile('icon/back_L.png'),
          rightIcon: $rawfile('icon/DealAIChat.png'),
          onclick: () => {
            this.tail_height = 200
            this.Tail_height = 200
            this.isVisible_CheckBox = !this.isVisible_CheckBox
            this.isVisible_head = true
            this.animation_Tail_appear()
          },
          onClickV2: () => {
            router.pushUrl({
              url: 'pages/ChatHistory',
              params: {
                topicId: this.firstMessage.id,
                topicName: this.firstMessage.name
              } as ChatHistoryPropmtType
            })
          },
          onClickBack: async () => {
            //await this.http_keepChatData_axios(this.user.token)
          }
        })
        Blank().height(10)
        Divider()
          .width('100%')
          .color('#ffccce')
          .strokeWidth(0.8)
        // 1.显示聊天的内容
        Scroll(this.scrollerForScroll) {
          // 1.2 对话显示区
          Column() {
            Blank().height(10)
            Text(this.time)
              .fontColor('#985e1f')
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
                      checkAll: this.allchecked,
                    })
                  } else if (item.role == "assistant") {
                    AI_Item({
                      item: item,
                      isVisible_CheckBox: $isVisible_CheckBox,
                      chatArray: $chatArray,
                      checkCount: $checkCount,
                      checkAll: $allchecked,
                      AITopic: this.firstMessage.name,
                      SourceArr: this.QandA
                    })
                  }
                }
                .padding({ bottom: 50 })
              })
              //对话加载动画出现逻辑
              if (this.Array.length > 0 && this.Array[this.Array.length-1].role == "user") {
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
                      spinColor: Color.White,
                      spinSize: 25,
                    })
                  }
                }
              }
            }
          }
          .borderRadius('5%')
          .height('100%')
          .width('100%')
          .padding({ top: 12, bottom: 12 })
          .onClick(() => {
            this.head_height = 0 //头部移动距离
            this.chatArray = [] //清空对象数组
            this.isVisible_head = true //隐藏头部
            if (this.isVisible_CheckBox === false) {
              this.isVisible_CheckBox = true
            } //隐藏勾选框
            this.onClickUpload = 1
            this.animation_Tail_appear() //输入框出现动画
          })
        }
        .width("85%")
        .padding({ bottom: 40 })
        .opacity(this.onClickUpload)
        .layoutWeight(1) //铺满剩余空间
        .height('90%')

        // 2.发送消息 + 返回按钮
        Row() {
            Column() {
              // TypeIn_box({
              //   isVisible_CheckBox: $isVisible_CheckBox,
              //   Array: $Array,
              //   message: $message,
              //   isVisible_head: $isVisible_head,
              //   tail_height: $tail_height,
              //   Tail_height: $Tail_height,
              //   sourceArr: $QandA
              // })
              this.TypeInBox()
            }
            .margin({
              top: this.Tail_height
            })
        }
        .width('100%')
        .height('10%')
      }
      .width("100%")
      .height("100%")
      .padding({ bottom: this.bottomHeight })
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor('#fffcf3')
      .transition( //入场
        TransitionEffect.translate({ y: 1000 })
          .animation({ curve: curves.springMotion(0.6, 0.8) })
      )
    }
  }

  //deepseek对话请求。
  async chatrequest(MessageInf: string, Uid:string):Promise<void> {
    axios({
      method: 'POST',
      url: "http://hellooracle.free.idcfengye.com" + "/deepseek/chat",
      data: {
        uid: Uid, //对话id//传参
        message: MessageInf//对话内容//传参
      } as ChatData_DS,
      headers: {
        'Authorization': 'Bearer ' + this.user.token,
        'Content-Type': 'application/json'
      }
    }).then((response: AxiosResponse<ApiResponse>) => {
      //封装对象，push进数组
      this.Array.push(new Message("assistant", response.data.data))
      console.log('GOT_INF____'+response.data.data)
    }).catch((error: BusinessError) => {
      console.error('GOT_Request failedV1:', error);
      return ;
    })
  }

  //转场效果
  pageTransition() {
    PageTransitionExit({ duration: 600 })// .slide(SlideEffect.START)//侧划入
      .slide(SlideEffect.Bottom)//侧划入
      .opacity(0)
      .scale({ x: 0, y: 0 }) //缩放
  }
}

interface ApiResponse {
  success: boolean;       // 表示请求是否成功
  errorCode: string | null; // 错误码，可能为 null
  errorMsg: string | null; // 错误信息，可能为 null
  data: string;           // 返回的数据，类型为字符串
}


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
import { chatData,chatResponseData, keepChatHistory } from 'ets/models/tempModel/Interface/Chat';

import { UserItem } from 'ets/commons/components/AIComponent/AI_chat/AI_chat_ListItem/User_Item'
import { AI_Item } from 'ets/commons/components/AIComponent/AI_chat/AI_chat_ListItem/AI_item';//AI聊天项
import { TypeIn_box } from 'ets/commons/components/AIComponent/AI_chat/TypeIn_box'//底部输入框
import { OperateBox } from 'ets/commons/components/AIComponent/AI_chat/Operate_box'//底部操作框
import { KeepAIChat,KeepAIChatResponse } from '../models/tempModel/Interface/KeepAIChat';
import { GetToken } from '../models/tempModel/DataModel/GetToken';
import { markdownResponse } from '../models/tempModel/Interface/markdownReturn';
import { CustomNavBar } from '../commons/components';
import { QuestionAnswer } from 'ets/models/tempModel/Interface/ChatQandA'
import { httpChat_axios_v1, httpKeepChatHistory_axios } from '../views/HttpRequests';
import { AIChatNavBar } from '../commons/components/AIComponent/AI_chat/AIChatNavBar';
import { UserInfo } from '../commons/utils';
import { User } from '../models';
import { ChatHistoryPropmtType } from '../models/tempModel/Interface/PropmtInterfaces';
import { IRouterParams } from '../models/tempModel/Interface/ParamChatHistory';
import { IRouterParamsAIChat } from './TopicList';

//import { UploadWindow } from 'ets/components/AI_chat/Upload_window'//上传窗口组件
//import { chatData ,DataSet,returnData} from 'ets/model/ChatData';
// //数据测试：给我一串简单的java代码
@Entry
@Component
export struct Chat {
  @StorageProp(UserInfo) user: User = {} as User
  @State firstMessage: TopicAI = new TopicAI(1, 'java', 'javaINT','','avator', '1', 'java', 'java', 1,1)
  @State idGet:IRouterParamsAIChat = {} as IRouterParamsAIChat
  @State firstText: string = this.firstMessage.name//话题的ai介绍
  @State time: string = new Date().toLocaleString()//get//debug//这里目前引用当前时间
  @State Array: Array<Message> = []//渲染对象数组
  @State message: string = ''//输入框输入的内容
  @State AccessToken: string = ''//token
  @State QandA: Array<QuestionAnswer> = []

  // @State markdownReturn: string = ''//返回的markdown生成结果
  @StorageLink('userAvatar') pic:Resource|image.PixelMap = $rawfile('other/Mock/Enpty.png')//get
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

    try {
      this.idGet = router.getParams() as IRouterParamsAIChat
      this.getTopicDetail_axios(this.idGet.topicId, this.user.token)
    } catch (err){
      console.log('获取失败')
    }
    this.onClickUpload=1
  }



  //底部动画：出现
  animation_Tail_appear(): void {
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.Tail_height = 0
    })
  }

  aboutToDisappear(): void {
    //this.httpMarkdownCrater_axios()
  }
  build() {
    Stack() {
      Column() {
        //GotToken({ token: $AccessToken })
        AIChatNavBar({
          title: this.firstMessage.name,
          leftIcon: $rawfile('icon/backIcon.png'),
          rightIcon: $rawfile('icon/DealAIChat.png'),
          onclick: () => {
            this.tail_height = 200
            this.Tail_height = 200
            this.isVisible_CheckBox = !this.isVisible_CheckBox
            this.isVisible_head = true
            this.animation_Tail_appear()
          },
          onClickV2:()=>{
            //console.log('点击了GO—TO—CHAT—History')
            router.pushUrl({
              url: 'pages/ChatHistory',
              params: {
                topicId:this.firstMessage.id,
                topicName:this.firstMessage.name
              } as ChatHistoryPropmtType
            })
          },
          onClickBack: () => {
            httpKeepChatHistory_axios('uid','topicId','token',this.Array)//debug
          }
        })

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
                      AITopic: this.firstMessage.name,
                      SourceArr: this.QandA
                    })
                  }
                }
                .padding({ bottom: 50 })
                // .onAppear(() => {
                //   this.scrollerForScroll.scrollEdge(Edge.Bottom) //
                // })
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
                      spinColor: Color.White,
                      spinSize: 25,
                    })
                  }
                }
              }
            }
            .onAppear(async () => {
              this.Array.push(await httpChat_axios_v1('什么是' + this.firstMessage.name + '？80字以内解答。', 'chatId'))//debug
              //this.httpData_axios('什么是' + this.firstMessage.title + '？80字以内解答。', 'sbsbsbsb')//内容+id
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
                Tail_height: $Tail_height,
                sourceArr: $QandA
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
                ChatAIObj: $Array,
                chatArray: $chatArray,
                topicId: this.firstMessage.id,
                topicName: this.firstMessage.name,
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
      .backgroundColor('#16151a')
      .transition( //入场
        TransitionEffect.translate({ y: 1000 })
          .animation({ curve: curves.springMotion(0.6, 0.8) })
      )
      if(this.onClickUpload!=1) {
        //UploadWindow()
      }
    }
  }
  async getTopicDetail_axios(id: number,token: string): Promise<void> {
    axios({
      method: 'GET',
      url: "https://1fd33097.r5.cpolar.cn"+"/findAll",
      headers: {
        'Authorization': 'Bearer '+token
      },
      params: {
        id: id
      }
    }).then((response: AxiosResponse<TopicAI>) => {
      this.firstMessage = response.data
    }).catch((error: BusinessError) => {
      console.error('Request failed:', error);
    })
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
}

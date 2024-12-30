import { curves, router } from '@kit.ArkUI';
import { Message } from 'ets/models/tempModel/DataModel/Message';
import { TopicAI } from 'ets/models/tempModel/DataModel/TopicAI';
import { UserItem } from 'ets/commons/components/AIComponent/AI_chat/AI_chat_ListItem/User_Item';
import { AI_Item } from 'ets/commons/components/AIComponent/AI_chat/AI_chat_ListItem/AI_item'; //AI聊天项
import { QuestionAnswer } from 'ets/models/tempModel/Interface/ChatQandA';
import { AIChatNavBar } from '../commons/components/AIComponent/AI_chat/AIChatNavBar';
import { UserInfo } from '../commons/utils';
import { User } from '../models';
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { HistoryDetialResponse } from '../models/tempModel/Interface/HistoryDetail';
import { CustomNavBar } from '../commons/components';

export interface HistoryDetialParams {
  mid:string
}
@Entry
@Component
export struct HistoryDetial {
    @StorageProp(UserInfo) user: User = {} as User
    @StorageProp('bottomHeight')
    bottomHeight: number = 0
    @State firstMessage: TopicAI = {} as TopicAI
    @State messageOfTopic: TopicAI = {} as TopicAI
    @State GetMid:HistoryDetialParams = {} as HistoryDetialParams
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

    async aboutToAppear() {
      this.onClickUpload = 1;
      this.GetMid = router.getParams() as HistoryDetialParams
      console.log('GOT_pramas:' + JSON.stringify(this.GetMid))
      await this.httpGotDetial_axios()
    }



    build() {
      Stack() {
        Column() {
          CustomNavBar({
            title: '历史记录详情',
            showRightIcon: false,
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
            })
          }
          .width("85%")
          .padding({ bottom: 40 })
          .opacity(this.onClickUpload)
          .layoutWeight(1) //铺满剩余空间
          .height('90%')

          // 2.发送消息 + 返回按钮
          Row() {
              Column() {}
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
        .backgroundColor('#16151a')
        .transition( //入场
          TransitionEffect.translate({ y: 1000 })
            .animation({ curve: curves.springMotion(0.6, 0.8) })
        )
      }
    }
  async httpGotDetial_axios(): Promise<void> {
    axios({
      method: 'GET',
      url: 'https://1fd33097.r5.cpolar.cn'+'/ai/history_detail',
      headers: {
        'Authorization': 'Bearer ' +this.user.token
      },
      params:{
        mid: this.GetMid.mid
      }
    }).then((response: AxiosResponse<HistoryDetialResponse>) => {
        this.Array = response.data.data.messages;
    }).catch((error: BusinessError) => {
      console.error('GOT_Request failedV1:', error);
      return new Message('system', 'Error occurred during request');
    })
  }

}
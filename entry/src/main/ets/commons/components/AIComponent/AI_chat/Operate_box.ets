import router from '@ohos.router';
import { Message } from 'ets/models/tempModel/DataModel/Message';
import { AINotePropmtType } from '../../../../models/tempModel/Interface/PropmtInterfaces';


@Component
export struct OperateBox {
  @Prop CircleId: string
  @Link checkAll: boolean
  @Link onClickUpload: number
  @Link checkCount: number
  @Link isVisible_head: boolean
  @Link isVisible_CheckBox: boolean
  @Link ChatAIObj: Array<Message>
  @Link chatArray: Array<Message>
  @Prop topicId: number
  @Prop topicName: string
  @Prop Imgurl: string
  // 个人中心页
  changIndexMine = (index: number) => {
  }

  build() {
    Row({ space: 35 }) {
      Blank().width(15)
      Column() {
        Image($rawfile('icon/checkKnowledgeCircle.png'))
          .width(35)
          .height(35)
        Blank().height(5)
        Text('查看知识圈')
          .fontColor(Color.White)
          .fontSize(12)
      }
      .onClick(() => {
        this.changIndexMine(2)
      })

      Column() {
        Image($rawfile('icon/CreateAINote.png'))
          .width(35)
          .height(35)
        Blank().height(5)
        Text('一键生成AI笔记')
          .fontColor(Color.White)
          .fontSize(12)
      }
      .onClick(() => {
        if (this.checkCount >= 2) {
          router.replaceUrl({
            url: 'pages/AINote',
            params: {
              topicId: this.topicId,
              topicName: this.topicName,
              chatArray: this.chatArray,
              circleId: this.CircleId
            } as AINotePropmtType
          })
        } else {
          AlertDialog.show({
            title: '选择对话数过少', //弹窗标题
            message: '请选择两条以上的对话', //弹窗内容
            autoCancel: true, //点击遮罩层，是否关闭弹窗
            backgroundColor: '#b1ccd4', //背景色
            primaryButton: {
              // 主要按钮，左侧
              value: '确认',
              fontColor: Color.Red,
              action: () => {
                console.info('Button-clicking callback')
              }
            },
            cancel: () => {
              console.info('showDialog cancel');
            }
          })
        }
      })

      Column() {
        Image($rawfile('icon/checkAll.png'))
          .width(35)
          .height(35)
        Blank().height(5)
        Text('选择全部')
          .fontColor(Color.White)
          .fontSize(12)
      }
      .onClick(() => {
        this.checkAll = !this.checkAll
      })
    }
    .width('100%')
    .height('100%')
    .borderRadius(30)
    .backgroundColor('#313035')
  }
}
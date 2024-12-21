import { SNInput, SNList, SNNavBar, UserInfoDialog } from '../views/ShareNotes';
import { promptAction, router } from '@kit.ArkUI';
import { IPublisher, IPublisherData } from '../models';
import { httpReq, logger } from '../commons/utils';
import { ICircleIdParams } from '../commons/components';


@Entry
@Component
struct ShareNotes {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State publisherData: IPublisherData = {} as IPublisherData
  @State publisher: IPublisher = {} as IPublisher
  @State isSend: boolean = false
  // 笔记所属知识圈id
  @State circleId: string = ''
  // 笔记id
  @State noteId: string = ''
  UserInfoDialog = new CustomDialogController({
    builder: UserInfoDialog({ publisher: this.publisher }),
    customStyle: true,
    maskColor: '#4dcfcccc',
  })

  // 获取发布者笔记内容
  async getPublisherData(params: ICircleIdParams) {
    this.publisherData = await httpReq.request<IPublisherData>({
      url: '/note/queryById',
      // TODO
      headers: {
        "uid": "1000001"
      },
      params
    })
    logger.info('res--', JSON.stringify(this.publisherData))
  }

  // 发布者弹窗内容
  async getPublisher() {
    try {
      this.publisher = await httpReq.request<IPublisher>({
        url: '/user/findUserDetailById',
        params: {
          uid: this.publisherData.creatorId
        }
      })
      this.UserInfoDialog.open()
    } catch (err) {
      promptAction.showToast({ message: '请求失败' })
    }
  }

  aboutToAppear(): void {
    const params = router.getParams() as ICircleIdParams
    this.getPublisherData(params)
    this.noteId = params.noteId
    // promptAction.showToast({ message: JSON.stringify(params) })
  }

  build() {
    Column() {
      // 顶部导航条
      Row() {
        Image($rawfile('icon/backIcon.png'))
          .width(30)
          .margin({ right: 20 })
          .onClick(() => {
            router.back()
          })
        if (this.publisherData.creatorAvatar) {
          this.UserTitleBuilder()
          Blank()
          this.ChargingBtnBuilder()
        }
      }
      .width('100%')
      .padding({ left: 30, right: 30, top: this.topHeight })

      Scroll() {
        Column() {
          // 轮播图
          Swiper() {
            ForEach(this.publisherData.pictures || [$rawfile('other/defaultNote.png')], (item: string) => {
              Column() {
                Image(item)
                  .alt($rawfile('other/defaultNote.png'))
                  .width('100%')
                  .height(390)
                  .borderRadius(20)
              }
              .width('100%')
              .padding({ left: 10, right: 10 })
            })
          }
          .width('100%')
          .height(420)
          .loop(false)
          .indicator(
            new DotIndicator()
              .selectedColor('rgb(141, 135, 242)')
              .color('rgb(196, 196, 196)')
              .selectedItemWidth(10)
              .selectedItemHeight(10)
              .itemWidth(10)
              .itemHeight(10)
          )

          // 话题
          Column({ space: 10 }) {
            Text(this.publisherData.title)
              .fontSize(24)
              .fontWeight(900)
              .fontColor(Color.White)
              .width('100%')

            Text(this.publisherData.word)
              .fontSize(14)
              .fontColor(Color.White)
              .width('100%')
            if (this.publisherData.creatorAvatar) {
              Row() {
                Image($rawfile('icon/aiIcon.png'))
                  .width(28)
                Text('这里是话题')
                  .fontSize(20)
                  .fontWeight(900)
                  .fontColor('#98F4E9')
                  .width('100%')
              }
              .onClick(() => {
                // TODO
              })
            }

            Divider()
              .width('100%')
              .height(2)
              .color('rgb(136, 136, 136)')
              .width('100%')
              .margin({ top: 10 })
          }
          .margin({ bottom: 20 })

          // 聊天
          SNList()
        }
        .width('100%')
        .padding({ right: 30, left: 30 })
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
      .margin({ top: 20 })

      if (this.isSend) {
        // 发送评论
        SNInput({ isSend: this.isSend })
      } else {
        // 底部点赞
        SNNavBar({ isSend: this.isSend, noteId: this.noteId, publisherData: this.publisherData })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
  }

  @Builder
  UserTitleBuilder() {
    Row({ space: 10 }) {
      Image(this.publisherData.creatorAvatar || $rawfile('other/ic_mine_avatar.svg'))
        .alt($rawfile('other/ic_mine_avatar.svg'))
        .width(50)
        .borderRadius(25)
        .onClick(() => {
          this.getPublisher()
        })
      Text(this.publisherData.creatorName)
        .fontSize(24)
        .fontColor(Color.White)
        .fontWeight(700)
    }
    .height(50)
  }

  @Builder
  ChargingBtnBuilder() {
    Text('充电')
      .fontSize(24)
      .fontWeight(900)
      .fontColor('rgb(255, 253, 154)')
      .padding({
        left: 10,
        right: 10,
      })
      .borderRadius(20)
      .border({
        color: 'rgb(255, 153, 150)',
        width: 3
      })

  }
}
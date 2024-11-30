import { SNInput, SNList, SNNavBar, UserInfoDialog } from '../views/ShareNotes';
import { router } from '@kit.ArkUI';
import { IContext, IPublisher, IPublisherData } from '../models';
import { httpReq } from '../commons/utils';
import { ICircleIdParams } from '../commons/components';


@Entry
@Component
struct ShareNotes {
  @State publisher: IPublisher = {} as IPublisher
  @State publishContext: IContext = {} as IContext
  @StorageProp('topHeight')
  topHeight: number = 0
  @State isSend: boolean = false
  UserInfoDialog = new CustomDialogController({
    builder: UserInfoDialog({ publisher: this.publisher }),
    customStyle: true,
    maskColor: '#4dcfcccc',
  })

  async getPublisherData(params: ICircleIdParams) {
    const res = await httpReq.request<IPublisherData>({
      url: '/circle/queryById',
      // TODO
      params
    })
    return res
  }

  aboutToAppear(): void {
    // TODO
    const params = router.getParams() as ICircleIdParams
    const res = {
      circleId: '1',
      context: {
        pictures: [
          'https://tse2-mm.cn.bing.net/th/id/OIP-C.5ASZMDn60QmoRWwJhfAs9AHaHa?rs=1&pid=ImgDetMain',
          'https://bpic.588ku.com/element_origin_min_pic/19/04/09/c2927d488f5166168b85288b186333b5.jpg',
          'https://bpic.588ku.com/element_pic/23/04/25/1ff048e85ae0147376033edab9307568.png',
          'https://bpic.588ku.com/element_pic/23/04/25/1ff048e85ae0147376033edab9307568.png',
          'https://img95.699pic.com/element/40159/7630.png_300.png'
        ],
        title: "我最帅",
        word: "文字描述666"
      },
      createTime: null,
      id: '36467884384555459937',
      topic: {
        id: 1,
        name: "绪论",
        attractTitle: "这是一个营销号标题"
      },
      user: {
        uid: '1000001',
        name: '黑夜',
        avatar: 'https://pic1.zhimg.com/v2-e5962333059d0dc857301394d30f396d_r.jpg?source=1940ef5c',
        introduction: '我是百变小樱，不是百变酒精assfasafaafafafaf',
        studyProgress: 0,
        attendance: 0,
        referral: 0,
        praise: 0
      }
    } as IPublisherData
    this.publisher = res.user
    this.publishContext = res.context
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
        this.UserTitleBuilder()
        Blank()
        this.ChargingBtnBuilder()
      }
      .width('100%')
      .padding({ left: 30, right: 30, top: this.topHeight })

      Scroll() {
        Column() {
          // 轮播图
          Swiper() {
            ForEach(this.publishContext.pictures, (item: string) => {
              Column() {
                Image(item)
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
            Text(this.publishContext.title)
              .fontSize(24)
              .fontWeight(900)
              .fontColor(Color.White)
              .width('100%')

            Text(this.publishContext.word)
              .fontSize(20)
              .fontWeight(900)
              .fontColor(Color.White)
              .width('100%')
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
        SNNavBar({ isSend: this.isSend })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
  }

  @Builder
  UserTitleBuilder() {
    Row({ space: 10 }) {
      Image('https://pic1.zhimg.com/v2-e5962333059d0dc857301394d30f396d_r.jpg?source=1940ef5c')
        .width(50)
        .borderRadius(25)
        .onClick(() => {
          this.UserInfoDialog.open()
        })
      Text('用户001')
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
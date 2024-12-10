import { router } from '@kit.ArkUI'
import { NotesWaterFlow, roseChart } from '../../commons/components'
import { auth, UserInfo } from '../../commons/utils'
import { User, WaterFlowType } from '../../models'

@Component
export struct MinePage {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State isShow: boolean = false
  @State sheetTitle: string = ''
  // 半模态框种类
  @State sheetType: WaterFlowType = WaterFlowType.myNotes
  @StorageProp(UserInfo)
  user: User = {} as User

  build() {
    Scroll() {
      Column() {
        Column({ space: 15 }) {
          Row() {
            Image($rawfile('icon/Setting.png'))
              .width(15)
          }
          .width(30)
          .height(30)
          .backgroundColor('rgba(141, 135, 242, 0.8)')
          .justifyContent(FlexAlign.Center)
          .borderRadius(15)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Mine/InformationEdite'
            })
          })

          Row({ space: 13 }) {
            Image(this.user.avatar || $rawfile('other/ic_mine_avatar.svg'))
              .alt($rawfile('other/ic_mine_avatar.svg'))
              .width(80)
              .borderRadius(40)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Mine/InformationEdite'
                })
              })
            if (this.user.token) {
              Column() {
                Text(this.user.name)
                  .fontSize(23)
                  .fontWeight(900)
                  .fontColor(Color.White)
                Text(this.user.introduction)
                  .fontWeight(700)
                  .fontColor(Color.White)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            } else {
              Column() {
                Text('立即登录')
                  .fontSize(23)
                  .fontWeight(900)
                  .fontColor(Color.White)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/Login/Login'
                    })
                  })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
          }
          .width('100%')

          // 用户获赞信息
          Grid() {
            ForEach(Array.from({ length: 3 }), (item: null, index: number) => {
              GridItem() {
                Column() {
                  Text(index == 0 ? '100' : index == 1 ? '230' : '145')
                    .fontSize(36)
                    .fontWeight(900)
                    .fontColor('rgb(255, 124, 120)')
                  Text(index == 0 ? '获赞数' : index == 1 ? '获亮数' : '发过笔记')
                    .fontWeight(700)
                    .fontColor('rgb(99, 95, 113)')
                }
                .padding(15)
              }
              .border({
                color: 'rgb(165, 165, 165)',
                width: { right: index != 2 ? 1 : 0 }
              })
              .onClick(() => {
                if (index == 2) {
                  this.isShow = true
                  this.sheetTitle = '发布过的笔记'
                  this.sheetType = WaterFlowType.myNotes
                }
              })
            })
          }
          .width('100%')
          .borderRadius(26)
          .backgroundColor(Color.White)
          .columnsTemplate('1fr 1fr 1fr')
          .rowsTemplate('1fr')
          .height(90)

          // 学习时长
          Row() {
            Column({ space: 12 }) {
              Text() {
                Span('学习时长')
                  .fontWeight(900)
                  .fontColor(Color.White)
                ImageSpan($rawfile('icon/duration.png'))
                  .width(17)
              }

              Text() {
                Span('138')
                  .fontWeight(700)
                  .fontColor(Color.Black)
                  .fontSize(20)
                Span('小时')
                  .fontWeight(600)
                  .fontColor(Color.White)
                Span('43')
                  .fontWeight(700)
                  .fontColor(Color.Black)
                  .fontSize(24)
                Span('分钟')
                  .fontWeight(600)
                  .fontColor(Color.White)
              }
            }
            .height(90)
            .width(150)
            .padding(10)
            .backgroundColor('rgb(184, 181, 246)')
            .borderRadius(30)
            .justifyContent(FlexAlign.Center)

            Column() {
              Text() {
                Span('连续打卡天数')
                  .fontWeight(900)
                  .fontColor(Color.White)
                ImageSpan($rawfile('icon/clockIn.png'))
                  .width(17)
              }

              Text() {
                Span('23')
                  .fontWeight(700)
                  .fontColor(Color.Black)
                  .fontSize(48)
                Span('天')
                  .fontWeight(600)
                  .fontColor(Color.White)
              }
            }
            .height(90)
            .width(150)
            .padding(10)
            .backgroundColor('rgb(184, 181, 246)')
            .borderRadius(30)
            .justifyContent(FlexAlign.SpaceAround)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
        }
        .width('100%')
        .padding({ left: 30, right: 30 })
        .alignItems(HorizontalAlign.End)
        .margin({ bottom: 12 })

        // 学习分析部分
        Column() {
          Row() {
            Column({ space: 10 }) {
              Text('学习分析')
                .fontSize(14)
                .fontWeight(700)
                .fontColor('rgb(255, 153, 150)')
              Image($rawfile('icon/PieChart.png'))
                .width(78)
            }
            .width(90)
            .padding({ top: 13 })

            // 收藏以及草稿按钮
            Row({ space: 15 }) {
              ForEach(Array.from({ length: 2 }), (item: null, index: number) => {
                // 收藏
                Column({ space: 5 }) {
                  Row() {
                    Image(index == 0 ? $rawfile('icon/collection2.png') : $rawfile('icon/draft.png'))
                      .width(40)
                  }
                  .width('100%')
                  .height(50)
                  .backgroundColor(index == 0 ? 'rgb(255, 236, 235)' : 'rgb(165, 156, 204)')
                  .borderRadius(30)
                  .justifyContent(FlexAlign.Center)
                  .onClick(() => {
                    this.isShow = true
                    if (index == 0) {
                      this.sheetTitle = '收藏'
                      this.sheetType = WaterFlowType.collection
                    } else {
                      this.sheetTitle = '笔记保存'
                      this.sheetType = WaterFlowType.draft
                    }
                  })

                  Text(index == 0 ? '收藏' : '笔记保存')
                    .fontSize(14)
                    .fontWeight(700)
                    .fontColor(index == 0 ? 'rgb(255, 153, 150)' : Color.White)
                }
                .width(100)
                .height(70)
              })
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.End)
            .height(110)
            .alignItems(VerticalAlign.Top)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Button('清除用户数据')
            .onClick(() => {
              auth.setUser({} as User)
            })
          Button('模拟token失效')
            .onClick(() => {

            })

          roseChart({
            dataValue: [
              { type: '学习', value: '23' },
              { type: '休息', value: '50' },
              { type: '运动', value: '27' },
            ],
            legendPosition: 'bottom'
          })
        }
        .height(600)
        .width('100%')
        .backgroundImage($rawfile('other/analyzeBtnBackground.png'))
        .backgroundImageSize(ImageSize.Cover)
        .padding({ left: 30, right: 30 })
      }
      .bindSheet($$this.isShow, this.BindSheetBuilder(this.sheetTitle), { showClose: false })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 10 })
    .margin({ bottom: 10 })
    .scrollBar(BarState.Off)
  }

  // 收藏/草稿/发布的笔记半模态弹窗
  @Builder
  BindSheetBuilder(title: string) {
    Column({ space: 27 }) {
      Row() {
        Text(title)
          .fontSize(36)
          .fontWeight(700)
          .fontColor(Color.White)
        Blank()
        Text('关闭')
          .fontWeight(500)
          .fontColor(Color.White)
          .onClick(() => {
            this.isShow = false
          })
      }
      .width('100%')

      NotesWaterFlow({ flowType: this.sheetType })
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({
      left: 30,
      right: 30,
      top: 30,
      bottom: this.bottomHeight
    })
    .backgroundColor('rgb(53, 50, 66)')
  }
}
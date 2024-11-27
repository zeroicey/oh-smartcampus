import { router } from '@kit.ArkUI'

@Component
export struct KnowledgeSphere {
  @State list: string[] = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Elderberry",
    "Fig",
    "Grape",
    "Honeydew",
    "Kiwi",
    "Lemon",
    "Mango",
    "Nectarine",
    "Orange",
    "Papaya",
    "Quince",
    "Raspberry",
    "Strawberry",
    "Tangerine",
    "Ugli fruit",
    "Vanilla",
    "Watermelon",
    "Xigua",
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Elderberry",
    "Fig",
    "Grape",
    "Honeydew",
    "Kiwi",
    "Lemon",
    "Mango",
    "Nectarine",
    "Orange",
    "Papaya",
    "Quince",
    "Raspberry",
    "Strawberry",
    "Tangerine",
    "Ugli fruit",
    "Vanilla",
    "Watermelon",
    "Xigua"
  ]
  @StorageProp('topHeight')
  topHeight: number = 0
  @State activeIndex: number = 0
  @State isShow: boolean = false
  @StorageProp('bottomHeight')
  bottomHeight: number = 0

  build() {
    Column() {
      Text('知识圈')
        .width('100%')
        .fontColor(Color.White)
        .fontSize(48)
        .fontWeight(900)
        .textAlign(TextAlign.Center)
        .padding({ top: this.topHeight })
      Stack({ alignContent: Alignment.TopEnd }) {
        Tabs({ index: this.activeIndex }) {
          ForEach(this.list, (item: string, index: number) => {
            TabContent() {
              WaterFlow() {
                ForEach(Array.from({ length: 10 }), () => {
                  FlowItem() {
                    Column() {
                      Text()
                        .height(168)
                        .width('100%')
                      Row() {

                      }
                      .height(50)
                      .width('100%')
                      .backgroundColor('rgba(196, 196, 196, 0.5)')
                      .borderRadius({ bottomLeft: 20, bottomRight: 20 })
                    }
                    .borderRadius(20)
                    .width('100%')
                    .backgroundColor('rgb(255, 255, 255)')
                    .onClick(() => {
                      // TODO
                      router.pushUrl({
                        url: 'pages/ShareNotes'
                      })
                    })
                  }

                })
              }
              .columnsTemplate('1fr 1fr')
              .columnsGap(10)
              .rowsGap(10)
            }
            .tabBar(this.tabBarBuilder(item, index))
            .padding({ left: 15, right: 15, bottom: 24 })
          })
        }
        .barMode(BarMode.Scrollable)
        .fadingEdge(false)
        .width('100%')
        .onTabBarClick((index: number) => {
          this.activeIndex = index
        })
        .onAnimationEnd((index: number) => {
          this.activeIndex = index
        })

        Row() {
          Image($rawfile('icon/more.png'))
            .width(27)
            .aspectRatio(1)
            .onClick(() => {
              this.isShow = true
              // TODO
              // router.pushUrl({
              //   url: 'pages/ChannelSelection',
              //   params: {
              //     list: this.list,
              //     activeIndex: this.activeIndex
              //   }
              // })
            })
        }
        .width(40)
        .height(50)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('rgb(53, 50, 66)')
        .bindSheet($$this.isShow, this.FilterSheetBuilder, {
          showClose: false
        })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 15, right: 15 })
  }

  @Builder
  tabBarBuilder(item: string, index: number) {
    Text(item)
      .height(34)
      .constraintSize({ minWidth: 80 })
      .backgroundColor(this.activeIndex == index ? Color.Pink : Color.White)
      .borderRadius(20)
      .margin({ right: 10 })
      .textAlign(TextAlign.Center)
      .padding({ left: 10, right: 10 })
  }

  @Builder
  FilterSheetBuilder() {
    Column() {
      // HcNavBar({ title: '知识圈', showRightIcon: false, leftIcon: $rawfile('icon/backIcon.png') })
      //   .margin({ bottom: 40 })
      Text('我的频道')
        .fontSize(24)
        .fontWeight(700)
        .fontColor(Color.White)
        .width('100%')
        .margin({ bottom: 19, top: 40 })
      Scroll() {
        Column() {
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.list, (item: string, index: number) => {
              Text(item)
                .height(40)
                .constraintSize({ minWidth: 75 })
                .borderRadius(20)
                .backgroundColor(this.activeIndex == index ? Color.Pink : Color.White)
                .textAlign(TextAlign.Center)
                .margin({ right: 14, bottom: 15 })
                .padding({ left: 10, right: 10 })
                .onClick(() => {
                  this.activeIndex = index
                  this.isShow = false
                })
            })
          }
          .margin({ bottom: 64 })

          Row() {
            Text('点击进入知识圈频道')
              .fontSize(24)
              .fontWeight(700)
              .width('100%')
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .margin({ bottom: this.bottomHeight })
          }
        }
        .width('100%')
        .padding({ bottom: 40 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({ left: 30, right: 30 })
  }
}
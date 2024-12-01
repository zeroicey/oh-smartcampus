import { NotesWaterFlow } from '../commons/components'

@Entry
@Component
export struct IncircleContent {
  @State list: string[] = [
    "Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew", "Kiwi", "Lemon", "Mango",
    "Nectarine", "Orange", "Papaya", "Quince", "Raspberry", "Strawberry", "Tangerine", "Ugli fruit", "Vanilla",
    "Watermelon", "Xigua", "Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew", "Kiwi",
    "Lemon", "Mango", "Nectarine", "Orange", "Papaya", "Quince", "Raspberry", "Strawberry", "Tangerine", "Ugli fruit",
    "Vanilla", "Watermelon", "Xigua"
  ]
  @StorageProp('topHeight')
  topHeight: number = 0
  @State activeIndex: number = 0
  @State isShow: boolean = false
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  tabControl = new TabsController()

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Tabs({ controller: this.tabControl }) {
          ForEach(this.list, (item: string, index: number) => {
            TabContent() {
              // 单个标签内的所有内容
              NotesWaterFlow()
            }
            .width('100%')
            .height('100%')
            .tabBar(this.tabBarBuilder(item, index))
            .padding({ left: 15, right: 15 })
          })
        }
        .barMode(BarMode.Scrollable)
        .fadingEdge(false)
        .width('100%')
        .height('100%')
        .scrollable(true)
        .padding({ bottom: 10 })
        .onTabBarClick((index: number) => {
          this.activeIndex = index
          this.tabControl.changeIndex(this.activeIndex)
        })
        .onAnimationEnd((index: number) => {
          this.activeIndex = index
        })

        // 更多icon
        Row() {
          Image($rawfile('icon/more.png'))
            .width(27)
            .aspectRatio(1)
            .onClick(() => {
              this.isShow = true
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
    .padding({
      left: 15,
      right: 15,
      top: this.topHeight + 10,
      bottom: this.bottomHeight
    })
    .backgroundColor('rgb(53, 50, 66)')
  }

  // 自定义标题样式
  @Builder
  tabBarBuilder(item: string, index: number) {
    Text(item)
      .height(34)
      .constraintSize({ minWidth: 80 })
      .backgroundColor(this.activeIndex == index ? Color.Pink : Color.White)
      .borderRadius(20)
      .margin({ right: 10 })
      .textAlign(TextAlign.Center)
      .padding({
        left: 10,
        right: 10
      })
  }

  // 筛选半模态框
  @Builder
  FilterSheetBuilder() {
    Column() {
      Text('频道')
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
                  this.tabControl.changeIndex(this.activeIndex)
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
    .padding({
      left: 30,
      right: 30,
      bottom: this.bottomHeight
    })
  }
}
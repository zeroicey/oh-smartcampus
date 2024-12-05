import { NotesWaterFlow } from '../commons/components'
import { httpReq } from '../commons/utils'
import { ITopic } from '../models'

@Entry
@Component
export struct IncircleContent {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State topicList: ITopic[] = []
  @State activeIndex: number = 0
  @State isShow: boolean = false
  tabControl = new TabsController()

  async getToicp() {
    const res = await httpReq.request<ITopic>({
      url: '/topic/findTopic',
      params: {
        circleId: '1'
      }
    })
    return res
  }

  aboutToAppear(): void {
    // TODO
    const res = [
      {
        attractTitle: '探索宇宙的奥秘',
        id: 1,
        name: '天文学'
      },
      {
        attractTitle: '未来科技的展望',
        id: 2,
        name: '科技前沿'
      },
      {
        attractTitle: '金融市场的波动',
        id: 3,
        name: '财经动态'
      },
      {
        attractTitle: '健康生活的秘诀',
        id: 4,
        name: '健康生活'
      },
      {
        attractTitle: '艺术与文化的交融',
        id: 5,
        name: '艺术文化'
      },
      {
        attractTitle: '旅行中的奇遇',
        id: 6,
        name: '旅游探险'
      },
      {
        attractTitle: '美食的诱惑',
        id: 7,
        name: '美食天下'
      },
      {
        attractTitle: '时尚潮流的风向',
        id: 8,
        name: '时尚潮流'
      },
      {
        attractTitle: '心理与情绪的管理',
        id: 9,
        name: '心理健康'
      },
      {
        attractTitle: '历史长河的回响',
        id: 10,
        name: '历史探索'
      }
    ] as ITopic[]
    this.topicList = res
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Tabs({ controller: this.tabControl }) {
          ForEach(this.topicList, (item: ITopic, index: number) => {
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
  tabBarBuilder(item: ITopic, index: number) {
    Text(item.name)
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
            ForEach(this.topicList, (item: ITopic, index: number) => {
              Text(item.name)
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
          .backgroundColor(Color.Green)

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
        .borderColor(Color.Blue)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor(Color.Pink)
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
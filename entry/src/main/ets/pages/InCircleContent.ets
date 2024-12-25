import { FilterSheet, NotesWaterFlow } from '../commons/components'
import { httpReq } from '../commons/utils'
import { ITopic, WaterFlowType } from '../models'
import { router } from '@kit.ArkUI'

export interface ICircleIdParam {
  circleId: string
}

@Entry
@Component
export struct InCircleContent {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State circleId: string = ''
  @State topicList: ITopic[] = []
  @State activeIndex: number = 0
  @State isShow: boolean = false
  tabControl = new TabsController()

  async getTopic() {
    this.topicList = await httpReq.request<ITopic[]>({
      url: '/topic/findAllById',
      params: {
        circleId: this.circleId
      }
    })
  }

  aboutToAppear(): void {
    // TODO
    const param = router.getParams() as ICircleIdParam
    this.circleId = param.circleId
    this.getTopic()
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Tabs({ controller: this.tabControl }) {
          ForEach(this.topicList, (item: ITopic, index: number) => {
            TabContent() {
              // 单个标签内的所有内容
              NotesWaterFlow({
                circleId: this.circleId,
                topicId: item.id,
                flowType: WaterFlowType.circle
              })
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
        .width(60)
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
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontColor(this.activeIndex == index ? Color.White : Color.Black)
      .height(34)
      .constraintSize({ minWidth: 60, maxWidth: 150 })
      .backgroundColor(this.activeIndex == index ? '#B8ABEF' : Color.White)
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
    FilterSheet({
      title: '频道',
      isShow: this.isShow,
      activeIndex: this.activeIndex,
      list: this.topicList,
      onclick: (index: number) => {
        this.activeIndex = index
        this.tabControl.changeIndex(this.activeIndex)
        this.isShow = false
      }
    })
  }
}
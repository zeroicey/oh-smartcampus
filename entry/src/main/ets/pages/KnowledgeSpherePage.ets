import { router } from '@kit.ArkUI'
import { NotesWaterFlow } from '../commons/components'
import { httpReq } from '../commons/utils'
import { IAllCircle, WaterFlowType } from '../models'

@Component
export struct KnowledgeSpherePage {
  @State angleNumber: number = 180
  @State scaleX: number = 10
  @State scaleY: number = 10
  @State isShow: boolean = false
  @State translateY: string = '120%'
  @State timeId: number = -1
  @State circleList: IAllCircle[] = [
    {
      circleId: '1',
      name: 'nihao'
    },
    {
      circleId: '2',
      name: 'nihao'
    },
    {
      circleId: '3',
      name: 'nihao'
    },
    {
      circleId: '4',
      name: 'nihao'
    }
  ]
  @State isRefreshing: boolean = false
  @State refreshId: number = -1
  @Prop
  @Watch('changeIndex')
  activeIndex: number = 0

  async changeIndex() {
    clearTimeout(this.timeId)
    this.timeId = setTimeout(() => {
      if (this.activeIndex == 2) {
        this.angleNumber = 180
        this.scaleX = 10
        this.scaleY = 10
        this.isShow = false
        this.translateY = '120%'
        animateTo({
          duration: 1500,
          onFinish: () => {
            this.isShow = true
            animateTo({
              duration: 1000
            }, () => {
              this.translateY = '0'
            })
          }
        }, () => {
          this.scaleX = 1
          this.scaleY = 1
          this.angleNumber = 0
        })
      }
    }, 500)
  }

  async getCircleList() {
    this.circleList = await httpReq.request<IAllCircle[]>({
      url: '/circle/findAll'
    })
    this.isRefreshing = false
  }

  aboutToAppear(): void {
    this.getCircleList()
  }

  build() {
    Refresh({ refreshing: this.isRefreshing }) {
      Scroll() {
        Column() {
          Grid() {
            ForEach(this.circleList, (item: IAllCircle, index: number) => {
              GridItem() {
                Column() {
                  // Text(item.circleId)
                }
                .width('100%')
                .height(130)
                .borderRadius(30)
                .backgroundImage(index == 0 || index == 3 ? $rawfile('other/circleBg1.png') :
                $rawfile('other/circleBg2.png'))
                .backgroundImageSize(ImageSize.Cover)
                .backgroundColor(index == 0 || index == 3 ? 'rgb(202, 193, 255)' : 'rgb(255, 193, 193)')
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/InCircleContent',
                    params: {
                      circleId: item.circleId
                    }
                  })
                })
              }
            })
          }
          .width('100%')
          .height(280)
          .columnsTemplate('1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .rowsGap(15)
          .columnsGap(15)
          .margin({ bottom: 40 })
          .rotate({ angle: this.angleNumber })
          .scale({ x: this.scaleX, y: this.scaleY })
          .onAppear(() => {
            this.changeIndex()
          })

          if (this.isShow) {
            Text('今日资讯')
              .fontSize(18)
              .fontWeight(500)
              .fontColor(Color.White)
              .margin({ bottom: 15 })
              .width('100%')
              .translate({ y: this.translateY })
            NotesWaterFlow({ flowType: WaterFlowType.message })
              .translate({ y: this.translateY })
          }

        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 30, right: 30 })
    }
    .onRefreshing(() => {
      this.isRefreshing = true
      clearTimeout(this.refreshId)
      this.refreshId = setTimeout(() => {
        this.getCircleList()
      }, 500)
    })
  }
}
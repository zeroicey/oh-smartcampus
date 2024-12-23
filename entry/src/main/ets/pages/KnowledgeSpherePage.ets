import { router } from '@kit.ArkUI'
import { HcSkeletonGrid, NotesWaterFlow } from '../commons/components'
import { httpReq } from '../commons/utils'
import { IAllCircle, WaterFlowType } from '../models'

@Component
export struct KnowledgeSpherePage {
  @State isSkeleton: boolean = false
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

  async getCircleList() {
    this.isSkeleton = true
    this.circleList = await httpReq.request<IAllCircle[]>({
      url: '/circle/findAll'
    })
    this.isSkeleton = false
  }

  aboutToAppear(): void {
    this.getCircleList()
  }

  build() {
    Scroll() {
      Column({ space: 10 }) {
        Column() {
          if (this.isSkeleton) {
            HcSkeletonGrid()
          } else {
            Grid() {
              ForEach(this.circleList, (item: IAllCircle, index: number) => {
                GridItem() {
                  Column({ space: 5 }) {
                    Image($rawfile('other/caozuo.png'))
                      .width(80)
                      .height(80)
                      .borderRadius(30)
                      .alignSelf(ItemAlign.Start)
                    Text(item.name)
                      .width('100%')
                      .textAlign(TextAlign.End)
                      .fontSize(14)
                  }
                  .width('100%')
                  .height(130)
                  .borderRadius(30)
                  .padding(15)
                  .backgroundColor(Color.White)
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
            .height(320)
            .columnsTemplate('1fr 1fr')
            .rowsTemplate('1fr 1fr')
            .rowsGap(15)
            .columnsGap(15)
          }
        }
        .width('100%')
        .padding({
          left: 20,
          right: 20,
          bottom: 20,
        })
        .backgroundColor('rgb(53, 50, 66)')
        .borderRadius({ bottomLeft: 50, bottomRight: 50 })

        Column() {
          Text('今日资讯')
            .fontSize(18)
            .fontWeight(500)
            .fontColor(Color.White)
            .margin({ bottom: 15 })
            .width('100%')
          NotesWaterFlow({ flowType: WaterFlowType.message })
            .layoutWeight(1)
        }
        .width('100%')
        .padding({ left: 20, right: 20 })
        .layoutWeight(1)
        .margin({ bottom: 10 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#575470')
    .scrollBar(BarState.Off)
  }
}
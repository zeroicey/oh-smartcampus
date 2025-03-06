import { router } from '@kit.ArkUI'
import { CircleGrid, HcSkeletonGrid, NotesWaterFlow } from '../commons/components'
import { httpReq } from '../commons/utils'
import { IAllCircle, WaterFlowType } from '../models'

@Component
export struct KnowledgeSpherePage {
  @State isSkeleton: boolean = false
  @State circleList: IAllCircle[] = []

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
          Text('知识圈')
            .fontSize(36)
            .fontColor('#985e1f')
            .margin({ bottom: 6, top: 14 })
          if (this.isSkeleton) {
            HcSkeletonGrid()
          } else {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image($rawfile('other/dragonLogo_L.png'))
                .width(58)
                .translate({ y: '-80%' })
              CircleGrid({
                list: this.circleList,
                onclick: (circleId: string) => {
                  router.pushUrl({
                    url: 'pages/InCircleContent',
                    params: {
                      circleId: circleId
                    }
                  })
                }
              })
            }
          }
        }
        .width('100%')
        .padding({
          left: 20,
          right: 20,
          bottom: 20,
        })
        .backgroundColor('#fffcf3')
        .borderRadius({ bottomLeft: 50, bottomRight: 50 })

        Column() {
          Text('今日资讯')
            .fontSize(18)
            .fontWeight(500)
            .fontColor('#985e1f')
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
    .backgroundColor('#fff0cc')
    .scrollBar(BarState.Off)
  }
}
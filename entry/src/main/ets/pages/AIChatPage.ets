import { CircleGrid, HcSkeletonGrid } from '../commons/components';
import { IAllCircle } from '../models';
import { router } from '@kit.ArkUI';
import { auth, httpReq } from '../commons/utils';

@Component
export struct AIChatPage {
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
    Column() {
      Column({ space: 10 }) {
        Column() {
          Text('AI对话')
            .fontSize(36)
            .fontColor('#985e1f')
            .margin({ bottom: 6, top: 14 })
          if (this.isSkeleton) {
            HcSkeletonGrid()
          } else {
            CircleGrid({
              list: this.circleList,
              onclick: (circleId: string) => {
                auth.CheckAuth(() => {
                  router.pushUrl({
                    url: 'pages/TopicList',
                    params: {
                      circleId: circleId
                    }
                  })
                })
              }
            })
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
          Image($rawfile('other/dragonLogo_L.png'))
            .height('100%')
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#fff0cc')
  }
}
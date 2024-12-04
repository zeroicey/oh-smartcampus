import { HcNavBar } from '../commons/components'
import { router } from '@kit.ArkUI'

interface RouterParams {
  list: string[]
  activeIndex: number
}

@Entry
@Component
struct ChannelSelection {
  @State list: string[] = []
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State activeIndex: number = 0

  aboutToAppear(): void {
    const params = router.getParams() as RouterParams
    this.list = params.list
    this.activeIndex = params.activeIndex
  }

  build() {
    Column() {
      HcNavBar({ title: '知识圈', showRightIcon: false, leftIcon: $rawfile('icon/backIcon.png') })
        .margin({ bottom: 40 })
      Text('我的频道')
        .fontSize(24)
        .fontWeight(700)
        .fontColor(Color.White)
        .width('100%')
        .margin({ bottom: 19 })
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
                  router.back(1, { activeIndex: this.activeIndex })
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
    .padding({ left: 30, right: 30, bottom: this.bottomHeight })
  }
}
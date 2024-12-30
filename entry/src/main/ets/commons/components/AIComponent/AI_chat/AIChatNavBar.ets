// 自定义顶部导航栏

import { router } from '@kit.ArkUI'

@Component
export struct AIChatNavBar {
  @StorageProp('topHeight') topHeight: number = 0
  // 标题文字
  @Prop title: string = 'Empty'
  // 左边图标
  @Prop leftIcon: ResourceStr = $rawfile('icon/backIcon.png')
  // 右边图标
  @Prop rightIcon: ResourceStr = $rawfile('icon/Finished.png')
  //邮编第二个图标
  @Prop rightIconV2: ResourceStr = $rawfile('icon/MonthChatSearch.png')
  onclick = () => {
  }
  onClickBack = () => {
  }
  onClickV2 = () => {
  }

  build() {
    Row() {
      Image(this.leftIcon)
        .width(23)
        .margin({ right: 20 })
        .onClick(() => {
          this.onClickBack()
          router.back()
        })
      Text(this.title)
        .fontSize(24)
        .fontWeight(900)
        .width('60%')
        .fontColor(Color.White)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Blank()
      Image(this.rightIconV2)
        .width(30)
        .margin({ right: 10 })
        .onClick(() => {
          this.onClickV2()
        })
      Image(this.rightIcon)
        .width(25)
        .onClick(() => {
          this.onclick()
        })

    }
    .width('100%')
    .padding({ left: 30, right: 30, top: this.topHeight })
  }
}
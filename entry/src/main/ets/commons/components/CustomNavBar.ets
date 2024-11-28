import { promptAction, router } from '@kit.ArkUI'

@Preview
@Component
export struct CustomNavBar {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 标题文字
  @Prop
  title: string = '忘记密码'
  // 左边图标
  @Prop
  leftIcon: ResourceStr = $rawfile('icon/backIcon.png')
  // 右边图标
  @Prop
  rightIcon: ResourceStr = $rawfile('icon/Finished.png')
  // 是否显示右边图标
  @Prop
  showRightIcon: boolean = true

  build() {
    Row() {
      Image(this.leftIcon)
        .width(30)
        .margin({ right: 20 })
        .onClick(() => {
          router.back()
        })
      Text(this.title)
        .fontSize(36)
        .fontWeight(700)
        .fontColor(Color.White)
      Blank()
      if (this.showRightIcon) {
        Image(this.rightIcon)
          .width(40)
          .onClick(() => {
            promptAction.showToast({ message: '编辑完成' })
          })
      }
    }
    .width('100%')
    .padding({ left: 30, right: 30, top: this.topHeight })
  }
}
// 自定义顶部导航栏

import { router } from '@kit.ArkUI'

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
  // 是否显示左边图标
  @Prop
  showLeftIcon: boolean = true
  onclick = () => {

  }
  //返回键点击事件
  onClickBack = () => {

  }


  build() {
    Row() {
      if (this.showLeftIcon) {
        Image(this.leftIcon)
          .width(30)
          .margin({ right: 20 })
          .onClick(() => {
            this.onClickBack()
            router.back()
          })
      }
      Text(this.title)
        .fontSize(24)
        .fontWeight(900)
        .fontColor(Color.White)
      Blank()
      if (this.showRightIcon) {
        Image(this.rightIcon)
          .width(30)
          .onClick(() => {
            this.onclick()
          })
      }
    }
    .width('100%')
    .padding({ left: 30, right: 30, top: this.topHeight })
  }
}
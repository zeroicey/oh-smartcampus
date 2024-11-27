import { InputComponent } from '../commons/components'
import { Type } from '../models'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct LoginPage {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp('topHeight')
  topHeight: number = 0

  build() {
    Column() {
      Text('')
        .width(180)
        .height(180)
        .backgroundColor('rgb(196, 196, 196)')
        .margin({ bottom: 12, top: 40 })
      Text('登录您的账户')
        .fontSize(23)
        .fontWeight(900)
        .fontColor(Color.White)
        .margin({ bottom: 24 })
      Column({ space: 20 }) {
        InputComponent({ title: '输入账户', placeholder: '电子邮箱或手机号码' })
        InputComponent({ title: '输入密码', type: Type.password, placeholder: '请输入密码' })
      }
      .width('100%')
      .margin({ bottom: 20 })

      Row({ space: 5 }) {
        //TODO
        Checkbox()
          .width(16)
          .shape(CheckBoxShape.ROUNDED_SQUARE)
          .unselectedColor('rgb(55, 226, 204)')
          .selectedColor('rgb(55, 226, 204)')
          .mark({
            strokeColor: Color.Black,
            strokeWidth: 3
          })
        Text('记住密码')
          .fontWeight(600)
          .fontColor(Color.White)
          .fontSize(14)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .margin({ bottom: 12 })

      Button('登录')
        .fontWeight(900)
        .fontSize(20)
        .fontColor(Color.White)
        .backgroundColor('rgb(141, 135, 242)')
        .width('70%')
        .margin({ bottom: 5 })
        .onClick(() => {
          router.back()
        })
      Text('忘记密码？')
        .fontWeight(600)
        .fontColor('rgb(55, 226, 204)')
        .width('100%')
        .textAlign(TextAlign.Center)
      Blank()
      Text() {
        Span('没有账户？')
          .fontWeight(700)
          .fontColor(Color.White)
        Span('注册')
          .fontColor('rgb(55, 226, 204)')
          .fontWeight(700)
      }
      .textAlign(TextAlign.Center)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({
      left: 45,
      right: 45,
      bottom: this.bottomHeight,
      top: this.topHeight
    })
  }
}
import { router } from '@kit.ArkUI'
import { InputComponent } from '../../commons/components'
import { Type } from '../../models'

@Entry
@Component
struct ResetPassword {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp('topHeight')
  topHeight: number = 0

  build() {
    Column() {
      Row({ space: 20 }) {
        Image($rawfile('icon/encryptedBack.png'))
          .width(36)
          .onClick(() => {
            router.back()
          })
        Text('忘记密码')
          .fontSize(30)
          .fontWeight(900)
          .fontColor(Color.White)
      }
      .width('100%')
      .margin({ bottom: 50 })

      Column({ space: 30 }) {
        Text('请输入您的新密码')
          .fontColor(Color.White)
          .fontSize(24)
          .fontWeight(700)
          .width('100%')
        InputComponent({ title: '请输入新密码', type: Type.password })
        InputComponent({ title: '请确认新密码', type: Type.password })
      }

      Blank()

      Row() {
        Button('完成')
          .width('100%')
          .backgroundColor('rgb(141, 135, 242)')
          .fontSize(20)
          .fontWeight(900)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login/Login'
            })
            router.clear()
          })
      }
      .width('100%')
      .padding({ left: 15, right: 15 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({
      left: 30,
      right: 30,
      bottom: this.bottomHeight,
      top: this.topHeight
    })
  }
}
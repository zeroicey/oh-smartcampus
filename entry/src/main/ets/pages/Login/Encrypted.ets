import { router } from '@kit.ArkUI'

@Entry
@Component
struct Encrypted {
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
        Text('请回答密保问题')
          .fontColor(Color.White)
          .fontSize(24)
          .fontWeight(700)
          .width('100%')
        Column({ space: 10 }) {
          Text('你最喜欢的食物：')
            .width('100%')
            .fontSize(20)
            .fontWeight(700)
            .fontColor(Color.White)
          Row() {
            Text('回答')
              .fontSize(20)
              .fontWeight(700)
              .fontColor('rgb(229, 228, 249)')
            TextInput()
              .layoutWeight(1)
              .backgroundColor('rgb(115, 111, 138)')
          }
          .width('100%')
          .borderRadius(40)
          .backgroundColor('rgb(115, 111, 138)')
          .padding({
            right: 26,
            left: 26
          })
        }

        Column({ space: 10 }) {
          Text('你最讨厌的食物：')
            .width('100%')
            .fontSize(20)
            .fontWeight(700)
            .fontColor(Color.White)
          Row() {
            Text('回答')
              .fontSize(20)
              .fontWeight(700)
              .fontColor('rgb(229, 228, 249)')
            TextInput()
              .layoutWeight(1)
              .backgroundColor('rgb(115, 111, 138)')
          }
          .width('100%')
          .borderRadius(40)
          .backgroundColor('rgb(115, 111, 138)')
          .padding({
            right: 26,
            left: 26
          })
        }

        Column({ space: 10 }) {
          Text('一个奇怪的问题：')
            .width('100%')
            .fontSize(20)
            .fontWeight(700)
            .fontColor(Color.White)
          Row() {
            Text('回答')
              .fontSize(20)
              .fontWeight(700)
              .fontColor('rgb(229, 228, 249)')
            TextInput()
              .layoutWeight(1)
              .backgroundColor('rgb(115, 111, 138)')
          }
          .width('100%')
          .borderRadius(40)
          .backgroundColor('rgb(115, 111, 138)')
          .padding({
            right: 26,
            left: 26
          })
        }
      }

      Blank()

      Row() {
        Button('验证')
          .width('100%')
          .backgroundColor('rgb(141, 135, 242)')
          .fontSize(20)
          .fontWeight(900)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login/ResetPassword'
            })
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
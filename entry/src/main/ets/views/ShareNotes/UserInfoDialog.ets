@CustomDialog
export struct UserInfoDialog {
  controller: CustomDialogController

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Image('https://pic1.zhimg.com/v2-e5962333059d0dc857301394d30f396d_r.jpg?source=1940ef5c')
          .width(142)
          .border({
            color: 'rgb(141, 135, 242)',
            width: 8
          })
          .borderRadius(80)
        Text('用户001')
          .fontSize(20)
          .fontWeight(900)
          .fontColor('rgb(0, 0, 0)')
          .width(100)
          .height(30)
          .borderRadius(5)
          .textAlign(TextAlign.Center)
          .backgroundColor('rgb(141, 135, 242)')
      }
      .width(150)
      .height(150)
      .translate({ y: '-50%' })

      Column({ space: 15 }) {
        Text('已学课程：65%')
          .fontColor(Color.White)
          .width('100%')
          .fontSize(20)
          .fontWeight(900)
          .textAlign(TextAlign.Center)
        Text('我是百变小樱，不是百变酒精')
          .fontColor(Color.White)
          .width('100%')
          .fontSize(20)
          .fontWeight(900)
          .textAlign(TextAlign.Center)
        Row({ space: 25 }) {
          Column() {
            Text('350')
              .fontColor('rgb(97, 217, 201)')
              .fontSize(24)
              .fontWeight(900)
            Text('累计签到')
              .fontColor('rgb(232, 232, 232)')
              .fontSize(14)
              .fontWeight(900)
          }

          Column() {
            Text('350')
              .fontColor('rgb(97, 217, 201)')
              .fontSize(24)
              .fontWeight(900)
            Text('累计签到')
              .fontColor('rgb(232, 232, 232)')
              .fontSize(14)
              .fontWeight(900)
          }

          Column() {
            Text('350')
              .fontColor('rgb(97, 217, 201)')
              .fontSize(24)
              .fontWeight(900)
            Text('累计签到')
              .fontColor('rgb(232, 232, 232)')
              .fontSize(14)
              .fontWeight(900)
          }
        }
      }
      .width('100%')
      .translate({ y: -45 })

    }
    .width(300)
    .height(250)
    .backgroundColor('rgb(53, 50, 66)')
    .borderRadius(30)
    .padding({ left: 20, right: 20 })
  }
}
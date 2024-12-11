@Component
export struct MineStudyTime {
  build() {
    Row() {
      Column({ space: 12 }) {
        Text() {
          Span('学习时长')
            .fontWeight(900)
            .fontColor(Color.White)
          ImageSpan($rawfile('icon/duration.png'))
            .width(17)
        }

        Text() {
          Span('138')
            .fontWeight(700)
            .fontColor(Color.Black)
            .fontSize(20)
          Span('小时')
            .fontWeight(600)
            .fontColor(Color.White)
          Span('43')
            .fontWeight(700)
            .fontColor(Color.Black)
            .fontSize(24)
          Span('分钟')
            .fontWeight(600)
            .fontColor(Color.White)
        }
      }
      .height(90)
      .width(150)
      .padding(10)
      .backgroundColor('rgb(184, 181, 246)')
      .borderRadius(30)
      .justifyContent(FlexAlign.Center)

      Column() {
        Text() {
          Span('连续打卡天数')
            .fontWeight(900)
            .fontColor(Color.White)
          ImageSpan($rawfile('icon/clockIn.png'))
            .width(17)
        }

        Text() {
          Span('23')
            .fontWeight(700)
            .fontColor(Color.Black)
            .fontSize(48)
          Span('天')
            .fontWeight(600)
            .fontColor(Color.White)
        }
      }
      .height(90)
      .width(150)
      .padding(10)
      .backgroundColor('rgb(184, 181, 246)')
      .borderRadius(30)
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
  }
}
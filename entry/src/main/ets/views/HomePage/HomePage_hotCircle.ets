

@Component
export struct HomePage_hotCircle {
  @Link circle: number[]
  build() {
    Column({ space: 5 }) { //hot circle
      Text('热门圈子')
        .fontColor(Color.White)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('90%')

      Row() {
        Blank().width(10)
        ForEach(this.circle, (item: number, index: number) => {
          Column() {
            Image($rawfile('other/Mock/Enpty.png'))
              .height(50)
              .width(50)
              .borderRadius(50)
          }

          Blank().width(30)
        })
      }
      .width('90%')
    }
    .borderRadius(25)
    .width('100%')
    .height('13%')
    .backgroundColor('#ffc1c1')
  }
}
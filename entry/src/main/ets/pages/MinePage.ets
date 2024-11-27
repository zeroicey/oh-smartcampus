@Component
export struct MinePage {
  @StorageProp('topHeight')
  topHeight: number = 0

  build() {
    Column() {
      Row() {
        Text('我的')
          .fontSize(26)
          .fontWeight(900)
          .fontColor(Color.White)
        Blank()
        Row() {
          Image($rawfile('icon/PieChart.png'))
            .width(25)
          Text('学习分析')
            .fontSize(18)
            .fontWeight(900)
            .fontColor('rgb(255, 153, 150)')
        }
        .padding({ left: 13, right: 13 })
      }
      .width('100%')

      Row({ space: 24 }) {
        Image('https://pic1.zhimg.com/v2-e5962333059d0dc857301394d30f396d_r.jpg?source=1940ef5c')
          .width(100)
          .borderRadius(50)
        Column() {
          Text('Hua')
            .width('100%')
            .fontSize(23)
            .fontWeight(900)
            .fontColor(Color.White)
          Text('woyebuzhidao@zhetamashisha.com')
            .width('100%')
            .fontWeight(700)
            .fontColor(Color.White)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ top: 26, bottom: 42 })
      .padding({ right: 14 })

      Column({ space: 24 }) {
        Column({ space: 8 }) {
          Text() {
            Span('名字')
              .fontColor(Color.White)
              .fontWeight(600)
            Span('*')
              .fontColor('rgb(242, 111, 56)')
          }
          .width('100%')
          .padding({ left: 24 })

          TextInput()
            .type(InputType.Normal)
        }
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding({ left: 22, right: 22, top: this.topHeight + 40 })
  }
}
@Entry
@Component
export struct CommentReply {
  build() {
    Column() {
      Row({ space: 5 }) {
        Image('https://pic3.zhimg.com/v2-b173b089c839b82b923260d8acf1688f_r.jpg?source=1940ef5c')
          .width(50)
          .borderRadius(25)
          .margin({ left: 10 })
          .alignSelf(ItemAlign.Start)
        Column() {
          Row() {
            Text('用户002')
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(900)
            Blank()
            Column() {
              Image(false ? $rawfile('icon/like_Selected.png') : $rawfile('icon/userLike.png'))
                .width(24)
              if (true) {
                Text('24')
                  .fontSize(14)
                  .fontWeight(900)
                  .fontColor('rgb(177, 177, 177)')
              }
            }
          }
          .width('100%')

          Text('这里hyauisdhiudhiahaiso;aisd;ia说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话\n' +
            '这里说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话')
            .width('100%')
            .margin({ bottom: 18 })
            .fontSize(16)
            .fontWeight(900)
            .fontColor('rgb(241, 241, 241)')
          Row() {
            Divider()
              .width(50)
              .height(2)
              .color('rgb(136, 136, 136)')
            Text('展开25条回复')
              .fontSize(12)
              .fontWeight(900)
              .fontColor('rgb(136, 136, 136)')
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .margin({ bottom: 20 })
        }
        .layoutWeight(1)
      }

      Divider()
        .width('100%')
        .height(2)
        .color('rgb(136, 136, 136)')
    }
    .width('100%')
  }
}
// 回复评论组件

@Component
export struct CommentReply {
  // 是否设置右侧点赞按钮
  @Prop showRightIcon: boolean = true
  @State praiseFlag: boolean = false

  build() {
    Row({ space: 5 }) {
      Image('https://pic3.zhimg.com/v2-b173b089c839b82b923260d8acf1688f_r.jpg?source=1940ef5c')
        .width(50)
        .borderRadius(25)
        .margin({ left: 10 })
        .alignSelf(ItemAlign.Start)
      Column() {
        Row() {
          Text('用户002')
            .fontColor('#c77a28')
            .fontWeight(900)
          Blank()
          if (this.showRightIcon) {
            Column() {
              Image(this.praiseFlag ? $rawfile('icon/like_Selected.png') : $rawfile('icon/like.png'))
                .width(24)
              Text('24')
                .fontSize(14)
                .fontWeight(900)
                .fontColor('#c77a28')
            }
            .onClick(() => {
              this.praiseFlag = !this.praiseFlag
            })
          }
        }
        .width('100%')
        .height(40)

        Text('这里hyauisdhiudhiahaiso;aisd;ia说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话')
          .width('100%')
          .margin({ bottom: 18 })
          .fontSize(14)
          .fontColor(Color.Black)
      }
      .layoutWeight(1)
    }
  }
}
@Component
export struct SNNavBar {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0

  build() {
    Row({ space: 30 }) {
      Row({ space: 5 }) {
        Image(false ? $rawfile('icon/like_Selected.png') : $rawfile('icon/like.png'))
          .width(37)
        Text('432')
          .fontColor(false ? 'rgb(255, 153, 150)' : Color.White)
          .fontSize(18)
          .fontWeight(900)
      }
      .alignItems(VerticalAlign.Bottom)

      Row({ space: 5 }) {
        Image(false ? $rawfile('icon/collection_Selected.png') : $rawfile('icon/collection.png'))
          .width(37)
        Text('432')
          .fontColor(false ? 'rgb(242, 245, 95)' : Color.White)
          .fontSize(18)
          .fontWeight(900)

      }
      .alignItems(VerticalAlign.Bottom)

      Row({ space: 5 }) {
        Image($rawfile('icon/review.png'))
          .width(36)
        Text('432')
          .fontColor(Color.White)
          .fontSize(18)
          .fontWeight(900)
      }
      .alignItems(VerticalAlign.Bottom)
    }
    .width('100%')
    .borderRadius(20)
    .backgroundColor('rgb(59, 59, 59)')
    .padding({
      left: 50,
      right: 50,
      bottom: this.bottomHeight,
      top: 25
    })
  }
}
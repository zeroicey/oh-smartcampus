@Preview
@Component
export struct HcSkeletonItem {
  build() {
    Column() {
      Text()
        .width('100%')
        .height(45)
        .backgroundColor('rgba(166, 166, 166, 0.5)')
        .borderRadius({ bottomLeft: 20, bottomRight: 20 })
        .backdropBlur(20)
    }
    .width('100%')
    .borderRadius(20)
    .backgroundColor(Color.Gray)
    .height(210)
    .justifyContent(FlexAlign.End)
  }
}
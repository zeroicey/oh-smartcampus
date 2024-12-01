// 分数线组件
@Component
export struct GradeLine {
  build() {
    Column() {
      Row({ space: 33 }) {
        Text('广东省')
          .width('50%')
          .fontSize(36)
          .fontColor(Color.White)
          .fontWeight(900)
          .padding({ right: 17 })
          .border({
            width: { right: 3 },
            color: 'rgb(141, 135, 242)'
          })
          .textAlign(TextAlign.End)
        Column() {
          Text('计算机专业')
            .fontSize(18)
            .fontWeight(900)
            .fontColor(Color.White)
          Text('563')
            .fontSize(36)
            .fontWeight(900)
            .fontColor('rgb(55, 226, 204)')
        }
        .width('50%')
        .alignItems(HorizontalAlign.Start)
      }
    }
    .height(190)
    .backgroundColor('rgb(196, 196, 196)')
    .padding(20)
    .width('100%')
    .borderRadius(20)
  }
}
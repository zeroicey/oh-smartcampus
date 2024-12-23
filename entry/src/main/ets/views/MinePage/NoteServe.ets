@Component
export struct NoteServe {
  @Prop icon: ResourceStr

  build() {
    Row() {
      Image(this.icon)
        .width(35)
    }
    .width(100)
    .height(60)
    .borderRadius(20)
    .justifyContent(FlexAlign.Center)
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [['rgb(198, 255, 248)', 0.02], ['rgb(43, 190, 171)', 1]]
    })
  }
}
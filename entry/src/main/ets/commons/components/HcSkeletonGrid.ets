@Component
export struct HcSkeletonGrid {
  @State opacityValue: number = 1

  build() {
    Grid() {
      ForEach(Array.from({ length: 4 }), () => {
        GridItem()
          .width('100%')
          .height(130)
          .borderRadius(30)
          .backgroundColor(Color.Gray)
      })
    }
    .opacity(this.opacityValue)
    .width('100%')
    .height(320)
    .columnsTemplate('1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .rowsGap(15)
    .columnsGap(15)
    .animation({
      duration: 600,
      iterations: -1,
      playMode: PlayMode.Alternate,
      curve: Curve.EaseInOut
    })
    .onAppear(() => {
      this.opacityValue = 0.5
    })
  }
}
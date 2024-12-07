import { HcSkeletonItem } from '.'

// 骨架屏封装
@Component
export struct HcSkeleton {
  @BuilderParam
  default: () => void = this.defaultBuilder
  @State opacityValue: number = 1

  @Builder
  defaultBuilder() {
    WaterFlow() {
      ForEach(Array.from({ length: 8 }), () => {
        HcSkeletonItem()
      })
    }
    .columnsTemplate('1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)
  }

  build() {
    Row({ space: 10 }) {
      this.defaultBuilder()
    }
    .opacity(this.opacityValue)
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
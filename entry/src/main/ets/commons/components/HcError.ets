/**
 * 错误重试占位组件
 *
 * 与 HcEmpty 的区别：HcError 强调「出错了 + 可重试」，
 * 页面的请求失败分支统一使用该组件，避免出现白屏。
 */
@Component
export struct HcError {
  /** 错误文案 */
  @Prop message: string = '网络开小差了'
  /** 补充说明 */
  @Prop description: string = '请检查网络后重试'
  /** 重试按钮文案 */
  @Prop retryText: string = '重新加载'
  /** 图标 */
  @Prop icon: ResourceStr = $rawfile('other/notBright.png')
  /** 是否撑满剩余空间 */
  @Prop fill: boolean = true
  onretry = () => {
  }

  build() {
    Column({ space: 12 }) {
      Image(this.icon)
        .width(120)
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
        .opacity(0.8)

      Text(this.message)
        .fontSize(16)
        .fontWeight(700)
        .fontColor($r('app.color.common_gray_02'))
        .textAlign(TextAlign.Center)

      Text(this.description)
        .fontSize(13)
        .fontColor($r('app.color.common_gray_01'))
        .textAlign(TextAlign.Center)

      Row({ space: 8 }) {
        Image($rawfile('icon/reload.png'))
          .width(16)
          .aspectRatio(1)
        Text(this.retryText)
          .fontSize(15)
          .fontWeight(700)
          .fontColor($r('app.color.common_blue'))
      }
      .padding({ left: 20, right: 20, top: 8, bottom: 8 })
      .borderRadius(20)
      .border({ width: 1, color: $r('app.color.common_blue') })
      .onClick(() => {
        this.onretry()
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height(this.fill ? '100%' : 'auto')
    .padding({ top: 20, bottom: 20 })
  }
}

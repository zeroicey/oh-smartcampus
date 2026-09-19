/**
 * 空状态占位组件
 *
 * 用于列表为空、搜索无结果、未登录等场景，统一视觉与文案层级。
 */
@Component
export struct HcEmpty {
  /** 主文案 */
  @Prop title: string = '暂无内容'
  /** 副文案，可为空 */
  @Prop description: string = ''
  /** 占位图，默认使用项目内置的空态图 */
  @Prop image: ResourceStr = $rawfile('other/Mock/Enpty.png')
  /** 占位图尺寸 */
  @Prop imageSize: number = 160
  /** 操作按钮文案，为空则不展示按钮 */
  @Prop actionText: string = ''
  /** 容器背景色 */
  @Prop bgColor: ResourceColor = Color.Transparent
  /** 是否撑满剩余空间 */
  @Prop fill: boolean = true
  onclick = () => {
  }

  build() {
    Column({ space: 12 }) {
      Image(this.image)
        .width(this.imageSize)
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
        .opacity(0.7)

      Text(this.title)
        .fontSize(16)
        .fontWeight(700)
        .fontColor($r('app.color.common_gray_02'))
        .textAlign(TextAlign.Center)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      if (this.description) {
        Text(this.description)
          .fontSize(13)
          .fontColor($r('app.color.common_gray_01'))
          .textAlign(TextAlign.Center)
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .padding({ left: 30, right: 30 })
      }

      if (this.actionText) {
        Text(this.actionText)
          .fontSize(15)
          .fontWeight(700)
          .fontColor(Color.White)
          .height(40)
          .constraintSize({ minWidth: 120 })
          .padding({ left: 20, right: 20 })
          .borderRadius(20)
          .backgroundColor($r('app.color.common_blue'))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.onclick()
          })
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height(this.fill ? '100%' : 'auto')
    .backgroundColor(this.bgColor)
    .padding({ top: 20, bottom: 20 })
  }
}

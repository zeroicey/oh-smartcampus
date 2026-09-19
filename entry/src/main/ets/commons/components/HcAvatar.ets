/**
 * 头像组件
 *
 * 统一处理「无头像 → 默认头像」「加载失败 → 兜底」的逻辑，
 * 并在头像右上角支持角标（如未读数）。
 */
@Component
export struct HcAvatar {
  /** 头像地址 */
  @Prop src: ResourceStr = ''
  /** 尺寸 */
  @Prop size: number = 40
  /** 圆角，默认为圆形（size/2） */
  @Prop radius: number = -1
  /** 角标文案，为空则不显示 */
  @Prop badge: string = ''
  /** 是否可点击 */
  @Prop clickable: boolean = false
  /** 默认兜底图 */
  @Prop fallback: ResourceStr = $rawfile('other/ic_mine_avatar.svg')
  onclick = () => {
  }

  private getRadius(): number {
    return this.radius >= 0 ? this.radius : this.size / 2
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.src || this.fallback)
        .alt(this.fallback)
        .width(this.size)
        .height(this.size)
        .borderRadius(this.getRadius())
        .objectFit(ImageFit.Cover)
        .backgroundColor($r('app.color.common_gray_bg'))

      if (this.badge) {
        Text(this.badge)
          .fontSize(9)
          .fontColor(Color.White)
          .backgroundColor('#FF3B30')
          .borderRadius(8)
          .constraintSize({ minWidth: 16 })
          .height(16)
          .padding({ left: 4, right: 4 })
          .textAlign(TextAlign.Center)
          .margin({ top: -2, right: -2 })
      }
    }
    .width(this.size)
    .height(this.size)
    .onClick(() => {
      if (this.clickable) {
        this.onclick()
      }
    })
  }
}

/**
 * 标签组件
 *
 * 用于话题标签、状态标记、难度标识等场景。
 * selected 使用 @Prop（单向）+ 内部状态，父组件可直接传字面量，
 * 需要感知变化时通过 onchange 回调获取。
 */
@Component
export struct HcTag {
  @Prop text: string = ''
  /** 主色 */
  @Prop color: ResourceColor = $r('app.color.common_blue')
  /** 是否使用描边样式（默认填充样式） */
  @Prop outlined: boolean = false
  /** 是否可选中 */
  @Prop selectable: boolean = false
  /** 初始选中态 */
  @Prop selected: boolean = false
  /** 尺寸：small 20vp / normal 26vp / large 32vp */
  @Prop size: string = 'normal'
  @State innerSelected: boolean = false
  onclick = () => {
  }
  onchange = (selected: boolean) => {
  }

  aboutToAppear(): void {
    this.innerSelected = this.selected
  }

  private getHeight(): number {
    if (this.size === 'small') {
      return 20
    }
    if (this.size === 'large') {
      return 32
    }
    return 26
  }

  private getFontSize(): number {
    if (this.size === 'small') {
      return 10
    }
    if (this.size === 'large') {
      return 14
    }
    return 12
  }

  private isActive(): boolean {
    return this.selectable ? this.innerSelected : !this.outlined
  }

  build() {
    Text(this.text)
      .fontSize(this.getFontSize())
      .fontWeight(700)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .height(this.getHeight())
      .constraintSize({ maxWidth: 160 })
      .padding({ left: 10, right: 10 })
      .borderRadius(this.getHeight() / 2)
      .textAlign(TextAlign.Center)
      .fontColor(this.isActive() ? Color.White : this.color)
      .backgroundColor(this.isActive() ? this.color : Color.Transparent)
      .border({
        width: this.isActive() ? 0 : 1,
        color: this.color
      })
      .onClick(() => {
        if (this.selectable) {
          this.innerSelected = !this.innerSelected
          this.onchange(this.innerSelected)
        }
        this.onclick()
      })
  }
}

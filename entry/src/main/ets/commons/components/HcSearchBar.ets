/**
 * 搜索栏组件
 *
 * 用于知识圈 / 笔记列表的顶部搜索，支持防抖回调与一键清空。
 */
@Component
export struct HcSearchBar {
  /** 占位提示 */
  @Prop placeholder: string = '搜索内容'
  /** 搜索栏高度 */
  @Prop barHeight: number = 44
  /** 是否自动聚焦 */
  @Prop autoFocus: boolean = false
  /** 输入内容 */
  @Link keyword: string
  /** 防抖间隔（毫秒），0 表示不防抖 */
  @Prop debounce: number = 300
  /** 搜索图标 */
  @Prop searchIcon: ResourceStr = $rawfile('icon/search.png')
  /** 输入内容变化（防抖后） */
  onsearch = (keyword: string) => {
  }
  /** 清空回调 */
  onclear = () => {
  }
  /** 输入过程中的实时回调（不防抖） */
  oninput = (keyword: string) => {
  }
  private timerId: number = -1

  aboutToDisappear(): void {
    if (this.timerId !== -1) {
      clearTimeout(this.timerId)
      this.timerId = -1
    }
  }

  private emitSearch(value: string): void {
    if (this.debounce <= 0) {
      this.onsearch(value)
      return
    }
    if (this.timerId !== -1) {
      clearTimeout(this.timerId)
    }
    this.timerId = setTimeout(() => {
      this.onsearch(value)
      this.timerId = -1
    }, this.debounce)
  }

  build() {
    Row({ space: 10 }) {
      Image(this.searchIcon)
        .width(18)
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
        .opacity(0.6)

      TextInput({ text: $$this.keyword, placeholder: this.placeholder })
        .layoutWeight(1)
        .height(this.barHeight)
        .fontSize(15)
        .placeholderFont({ size: 15 })
        .backgroundColor(Color.Transparent)
        .padding(0)
        .maxLength(50)
        .enableKeyboardOnFocus(true)
        .focusOnTouch(true)
        .onChange((value: string) => {
          this.oninput(value)
          this.emitSearch(value)
        })
        .onSubmit(() => {
          this.onsearch(this.keyword)
        })

      if (this.keyword.length > 0) {
        Image($rawfile('icon/closeEyeIcon.png'))
          .width(16)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
          .opacity(0.5)
          .onClick(() => {
            this.keyword = ''
            this.onclear()
            this.emitSearch('')
          })
      }
    }
    .width('100%')
    .padding({ left: 14, right: 14, top: 6, bottom: 6 })
    .borderRadius(this.barHeight / 2)
    .backgroundColor($r('app.color.common_gray_bg'))
  }
}

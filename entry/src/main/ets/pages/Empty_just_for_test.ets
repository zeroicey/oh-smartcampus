

@Entry
@Component
export struct Empty_just_for_test {
  build() {
    Column() {
      Image('https://sfile.chatglm.cn/markmap/84f8ea3c-286e-42f8-b7eb-32768ea39145.png')
        .height(200)
        .width(200)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)

  }
}
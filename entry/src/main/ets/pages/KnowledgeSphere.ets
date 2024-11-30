import { router } from '@kit.ArkUI'

@Entry
@Component
export struct KnowledgeSphere {
  @State angleNumber: number = 45

  build() {
    Column() {
      Grid() {
        ForEach(Array.from({ length: 4 }), (item: null, index: number) => {
          GridItem() {
            Column() {
              Text(index.toString())
            }
            .width(130)
            .height(130)
            .borderRadius(30)
            .backgroundColor(index == 0 || index == 3 ? 'rgb(202, 193, 255)' : 'rgb(255, 193, 193)')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/IncircleContent'
              })
            })
          }
        })
      }
      .width(280)
      .height(280)
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .rowsGap(15)
      .columnsGap(15)
      .rotate({ angle: this.angleNumber })
      .onAppear(() => {
        animateTo({
          duration: 1000
        }, () => {
          this.angleNumber = 0
        })
      })

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ left: 30, right: 30 })
  }
}
import { router } from '@kit.ArkUI'

@Component
export struct MinePage {
  @StorageProp('topHeight')
  topHeight: number = 0

  build() {
    Column() {
      Column() {
        Row() {
          Image($rawfile('icon/Setting.png'))
            .width(15)
        }
        .width(30)
        .height(30)
        .backgroundColor('rgba(141, 135, 242, 0.8)')
        .justifyContent(FlexAlign.Center)
        .borderRadius(15)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Mine/InformationEdite'
          })
        })

        Row({ space: 13 }) {
          Image('https://pic1.zhimg.com/v2-e5962333059d0dc857301394d30f396d_r.jpg?source=1940ef5c')
            .width(80)
            .borderRadius(40)
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 30, right: 30 })
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .height('100%')
    .padding({ top: this.topHeight })
  }
}
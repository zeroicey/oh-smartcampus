import { ImagePreviewOption } from '@xwf/image_preview'
import { ImagePreview } from '@xwf/image_preview'
import { promptAction, router } from '@kit.ArkUI'


export function pushImagePreview(option:ImagePreviewOption) {
  router.pushUrl({
    url: 'pages/ImgPreview',
    params: option
  })
}

@Entry
@Component
export struct ImagePreviewPage {
  data:ImagePreviewOption = router.getParams() as ImagePreviewOption

  build() {
    Stack() {
      ImagePreview({
        option:this.data,
        colors:[Color.Black,Color.White],
        indicator:new DotIndicator().color(Color.Gray).selectedColor(Color.Blue),
        onChange: (index:number)=> {
          promptAction.showToast({message:`图片下标:${index}`})
        }
      })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .height('100%')
    .width('100%')
  }
}
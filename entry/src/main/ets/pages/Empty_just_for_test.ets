import { sourceDialog } from "../commons/components/AIComponent/AI_chat/dialog/sourceDialog"
import { QuestionAnswer } from "../models/tempModel/Interface/ChatQandA"


@Entry
@Component
export struct Empty_just_for_test {
  @State SourceArr:QuestionAnswer[] = []
  controller:CustomDialogController=new CustomDialogController({
    builder:sourceDialog({
      souArr: this.SourceArr
    })
  })
  build() {
    Column() {
      Image($rawfile('icon/backIcon.png'))
        .height(200)
        .width(200)
        .onClick(()=>{
          this.controller.open()
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)

  }
}
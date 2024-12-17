import { QuestionAnswer } from "../../../../../models/tempModel/Interface/ChatQandA"


@CustomDialog
export struct sourceDialog {
  @State colorArr: Array<string> = ['#ffcccc','#ffe5cc','#ffffcc','#ccccff','#e5ffcc']
  @Prop souArr: Array<QuestionAnswer>
  controller:CustomDialogController
  build() {
    Column(){
      Scroll() {
        List() {
          ForEach(this.souArr, (item: QuestionAnswer,index: number) => {
            ListItem() {
              Column({ space: 10 }) {
                Text("Q:   " + item.q)
                  .fontSize(24)
                  //.fontColor('#FFFFFF')
                  .margin({ top: 20 })
                  .width('100%')
                  .textAlign(TextAlign.Start)

                Text("A:   " + item.a)
                  .fontSize(24)
                  //.fontColor('#FFFFFF')
                  .margin({ top: 20 })
                  .width('100%')
                  .textAlign(TextAlign.Start)

                Text('出处：  《' + item.sourceName+'》')
                  .fontSize(24)
                  //.fontColor('#FFFFFF')
                  .margin({ top: 20 })
                  .width('100%')
                  .textAlign(TextAlign.Start)
                Blank().height(30)
              }
              .backgroundColor(this.colorArr[index%5])
            }
          })
        }
      }
      .height('auto')
      .width('100%')
    }
    .width('80%')
    .height('auto')
    .backgroundColor('#2b2b2b')
  }
}
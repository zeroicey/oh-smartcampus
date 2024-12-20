import { QuestionAnswer, scoreItem } from "../../../../../models/tempModel/Interface/ChatQandA"
@CustomDialog
export struct sourceDialog {
   @State colorArr: Array<string> = ['#ffcccc','#ffe5cc','#ffffcc','#ccccff','#e5ffcc']
   @Prop souArr: Array<QuestionAnswer> = []
   controller:CustomDialogController
  build() {
    Column(){
      Scroll() {
        List() {
          ForEach(this.souArr, (item: QuestionAnswer,index: number) => {
            ListItem() {
              Column({ space: 10 }) {
                Text("Q:   \n" + item.q)
                  .fontSize(24)
                  //.fontColor('#FFFFFF')
                  .margin({ top: 20 })
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .backgroundColor(this.colorArr[index%5])

                Text("A:   \n" + item.a)
                  .fontSize(24)
                  //.fontColor('#FFFFFF')
                  .margin({ top: 20 })
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .backgroundColor(this.colorArr[index%4])

                Text('出处：  \n《' + item.sourceName+'》')
                  .fontSize(24)
                  //.fontColor('#FFFFFF')
                  .margin({ top: 20 })
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .backgroundColor(this.colorArr[index%3])
                Blank().height(30)
              }
              .backgroundColor(this.colorArr[index%5])
            }
          })
        }
      }
      .height('100%')
      .width('90%')
    }
    .width('80%')
    .height('60%')
    //.backgroundColor('#2b2b2b')
  }

}


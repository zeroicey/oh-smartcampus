
import router from '@ohos.router';

@Component
export struct HomePage_InfFastLook{
  @Link circle:number[]
  build() {
    Column({ space: 20 }) { //zixunsukan
      Row() {
        Text('资讯速看')
          .fontColor(Color.White)
          .fontSize(20)
          .fontWeight(FontWeight.Bolder)
          .width('70%')
        Text('查看全部 >')
          .fontColor(Color.Gray)
          .fontSize(15)
          .width('30%')
          .textAlign(TextAlign.End)

      }

      Scroll() {
        Row() {
          ForEach(this.circle, (item: number, index: number) => {
            Row() {
              Text('')
                .width(100)
                .height(22)
                .borderRadius(10)
                .backgroundColor('#c4c4c4')
            }

            Blank().width(10)
          })
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)


      Column() {
        // TODO
        ForEach(this.circle, (item: number, index: number) => {
          Column({ space: 10 }) {
            Row() {
              Text('java')//debug
              //
            }
            .backgroundColor('#c4c4c4')
            .width('100%')
            .height(80)
            .borderRadius(20)
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/AIChat'
              })
            })
          }

          Blank().height(10)
        })
      }
      //.backgroundColor(Color.Pink)
      .width('90%')

    }
    .width('100%')
  }
}
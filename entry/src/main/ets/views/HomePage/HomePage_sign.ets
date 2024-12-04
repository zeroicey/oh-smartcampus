import { week } from 'ets/pages/HomePage'
import router from '@ohos.router';
@Component
export struct HomePage_sign{
  @Link week:Array<week>
  build() {
    Stack() { //打卡及ai
      Image($rawfile('other/card/homePageCard.png'))
        .width('100%')
        .height(200)
      Column() {
        Row() {
          Blank().width(12)
          Text('AI')
            .fontColor(Color.Black)
            .backgroundColor(Color.White)
            .fontWeight(FontWeight.Bolder)
            .fontSize(25)
            .height(40)
            .width(40)
            .textAlign(TextAlign.Center)
            .borderRadius(20)
          Blank().width('8%')

          Row({ space: 3 }) {
            Blank().width(4)
            ForEach(this.week, (item: week, index: number) => {
              Row() {
                Text(item.day.toString())
                  .fontColor(Color.Black)
                  .fontWeight(FontWeight.Bolder)
                  .fontSize(20)
                  .height(30)
                  .width(30)
                  .textAlign(TextAlign.Center)
                  .borderRadius(50)
                  .backgroundColor(item.color)
              }
            })
          }
          .width('75%')
          .height('80%')
          .backgroundColor('#c4c4c4')
          .margin({ bottom: 15, right: 15 })
          .borderRadius(20)
          .onClick(()=>{
            console.log('aaaaaa')
            router.pushUrl({
              url: 'pages/Sign'
            })
          })
        }
        //.backgroundColor(Color.Pink)
        .width('100%')
        .height('30%')

        Column() {

        }
        .width('100%')
        .height('70%')

        //.backgroundColor(Color.Blue).opacity(0.2)//debug
      }
    }
    .height('27%')
  }
}
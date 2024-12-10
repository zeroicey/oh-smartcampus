import { week } from 'ets/pages/HomePage'
import router from '@ohos.router';
@Component
export struct HomePage_sign{
  @Link week:Array<week>
  build() {
    Stack() { //打卡及ai
      Image($rawfile('other/card/homePageCard.png'))
        .width('100%')
        .height(220)

      Column() {
        Row() {
          Blank().width(12)
          Image($rawfile('icon/paw.png'))
            .height(40)
            .width(40)

          Blank().width('5%')

          Row({ space: 7 }) {
            Blank().width(5)
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
          .width('80%')
          .height('80%')
          .backgroundColor('#c4c4c4')
          .margin({bottom:15, right: 15 })
          .borderRadius(25)
          .onClick(()=>{
            console.log('aaaaaa')
            router.pushUrl({
              url: 'pages/Sign'
            })
          })
        }
        //.backgroundColor(Color.Pink)
        .width('100%')
        .height('32%')
        .backgroundColor(Color.Transparent)

        Column() {
          Column(){
            Image($rawfile('other/card/cardFace.png'))//debug
              .height(90)
              .width(117)
              .align(Alignment.Center)
              .margin({top:25})
          }
          .width('90%')
          .height(130)
          //.backgroundColor(Color.Pink)//debug
          .borderRadius(25)
        }
        .height('70%')



        //.backgroundColor(Color.Blue).opacity(0.2)//debug
      }
    }
    .height('30%')

  }
}
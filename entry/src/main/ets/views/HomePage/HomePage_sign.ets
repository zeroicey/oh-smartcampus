import { week } from 'ets/pages/HomePage'
import router from '@ohos.router';
import { auth } from '../../commons/utils';

@Component
export struct HomePage_sign{
  @Link week:Array<week>
  build() {
      Column() {
          Stack() {
            Image($rawfile('icon/homeSignCard_L.png'))//photo change
              .width('100%')
            Column({ space: 10}) {
              Text('每日打卡进度')
                .fontColor('#c77a28')//font color
                .fontSize(45)
                .width('100%')
                .textAlign(TextAlign.Center)
              Row({ space: 8 }) {//space: 7
                Blank().width(5)
                ForEach(this.week, (item: week) => {
                  Row() {
                    Text(item.day.toString())
                      .fontColor(Color.White)//color change
                      .fontWeight(FontWeight.Bolder)
                      .fontSize(20)
                      .height(38)
                      .width(38)
                      .textAlign(TextAlign.Center)
                      .borderRadius(50)
                      .backgroundColor(item.color)
                  }
                })
              }
              .width('100%')
              .height('20%')
              .margin({ left: 10 })
            }
            .margin({top: 20})
          }
      }
      .height('20%')
      .onClick(() => {
        auth.CheckAuth(()=>{
          router.pushUrl({
            url: 'pages/Sign'
          })
        })
      })
  }
}


import { week } from 'ets/pages/HomePage'
import router from '@ohos.router';
import { auth } from '../../commons/utils';

@Component
export struct HomePage_sign{
  @Link week:Array<week>
  build() {
      Column() {
          Stack() {
            Image($rawfile('icon/homeSignCard.png'))
              .width('100%')
            Column({ space: 10}) {
              Text('每日打卡进度')
                .fontColor(Color.White)
                .fontSize(45)
                .width('100%')
                .textAlign(TextAlign.Center)
              Row({ space: 18 }) {
                Blank().width(5)
                ForEach(this.week, (item: week, index: number) => {
                  Row() {
                    Text(item.day.toString())
                      .fontColor(Color.Black)
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
            .margin({top: 35})
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

/*
build() {
      Column() {
          Stack() {
            Image($rawfile('icon/homeSignCard.png'))
              .width('100%')
            Column({ space: 10}) {
              Text('每日打卡进度')
                .fontColor(Color.White)
                .fontSize(45)
                .width('100%')
                .textAlign(TextAlign.Center)
              Row({ space: 7 }) {
                Blank().width(5)
                ForEach(this.week, (item: week, index: number) => {
                  Row() {
                    Text(item.day.toString())
                      .fontColor(Color.Black)
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
      .height('15%')
      .onClick(() => {
        auth.CheckAuth(()=>{
          router.pushUrl({
            url: 'pages/Sign'
          })
        })
      })
  }
 */
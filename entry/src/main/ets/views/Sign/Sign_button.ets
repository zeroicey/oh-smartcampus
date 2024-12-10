import { HmCalendarSelectedDay } from '@ohmos/calendar'

@Component
export struct Sign_button {
  @Link buttonMovewidth: number
  @Link fireworkSize: number
  @Link signArr: Array<HmCalendarSelectedDay>
  @Link clickFlag: number

  animation_button(): void {
    animateTo({ duration: 1000, curve: Curve.Linear }, () => {
      this.buttonMovewidth = 150
    })
  }

  animation_firework(): void {
    animateTo({ duration: 200, curve: Curve.Ease }, () => {
      this.fireworkSize = 100
    })
  }

  build() {
    Row() {
      Row() {
          Row() {
            if(this.clickFlag != 1) {
              Row() {
                Image($rawfile('icon/firework.png'))
                  .width(this.fireworkSize)
                  .height(this.fireworkSize)
                  .align(Alignment.Center)
                  .margin({ left: 20 })
                // .scale({ x: 4, y: 4 })//缩放属性
                // .rotate({ angle: 45 }) //旋转
              }
              .backgroundColor('#37e2cc')
              .width(this.buttonMovewidth)
              .borderRadius(50)
              .height(60)
              .borderWidth(5)
              .borderColor('#37e2cc')
            } else {
              Text(' 长按打卡 ')
                .fontColor(Color.White)
                .fontSize(35)
                .height('100%')
                .fontWeight(FontWeight.Bold)
                .backgroundColor(Color.Transparent)
            }
          }
          .height(60)
          .backgroundColor(Color.Transparent)
          .borderWidth(5)
          .borderColor('#37e2cc')
          .width(160)
          .borderRadius(50)
          .gesture(
            LongPressGesture({ repeat: true }).onAction((event: GestureEvent) => {
              if (event.repeat) {
                this.clickFlag=2
                this.animation_button()
              }
            })
              .onActionEnd(() => {
                this.animation_firework()
                this.signArr.push({ date: new Date().toLocaleDateString() })
                Sleep(600).then(()=>{
                  this.clickFlag=3
                })
              })
          )
        }

    }
    .height('10%')
  }
}
const Sleep = (ms: number)=> {
  return new Promise<void>(resolve=>setTimeout(resolve, ms))
}
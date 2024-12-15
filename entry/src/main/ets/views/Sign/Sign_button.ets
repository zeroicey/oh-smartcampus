import { HmCalendarSelectedDay } from '@ohmos/calendar'
import axios,{ AxiosResponse } from '@ohos/axios'
import { BusinessError } from '@kit.BasicServicesKit'

@Component
export struct Sign_button {
  @Link buttonMovewidth: number
  @Link fireworkSize: number
  @Link signArr: Array<HmCalendarSelectedDay>
  @Link clickFlag: number
  @State reqFlag:boolean = false
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

                  this.httpSign_axios()//进行签到操作

                })
              })
          )
        }

    }
    .height('10%')
  }
  httpSign_axios(){
    axios({
      method: 'GET',
      url: 'http://127.0.0.1:8081/taskList/press',
    })
      .then((response: AxiosResponse)=>{
      this.clickFlag = response.data
        this.clickFlag=3
    })
    .catch((error:BusinessError)=>{
      this.clickFlag=4
      console.log(error.message)
    })
  } //上传打卡数据
}
const Sleep = (ms: number)=> {
  return new Promise<void>(resolve=>setTimeout(resolve, ms))
}
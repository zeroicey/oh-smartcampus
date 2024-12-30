import { HmCalendarSelectedDay } from '@ohmos/calendar'
import axios,{ AxiosResponse } from '@ohos/axios'
import { BusinessError } from '@kit.BasicServicesKit'
import { promptAction } from '@kit.ArkUI'

@Component
export struct Sign_button {
  @State buttonMovewidth: number = 0
  @State fireworkSize: number = 0
  @Link signArr: Array<HmCalendarSelectedDay>
  @Link clickFlag: number//3跳弹窗，4失败
  @Prop uid: string = ''
  @Prop token: string = ''
  @State reqFlag:boolean = false
  @State signedDays:number = 1

  animation_button(): void {
    animateTo({ duration: 1000, curve: Curve.FastOutLinearIn }, () => {
      this.buttonMovewidth = 150
    })
  }

  animation_firework(): void {
    animateTo({ duration: 200, curve: Curve.Ease }, () => {
      this.fireworkSize = 100
    })
  }

  aboutToAppear(): void {
    //this.httpGotSignDays_axios()
    //this.httpSign_axios(this.uid,this.token)//打卡动作
  }

  build() {
    Row() {
      Row() {
          Row() {
            if(this.clickFlag != 1&&this.clickFlag != 4) {
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
            } else if(this.clickFlag == 1 || this.clickFlag == 4 ){
              Text(' 长按打卡  ')
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
          .gesture(LongPressGesture().onAction(() => {
                this.clickFlag=2
                this.animation_button()
                promptAction.showToast({ message: "正在上传打卡信息" ,duration: 2000 })
            }).onActionEnd(() => {
                this.animation_firework()
                Sleep(600).then(()=>{
                  this.httpSign_axios(this.uid,this.token)//进行签到操作
                })
            }))
        }
    }
    .height('10%')
  }

  httpSign_axios(uid:string,token:string){//打卡
    axios({
      method: 'GET',
      url: 'https://1fd33097.r5.cpolar.cn'+'/taskList/press',
      headers:{
        'uid':uid,
        'Authorization': 'Bearer '+token,
      }
    }).then((res:AxiosResponse<boolean>)=>{
      this.signArr.push({ date: new Date().toLocaleDateString() })
      console.log('GOT_success:'+res)
      this.clickFlag=3//3跳弹窗
    }).catch((error:BusinessError)=>{
      this.fireworkSize = 0
      this.buttonMovewidth = 0
      this.clickFlag=4//4失败
      console.log('GOT_ERR:'+error.message)
    })
  }
}

const Sleep = (ms: number)=> {
  return new Promise<void>(resolve=>setTimeout(resolve, ms))
}
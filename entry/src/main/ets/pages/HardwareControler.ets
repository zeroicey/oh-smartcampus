import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
export struct HardwareControler{
  private swiperController: SwiperController = new SwiperController()
  @State IconArrOpen:Resource[] = [$rawfile('icon/Light_c.png'),$rawfile('icon/Door_c.png'),$rawfile('icon/Temperature_c.png'),$rawfile('icon/Screen_c.png')]
  @State IconArrClose:Resource[] = [$rawfile('icon/Light_o.png'),$rawfile('icon/Door_o.png'),$rawfile('icon/Temperature_o.png'),$rawfile('icon/Screen_o.png')]
  @State AniIconLtoD:Resource[] = [$rawfile('icon/ani1.png'),$rawfile('icon/ani2.png'),$rawfile('icon/ani3.png')]
  @State HardwareArr:string[] = ['灯','门','空调','屏幕']
  @State places:string[] = ['1楼','2楼','3楼','4楼','5楼','6楼','7楼','8楼','9楼']
  @State onClickFlag:number = 0
  @State aniHeight:number = 110
  @State marginNum:number = 0
  @State openOrNotArr:boolean[] = [false,false,false,false]
  @Builder
  head(){
    Row(){
      Image($rawfile('icon/back_L.png'))
        .width(23)
        //.margin({ right: 20 })
        .onClick(() => {
          router.back()
        })
      Text('智能控制')
        .fontSize(24)
        .fontColor('#985e1f')
        .fontWeight(700)
        .fontSize(28)
        .margin({ left: 60, right: 60})
      Image($rawfile('icon/Setting_L.png'))
        .width(30)
        .onClick(()=>{
          this.onClickFlag = 1
        })
    }
    .padding({ left: 20, right: 20, top: 40 ,bottom:20})
  }
  @Builder
  control_button(num:number) {
    Column() {
      Column() {
        Image(this.openOrNotArr[num] ? this.IconArrClose[num] : this.IconArrOpen[num])
          .height(100)
          .width(100)
      }
      .height(200)
      .width(200)
      .borderRadius(100)
      .backgroundColor('#fff0cc')
      .padding({
        top: 50,
        bottom: 50,
        left: 50,
        right: 50
      })
      .onClick(() => {
        this.openOrNotArr[num] = !this.openOrNotArr[num]
        if(this.openOrNotArr[num]){
          promptAction.showToast({message:'已打开 '+this.HardwareArr[num]})
        } else {
          promptAction.showToast({message:'已关闭 '+this.HardwareArr[num]})
        }

        console.log('   GOT_EM: _____/  '+num.toString() + '   GOT_BOOLEAN:  _______/  '+ this.openOrNotArr[num])
        console.log(this.openOrNotArr.toString())
        //点击事件//请求运行硬件驱动
      })

      Blank().height(30)
      Text(this.HardwareArr[num])
        .fontSize(20)
        .fontColor('#985e1f')
        .fontWeight(700)
        .fontSize(28)
        .textAlign(TextAlign.Center)
      Blank().height(30)
    }
    .width('100%')
  }
  @Builder
  skipArea(){
    Row() {
      Column(){
        Column(){
          Image($rawfile('icon/GoLeft_L.png'))
            .height(30)
            //.padding({ left: 10, right: 10, top: 10, bottom: 10})
            .margin({ left: 20, right: 10, top: 10, bottom: 10})
        }
        .height(50)
        .width('20%')
        .backgroundColor('#fee170')
        .borderRadius({ topRight: 25, bottomRight: 25})
        .onClick(()=>{
          this.swiperController.showPrevious()
        })
        Column()
          .height(200)
          .width('20%')
      }

      Column() {
        Column(){
          Stack() {
            if (this.onClickFlag == 0) { //debug
              Column() {
                ForEach(this.AniIconLtoD, (item: Resource, index) => {
                  Image(item)
                    .width(60)
                    .padding({ left: 10, right: 10 })
                    .margin({ left: 10, right: 10 })
                })
              }
              .margin({bottom: 50})
            }
            Image($rawfile('icon/ButtonUp_L.png'))
              .width(60)
              .height(60)
              .backgroundColor('#fffcf3')
              .borderRadius(50)
              .margin({ left: 20, right: 20, top: this.aniHeight, bottom: 20 })
              .onClick(() => {
                this.aniBottonUp()
              })
          }
        }
        .width('40%')
        .height('75%')
        .borderRadius(50)
        .backgroundColor('#fff0cc')//
      }
      .width('60%')
      .height(250)
      Column() {
        Column(){
          Image($rawfile('icon/GoRight_L.png'))
            .height(30)
              //.padding({ left: 10, right: 10, top: 10, bottom: 10})
            .margin({ left: 10, right: 20, top: 10, bottom: 10})
            .onClick(()=>{
              this.swiperController.showNext()
            })
        }
        .height(50)
        .width('20%')
        .backgroundColor('#fee170')
        .borderRadius({ topLeft: 25, bottomLeft: 25})
        Column()
          .height(200)
          .width('20%')
      }
    }
  }
  @Builder
  dealBox(){
    Column({space:20}) {
      Slider({ min: 0, max: 100 })
        .width('80%')
        .onChange(value => {

        })
      Slider({ min: 0, max: 100 })
        .width('80%')
        .onChange(value => {

        })

      Column() {
        Grid() {
          ForEach(this.places, (item: string, index: number) => {
            GridItem() {
              Button(item)
                .type(ButtonType.Normal)
                .fontColor('#985e1f')
                .backgroundColor('#fff0cc')
                .borderRadius(10)
                .height(30)
                .width(80)
            }
          })
        }
        .rowsTemplate('1fr 1fr 1fr')
        .columnsTemplate('4fr 4fr 4fr')
      }
      .width('80%')
      .height('40%')

      Text('﹀')
        .textAlign(TextAlign.Center)
        .width('100%')
        .fontSize(80)
        .onClick(()=>{
          //this.aniBox()
          this.onClickFlag = 0
          this.aniHeight = 110

        })
    }
    .width('100%')
    .height(350)
    .backgroundColor('#fee170')
    .borderRadius(50)
    .margin({ top: this.marginNum })
  }

  aboutToAppear(): void {

  }
  aniBottonUp() {
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      if (this.onClickFlag == 0) {
        this.aniHeight = 20
        this.onClickFlag = 1
      } else if (this.onClickFlag == 1){
        this.aniHeight = 110
        this.onClickFlag = 0
      }
    })
  }
  aniBox() {
   animateTo({ duration: 500, curve: Curve.Smooth }, () => {
     this.marginNum = 400
   })
  }

  build(){
    Stack(){
      Column() {
        this.head()
        Blank().height(50)
        Swiper(this.swiperController) {
          ForEach(this.openOrNotArr, (item: Resource, index) => {
            this.control_button(index)
          })
        }
        .indicator(false)
        .loop(false)
        .prevMargin(70,true) // 漏出前一项的部分
        .nextMargin(70,true)// 漏出后一项的部分
        Blank().height(50)
        this.skipArea()
        // if (this.onClickFlag == 0){
        //   this.skipArea()
        // } else if (this.onClickFlag == 1) {
        //   this.dealBox()
        // }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fffcf3')
      if (this.onClickFlag == 1) {
        Column(){
          Column()
            .backgroundColor(Color.White)
            .height('55%')
            .width('100%')
            .opacity(0.7)
            .onClick(()=>{
              this.onClickFlag = 0
              this.aniHeight = 110
            })
          this.dealBox()
        }
          .width('100%')
          .height('100%')
      }
    }
  }
}


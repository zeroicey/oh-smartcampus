import curves from "@ohos.curves"
@CustomDialog
export struct SignDialog {
  @Link ConsecutiveCheckIn:number
  @Link signedDay:number
  @Link rewardOfToday:number
  @Link LearningPercentage:number
  @State leftoverDays:number=getDaysInCurrentMonth()-this.ConsecutiveCheckIn
  @State doScale: ScaleOptions = { x: 1, y: 1 }
  controller:CustomDialogController
  startAnimation() {
    animateTo({
      duration: 1600,
      curve: curves.springCurve(0, 10, 80, 10),
      iterations: 1,

    }, () => {
      this.doScale = { x: 1.1, y: 1.1 };
    })
    this.doScale = { x: 1, y: 1 };
  }
  build() {
    Column({ space: 20}){
      Row({space:20}){
        Text('  '+this.ConsecutiveCheckIn.toString()+'连签  ')
          .fontColor(Color.White)
          .fontSize(25)
          .fontWeight(FontWeight.Bolder)
          .backgroundColor('#605e69')
          .height(50)
          .borderRadius(25)
        Row(){
          Text('  还有')
            .fontColor(Color.White)
            .fontSize(25)
            .fontWeight(FontWeight.Bolder)
          Text(this.leftoverDays.toString())
            .fontColor('#37e2cc')
            .fontSize(25)
            .fontWeight(FontWeight.Bolder)
          Text('天月满贯  ')
            .fontColor(Color.White)
            .fontSize(25)
            .fontWeight(FontWeight.Bolder)
            .borderRadius(15)
        }
        .backgroundColor('#605e69')
        .height(60)
        .borderRadius(25)
      }
      .height('20%')
      Column(){
        Column({space:20}) {
          Blank().height(0)
          Row({space:20}) {
            Image($rawfile('icon/face.png'))
              .height(75)
              .width(70)
              .margin({top:20})
            Text(' 签到成功！')
              .backgroundColor('#eda6a4')
              .height(50)
              .fontColor(Color.White)
              .fontSize(25)
              .fontWeight(FontWeight.Bolder)
              .textAlign(TextAlign.Center)
              .borderRadius(10)
              .margin({bottom:25})
          }

          Row() {
            Column({space:10}){
              Text(this.rewardOfToday.toString())
                .width('100%')
                .textAlign(TextAlign.Center)
                .fontColor(Color.White)
                .fontSize(25)
                .fontWeight(FontWeight.Bolder)
              Text('今日奖励')
                .width('100%')
                .textAlign(TextAlign.Center)
                .fontColor(Color.White)
                .fontSize(15)
                .fontWeight(FontWeight.Bolder)
            }
            .width('33.3%')
            Column({space:10}){
              Text(this.ConsecutiveCheckIn.toString())
                .width('100%')
                .textAlign(TextAlign.Center)
                .fontColor(Color.White)
                .fontSize(25)
                .fontWeight(FontWeight.Bolder)
              Text('连续签到')
                .width('100%')
                .textAlign(TextAlign.Center)
                .fontColor(Color.White)
                .fontSize(20)
                .fontWeight(FontWeight.Bolder)
            }
            .width('33.3%')
            Column({space:10}){
              Text(this.LearningPercentage.toString()+'%')
                .width('100%')
                .textAlign(TextAlign.Center)
                .fontColor(Color.White)
                .fontSize(25)
                .fontWeight(FontWeight.Bolder)
              Text('今日学习')
                .width('100%')
                .textAlign(TextAlign.Center)
                .fontColor(Color.White)
                .fontSize(15)
                .fontWeight(FontWeight.Bolder)
            }
            .width('33.3%')
          }

          Button('抖一抖')
            .backgroundColor('#61d9c9')
            .height(50)
            .fontColor(Color.White)
            .fontSize(30)
            .fontWeight(FontWeight.Bolder)
            .width('80%')
            .onClick(()=>{
              this.startAnimation()
            })
          Blank().height(30)
        }
        .width('80%')

      }
      .height('70%')
      .backgroundColor('#353242')
      .width('100%')
      .borderRadius(30)
      .scale(this.doScale)
    }
    .height('60%')
    .width('90%')
    .backgroundColor(Color.Transparent)
  }
}

function getDaysInCurrentMonth(): number {
  const now = new Date();
  const currentYear = now.getFullYear();
  const currentMonth = now.getMonth();
  const nextMonthFirstDay = new Date(currentYear, currentMonth + 1, 1);
  const thisMonthFirstDay = new Date(currentYear, currentMonth, 1);
  const differenceInMilliseconds = nextMonthFirstDay.getTime() - thisMonthFirstDay.getTime();
  const days = differenceInMilliseconds / (1000 * 60 * 60 * 24);
  return days;
}
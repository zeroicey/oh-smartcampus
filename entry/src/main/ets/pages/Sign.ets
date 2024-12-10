import { Sign_head } from '../views/Sign/Sign_head';
import { Sign_calender } from '../views/Sign/Sign_calender';
import { HmCalendarSelectedDay } from '@ohmos/calendar';
import { Sign_button } from '../views/Sign/Sign_button';
import { Sign_LearningProgress } from '../views/Sign/Sign_LearningProgress';
import { SignDialog } from '../views/Sign/SignDialog';

interface date { date:string }


@Entry
@Component
struct Sign {
  @State year: string = new Date().getFullYear().toString()
  @State month: string = new Date().getMonth().toString()
  @State DateArray: Array<date> = [ { date: '2024-12-01'} ]//get
  @State signArr: Array<HmCalendarSelectedDay> = this.DateArray
  @State today: HmCalendarSelectedDay = { date: new Date().toLocaleDateString() }
  @State clickFlag: number = 1
  @State buttonMovewidth: number = 0
  @State fireworkSize: number = 0
  @State aniNum: number = 0
  @State ConsecutiveCheckIn :number = 2//get
  @State signedDay:number = 4//get
  @State rewardOfToday:number = 6//get
  @State LearningPercentage:number = 8//get
  controller:CustomDialogController=new CustomDialogController({
    builder: SignDialog({
      ConsecutiveCheckIn:$ConsecutiveCheckIn,
      signedDay:$signedDay,
      rewardOfToday:$rewardOfToday,
      LearningPercentage:$LearningPercentage
    })
  })
  build() {
    Column() {
      Sign_head()

      Sign_calender({
        signArr: $signArr,
        today: $today,
        // month: $month,
        // year: $year
      })

      Sign_button({
        buttonMovewidth: $buttonMovewidth,
        fireworkSize: $fireworkSize,
        signArr: $signArr,
        clickFlag: $clickFlag
      })

      Sign_LearningProgress({
        aniNum: $aniNum
      })
      if(this.clickFlag==3){
        Blank().height(0).onAppear(()=>{this.controller.open()})
      }
    }
    .height('160%')
    .width('100%')
    .backgroundColor('#353242')
  }

  httpSign_axios(){
    //TODO
  }
}
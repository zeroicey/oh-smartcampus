import { roseChart } from 'ets/commons/utils/chart'
import router from '@ohos.router';
import { Sign_head } from '../views/Sign/Sign_head';
import { Sign_calender } from '../views/Sign/Sign_calender';
import { HmCalendar,HmCalendarType,HmCalendarSelectedDay} from '@ohmos/calendar'
import { Sign_button } from '../views/Sign/Sign_button';
import { Sign_LearningProgress } from '../views/Sign/Sign_LearningProgress';

@Entry
@Component
struct Sign {
  @State message: string = 'Hello World';
  @State year: string = new Date().getFullYear().toString()
  @State month: string = new Date().getMonth().toString()
  @State signArr: Array<HmCalendarSelectedDay> = [
      { date: '2024-12-01' }
    ]
  @State today:HmCalendarSelectedDay = { date: new Date().toLocaleDateString() }
  @State clickFlag:number=1
  @State buttonMovewidth:number=0
  @State fireworkSize:number=0
  @State aniNum:number=0




  build() {
   Column(){
     Sign_head()

     Sign_calender({
       signArr: $signArr,
       today: $today,
       month: $month,
       year: $year
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

   }
   .height('160%')
   .width('100%')
   .backgroundColor('#353242')
  }
}
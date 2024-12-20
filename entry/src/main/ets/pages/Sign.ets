import { promptAction } from '@kit.ArkUI';
import { HmCalendarSelectedDay } from '@ohmos/calendar';
import { CustomNavBar } from '../commons/components';
import axios ,{ AxiosResponse }from '@ohos/axios';
import { SignData } from '../models/tempModel/Interface/SignData';
import { SignDialog,Sign_LearningProgress,Sign_calender,Sign_button } from '../views/Sign/index';
interface date { date:string }

@Entry
@Component
struct Sign {
  // @State year: string = new Date().getFullYear().toString()
  // @State month: string = new Date().getMonth().toString()
  @State DateArray: Array<date> = []//get from server
  @State signArr: Array<HmCalendarSelectedDay> = this.DateArray
  @State today: HmCalendarSelectedDay = { date: new Date().toLocaleDateString() }
  @State clickFlag: number = 1
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

      CustomNavBar({
        title: '打卡',
        showRightIcon: false,
      }).margin({bottom:20})

      Sign_calender({
        signArr: $signArr,
        today: $today,
      })

      Sign_button({
        signArr: $signArr,
        clickFlag: $clickFlag
        //TODO 打卡记录统计数据
      })

      Sign_LearningProgress({
        aniNum: $aniNum
        //TODO 学习数据统计图表数据
      })

      if(this.clickFlag==3){
        Blank().height(0).onAppear(()=>{
          this.controller.open()
        })
      } else if(this.clickFlag==4){
        Blank().height(0).onAppear(()=>{
          promptAction.showToast({ message: "网络错误，打卡失败" ,duration: 2000 })
        })
      }

    }
    .height('160%')
    .width('100%')
    .backgroundColor('#353242')
  }
  httpSignData_axios(){
    axios({
      method: 'GET',
      url: 'http://127.0.0.1:8081/taskList/day',
      headers:{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ', //token
        'uid': '1000001'
      }
    })
      .then((response: AxiosResponse<SignData>)=>{
        this.signedDay = response.data.data
    })
  }
}
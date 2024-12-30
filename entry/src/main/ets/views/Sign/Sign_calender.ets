import { HmCalendar,HmCalendarType,HmCalendarSelectedDay} from '@ohmos/calendar'
import axios, { AxiosResponse } from '@ohos/axios'
import { BusinessError } from '@kit.BasicServicesKit'

@Component
export struct Sign_calender{
  @Link signArr: Array<HmCalendarSelectedDay>
  @Link today:HmCalendarSelectedDay

  aboutToAppear(): void {
    this.httpGotSignMonthHistory_axios()
  }

  build() {
    Scroll(){
      Column(){
        Blank().height(20)
        HmCalendar({
          type: HmCalendarType.MONTH,
          selectedDays: this.signArr,
          showToolBar: true,
          color:'#ff9996',
          rowsAuto: true,
          weeks: ['Su','Mo','Tu','We','Th','Fr','Sa']
        })
          .padding(15.5)
      }
    }
    .scrollBar(BarState.Off)
    .backgroundColor('#b7b2ff')
    .borderRadius(25)
    .width('85%')
    .height('25%')
  }
  httpGotSignMonthHistory_axios(){
    axios({
      method: 'GET',
      url: ''+'/dayLog/find',//get
      headers:{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ',//token
      }
    }).then((response: AxiosResponse<Array<HmCalendarSelectedDay>>)=>{
        this.signArr = response.data
    }).catch((error:BusinessError)=>{
        console.log(error.message)
    })
  }
}
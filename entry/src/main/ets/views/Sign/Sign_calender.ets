import { HmCalendar,HmCalendarType,HmCalendarSelectedDay} from '@ohmos/calendar'


@Component
export struct Sign_calender{
  @Link signArr: Array<HmCalendarSelectedDay>
  @Link today:HmCalendarSelectedDay
  @Link month:string
  @Link year:string
  build() {
    Scroll(){
      Column(){
        Blank().height(20)
        Text('  '+this.month+' '+this.year)
          .fontColor(Color.White)
          .fontSize(35)
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bolder)
        HmCalendar({
          type: HmCalendarType.MONTH,
          selectedDays: this.signArr,
          showToolBar: false,
        })
          .padding(15.5)
      }
    }
    .backgroundColor('#b7b2ff')
    .borderRadius(25)
    .width('85%')
    .height('25%')
  }
}
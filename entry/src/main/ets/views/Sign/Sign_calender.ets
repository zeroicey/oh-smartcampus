import { HmCalendar,HmCalendarType,HmCalendarSelectedDay} from '@ohmos/calendar'

@Component
export struct Sign_calender{
  @Link signArr: Array<HmCalendarSelectedDay>
  @Link today:HmCalendarSelectedDay
  // @Link month:string
  // @Link year:string
  build() {
    Scroll(){
      Column(){
        Blank().height(20)
        // Text('  '+this.month+'. '+this.year)
        //   .fontColor(Color.White)
        //   .fontSize(35)
        //   .width('100%')
        //   .textAlign(TextAlign.Start)
        //   .fontWeight(FontWeight.Bolder)
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
}

import router from '@ohos.router';
import { roseChart ,ValueObjects_rose} from '../../commons/components';
import { BarChart ,valueObjects_bar} from '../../commons/components/BarChart';



@Component
export struct Sign_LearningProgress{
  @Link aniNum:number

  //mock
  @State BarArr:Array<valueObjects_bar> = [
    { type: 'oxygen',time:'2024-12-01', value: 46 },
    { type: 'silicon',time:'2024-12-02', value: 27 },
    { type: 'aluminum',time:'2024-12-03', value: 8 },
    { type: 'iron',time:'2024-12-04', value: 5 },
    { type: 'calcium',time:'2024-12-05', value: 3 },
  ]
  @State RoseArr:Array<ValueObjects_rose> = [
    { type: 'oxygen', value: '46' },
    { type: 'silicon', value: '27' },
    { type: 'aluminum', value: '8' },
    { type: 'iron', value: '5' },
    { type: 'calcium', value: '3' },
  ]

  animation_chart(): void {
    animateTo({ duration: 300, curve: Curve.Linear}, () => {
      if(this.aniNum==0)
        this.aniNum = -500
      else
        this.aniNum = 0
    })
  }

  build() {
    Column(){
      Blank().height(20)
      Text('学习进度')
        .fontWeight(FontWeight.Bolder)
        .fontSize(35)
      Scroll() {
        Column({space:20}) {
          roseChart({
            dataValue: this.RoseArr,
            legendPosition: 'bottom'
          })

          BarChart({
            dataValue: this.BarArr
          })

          Text('aaaaaaaaaaaaaaaaaaaaa\n' +
               'bbbbbbbbbbbbbbbbbbbbb\n' +
               'ccccccccccccccccccccc')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
      }
      .height(600)

    }
    .margin({top:this.aniNum})
    .height('100%')
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(30)
    .onClick(()=>{
      if(this.aniNum==-500){
        this.animation_chart()
        this.aniNum=0
      } else {
        this.animation_chart()
        this.aniNum=-500
      }
    })
  }
}
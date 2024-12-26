
import router from '@ohos.router';
import axios from '@ohos/axios';
import { roseChart ,ValueObjects_rose} from '../../commons/components';
import { BarChart ,valueObjects_bar} from '../../commons/components/BarChart';
import { BusinessError } from '@kit.BasicServicesKit';


@Component
export struct Sign_LearningProgress{
  @Link aniNum:number

  //mock
  @State BarArr:Array<valueObjects_bar> = [
    { type: '学习',time:'2024-12-03', value: 46 },
    { type: '浏览',time:'2024-12-03', value: 57 },
    { type: '其他',time:'2024-12-03', value: 20 },
  ]
  @State RoseArr:Array<ValueObjects_rose> = [
    { type: '学习', value: '46' },
    { type: '浏览', value: '57' },
    { type: '其他', value: '20' },
  ]

  animation_chart(): void {
    animateTo({ duration: 300, curve: Curve.Linear}, () => {
      if(this.aniNum==0)
        this.aniNum = -500
      else
        this.aniNum = 0
    })
  }

  aboutToAppear(): void {
    this.httpChartDataLearingProcess_axios()//获取图标数据
    this.httpGetSyudyDays_axios()//获取学打卡天数
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

          // Text('aaaaaaaaaaaaaaaaaaaaa\n' + 'bbbbbbbbbbbbbbbbbbbbb\n' + 'ccccccccccccccccccccc')
          //   .fontSize(20)
          //   .fontWeight(FontWeight.Bold)
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
  httpChartDataLearingProcess_axios(){
    axios({
      method: 'GET',
      url: '',//get
    }).then(()=>{
      //TODO
    }).catch((error:BusinessError)=>{
      console.log(error.message)
    })
  }

  httpGetSyudyDays_axios(){
    axios({
      method: 'GET',
      url: '',//get
    }).then(()=>{
      //TODO
    }).catch((error:BusinessError)=>{
      console.log(error.message)
    })
  }
}
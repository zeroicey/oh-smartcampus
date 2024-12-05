
import router from '@ohos.router';
import { roseChart } from '../../commons/components';

@Component
export struct Sign_LearningProgress{
  @Link aniNum:number

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
      Row(){
        roseChart({
          dataValue: [
            { type: '学习', value: '23' },
            { type: '休息', value: '50' },
            { type: '运动', value: '27' },
          ],
          legendPosition: 'bottom'
        })
      }
      .height(400)
      Text('aaaaaaaaaaaaaaaaaaaaaaaaaa\nbbbbbbbbbbbbbbbbbbbbbb\ncccccccccccccccc')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
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
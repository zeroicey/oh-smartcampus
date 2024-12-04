import router from '@ohos.router';

@Component
export struct AINote_head {
  build() {
    Column(){
      Blank().height(50)
      Row({space: 20}){
        Blank().width(10)
        Image($rawfile('icon/backIcon.png'))
          .width(30)
          .height(40)
          .onClick(()=>{
            router.back()
          })
        Text('AI笔记')
          .fontColor(Color.White)
          .fontSize(25)
          .fontWeight(FontWeight.Bolder)
        Blank().width(30)
      }
      .width('100%')

      Blank().height(30)
      // Divider()
      //   .width('100%')
      //   .color('#ff9996')
      //   .strokeWidth(0.8)
    }
    .height('15%')
  }
}
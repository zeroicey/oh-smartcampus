
import router from '@ohos.router';
@Component
export struct EditNote_dealButton{
  @Link onClickFlag:number
  @Link buttonWidth1:string
  @Link buttonWidth2:string

  animation_button(): void {
    if(this.onClickFlag==1){
      animateTo({ duration: 500, curve: Curve.Smooth }, () => {
        this.buttonWidth1='50%'
        this.buttonWidth2='20%'
      })
    } else if(this.onClickFlag==2) {
      animateTo({ duration: 500, curve: Curve.Smooth }, () => {
        this.buttonWidth1='20%'
        this.buttonWidth2='50%'
      })
    } else if(this.onClickFlag==3){
      animateTo({ duration: 500, curve: Curve.Smooth }, () => {
        this.buttonWidth1='30%'
        this.buttonWidth2='30%'
      })
    }
  }

  build() {
    Stack(){
      Row({space:50}){}
      .width('100%')
      .height('100%')
      Row({space:50}){
        Button('保存')
          .width(this.buttonWidth1)
          .fontColor(Color.White)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#ff9996')
          .onClick(()=>{
            this.onClickFlag=1
            this.animation_button()
            if(this.onClickFlag==1){
              router.pushUrl({
                url: 'pages/AI_chatPage',
                params: {
                  //TODO
                  //topic: this.TargetAI_topic//待修改
                }
              })
            }
          })

        Button('发布')
          .width(this.buttonWidth2)
          .fontColor(Color.White)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#ff9996')
          .onClick(()=>{
            this.onClickFlag=2
            this.animation_button()
            if(this.onClickFlag==2){
              router.pushUrl({
                url: 'pages/AI_chatPage',
                params: {
                  //TODO
                  //topic: this.TargetAI_topic//待修改
                }
              })
            }
          })
      }
    }
    .height('10%')
    .backgroundColor('#3b3b3b')
    .borderRadius(30)
    .width('100%')
  }
}
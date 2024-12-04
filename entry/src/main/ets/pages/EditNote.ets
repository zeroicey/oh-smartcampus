import router from '@ohos.router';
import { EditNote_dealButton } from '../views/EditNote/EditNote_dealButton';
import { EditNote_edit } from '../views/EditNote/EditNote_edit';
import { EditNote_head } from '../views/EditNote/EditNote_head';
import { EditNote_imgArr } from '../views/EditNote/EditNote_imgArr';

@Entry
@Component
export struct EditNote {
  @State ImageList: Array<string> = []
  @State AIPictureUrl:string=''
  @State UserName:string='MR.ASS'
  @State Topic: string = ''
  @State Text: string = ''
  @State TargetAI_topic: string = 'TOPIC'
  @State DATE:string = new Date().toLocaleDateString()
  @State buttonWidth1:string='30%'
  @State buttonWidth2:string='30%'
  @State onClickFlag:number=1

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
    Column(){
      EditNote_head()
      //.backgroundColor(Color.Pink)

      Scroll(){
        Column() {
          EditNote_imgArr({
            ImageList:$ImageList,
            AIPictureUrl:$AIPictureUrl
          })
          //.backgroundColor(Color.Pink)
          EditNote_edit({
            Text:$Text,
            Topic:$Topic,
            DATE:$DATE,
            UserName:$UserName,
            TargetAI_topic:$TargetAI_topic
          })

          Blank().height('51%')
          Text('<  END')
            .width('100%')
            .fontColor(Color.White)
            .textAlign(TextAlign.End)
        }
        .width('85%')
        .height('auto')
        .onClick(()=>{
          this.onClickFlag=3
          this.animation_button()
        })
        //.backgroundColor(Color.Pink)
      }
      .height('75%')
      .width('100%')
      //.backgroundColor(Color.Gray)

      EditNote_dealButton({
        buttonWidth1:$buttonWidth1,
        buttonWidth2:$buttonWidth2,
        onClickFlag:$onClickFlag,

      })


    }
    .backgroundColor('#353242')
  }
}
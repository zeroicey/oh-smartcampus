
import router from '@ohos.router';
import { SendNoteData } from '../../models/tempModel/Interface/SendNote';
import { text } from '@kit.ArkGraphics2D';
import axios, { AxiosResponse } from '@ohos/axios';
import { TopicAI } from '../../models/tempModel/DataModel/TopicAI';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct EditNote_edit{
  @Link EditData:SendNoteData
  // @Link Topic: string
  // @Link Text: string
  // @Link TargetAI_topic: string
   @Link DATE:string
   @Link UserName:string
  //@Link AIPictureUrl:string
  build() {
    Column() {
      Divider()
        .width('90%')
        .borderColor(Color.White)
        .borderWidth(0.3)
        .opacity(0.5)

      TextInput({ placeholder: '输入你的标题>', text: this.EditData.title })//topic
        .width('100%')
        .height('auto')
        .fontSize(25)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
        .backgroundColor(Color.Transparent)
        .placeholderColor(Color.White)
        .onChange((text: string) => {
          this.EditData.title = text
        })

      TextArea({ placeholder: '输入你的文本笔记>', text: this.EditData.word })//text
        .width('100%')
        .height('auto')
        .fontSize(25)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
        .backgroundColor(Color.Transparent)
        .placeholderColor(Color.White)
        .onChange((text: string) => {
          this.EditData.word = text
        })
      Row() {
        Image($rawfile('icon/JumpToAI.png'))
          .height(30)
          .width(30)

        Text('点击跳转话题' + this.EditData.topicId)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#98f4e9')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/AIChatPage',
              params: {
                //
              }
            })
          })
      }
      .width('100%')


      Text(this.DATE)//date
        .fontColor(Color.White)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.End)

      Text(this.UserName)//name
        .fontColor(Color.White)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.End)
    }
  }

  httpGettopicAiDetil_axios(id:string){
    axios({
      method: 'GET',
      url: "https://1fd33097.r5.cpolar.cn"+"/topic/findById/{id}",
      headers: {
        'Content-Type': 'application/json',
      }
    }).then((response:AxiosResponse<TopicAI>)=>{

    }).catch((error: BusinessError)=>{
      console.log('GOT_'+error.name+' : '+error.message)
    })
  }
}
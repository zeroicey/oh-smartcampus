
import router from '@ohos.router';
import axios from '@ohos/axios';
import { keepNoteData } from '../../models/tempModel/Interface/KeepNote';
import { BusinessError } from '@kit.BasicServicesKit';
import { SendNoteData } from '../../models/tempModel/Interface/SendNote';
import { promptAction } from '@kit.ArkUI';

@Component
export struct EditNote_dealButton{
  @Link onClickFlag:number
  @Link buttonWidth1:string
  @Link buttonWidth2:string
  @Link topicId:string
  @Link circleId:string
  @Link uid:string
  @Link pictures:Array<string>
  @Link title:string
  @Link word:string
  @Link token:string
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
              httpKeepNote_axios(this.pictures,this.title,this.word,this.uid,this.topicId,this.circleId,this.token)
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
              httpPublishNote_axios(this.pictures,this.title,this.word,this.uid,this.topicId,this.circleId,this.token)
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

function httpKeepNote_axios(imgArr:string[],title:string,word:string,uid:string,topicId:string,circleId:string,token:string){
  axios({
    method: 'POST',
    url: "http://127.0.0.1:8081/topic"+"/note/save_note",
    data: {
      context:{
        pictures:imgArr,
        title:title,
        word:word
      },
      uid:uid,
      topicId:topicId,
      createTime:{
        $date:new Date().toLocaleDateString()
      },
      updateTime:{
        $date:new Date().toLocaleDateString()
      },
      type:"1",
      _class:"Oracle.entity.Mongo.CircleContext",
      circleId:circleId,
    } as keepNoteData,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer '+token
    }
  }).then(()=>{
    promptAction.showToast({message: '保存成功', duration: 2000})
  }).catch((error: BusinessError)=>{
    promptAction.showToast({message: '保存失败，请检查网络', duration: 1000})
    console.log(error.name+' : '+error.message)
  })
}

function httpPublishNote_axios(imgArr:string[],title:string,word:string,uid:string,topicId:string,circleId:string,token:string){
  axios({
    method: 'POST',
    url: "http://127.0.0.1:8081/topic"+"/note/sendNote",
    data: {
      topicId:topicId,
      circleId:circleId,
      uid:uid,
      pictures:imgArr,
      title:title,
      word:word,
      createTime:new Date().toLocaleDateString()
    } as SendNoteData,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer '+token
    }
  }).then(()=>{
    promptAction.showToast({message: '发布成功', duration: 2000})
  }).catch((error: BusinessError)=>{
    promptAction.showToast({message: '发布失败，请检查网络', duration: 1000})
    console.log(error.name+' : '+error.message)
  })
}


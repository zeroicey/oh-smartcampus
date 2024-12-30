
import axios from '@ohos/axios';
import { CirclePost } from '../../models/tempModel/Interface/KeepNote';
import { BusinessError } from '@kit.BasicServicesKit';
import { SendNoteData } from '../../models/tempModel/Interface/SendNote';
import { promptAction } from '@kit.ArkUI';

@Component
export struct EditNote_dealButton{
  @Link EditData:SendNoteData
  @Link onClickFlag:number
  @Link buttonWidth1:string
  @Link buttonWidth2:string
  @Link token:string
  @Prop uid:string = ''
  animation_button(): void {
    if(this.onClickFlag==1){//left bigger
      animateTo({ duration: 500, curve: Curve.Smooth }, () => {
        this.buttonWidth1='50%'
        this.buttonWidth2='20%'
      })
    } else if(this.onClickFlag==2) {//right bigger
      animateTo({ duration: 500, curve: Curve.Smooth }, () => {
        this.buttonWidth1='20%'
        this.buttonWidth2='50%'
      })
    } else if(this.onClickFlag==3){//reset
      animateTo({ duration: 500, curve: Curve.Smooth }, () => {
        this.buttonWidth1='30%'
        this.buttonWidth2='30%'
      })
    }
  }

  build(){
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
          .onClick(() => {
            if (this.onClickFlag!=1) {
              this.onClickFlag = 1
              this.animation_button()
            } else if(this.onClickFlag == 1){
              httpKeepNote_axios(this.EditData.pictures,this.EditData.title,this.EditData.word,this.EditData.uid,this.EditData.topicId,this.EditData.circleId,this.token)
            }
          })

        Button('发布')
          .width(this.buttonWidth2)
          .fontColor(Color.White)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#ff9996')
          .onClick(() => {
            if(this.onClickFlag!=2){
                this.onClickFlag = 2
                this.animation_button()
              } else if(this.onClickFlag == 2){
              httpPublishNote_axios(this.EditData,this.token,this.uid)
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
    url: "https://1fd33097.r5.cpolar.cn"+"/note/save_note",
    data: {
      circle_id: circleId,
      id: getNoteId(),
      pictures: imgArr,
      title: title,
      word: word,
      uid: uid,
      topicId: topicId,
      createTime: getCurrentTime(),
      updateTime: ''
     } as CirclePost,
    headers: {
      'uid': uid,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer '+token
    }
  }).then(()=>{
    promptAction.showToast({message: '保存成功', duration: 2000})
    console.log('GOT_保存成功:'+topicId+"---"+uid+'======'+circleId)
  }).catch((error: BusinessError)=>{
    promptAction.showToast({message: '保存失败，请检查网络', duration: 1000})
    console.log(error.name+' : '+error.message)
  })
}

function httpPublishNote_axios(EditData:SendNoteData,token:string,uid:string){
  axios({
    method: 'POST',
    url: "https://1fd33097.r5.cpolar.cn"+"/note/sendNote",
    data: EditData,
    headers: {
      'uid': uid,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer '+token
    }
  }).then(()=> {
    console.log('GOT_发布成功:'+JSON.stringify(EditData))
    promptAction.showToast({message: '发布成功', duration: 2000})
  }).catch((error: BusinessError)=>{
    promptAction.showToast({message: '发布失败，请检查网络', duration: 1000})
    console.log(error.name+' : '+error.message)
  })
}

function getNoteId():string {
  const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  for (let i = 0; i < 6; i++) {
    result += charset.charAt(Math.floor(Math.random() * charset.length));
  }
  return Date.now().toString()+result;
}

function getCurrentTime(): string {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  const hour = String(now.getHours()).padStart(2, '0');
  const minute = String(now.getMinutes()).padStart(2, '0');
  const second = String(now.getSeconds()).padStart(2, '0');

  return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
}

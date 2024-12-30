import router from '@ohos.router';
import { CustomNavBar, HcLoadingDialog } from '../commons/components';
import { httpReq, logger, UserInfo } from '../commons/utils';
import { User } from '../models';
import { NoteEditPropmtType } from '../models/tempModel/Interface/PropmtInterfaces';
import { SendNoteData } from '../models/tempModel/Interface/SendNote';
import { EditNote_dealButton } from '../views/EditNote/EditNote_dealButton';
import { EditNote_edit } from '../views/EditNote/EditNote_edit';
import { EditNote_imgArr } from '../views/EditNote/EditNote_imgArr';


@Entry
@Component
export struct EditNote {
  @StorageProp(UserInfo)
  user: User = {} as User
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State token: string = ''
  @State getPropmt: NoteEditPropmtType = {} as NoteEditPropmtType
  @State DATE: string = new Date().toLocaleDateString() // 现在的日期
  @State AIPictureUrl: string = ''
  @State UserName: string = 'MR.ASS'
  @State TargetAI_topic: string = 'TOPIC'
  @State buttonWidth1: string = '30%'
  @State buttonWidth2: string = '30%'
  @State onClickFlag: number = 3
  @State url: string = ''
  @State updateFlag: boolean = false
  @State EditData: SendNoteData = {} as SendNoteData
  @State LocalImg: string = ''
  // 加载弹窗
  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog({ message: '更新中请稍后...' }),
    customStyle: true
  })

  sendNoteData() {
    this.EditData.topicId = '2'
    this.EditData.uid = ''
    this.EditData.title = ''
    this.EditData.word = ''
    this.EditData.circleId = '1'
    this.EditData.pictures = []
    this.EditData.createTime = new Date().toLocaleDateString()
  }

  animation_button(): void {
    if (this.onClickFlag == 1) {
      animateTo({ duration: 500, curve: Curve.Smooth }, () => {
        this.buttonWidth1 = '50%'
        this.buttonWidth2 = '20%'
      })
    } else if (this.onClickFlag == 2) {
      animateTo({ duration: 500, curve: Curve.Smooth }, () => {
        this.buttonWidth1 = '20%'
        this.buttonWidth2 = '50%'
      })
    } else if (this.onClickFlag == 3) {
      animateTo({ duration: 500, curve: Curve.Smooth }, () => {
        this.buttonWidth1 = '30%'
        this.buttonWidth2 = '30%'
      })
    }
  }



  aboutToAppear(): void {
    try {
      this.getPropmt = router.getParams() as NoteEditPropmtType
      console.log('GOT_EditNote_aboutToAppear:'+JSON.stringify(this.getPropmt))
      this.EditData.pictures.push(this.getPropmt.url)
    } catch (err) {
      console.log('ERROR_EditNote_aboutToAppear')
    }
    this.url = this.getPropmt.url
    this.token = this.user.token
    this.UserName = this.user.name
    this.EditData.uid = this.user.uid
    this.EditData.topicId = this.getPropmt.topicId.toString()
    this.EditData.circleId = '1'
  }

  build() {
    Column() {
      CustomNavBar({
        title: '编辑笔记',
        showRightIcon: false,
      })
      Scroll() {
        Column() {
          EditNote_imgArr({
            EditData: $EditData,
            url: this.url,
            LocalImg: $LocalImg
          })
          EditNote_edit({
            EditData: $EditData,
            DATE: $DATE,
            UserName: $UserName,
          })
          Blank().height('51%')
          Row() {
            Text('<  END')
              .width('100%')
              .fontColor(Color.White)
              .textAlign(TextAlign.End)
          }
        }
        .width('85%')
        .height('auto')
        .onClick(() => {
          this.onClickFlag = 3
          this.animation_button()
        })
      }
      .height('75%')
      .width('100%')

      Blank()

      EditNote_dealButton({
        EditData: $EditData,
        buttonWidth1: $buttonWidth1,
        buttonWidth2: $buttonWidth2,
        onClickFlag: $onClickFlag,
        token: $token,
        uid: this.user.uid
        //updateFlag:this.updateFlag
      })
    }
    .width('100%')
    .height('100%')
    .padding({ bottom: this.bottomHeight })
    .backgroundColor('#16151A')
  }
}
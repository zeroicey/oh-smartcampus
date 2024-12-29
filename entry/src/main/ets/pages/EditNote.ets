import router from '@ohos.router';
import { CustomNavBar, HcLoadingDialog } from '../commons/components';
import { httpReq, logger, UserInfo } from '../commons/utils';
import { User } from '../models';
import { NoteEditPropmtType } from '../models/tempModel/Interface/PropmtInterfaces';
import { SendNoteData } from '../models/tempModel/Interface/SendNote';
import { EditNote_dealButton } from '../views/EditNote/EditNote_dealButton';
import { EditNote_edit } from '../views/EditNote/EditNote_edit';
import { EditNote_imgArr } from '../views/EditNote/EditNote_imgArr';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { FormData } from '@ohos/axios';

@Entry
@Component
export struct EditNote {
  @StorageProp(UserInfo)
  user: User = {} as User
  @State token:string = ''
  @State getPropmt:NoteEditPropmtType = {} as NoteEditPropmtType
  @State DATE:string = new Date().toLocaleDateString()// 现在的日期
  @State AIPictureUrl:string = ''
  @State UserName:string = 'MR.ASS'
  @State TargetAI_topic: string = 'TOPIC'
  @State buttonWidth1:string = '30%'
  @State buttonWidth2:string = '30%'
  @State onClickFlag:number = 3
  @State url:string=''
  @State updateFlag:boolean = false
  @State EditData:SendNoteData = {} as SendNoteData
  @State LocalImg:string = ''
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
  async updateAvatar() {
    // 先创建一个图片选择器
    const PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
    // 指定文件类型是图片
    PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    // 设置最大选择图片数量
    PhotoSelectOptions.maxSelectNumber = 1
    // 创建相册选择器
    const photoPicker = new photoAccessHelper.PhotoViewPicker()
    // 选择图片并且拉起图片
    const selectResult = await photoPicker.select(PhotoSelectOptions)
    // 得到图片完整的uri路径
    const uri = selectResult.photoUris[0]
    // ------------------------------------------------
    if (uri) {
      this.dialog.open()
      // 根据相册图片生成ImageSource对象
      const file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY)
      const imageSource = image.createImageSource(file.fd)
      // 使用packing压缩图片，生成二进制图片数据
      const imagePacker = image.createImagePacker()
      const arrayBuffer = await imagePacker.packing(imageSource, {
        format: 'image/jpeg',
        quality: 70
      })
      // 存储到沙箱环境目录
      const newFilePath = getContext(this).cacheDir + '/' + Date.now() + '.jpg'
      const newFile = fileIo.openSync(newFilePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
      fileIo.writeSync(newFile.fd, arrayBuffer)
      logger.info('压缩后的图片大小', fileIo.statSync(newFile.fd).size.toString())
      fileIo.closeSync(newFile.fd)
      // 创建formData对象---用来装载图片
      const formData = new FormData()
      formData.append('file', `internal://cache/${newFile.name}`)
      // 提交头像文件
      this.LocalImg = await httpReq.request<string>({
        url: '/file/upload/image',
        method: 'post',
        data: formData,
        headers: { 'Content-Type': 'multipart/form-data' },
        context: getContext(this)
      })
      this.dialog.close()
    }
  }

  aboutToAppear(): void {
    try {
      this.getPropmt = router.getParams() as NoteEditPropmtType
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
    Column(){
      CustomNavBar({
        title: '编辑笔记',
        showRightIcon: false,
      })
      Scroll(){
        Column() {
          EditNote_imgArr({
            EditData:$EditData,
            url:this.url,
            LocalImg:this.LocalImg
          })
          EditNote_edit({
            EditData:$EditData,
            DATE:$DATE,
            UserName:$UserName,
          })
          Blank().height('51%')
          Row(){
            Button(' 删除 ')
              .backgroundColor('#d4c2ed')
              .width(80)
              .height('30')
              .fontSize(20)
              .onClick(()=>{
                //TODO  删除接口等待完善(后续开发准备)
                //delete
              })
            Text('<  END')
              .width('100%')
              .fontColor(Color.White)
              .textAlign(TextAlign.End)
          }
        }
        .width('85%')
        .height('auto')
        .onClick(()=>{
          this.onClickFlag=3
          this.animation_button()
        })
      }
      .height('75%')
      .width('100%')
      EditNote_dealButton({
        EditData:$EditData,
        buttonWidth1:$buttonWidth1,
        buttonWidth2:$buttonWidth2,
        onClickFlag:$onClickFlag,
        token:$token,
        uid:this.user.uid
        //updateFlag:this.updateFlag
      })
    }
    .backgroundColor('#353242')
  }
}
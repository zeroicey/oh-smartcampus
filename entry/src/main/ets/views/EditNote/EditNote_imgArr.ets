
import { LengthMetrics } from '@kit.ArkUI';
import { pushImagePreview } from 'ets/pages/ImgPreview'
import { SendNoteData } from '../../models/tempModel/Interface/SendNote';
import { CustomNavBar, HcLoadingDialog } from 'ets/commons/components';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { FormData } from '@ohos/axios';
import { httpReq, logger, UserInfo } from 'ets/commons/utils';
@Component
export struct EditNote_imgArr {
  //@Link imageItems:Array<string>
  @Link EditData:SendNoteData
  @Prop url:string = ''
  @Link LocalImg:string

  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog({ message: '更新中请稍后...' }),
    customStyle: true
  })
  //@Link AIPictureUrl:string
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
  build() {
    Column({space:10}) {
      Row(){
        List(){
          ForEach(this.EditData.pictures, (item:string,index:number) => {
            ListItem() {
              Image(item)
                .width(100)
                .height(100)
                .margin({ top: 10, bottom: 10, left: 10, right: 10 })
                .borderRadius(20)
                .sharedTransition(JSON.stringify(item))//
                .onClick(() => {
                  pushImagePreview({images:this.EditData.pictures,index:index})//
                })

            }
          })
          ListItem(){
            Column(){
              Image($rawfile('icon/addImg.png'))
                .width(50)
                .height(50)
                .margin({top:25})
                .onClick(()=>{
                  this.updateAvatar().then(()=>{
                    this.EditData.pictures.push(this.LocalImg)
                  })
                })

            }
            .width(100)
            .height(100)
            .backgroundColor('#c4c4c4')
            .margin({ top: 10, bottom: 10, left: 10, right: 10 })
            .borderRadius(20)
          }
        }
        .listDirection(Axis.Horizontal)
        .width('100%')
      }
    }
    .height(120)
  }
}
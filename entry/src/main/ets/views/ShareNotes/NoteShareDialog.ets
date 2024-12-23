import { UserInfo } from '../../commons/utils/Auth'
import { componentSnapshot, promptAction } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import { fileIo, fileUri } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { IPublisherData, User } from '../../models'

@Preview
@CustomDialog
export struct NoteShareDialog {
  @Prop item: IPublisherData
  @StorageProp(UserInfo) user: User = {} as User
  controller: CustomDialogController

  async saveImage() {
    // 进行截图
    const pixelMap = await componentSnapshot.get('share')
    // 图片数据 - 获取图片二进制
    const imagePacker = image.createImagePacker()
    // format为图片类型quality为压缩多少，值越大越清晰
    const arrayBuffer = await imagePacker.packing(pixelMap, { format: 'image/jpeg', quality: 98 })
    // 存储图片到应用下
    const ctx = getContext(this)
    // 生成图片路径 - 基于时间戳
    const imagePath = ctx.cacheDir + '/' + Date.now() + '.jpeg'
    // 让图片具备创建和读写的能力
    const file = fileIo.openSync(imagePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    // 写入图片数据
    fileIo.writeSync(file.fd, arrayBuffer)
    // 关闭图片
    fileIo.closeSync(file.fd)
    // 保存到相册+获取隐私权限
    // 1.获取uri
    // 2.创建相册资源请求 - 图片资产的变更请求
    // 3.添加创建请求，实现存储

    // 将生成的图片路径转化成fileuri
    const uri = fileUri.getUriFromPath(imagePath)
    const assetChangeRequest = photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(ctx, uri)
    const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(ctx)
    await phAccessHelper.applyChanges(assetChangeRequest)
    this.controller.close()
    promptAction.showToast({ message: '保存成功' })
  }

  build() {
    Stack() {
      Column() {

      }
      .width('100%')
      .height('100%')
      .blur(20)
      .onClick(() => {
        this.controller.close()
      })

      Stack({ alignContent: Alignment.BottomEnd }) {
        Column({ space: 20 }) {
          Text('知识在分享中裂变,智慧于交流里升华 ')
            .fontColor('rgb(202, 193, 255)')
          Divider()
            .strokeWidth(0.5)
            .color('rgb(202, 193, 255)')
          Text('笔记分享：' + this.item.title)
            .fontSize(12)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(600)
            .fontColor('rgb(202, 193, 255)')
            .width('100%')
            .lineHeight(24)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          QRCode(this.item.id)
            .color(Color.White)
            .width(160)
            .height(160)
            .backgroundColor('rgb(53, 50, 66)')
            .alignSelf(ItemAlign.Center)
          Text('扫码查看笔记')
            .fontSize(12)
            .fontColor('rgb(202, 193, 255)')
            .alignSelf(ItemAlign.Center)
          Image($rawfile('other/dragonLogo.png'))
            .width(40)
          Text('笔记来自：' + this.item.creatorName)
            .fontSize(12)
            .fontColor('rgb(202, 193, 255)')
        }
        .id('share')
        .padding({
          left: 20,
          top: 40,
          right: 20,
          bottom: 20
        })
        .alignItems(HorizontalAlign.Start)
        .width(300)
        // .height(500)
        .backgroundColor('rgb(53, 50, 66)')

        Row() {
          // 使用安全控件
          SaveButton({
            icon: SaveIconStyle.FULL_FILLED,
            text: SaveDescription.SAVE_IMAGE,
            buttonType: ButtonType.Normal
          })
            .fontColor($r('app.color.white'))
            .fontSize(14)
            .padding(12)
            .backgroundColor('rgb(202, 193, 255)')
            .onClick((event, result: SaveButtonOnClickResult) => {
              if (result == SaveButtonOnClickResult.SUCCESS) {
                this.saveImage()
              }
            })
        }
        .borderRadius({ topLeft: 20 })
        .clip(true)
      }
      .borderRadius(30)
      .clip(true)
    }
  }
}
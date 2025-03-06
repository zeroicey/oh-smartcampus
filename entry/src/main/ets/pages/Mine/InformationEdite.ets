import { CustomNavBar, HcLoadingDialog, InputComponent } from '../../commons/components'
import { auth, httpReq, logger, UserInfo } from '../../commons/utils'
import { ITextType, User } from '../../models'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { FormData } from '@ohos/axios'
import { promptAction, router } from '@kit.ArkUI'
import { UICalendarPicker } from '@hw-agconnect/ui-calendar-picker'
import { ChangeEmailDialog } from '../../views/InformationEdite/ChangeEmailDialog'
import { image } from '@kit.ImageKit'
import { MoreDialog } from '../../views/InformationEdite/MoreDialog'

interface IUpdateInfoParams {
  name?: string
  birthday?: string
  sex?: number
  introduction?: string
}

@Entry
@Component
export struct InformationEdite {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp(UserInfo)
  user: User = {} as User
  @State name: string = this.user.name
  @State birth: string = this.user.birthday
  @State email: string = this.user.email
  @State gender: number = this.user.sex
  @State sign: string = this.user.introduction
  // 用户名校验
  regName: RegExp = new RegExp('^[a-zA-Z0-9_]{4,20}$')
  // 加载弹窗
  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog({ message: '更新中请稍后...' }),
    customStyle: true
  })
  // 换绑弹窗
  changeEmailDialog: CustomDialogController = new CustomDialogController({
    builder: ChangeEmailDialog({
      updateInfo: (newEmail: string) => {
        this.email = newEmail
      }
    }),
    customStyle: true,
    maskColor: '#4dcfcccc'
  })
  // 更多弹窗
  MoreDialog: CustomDialogController = new CustomDialogController({
    builder: MoreDialog({
      onclick: () => {
        auth.setUser({} as User)
        this.MoreDialog.close()
        router.back()
      }
    }),
    customStyle: true,
    maskColor: '#4dcfcccc'
  })

  // 更新头像
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
      this.user.avatar = await httpReq.request<string>({
        url: '/file/upload/image',
        method: 'post',
        data: formData,
        headers: { 'Content-Type': 'multipart/form-data' },
        context: getContext(this)
      })
      // 并更新user数据
      auth.setUser(this.user)
      this.dialog.close()
      // 再提交用户数据给后台
      await this.updateUserInfo()
    }
  }

  // 更新用户内容
  async updateUserInfo() {
    if (this.name == '' || !this.regName.test(this.name)) {
      promptAction.showToast({
        message: this.name == '' ? '用户名不能为空' : '用户名无效。请使用4-20个字符，可以包含字母、数字和下划线。'
      })
      return
    }
    this.user.name = this.name
    this.user.birthday = this.birth
    this.user.sex = this.gender
    this.user.introduction = this.sign
    this.dialog.open()
    // 先更新后台数据
    await httpReq.request<null, IUpdateInfoParams>({
      url: '/user/update/info',
      method: 'post',
      data: this.user
    })
    // 在更新本地数据
    auth.setUser(this.user)
    this.dialog.close()
    promptAction.showToast({ message: '修改成功！' })
  }

  build() {
    Column() {
      CustomNavBar({
        title: '信息编辑',
        onclick: () => {
          this.updateUserInfo()
        }
      })
      Scroll() {
        Column() {
          Image(this.user.avatar || $rawfile('other/ic_mine_avatar.svg'))
            .width(125)
            .aspectRatio(1)
            .borderRadius(50)
            .margin({ bottom: 20, top: 24 })
            .onClick(async () => {
              await this.updateAvatar()
            })

          Column() {
            Divider()
              .width('100%')
              .height(2)
              .backgroundColor('#985e1f')
              .margin({ bottom: 15 })

            List({ space: 15 }) {
              ListItem() {
                InputComponent({ title: '名字', value: this.name })
              }

              ListItem() {
                InputComponent({
                  title: '电子邮箱',
                  value: this.email,
                  type: ITextType.email,
                  emailType: 1,
                  onclick: () => {
                    this.changeEmailDialog.open()
                  }
                })
              }

              ListItem() {
                Column({ space: 15 }) {
                  Text() {
                    Span('生日')
                      .fontColor('#985e1f')
                      .fontWeight(600)
                    Span('*')
                      .fontColor('rgb(242, 111, 56)')
                  }
                  .width('100%')

                  Row() {
                    UICalendarPicker({
                      onSelected: (date) => {
                        const datee = date as Date
                        const year = datee.getFullYear()
                        const month = datee.getMonth() + 1
                        const dates = datee.getDate()
                        this.birth = `${year}-${month < 10 ? '0' + month : month}-${dates < 10 ? '0' + dates : dates}`
                        logger.info(this.birth)
                      }
                    }) {
                      Text(this.birth || '请选择')
                        .fontColor(Color.White)
                        .width('100%')
                    }
                  }
                  .width('100%')
                  .height(50)
                  .borderRadius(20)
                  .backgroundColor('#fee170')
                  .padding({ left: 24 })
                }
              }

              ListItem() {
                Column({ space: 15 }) {
                  Text() {
                    Span('性别')
                      .fontColor('#985e1f')
                      .fontWeight(600)
                    Span('*')
                      .fontColor('rgb(242, 111, 56)')
                  }
                  .width('100%')

                  Row() {
                    Text(this.gender == 0 ? '女' : '男')
                      .fontColor(Color.White)
                  }
                  .width('100%')
                  .height(50)
                  .borderRadius(20)
                  .backgroundColor('#fee170')
                  .padding({ left: 24 })
                  .bindMenu(this.MenuBuilder)
                }
              }

              ListItem() {
                InputComponent({ title: '个性签名', value: this.sign })
              }
            }

            Row() {
              Image($rawfile('icon/im_more.png'))
                .width(34)
            }
            .width(100)
            .height(50)
            .borderRadius(30)
            .backgroundColor('#fee170')
            .justifyContent(FlexAlign.Center)
            .margin({ top: 15 })
            .onClick(() => {
              this.MoreDialog.open()
            })
          }
          .width('100%')
          .padding({ left: 40, right: 40 })
        }
      }
      .layoutWeight(1)
      .width('100%')
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fffcf3')
    .padding({ top: 10, bottom: this.bottomHeight })
  }

  @Builder
  MenuBuilder() {
    Menu() {
      MenuItem({ content: '男' })
        .onClick(() => {
          this.gender = 1
        })

      MenuItem({ content: '女' })
        .onClick(() => {
          this.gender = 0
        })
    }
    .width(108)
  }
}



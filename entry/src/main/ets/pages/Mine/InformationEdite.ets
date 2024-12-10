import { CustomNavBar, HcLoadingDialog, InputComponent } from '../../commons/components'
import { auth, httpReq, logger, UserInfo } from '../../commons/utils'
import { ITextType, User } from '../../models'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { FormData } from '@ohos/axios'
import { promptAction } from '@kit.ArkUI'
import { UICalendarPicker } from '@hw-agconnect/ui-calendar-picker'
import { ChangeEmailDialog } from '../../views/InformationEdite/ChangeEmailDialog'

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
  @StorageProp(UserInfo)
  user: User = {} as User
  @State name: string = ''
  @State birth: string = ''
  @State email: string = ''
  @State gender: number = 1
  @State sign: string = ''
  regName: RegExp = new RegExp('^[a-zA-Z0-9_]{4,20}$')
  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog({ message: '更新中请稍后...' }),
    customStyle: true
  })
  changeEmailDialog: CustomDialogController = new CustomDialogController({
    builder: ChangeEmailDialog({ email: this.email }),
    customStyle: true
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
      // 将图片存储到沙箱环境下
      // 打开文件
      const file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY)
      // 生成完整的图片路径
      const filePath = getContext(this).cacheDir + '/' + file.name
      // 拷贝图片  file.fd-->文件的标识符
      fileIo.copyFileSync(file.fd, filePath)
      // 关闭图片
      fileIo.closeSync(file.fd)
      // ------------------------------------------------
      // 创建formData对象---用来装载图片
      const formData = new FormData()
      formData.append('file', `internal://cache/${file.name}`)
      // TODO
      setTimeout(() => {
        this.dialog.close()
        promptAction.showToast({ message: '更新成功' })
      }, 1000)
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
    this.user.email = this.email
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

  aboutToAppear(): void {
    this.name = this.user.name
    this.birth = this.user.birthday
    this.email = this.user.email
    this.gender = this.user.sex
    this.sign = this.user.introduction
  }

  build() {
    Column() {
      CustomNavBar({
        title: '信息编辑',
        onclick: () => {
          this.updateUserInfo()
        }
      })

      Image('https://pic1.zhimg.com/v2-e5962333059d0dc857301394d30f396d_r.jpg?source=1940ef5c')
        .width(125)
        .borderRadius(50)
        .margin({ bottom: 20, top: 24 })
        .onClick(() => {
          this.updateAvatar()
        })

      Column() {
        Divider()
          .width('100%')
          .height(2)
          .backgroundColor('rgb(171, 171, 171)')
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
                  .fontColor(Color.White)
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
              .backgroundColor('#141414')
              .padding({ left: 24 })
            }
          }

          ListItem() {
            Column({ space: 15 }) {
              Text() {
                Span('性别')
                  .fontColor(Color.White)
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
              .backgroundColor('#141414')
              .padding({ left: 24 })
              .bindMenu(this.MenuBuilder)
            }
          }

          ListItem() {
            InputComponent({ title: '个性签名', value: this.sign })
          }
        }
      }
      .width('100%')
      .padding({ left: 40, right: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({ top: 10 })
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


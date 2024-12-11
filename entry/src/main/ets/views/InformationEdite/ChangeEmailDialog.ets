import { InputComponent } from '../../commons/components'
import { auth, httpReq, UserInfo } from '../../commons/utils'
import { ITextType, User } from '../../models'
import { IVerifyParams } from '../../pages/Login/Encrypted'
import { promptAction } from '@kit.ArkUI'

export interface IChangeEmail {
  code: string;
  email: string;
}

@CustomDialog
export struct ChangeEmailDialog {
  controller: CustomDialogController
  @StorageProp(UserInfo)
  user: User = {} as User
  @State email: string = this.user.email
  @State emailNum: string = ''
  @State newEmail: string = ''
  // 是否点击下一步
  @State isChange: boolean = false
  updateInfo = (newEmail:string) => {
  }

  async verify() {
    try {
      await httpReq.request<null, IVerifyParams>({
        url: '/check/email',
        method: 'post',
        data: {
          email: this.user.email,
          code: this.emailNum
        }
      })
      this.isChange = true
      this.emailNum = ''
      promptAction.showToast({ message: '验证成功' })
    } catch (err) {
      // 验证码错误
      promptAction.showToast({ message: err.errorMsg })
    }
  }

  async changeEmail() {
    try {
      await httpReq.request<null, IChangeEmail>({
        url: '/user/update/email',
        method: 'post',
        headers: {
          'uid': this.user.uid
        },
        data: {
          email: this.newEmail,
          code: this.emailNum
        }
      })
      this.user.email = this.newEmail
      // 更新用户数据
      auth.setUser(this.user)
      promptAction.showToast({ message: '换绑成功！' })
      this.controller.close()
    } catch (err) {
      promptAction.showToast({ message: err.errorMsg })
    }
  }

  build() {
    Column({ space: 30 }) {
      Text('电子邮箱改绑')
        .fontSize(36)
        .fontWeight(700)
        .fontColor(Color.White)
      if (!this.isChange) {
        InputComponent({ title: '请输入您的邮箱', type: ITextType.email, value: this.email })
      } else {
        InputComponent({ title: '新的邮箱', type: ITextType.email, value: this.newEmail })
      }
      InputComponent({ title: '邮箱验证码', value: this.emailNum })
      Button(!this.isChange ? '下一步' : '完成')
        .width(150)
        .height(50)
        .fontColor(Color.White)
        .fontSize(24)
        .fontWeight(700)
        .backgroundColor('rgb(55, 226, 204)')
        .onClick(() => {
          if (!this.isChange) {
            // 校验验证码
            this.verify()
          } else {
            // 执行改绑操作
            this.changeEmail()
            this.updateInfo(this.newEmail)
          }
        })
    }
    .padding({
      top: 60,
      bottom: 20,
      left: 15,
      right: 15
    })
    .backgroundColor('rgb(184, 171, 239)')
    .borderRadius(30)
    .width(330)
  }
}
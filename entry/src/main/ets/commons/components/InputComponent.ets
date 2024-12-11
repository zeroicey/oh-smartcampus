// 自定义输入栏
import { ITextType } from '../../models'
import { httpReq } from '../utils'
import { promptAction } from '@kit.ArkUI'

interface EmailParam {
  email: string
}

@Component
export struct InputComponent {
  @Prop title: string
  @Prop type: ITextType = ITextType.name
  // 邮箱图标类型
  @Prop emailType: number = 0
  @Prop placeholder: string
  @Link value: string
  @State isWaiting: boolean = false
  @State waitTime: number = 3
  regEmail: RegExp =
    /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  onclick = () => {

  }

  async getEmailNum() {
    try {
      await httpReq.request<null, EmailParam>({
        url: '/send/email',
        method: 'post',
        data: {
          email: this.value
        }
      })
      promptAction.showToast({ message: '发送成功' })
      this.isWaiting = true
      const timeId = setInterval(() => {
        --this.waitTime
        if (this.waitTime == 0) {
          clearTimeout(timeId)
          this.isWaiting = false
          this.waitTime = 3
        }
      }, 1000)
    } catch (err) {
      promptAction.showToast({ message: '发送失败' })
    }
  }

  build() {
    Column({ space: 15 }) {
      Text() {
        Span(this.title)
          .fontColor(Color.White)
          .fontWeight(600)
        Span('*')
          .fontColor('rgb(242, 111, 56)')
      }
      .width('100%')

      Stack() {
        TextInput({ placeholder: this.placeholder, text: $$this.value })
          .fontColor(Color.White)
          .maxLength(100)
          .placeholderColor('rgb(229, 228, 249)')
          .placeholderFont({ weight: 700 })
          .height(50)
          .width('100%')
          .backgroundColor('#141414')
          .padding({ left: 24 })
          .type(this.type == ITextType.password ? InputType.Password : InputType.Normal)
          .passwordIcon(this.type == ITextType.password ?
            { onIconSrc: $rawfile('icon/openEyeIcon.png'), offIconSrc: $rawfile('icon/closeEyeIcon.png') } : null)
        if (this.type == ITextType.email) {
          Row() {
            if (this.emailType == 0) {
              // 发送验证码
              if (!this.isWaiting) {
                Image($rawfile('icon/email.png'))
                  .width(25)
                  .onClick(() => {
                    // 如果格式不对或者为空不允许发送邮件
                    if (this.value == '' || !this.regEmail.test(this.value)) {
                      promptAction.showToast({ message: this.value == '' ? '请输入邮箱' : '邮箱格式不对' })
                      return
                    }
                    this.getEmailNum()
                  })
              } else {
                Text(`${this.waitTime}s`)
                  .fontColor(Color.White)
              }
            }
            if (this.emailType == 1) {
              // 更改邮箱
              Image($rawfile('icon/changeEmail.png'))
                .width(25)
                .onClick(() => {
                  this.onclick()
                })
            }
          }
          .position({ x: '100%' })
          .translate({ x: '-150%', y: '50%' })
          .width(30)
          .height(26)
        }
      }
    }
  }
}
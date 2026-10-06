// 自定义输入栏
import { ITextType } from '../../models'
import { httpReq, logger, toast, validateEmail } from '../utils'
import { EMAIL_COUNTDOWN_SECONDS } from '../constants'

interface EmailParam {
  email: string
}

@Component
export struct InputComponent {
  @Prop title: string
  @Prop type: ITextType = ITextType.name
  @Prop emailType: number = 0
  @Prop placeholder: string
  @Link value: string
  @State isWaiting: boolean = false
  @State waitTime: number = EMAIL_COUNTDOWN_SECONDS
  private timerId: number = -1
  onclick = () => {
  }

  aboutToDisappear(): void {
    this.clearTimer()
  }

  /** 清理倒计时，避免页面销毁后定时器仍在跑 */
  private clearTimer(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
      this.timerId = -1
    }
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
      toast.success('验证码已发送')
      this.startCountdown()
    } catch (err) {
      toast.requestFailed(err)
      logger.error('InputComponent: 发送验证码失败', JSON.stringify(err))
    }
  }

  /** 开始倒计时：结束后恢复为完整的 60 秒，而不是重置为 3 秒 */
  private startCountdown(): void {
    this.clearTimer()
    this.isWaiting = true
    this.waitTime = EMAIL_COUNTDOWN_SECONDS
    this.timerId = setInterval(() => {
      this.waitTime--
      if (this.waitTime <= 0) {
        this.clearTimer()
        this.isWaiting = false
        this.waitTime = EMAIL_COUNTDOWN_SECONDS
      }
    }, 1000)
  }

  build() {
    Column({ space: 15 }) {
      Text() {
        Span(this.title)
          .fontColor('#985e1f')
          .fontWeight(600)
        Span('*')
          .fontColor('rgb(242, 111, 56)')
      }
      .width('100%')

      Stack() {
        TextInput({ placeholder: this.placeholder, text: $$this.value })
          .fontColor('#985e1f')
          .maxLength(100)
          .placeholderColor('#fee170')
          .placeholderFont({ weight: 700 })
          .height(50)
          .width('100%')
          .backgroundColor('#fee170')
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
                    // 统一使用校验工具，避免正则重复维护
                    const result = validateEmail(this.value)
                    if (!result.valid) {
                      toast.warn(result.message)
                      return
                    }
                    this.getEmailNum()
                  })
              } else {
                Text(`${this.waitTime}s`)
                  .fontColor(Color.White)
                  .fontSize(14)
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

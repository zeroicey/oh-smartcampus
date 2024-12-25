import { IInformation, User } from '../../models'
import { router } from '@kit.ArkUI'
import { auth, logger } from '../../commons/utils'

@Component
export struct Avatar {
  @Prop user: User
  @Prop item: IInformation

  aboutToAppear(): void {
    logger.info(JSON.stringify(this.user))
  }

  build() {
    Column({ space: 20 }) {
      Row() {
        Column() {
          Text(this.user.token ? 'Hi~' + this.user.name : '立即登录')
            .fontSize(23)
            .fontWeight(900)
            .fontColor(Color.White)
            .onClick(() => {
              if (!this.user.token) {
                router.pushUrl({
                  url: 'pages/Login/Login'
                })
              }
            })
          if (this.user.token) {
            Row({ space: 5 }) {
              Text(`学时：${this.item.studyTime}h`)
                .fontColor(Color.White)
                .fontSize(12)
              Text('签到：'+/*${this.item.attendance}*/'n'+' 天')
                .fontColor(Color.White)
                .fontSize(12)
            }
          }
        }
        .alignItems(HorizontalAlign.Start)

        Row() {
          Row() {
            Image(this.user.avatar || $rawfile('other/ic_mine_avatar.svg'))
              .alt($rawfile('other/ic_mine_avatar.svg'))
              .width(50)
              .aspectRatio(1)
              .borderRadius(40)
          }
          .width(60)
          .height(55)
          .borderRadius(40)
          .translate({ x: 10 })
          .backgroundColor('rgb(53, 50, 66)')
          .justifyContent(FlexAlign.Center)
          .zIndex(1)

          Row() {
            Image($rawfile('icon/Setting.png'))
              .width(25)
          }
          .width(50)
          .height(50)
          .backgroundColor('rgb(112, 111, 116)')
          .justifyContent(FlexAlign.Center)
          .borderRadius(25)
        }
        .onClick(() => {
          auth.CheckAuth(() => {
            router.pushUrl({
              url: 'pages/Mine/InformationEdite'
            })
          })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Text(this.user.introduction)
        .fontSize(20)
        .fontWeight(700)
        .fontColor(Color.White)
        .width('100%')
    }
    .width('100%')
  }
}
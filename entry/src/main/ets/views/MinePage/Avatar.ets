import { User } from '../../models'
import { router } from '@kit.ArkUI'
import { logger } from '../../commons/utils'

@Component
export struct Avatar {
  @Prop user: User

  aboutToAppear(): void {
    logger.info(JSON.stringify(this.user))
  }

  build() {
    Row({ space: 13 }) {
      Image(this.user.avatar || $rawfile('other/ic_mine_avatar.svg'))
        .alt($rawfile('other/ic_mine_avatar.svg'))
        .width(80)
        .aspectRatio(1)
        .borderRadius(40)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Mine/InformationEdite'
          })
        })
      if (this.user.token) {
        Column() {
          Text(this.user.name)
            .fontSize(23)
            .fontWeight(900)
            .fontColor(Color.White)
          Text(this.user.introduction)
            .fontWeight(700)
            .fontColor(Color.White)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      } else {
        Column() {
          Text('立即登录')
            .fontSize(23)
            .fontWeight(900)
            .fontColor(Color.White)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Login/Login'
              })
            })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
    }
    .width('100%')
  }
}
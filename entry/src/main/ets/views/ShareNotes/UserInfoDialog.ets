import { IPublisher } from '../../models'

@CustomDialog
export struct UserInfoDialog {
  controller: CustomDialogController
  @Prop publisher: IPublisher = {} as IPublisher

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

      Column() {
        Stack({ alignContent: Alignment.Bottom }) {
          Image(this.publisher.avatar || $rawfile('other/ic_mine_avatar.svg'))
            .alt($rawfile('other/ic_mine_avatar.svg'))
            .width(142)
            .border({
              color: 'rgb(141, 135, 242)',
              width: 8
            })
            .borderRadius(80)
          Text(this.publisher.name)
            .fontSize(20)
            .fontWeight(900)
            .fontColor('rgb(0, 0, 0)')
            .width(100)
            .height(30)
            .borderRadius(5)
            .textAlign(TextAlign.Center)
            .backgroundColor('rgb(141, 135, 242)')
        }
        .width(150)
        .height(150)
        .translate({ y: '-50%' })

        Column({ space: 15 }) {
          Text(`已学课程：${this.publisher.studyProgress}%`)
            .fontColor(Color.White)
            .width('100%')
            .fontSize(20)
            .fontWeight(700)
            .textAlign(TextAlign.Center)
          Text(this.publisher.introduction)
            .fontColor(Color.White)
            .width('100%')
            .fontSize(20)
            .fontWeight(700)
            .textAlign(TextAlign.Center)
          Row({ space: 25 }) {
            Column() {
              Text('' + this.publisher.attendance)
                .fontColor('rgb(97, 217, 201)')
                .fontSize(24)
                .fontWeight(700)
              Text('累计签到')
                .fontColor('rgb(232, 232, 232)')
                .fontSize(14)
                .fontWeight(700)
            }

            Column() {
              Text('' + this.publisher.brightTotal)
                .fontColor('rgb(97, 217, 201)')
                .fontSize(24)
                .fontWeight(700)
              Text('累计发光')
                .fontColor('rgb(232, 232, 232)')
                .fontSize(14)
                .fontWeight(700)
            }

            Column() {
              Text('' + this.publisher.likeTotal)
                .fontColor('rgb(97, 217, 201)')
                .fontSize(24)
                .fontWeight(700)
              Text('累计获赞')
                .fontColor('rgb(232, 232, 232)')
                .fontSize(14)
                .fontWeight(700)
            }
          }
        }
        .width('100%')
        .translate({ y: -45 })

      }
      .width(300)
      .backgroundColor('#16151A')
      .borderRadius(30)
      .padding({ left: 20, right: 20 })
    }
  }
}
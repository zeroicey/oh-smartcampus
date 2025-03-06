import { CommentReply } from '../../commons/components'

@Component
export struct SNList {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State isShow: boolean = false

  build() {
    List({ space: 20 }) {
      ForEach(Array.from({ length: 5 }), () => {
        ListItem() {
          Column() {
            // 回复
            CommentReply()
            Row() {
              Divider()
                .width(50)
                .height(2)
                .color('#c77a28')
              Text('展开25条回复')
                .fontSize(12)
                .fontWeight(900)
                .fontColor('#c77a28')
                .onClick(() => {
                  this.isShow = true
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.End)
            .margin({ bottom: 20 })

            Divider()
              .width('100%')
              .height(2)
              .color('#c77a28')
          }
          .width('100%')
        }
      })
    }
    .bindSheet($$this.isShow, this.ExpansionPopupBuilder(), {
      showClose: false
    })
  }

  @Builder
  ExpansionPopupBuilder() {
    Column() {
      Text('关闭')
        .width('100%')
        .fontWeight(900)
        .fontColor(Color.White)
        .textAlign(TextAlign.End)
        .onClick(() => {
          this.isShow = false
        })
      CommentReply({ showRightIcon: false })
      Divider()
        .width('100%')
        .color('#c77a28')
        .height(2)
        .margin({ bottom: 10 })
      Text() {
        Span('全部回复')
        Span('332')
      }
      .width('100%')
      .fontSize(14)
      .fontWeight(900)
      .fontColor('#c77a28')
      .margin({ bottom: 27 })

      List({ space: 20 }) {
        ForEach(Array.from({ length: 5 }), () => {
          ListItem() {
            Column() {
              CommentReply()
              Divider()
                .width('100%')
                .height(2)
                .color('#c77a28')
                .width('100%')
                .margin({ top: 10 })
            }
          }
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#fee170')
    .padding({
      left: 30,
      right: 30,
      bottom: this.bottomHeight,
      top: 30
    })
  }
}
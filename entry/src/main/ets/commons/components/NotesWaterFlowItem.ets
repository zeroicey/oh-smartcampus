import { Rows, WaterFlowType } from '../../models'

@Entry
@Component
export struct NotesWaterFlowItem {
  @Prop item: Rows = {} as Rows
  @Prop flowType: WaterFlowType = WaterFlowType.message

  build() {
    Stack() {
      Image(this.item.picture || $rawfile('icon/A.png'))
        .alt($rawfile('icon/A.png'))
        .width('100%')
        .borderRadius(20)
        .aspectRatio(1)
      Column() {
        Column() {

        }
        .width('100%')
        .height(158)
        .borderRadius({ topLeft: 20, topRight: 20 })

        Column({ space: 6 }) {
          Text(this.item.title)
            .fontSize(18)
            .fontWeight(700)
            .maxLines(2)
            .width('100%')
            .fontColor(Color.White)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Row() {
            Image(this.item.creatorAvatar || $rawfile('other/ic_mine_avatar.svg'))
              .alt($rawfile('other/ic_mine_avatar.svg'))
              .width(20)
              .borderRadius(10)
              .aspectRatio(1)
              .margin({ right: 3 })
            Text(this.item.creatorName)
              .fontSize(14)
              .fontWeight(700)
              .fontColor(Color.White)

            Blank()

            if (this.flowType != WaterFlowType.draft) {
              Text() {
                ImageSpan($rawfile('icon/like.png'))
                  .width(15)
                  .margin({ right: 3 })
                Span(`${this.item.likeTotal}`)
                  .fontSize(14)
                  .fontWeight(700)
                  .fontColor(Color.White)
              }
            }
          }
          .width('100%')
        }
        .width('100%')
        .backgroundColor('rgba(166, 166, 166, 0.5)')
        .borderRadius({ bottomLeft: 20, bottomRight: 20 })
        .padding({
          right: 8,
          left: 8,
          top: 5,
          bottom: 5
        })
        .backdropBlur(20)
      }
      .borderRadius(20)
      .width('100%')
      .backgroundImage(this.item.picture || $rawfile('other/defaultNote.png'))
      .backgroundImageSize(ImageSize.Cover)
    }
  }
}
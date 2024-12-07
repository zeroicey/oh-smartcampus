import { IAllPublisherNotes } from '../../models'

@Entry
@Component
export struct NotesWaterFlowItem {
  @Prop item: IAllPublisherNotes = {} as IAllPublisherNotes

  build() {
    Column() {
      Column() {
        Column() {

        }
        .width('100%')
        .height(158)
        .borderRadius({ topLeft: 20, topRight: 20 })

        Column({ space: 6 }) {
          Text(this.item.context.title)
            .fontSize(18)
            .fontWeight(700)
            .maxLines(2)
            .width('100%')
            .fontColor(Color.White)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Row() {
            Image(this.item.user.avatar)
              .width(20)
              .borderRadius(10)
              .margin({ right: 3 })
            Text(this.item.user.name)
              .fontSize(10)
              .fontWeight(700)
              .fontColor(Color.White)

            Blank()

            Text() {
              ImageSpan($rawfile('icon/userLike.png'))
                .width(15)
                .margin({ right: 3 })
              Span('' + this.item.user.praise)
                .fontSize(10)
                .fontWeight(700)
                .fontColor('rgb(127, 127, 127)')
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
      .backgroundImage(this.item.context.pictures[0])
      .backgroundImageSize(ImageSize.Cover)
    }
  }
}
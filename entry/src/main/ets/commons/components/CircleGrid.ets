import { IAllCircle } from '../../models'
import { logger } from '../utils'

@Component
export struct CircleGrid {
  @State list: IAllCircle[] = []
  onclick = (circleId: string) => {

  }

  build() {
    Grid() {
      ForEach(this.list, (item: IAllCircle, index: number) => {
        GridItem() {
          Column({ space: 5 }) {
            Image(item.avatar)
              .width(80)
              .height(80)
              .borderRadius(30)
              .alignSelf(ItemAlign.Start)
              .shadow({
                radius: 13,
                color: 'rgba(0, 0, 0, 0.25)',
              })
            Text(item.name)
              .width('100%')
              .textAlign(TextAlign.End)
              .fontSize(14)
          }
          .width('100%')
          .height(130)
          .borderRadius(30)
          .padding(15)
          .backgroundColor(Color.White)
          .onClick(() => {
            logger.info(item.circleId)
            this.onclick(item.circleId)
          })
        }
      })
    }
    .width('100%')
    .height(320)
    .columnsTemplate('1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .rowsGap(15)
    .columnsGap(15)
  }
}
import { UserInfo } from '../../commons/utils'
import { IInformation, User } from '../../models'

interface INoteParams {
  count: number,
  title: string,
  icon: ResourceStr
}

@Preview
@Component
export struct NoteInfomation {
  @StorageProp(UserInfo)
  user: User = {} as User
  @Prop item: IInformation

  build() {
    Row() {
      this.noteInfoBuilder({ count: this.item.likeTotal, title: '获赞数', icon: $rawfile('icon/mineLike.png') })
      this.noteInfoBuilder({ count: this.item.likeTotal, title: '获亮数', icon: $rawfile('icon/mineLight.png') })
      this.noteInfoBuilder({ count: this.item.likeTotal, title: '笔记数', icon: $rawfile('icon/mineNote.png') })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  noteInfoBuilder(item: INoteParams) {
    Stack({ alignContent: Alignment.Top }) {
      Column({ space: 5 }) {
        Text(this.user.token ? `${item.count}` : '--')
          .fontSize(36)
          .fontWeight(900)
          .fontColor(Color.White)
          .width('100%')
          .textAlign(TextAlign.Center)
        Text(item.title)
          .fontColor(Color.White)
      }
      .padding(16)
      .width(100)
      .height(120)
      .borderRadius(30)
      .backgroundColor(Color.Pink)
      .justifyContent(FlexAlign.End)
      .linearGradient({
        colors: [['rgb(241, 232, 255)', -0.07], ['rgb(164, 154, 223)', 0.49], ['rgb(65, 49, 158)', 1.39]]
      })

      Row() {
        Image(item.icon)
          .width(30)
      }
      .width(50)
      .height(50)
      .backgroundColor('rgb(53, 50, 66)')
      .borderRadius(25)
      .justifyContent(FlexAlign.Center)
      .translate({ y: '-50%' })
    }
  }
}
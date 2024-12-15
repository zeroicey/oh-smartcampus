import { httpReq } from '../../commons/utils';
import { promptAction } from '@kit.ArkUI';

export interface PraiseOrCollectParam {
  /**
   * 笔记 ID
   */
  noteId: string;
}

@Component
export struct SNNavBar {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @Link isSend: boolean
  @Prop noteId: string
  // TODO
  // 点赞和收藏应由父级组件传过来
  // 是否点赞
  @State isLike: number = 0
  // 是否收藏
  @State isCollect: number = 0
  // 防抖计时器Id
  @State timeId: number = -1

  // 点赞/取消点赞请求 1是点赞，0是取消点赞
  praise(isLike: 0 | 1) {
    try {
      this.isLike = isLike
      clearTimeout(this.timeId)
      this.timeId = setTimeout(async () => {
        await httpReq.request<null, PraiseOrCollectParam>({
          url: isLike == 1 ? '/note/like' : '/note/unlike',
          method: 'post',
          headers: {
            "uid": "1000001"
          },
          data: {
            noteId: this.noteId
          }
        })
        promptAction.showToast({ message: isLike == 0 ? '取消成功' : '点赞成功' })
      }, 500)
    } catch (err) {
      promptAction.showToast({ message: '请求失败' })
    }
  }

  // 收藏/取消收藏 1是收藏，0是取消收藏
  collect(isCollect: 0 | 1) {
    try {
      this.isCollect = isCollect
      clearTimeout(this.timeId)
      this.timeId = setTimeout(async () => {
        await httpReq.request<null, PraiseOrCollectParam>({
          url: isCollect == 1 ? '/note/collect' : '/note/uncollect',
          method: 'post',
          headers: {
            "uid": "1000001"
          },
          data: {
            noteId: this.noteId
          }
        })
        promptAction.showToast({ message: isCollect == 0 ? '取消成功' : '收藏成功' })
      }, 500)
    } catch (err) {
      promptAction.showToast({ message: '请求失败' })
    }
  }

  build() {
    Row({ space: 30 }) {
      Row({ space: 5 }) {
        Image(this.isLike == 0 ? $rawfile('icon/like.png') : $rawfile('icon/like_Selected.png'))
          .width(37)
          .onClick(() => {
            this.praise(this.isLike == 0 ? 1 : 0)
          })
        Text('432')
          .fontColor(this.isLike == 0 ? Color.White : 'rgb(255, 153, 150)')
          .fontSize(18)
          .fontWeight(900)
      }
      .alignItems(VerticalAlign.Bottom)

      Row({ space: 5 }) {
        Image(this.isCollect ? $rawfile('icon/collection_Selected.png') : $rawfile('icon/collection.png'))
          .width(37)
          .onClick(() => {
            this.collect(this.isCollect == 0 ? 1 : 0)
          })
        Text('432')
          .fontColor(this.isCollect ? 'rgb(242, 245, 95)' : Color.White)
          .fontSize(18)
          .fontWeight(900)
      }
      .alignItems(VerticalAlign.Bottom)

      Row({ space: 5 }) {
        Image($rawfile('icon/review.png'))
          .width(36)
        Text('432')
          .fontColor(Color.White)
          .fontSize(18)
          .fontWeight(900)
      }
      .alignItems(VerticalAlign.Bottom)
      .onClick(() => {
        this.isSend = true
      })
    }
    .width('100%')
    .borderRadius(20)
    .backgroundColor('rgb(59, 59, 59)')
    .justifyContent(FlexAlign.Center)
    .padding({
      left: 50,
      right: 50,
      bottom: this.bottomHeight,
      top: 25
    })
  }
}
import { httpReq } from '../../commons/utils';
import { promptAction } from '@kit.ArkUI';
import { IPublisherData } from '../../models';

export interface PraiseOrCollectParam {
  noteId: string; //笔记id
}

@Component
export struct SNNavBar {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  // 用来控制是否显示
  @Link isSend: boolean
  //笔记id
  @Prop noteId: string
  // 发布者所有内容
  @Prop publisherData: IPublisherData
  // 防抖计时器Id
  @State timeId: number = -1

  // 点赞/取消点赞请求
  praise() {
    this.publisherData.isLike = !this.publisherData.isLike
    clearTimeout(this.timeId)
    this.timeId = setTimeout(async () => {
      await httpReq.request<null, PraiseOrCollectParam>({
        url: this.publisherData.isLike ? '/note/like' : '/note/unlike',
        method: 'post',
        // TODO header请求头
        headers: {
          "uid": "1000001"
        },
        data: {
          noteId: this.noteId
        }
      })
      promptAction.showToast({ message: this.publisherData.isLike ? '点赞成功' : '取消成功' })
    }, 500)
  }

  // 收藏/取消收藏 1是收藏，0是取消收藏
  collect() {
    this.publisherData.isCollect = !this.publisherData.isCollect
    clearTimeout(this.timeId)
    this.timeId = setTimeout(async () => {
      await httpReq.request<null, PraiseOrCollectParam>({
        url: this.publisherData.isCollect ? '/note/collect' : '/note/uncollect',
        method: 'post',
        // TODO header请求头
        headers: {
          "uid": "1000001"
        },
        data: {
          noteId: this.noteId
        }
      })
      promptAction.showToast({ message: this.publisherData.isCollect ? '收藏成功' : '取消成功' })
    }, 500)
  }

  build() {
    Row() {
      Row({ space: 5 }) {
        Image(this.publisherData.isLike ? $rawfile('icon/like_Selected.png') : $rawfile('icon/like.png'))
          .width(37)
          .onClick(() => {
            this.praise()
            if (this.publisherData.isLike) {
              this.publisherData.likeTotal++
            } else {
              this.publisherData.likeTotal--
            }
          })
        Text(`${this.publisherData.likeTotal}`)
          .fontColor(this.publisherData.isLike ? 'rgb(255, 153, 150)' : Color.White)
          .fontSize(18)
          .fontWeight(900)
      }
      .alignItems(VerticalAlign.Bottom)

      Row({ space: 5 }) {
        Image(this.publisherData.isCollect ? $rawfile('icon/collection_Selected.png') : $rawfile('icon/collection.png'))
          .width(37)
          .onClick(() => {
            this.collect()
            if (this.publisherData.isCollect) {
              this.publisherData.collectTotal++
            } else {
              this.publisherData.collectTotal--
            }
          })
        Text(`${this.publisherData.collectTotal}`)
          .fontColor(this.publisherData.isCollect ? 'rgb(242, 245, 95)' : Color.White)
          .fontSize(18)
          .fontWeight(900)
      }
      .alignItems(VerticalAlign.Bottom)

      Row({ space: 5 }) {
        Image($rawfile('icon/review.png'))
          .width(36)
        Text(`${this.publisherData.commentTotal}`)
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
    .justifyContent(FlexAlign.SpaceAround)
    .padding({
      left: 50,
      right: 50,
      bottom: this.bottomHeight,
      top: 25
    })
  }
}
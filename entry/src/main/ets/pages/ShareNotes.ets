import { CustomNavBar } from '../commons/components';
import { UserInfoDialog } from '../views/ShareNotes/UserInfoDialog';

interface IconItem {
  icon: Resource;
  activeIcon: Resource;
}

@Entry
@Component
struct ShareNotes {
  @State swiperList: string[] = [
    'https://tse2-mm.cn.bing.net/th/id/OIP-C.5ASZMDn60QmoRWwJhfAs9AHaHa?rs=1&pid=ImgDetMain',
    'https://bpic.588ku.com/element_origin_min_pic/19/04/09/c2927d488f5166168b85288b186333b5.jpg',
    'https://bpic.588ku.com/element_pic/23/04/25/1ff048e85ae0147376033edab9307568.png',
    'https://bpic.588ku.com/element_pic/23/04/25/1ff048e85ae0147376033edab9307568.png',
    'https://img95.699pic.com/element/40159/7630.png_300.png'

  ]
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  UserInfoDialog = new CustomDialogController({
    builder: UserInfoDialog(),
    customStyle: true,
    maskColor: '#4dc4c4c4',
    // backgroundBlurStyle: BlurStyle.BACKGROUND_THICK
  })

  build() {
    Column() {
      // 顶部导航条
      CustomNavBar({ default: this.UserTitleBuilder, rightIcon: this.ChargingBtnBuilder })
      Scroll() {
        Column() {
          // 轮播图
          Swiper() {
            ForEach(this.swiperList, (item: string) => {
              Column() {
                Image(item)
                  .width('100%')
                  .height(390)
                  .borderRadius(20)
              }
              .width('100%')
              .padding({ left: 10, right: 10 })
            })
          }
          .width('100%')
          .height(420)
          .loop(false)
          .indicator(
            new DotIndicator()
              .selectedColor('rgb(141, 135, 242)')
              .color('rgb(196, 196, 196)')
              .selectedItemWidth(10)
              .selectedItemHeight(10)
              .itemWidth(10)
              .itemHeight(10)
          )

          // 话题
          Column({ space: 10 }) {
            Text('点击进入知识圈频道')
              .fontSize(24)
              .fontWeight(900)
              .fontColor(Color.White)
              .width('100%')

            Text('点击进入知识圈频道')
              .fontSize(20)
              .fontWeight(900)
              .fontColor(Color.White)
              .width('100%')
            Row() {
              Image($rawfile('icon/aiIcon.png'))
                .width(28)
              Text('这里是话题')
                .fontSize(20)
                .fontWeight(900)
                .fontColor('#98F4E9')
                .width('100%')
            }

            Divider()
              .width('100%')
              .height(2)
              .color('rgb(136, 136, 136)')
              .width('100%')
              .margin({ top: 10 })
          }
          .margin({ bottom: 20 })

          // 聊天
          List({ space: 20 }) {
            ForEach(Array.from({ length: 5 }), () => {
              ListItem() {
                Column() {
                  Row({ space: 5 }) {
                    Image('https://pic3.zhimg.com/v2-b173b089c839b82b923260d8acf1688f_r.jpg?source=1940ef5c')
                      .width(50)
                      .borderRadius(25)
                      .margin({ left: 10 })
                      .alignSelf(ItemAlign.Start)
                    Column() {
                      Row() {
                        Text('用户002')
                          .fontSize(16)
                          .fontColor(Color.White)
                          .fontWeight(900)
                        Blank()
                        Column() {
                          Image(false ? $rawfile('icon/like_Selected.png') : $rawfile('icon/userLike.png'))
                            .width(24)
                          if (true) {
                            Text('24')
                              .fontSize(14)
                              .fontWeight(900)
                              .fontColor('rgb(177, 177, 177)')
                          }
                        }
                      }
                      .width('100%')

                      Text('这里hyauisdhiudhiahaiso;aisd;ia说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话\n' +
                        '这里说了一大段不知道在说什么的话这里说了一大段不知道在说什么的话')
                        .width('100%')
                        .margin({ bottom: 18 })
                        .fontSize(16)
                        .fontWeight(900)
                        .fontColor('rgb(241, 241, 241)')
                      Row() {
                        Divider()
                          .width(50)
                          .height(2)
                          .color('rgb(136, 136, 136)')
                        Text('展开25条回复')
                          .fontSize(12)
                          .fontWeight(900)
                          .fontColor('rgb(136, 136, 136)')
                      }
                      .width('100%')
                      .justifyContent(FlexAlign.End)
                      .margin({ bottom: 20 })
                    }
                    .layoutWeight(1)
                  }

                  Divider()
                    .width('100%')
                    .height(2)
                    .color('rgb(136, 136, 136)')
                }
                .width('100%')
              }
            })
          }

        }
        .width('100%')
        .padding({ right: 30, left: 30 })
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
      .margin({ top: 20 })

      // 底部点赞
      Row({ space: 30 }) {
        Row({ space: 5 }) {
          Image(false ? $rawfile('icon/like_Selected.png') : $rawfile('icon/like.png'))
            .width(37)
          Text('432')
            .fontColor(false ? 'rgb(255, 153, 150)' : Color.White)
            .fontSize(18)
            .fontWeight(900)
        }
        .alignItems(VerticalAlign.Bottom)

        Row({ space: 5 }) {
          Image(false ? $rawfile('icon/collection_Selected.png') : $rawfile('icon/collection.png'))
            .width(37)
          Text('432')
            .fontColor(false ? 'rgb(242, 245, 95)' : Color.White)
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
      }
      .width('100%')
      .borderRadius(20)
      .backgroundColor('rgb(59, 59, 59)')
      .padding({
        left: 50,
        right: 50,
        bottom: this.bottomHeight,
        top: 25
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
  }

  @Builder
  UserTitleBuilder() {
    Row({ space: 10 }) {
      Image('https://pic1.zhimg.com/v2-e5962333059d0dc857301394d30f396d_r.jpg?source=1940ef5c')
        .width(50)
        .borderRadius(25)
        .onClick(() => {
          this.UserInfoDialog.open()
        })
      Text('用户001')
        .fontSize(24)
        .fontColor(Color.White)
        .fontWeight(700)
    }
    .height(50)
  }

  @Builder
  ChargingBtnBuilder() {
    Text('充电')
      .fontSize(24)
      .fontWeight(900)
      .fontColor('rgb(255, 253, 154)')
      .padding({
        left: 10,
        right: 10,
      })
      .borderRadius(20)
      .border({
        color: 'rgb(255, 153, 150)',
        width: 3
      })

  }
}
import { auth } from '../commons/utils/Auth';
import { AIChatPage } from './AIChatPage';
import { HomePage } from './HomePage';
import { KnowledgeSpherePage } from './KnowledgeSpherePage';
import { MinePage } from './Mine/MinePage';

interface TabItem {
  icon: Resource;
  activeIcon: Resource;
  name: string;
}

auth.initUser()

@Entry
@Component
struct Index {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp('topHeight')
  topHeight: number = 0
  tabList: TabItem[] = [
    {
      icon: $rawfile('icon/Home.png'),
      activeIcon: $rawfile('icon/Home_Selected.png'),
      name: '首页'
    },
    {
      icon: $rawfile('icon/AIChat.png'),
      activeIcon: $rawfile('icon/AIChat_Selected.png'),
      name: 'AI聊天'
    },
    {
      icon: $rawfile('icon/KnowledgeSphere.png'),
      activeIcon: $rawfile('icon/KnowledgeSphere_Selected.png'),
      name: '知识圈'
    },
    {
      icon: $rawfile('icon/Mine.png'),
      activeIcon: $rawfile('icon/Mine_Selected.png'),
      name: '我的'
    },
  ]
  @State activeIndex: number = 0
  @State angleNumber: number = 45

  @Builder
  TabContent(item: TabItem, index: number) {
    Row({ space: 4 }) {
      Image(this.activeIndex == index ? item.activeIcon : item.icon)
        .width(20)
        .aspectRatio(1)
      if (this.activeIndex == index) {
        Text(item.name)
          .fontSize(18)
          .fontColor(index == this.activeIndex ? '#0cddbe' : Color.White)
          .fontWeight(700)
      }
    }
    .padding(13)
    .borderRadius(12)
    .backgroundColor('rgba(255, 255, 255, 0.1)')
  }

  build() {
    Tabs() {
      ForEach(this.tabList, (item: TabItem, index: number) => {
        TabContent() {
          if (index == 0) {
            HomePage()
          } else if (index == 1) {
            AIChatPage()
          } else if (index == 2) {
            KnowledgeSpherePage()
          } else {
            MinePage()
          }
        }
        .tabBar(this.TabContent(item, index))
        .padding({ bottom: 10 })
      })
    }
    .barPosition(BarPosition.End)
    .backgroundColor('rgba(0,0,0,0)')
    .scrollable(false)
    .onTabBarClick((index: number) => {
      this.activeIndex = index
      this.angleNumber = 0
    })
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({ top: this.topHeight + 10, bottom: this.bottomHeight })
    .animationMode(AnimationMode.NO_ANIMATION)
  }
}
import { bundleManager } from '@kit.AbilityKit'
import { CustomNavBar, HcTag } from '../commons/components'
import { logger, toast, UserInfo, storage, searchHistory } from '../commons/utils'
import { STORAGE_NAME_SEARCH, STORAGE_NAME_TRACKING } from '../commons/constants'
import { User } from '../models'

/** 列表项参数 */
interface AboutItem {
  label: string
  value?: string
  arrow: boolean
}

/** 兜底版本号，读取失败时展示 */
const FALLBACK_VERSION = '1.0.0'

@Entry
@Component
struct About {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp(UserInfo)
  user: User = {} as User
  @State version: string = FALLBACK_VERSION
  @State cacheText: string = '计算中'
  private items: AboutItem[] = [
    { label: '用户协议', arrow: true },
    { label: '隐私政策', arrow: true },
    { label: '检查更新', arrow: true },
    { label: '意见反馈', arrow: true }
  ]

  aboutToAppear(): void {
    this.version = this.readVersion()
    this.refreshCacheText()
  }

  /** 读取应用版本号 */
  private readVersion(): string {
    try {
      const info = bundleManager.getBundleInfoForSelfSync(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT
      )
      return info.versionName || FALLBACK_VERSION
    } catch (err) {
      logger.error('About: 读取版本号失败', (err as Error).message)
      return FALLBACK_VERSION
    }
  }

  /** 刷新本地缓存占用展示 */
  private refreshCacheText(): void {
    const searchCount = searchHistory.size()
    this.cacheText = `搜索历史 ${searchCount} 条`
  }

  /** 清理本地缓存 */
  private clearCache(): void {
    storage.clear(STORAGE_NAME_SEARCH)
    storage.clear(STORAGE_NAME_TRACKING)
    this.refreshCacheText()
    toast.success('本地缓存已清理')
  }

  @Builder
  SectionTitle(title: string) {
    Text(title)
      .width('100%')
      .fontSize(14)
      .fontColor('#985e1f')
      .fontWeight(700)
      .margin({ top: 20, bottom: 10 })
  }

  @Builder
  ItemRow(item: AboutItem) {
    Row() {
      Text(item.label)
        .fontSize(16)
        .fontColor('#985e1f')
      Blank()
      if (item.value) {
        Text(item.value)
          .fontSize(14)
          .fontColor('#c77a28')
          .margin({ right: 6 })
      }
      if (item.arrow) {
        Text('›')
          .fontSize(22)
          .fontColor('#c77a28')
      }
    }
    .width('100%')
    .height(52)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#fce071')
    .borderRadius(16)
    .margin({ bottom: 10 })
    .onClick(() => {
      toast.info(`${item.label}功能建设中`)
    })
  }

  build() {
    Column() {
      CustomNavBar({ title: '关于我们', showRightIcon: false })

      Scroll() {
        Column() {
          Column({ space: 10 }) {
            Image($rawfile('other/dragonLogo.png'))
              .width(96)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
            Text($r('app.string.app_name'))
              .fontSize(20)
              .fontWeight(900)
              .fontColor('#985e1f')
            HcTag({ text: `v${this.version}`, size: 'small', selected: false })
          }
          .width('100%')
          .padding({ top: 24, bottom: 24 })
          .alignItems(HorizontalAlign.Center)

          Text($r('app.string.about_intro'))
            .width('100%')
            .fontSize(14)
            .lineHeight(22)
            .fontColor('#985e1f')
            .padding({ left: 16, right: 16 })

          this.SectionTitle('团队信息')
          this.ItemRow({ label: '开发团队', value: '东软灵犀团队', arrow: false })
          this.ItemRow({ label: '联系邮箱', value: 'support@example.com', arrow: false })

          this.SectionTitle('通用')
          ForEach(this.items, (item: AboutItem) => {
            this.ItemRow(item)
          }, (item: AboutItem) => item.label)

          this.SectionTitle('存储')
          Row() {
            Text('清除本地缓存')
              .fontSize(16)
              .fontColor('#985e1f')
            Blank()
            Text(this.cacheText)
              .fontSize(14)
              .fontColor('#c77a28')
          }
          .width('100%')
          .height(52)
          .padding({ left: 16, right: 16 })
          .backgroundColor('#fce071')
          .borderRadius(16)
          .onClick(() => {
            this.clearCache()
          })

          Blank().height(40)

          Text($r('app.string.about_copyright'))
            .width('100%')
            .fontSize(12)
            .fontColor('#c77a28')
            .textAlign(TextAlign.Center)
            .margin({ bottom: 30 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fffcf3')
    .padding({ bottom: this.bottomHeight })
  }
}

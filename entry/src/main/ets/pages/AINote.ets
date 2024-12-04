
import { AINote_head } from 'ets/views/AINote/AINote_head'
import { AINote_foot } from 'ets/views/AINote/AINote_foot'
import { AINote_content } from 'ets/views/AINote/AINote_content'
@Entry
@Component
export struct AINote {
  @State isLoading:boolean = true
  @State Text:string =
    'SpinKit 是一个适用于OpenHarmony/HarmonyOS的加载动画库。\n' +
    '\n' +
    'harmony-utils 一款功能丰富且极易上手的HarmonyOS工具库，借助众多实用工具类，致力于助力开发者迅速构建鸿蒙应用。\n' +
    '\n' +
    'harmony-dialog 一款极为简单易用的零侵入弹窗，仅需一行代码即可轻松实现，无论在何处都能够轻松弹出。'
  @State TargetAI_topic:string = 'TOPIC'


  build() {
    Column(){
      AINote_head()
      AINote_content({
        Text:$Text,
        TargetAI_topic:$TargetAI_topic,
        isLoading:$isLoading
      })
      AINote_foot()
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#353242')
  }
}
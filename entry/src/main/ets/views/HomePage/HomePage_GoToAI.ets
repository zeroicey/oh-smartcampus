import { router } from "@kit.ArkUI"

@Component
export struct HomePage_GoToAI{
  build() {
    Column(){
      Image($rawfile('icon/GOtoAIchat.png'))
        .width('100%')
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/AI_chat',
            params: {
              topic: 'AI_chat'
            }
          })
        })
    }
    .width('100%')
  }
}
import { CommentReply } from '../../commons/components'

@Component
export struct SNList {
  build() {
    List({ space: 20 }) {
      ForEach(Array.from({ length: 5 }), () => {
        ListItem() {
          CommentReply()
        }
      })
    }
  }
}
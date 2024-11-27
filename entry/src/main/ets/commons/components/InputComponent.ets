import { Type } from '../../models'

@Component
export struct InputComponent {
  @Prop title: string
  @Prop type: Type = Type.name
  @Prop placeholder: string

  build() {
    Column({ space: 15 }) {
      Text() {
        Span(this.title)
          .fontColor(Color.White)
          .fontWeight(600)
        Span('*')
          .fontColor('rgb(242, 111, 56)')
      }
      .width('100%')

      TextInput({ placeholder: this.placeholder })
        .placeholderColor('rgb(229, 228, 249)')
        .placeholderFont({ weight: 700 })
        .width('100%')
        .backgroundColor('rgb(115, 111, 138)')
        .padding({ left: 24 })
        .type(this.type == Type.password ? InputType.Password : InputType.Normal)
        .passwordIcon(this.type == Type.password ?
          { onIconSrc: $rawfile('icon/openEyeIcon.png'), offIconSrc: $rawfile('icon/closeEyeIcon.png') } : null)

    }
  }
}


@CustomDialog
export struct pickProvinceDialog {
  controller:CustomDialogController
  @Link selectedItem:string
  @State selectedIndex:number = -1
  @State provinceList:Array<string> = ['北京市', '天津市', '河北省', '山西省', '内蒙古自治区', '辽宁省', '吉林省', '黑龙江省', '上海市', '江苏省', '浙江省', '安徽省', '福建省', '江西省', '山东省', '河南省', '湖北省', '湖南省', '广东省', '广西壮族自治区', '海南省', '重庆市', '四川省', '贵州省', '云南省', '西藏自治区', '陕西省', '甘肃省', '青海省', '宁夏回族自治区', '新疆维吾尔自治区', '香港特别行政区', '澳门特别行政区', '台湾省']
  build() {
    Column(){
      Text('选择省份')
        .fontColor(Color.White)
        .fontSize(40)
        .fontWeight(FontWeight.Bolder)
        .textAlign(TextAlign.Center)
        .width('100%')
        .height('20%')
      Column(){
        Scroll() {
          Column() {
            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.provinceList, (item: string, index: number) => {
                Text(item)
                  .height(40)
                  .constraintSize({ minWidth: 75 })
                  .borderRadius(20)
                  .fontWeight(FontWeight.Bolder)
                  .fontColor(this.selectedIndex == index ? Color.White : Color.Black)
                  .backgroundColor(this.selectedIndex == index ? Color.Pink : Color.White)
                  .textAlign(TextAlign.Center)
                  .margin({ right: 14, bottom: 15 })
                  .padding({ left: 10, right: 10 })
                  .onClick(() => {
                    this.selectedItem=item
                    this.selectedIndex=index
                  })
              })
            }
            .margin({ bottom: 64 })

          }
          .width('90%')
          .padding({ bottom: 40 })
          .borderColor(Color.Blue)

        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .align(Alignment.Top)
      }
      .height('60%')
      Row(){
        Button('确定')
          .width('40%')
          .height('60%')
          .backgroundColor('#8d87f2')
          .fontColor(Color.White)
          .fontSize(30)
          .fontWeight(FontWeight.Bolder)
          .onClick(()=>{
            this.controller.close()
          })
      }
      .height('20%')
    }
    .height('70%')
    .width('100%')
    .backgroundColor('#353341')
  }
}
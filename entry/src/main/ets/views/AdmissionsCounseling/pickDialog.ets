import { SearchSchoolData } from "../../models/tempModel/Interface/SchoolSearch"


@CustomDialog
export struct pickDialog {
  controller:CustomDialogController
  @Link submitItem:SearchSchoolData
  //效果变化参数
  @State selectedItem:string = ''
  @State selectedString:string = ''
  @State selectedItemIndex:number = -1
  @State selectedStringIndex:number = -1
  @State selectedStringName:string = '省份'
  @State List:string[][] = [
    ['北京市', '天津市', '河北省', '山西省', '内蒙古自治区', '辽宁省', '吉林省', '黑龙江省', '上海市', '江苏省', '浙江省', '安徽省', '福建省', '江西省', '山东省', '河南省', '湖北省', '湖南省', '广东省', '广西壮族自治区', '海南省', '重庆市', '四川省', '贵州省', '云南省', '西藏自治区', '陕西省', '甘肃省', '青海省', '宁夏回族自治区', '新疆维吾尔自治区', '香港特别行政区', '澳门特别行政区', '台湾省'],
    [],
    [],
    []
  ]
  @State selectList:Array<string> = []

  @Builder mybutton1(item:string,index:number){
    Text(item)
      .height(40)
      .constraintSize({ minWidth: 75 })
      .borderRadius(20)
      .fontWeight(FontWeight.Bolder)
      .textAlign(TextAlign.Center)
      .fontColor(this.selectedItemIndex == index ? Color.White : Color.Black)
      .backgroundColor(this.selectedItemIndex == index ? Color.Pink : Color.White)
      .onClick(() => {
        this.selectedItem=item
        this.selectedItemIndex=index
      })
  }
  @Builder mybutton2(item:string,index:number){
    Text('  '+item+'  ')
      .height(40)
      .constraintSize({ minWidth: 75 })
      .borderRadius(20)
      .fontWeight(FontWeight.Bolder)
      .textAlign(TextAlign.Center)
      .fontColor(Color.White)
      .backgroundColor(this.selectedStringIndex == index ? '#817afc' : Color.Black)
      .onClick(() => {
        this.selectedString=item
        this.selectedStringIndex=index
        this.selectedStringName = item
        console.log('GOT_selectedStringIndex:'+this.selectedStringIndex.toString());
      })
  }
  build() {
    Column({space:20}){
      Row(){
        Text('具体查询')
          .fontColor(Color.White)
          .fontSize(30)
          .fontWeight(FontWeight.Bolder)
          .textAlign(TextAlign.Start)
          .width('85%')
          .padding(15)
        Image($rawfile('icon/search.png'))
          .height(30)
          .align(Alignment.End)
      }
      .width('90%')
      Row({space:10}){
        this.mybutton2('省份',0)
        this.mybutton2('专业类',1)
        this.mybutton2('专业名称',2)
        this.mybutton2('院校级别',3)
      }

      Text('选择'+this.selectedStringName)
        .width('90%')
        .fontColor(Color.White)
        .fontSize(25)
        .fontWeight(FontWeight.Bolder)
        .textAlign(TextAlign.Start)

      Column(){
        Scroll() {
          Column() {
            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.List[this.selectedStringIndex], (item: string, index: number) => {
                Row() {
                  this.mybutton1(item, index)
                }
                .margin({ right: 14, bottom: 15 })
                .padding({ left: 10, right: 10 })
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
    }
    .height('80%')
    .width('100%')
    .backgroundColor('#353341')
  }
}
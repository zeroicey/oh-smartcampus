import axios, { AxiosResponse } from '@ohos/axios'
import { ScoreData, SearchSchoolData, SearchSchoolResponse } from '../../models/tempModel/Interface/SchoolSearch'
import { BusinessError } from '@kit.BasicServicesKit'


@CustomDialog
export struct pickDialog {
  controller: CustomDialogController
  @Link submitItem: SearchSchoolData
  @Link responseSchoolData: Array<ScoreData>
  @Prop token: string = ''
  @Link flag: number
  //效果变化参数
  @State selectedItem: string = '' //fst
  @State selectedItemIndex: number = 0
  @State SelectedItemName: string = ''
  @State selectedString: string = '' //zyl
  @State selectedStringIndex: number = -1
  @State selectedStringName: string = ''
  @State selectedSpecialized: string = '' //sf
  @State selectedSpecializedIndex: number = -1
  @State selectedSpecializedName: string = ''
  @State selectedSecondIndex: number = -1 //zy
  @State selectedSecond: string = ''
  @State selectedSecondName: string = ''
  @State ListP: string[] =
    ['北京市', '天津市', '河北省', '山西省', '内蒙古自治区', '辽宁省', '吉林省', '黑龙江省', '上海市', '江苏省',
      '浙江省', '安徽省', '福建省', '江西省', '山东省', '河南省', '湖北省', '湖南省', '广东省', '广西壮族自治区',
      '海南省', '重庆市', '四川省', '贵州省', '云南省', '西藏自治区', '陕西省', '甘肃省', '青海省', '宁夏回族自治区',
      '新疆维吾尔自治区', '香港特别行政区', '澳门特别行政区', '台湾省']
  @State ListS: string[] = ['(0812)计算机科学与技术' , '(0835)软件工程' ,'(0854)电子信息']
  @State specializedList: string[][] = [
    ['(081200)计算机科学与技术' , '(081201)计算机软件与理论' , '(081202)计算机系统结构' , '(081203)计算机应用技术'],
    ['(083500)软件工程'],
    ['(085400)电子信息' , '(085404)计算机技术' , '(085405)软件工程' , '(085410)人工智能' , '(085411)大数据技术与工程' , '(085412)网络信息安全']
  ]
  @State gotData: string[] = []
  @State selectList: Array<string> = []

  @Builder
  mybutton2(item: string, index: number) {
    Text('  ' + item + '  ')
      .height(40)
      .constraintSize({ minWidth: 75 })
      .borderRadius(20)
      .fontWeight(FontWeight.Bolder)
      .textAlign(TextAlign.Center)
      .fontColor(Color.White)
      .backgroundColor(this.selectedItemIndex == index ? '#817afc' : Color.Black)
      .onClick(() => {
        this.selectedItem = item
        this.selectedItemIndex = index
        this.SelectedItemName = item
        console.log('GOT_selectedStringIndex:' + this.selectedItemIndex.toString());
      })
  }

  @Builder
  mybutton1(item: string, index: number) { //zyl
    Text('  ' + item + '  ')
      .height(40)
      .constraintSize({ minWidth: 75 })
      .borderRadius(20)
      .fontWeight(FontWeight.Bolder)
      .textAlign(TextAlign.Center)
      .fontColor(this.selectedStringIndex == index ? Color.White : Color.Black)
      .backgroundColor(this.selectedStringIndex == index ? Color.Pink : Color.White)
      .onClick(() => {
        this.selectedString = item
        this.selectedStringIndex = index
        this.submitItem.secondaryMajor = item //zyl
      })
  }

  @Builder
  mybutton3(item: string, index: number) { //sf
    Text('  ' + item + '  ')
      .height(40)
      .constraintSize({ minWidth: 75 })
      .borderRadius(20)
      .fontWeight(FontWeight.Bolder)
      .textAlign(TextAlign.Center)
      .fontColor(this.selectedSpecializedIndex == index ? Color.White : Color.Black)
      .backgroundColor(this.selectedSpecializedIndex == index ? Color.Pink : Color.White)
      .onClick(() => {
        this.selectedSpecialized = item
        this.selectedSpecializedIndex = index
        this.submitItem.region = item //sf
        console.log('GOT_selectedStringIndex:' + this.selectedStringIndex.toString());
      })
  }

  @Builder
  mybutton4(item: string, index: number) { //zy
    Text('  ' + item + '  ')
      .height(40)
      .constraintSize({ minWidth: 75 })
      .borderRadius(20)
      .fontWeight(FontWeight.Bolder)
      .textAlign(TextAlign.Center)
      .fontColor(this.selectedSecondIndex == index ? Color.White : Color.Black)
      .backgroundColor(this.selectedSecondIndex == index ? Color.Pink : Color.White)
      .onClick(() => {
        this.selectedSecond = item
        this.selectedSecondIndex = index
        this.submitItem.tertiaryMajor = item //zy
        console.log('GOT_selectedStringIndex:' + this.selectedStringIndex.toString());
      })
  }

  build() {
    Column({ space: 20 }) {
      Row() {
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
          .onClick(() => {
            this.httpSearchBackByRegion_axios(1, 10, this.token)
            this.controller.close()
          })
      }
      .width('90%')

      Row({ space: 10 }) {
        this.mybutton2('省份', 0)
        this.mybutton2('专业类', 1)
      }

      Text('选择' + this.selectedItem)
        .width('90%')
        .fontColor(Color.White)
        .fontSize(25)
        .fontWeight(FontWeight.Bolder)
        .textAlign(TextAlign.Start)

      Column() {
        Scroll() {
          Column() {
            if (this.selectedItemIndex == 0) {
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.ListP, (item: string, index: number) => {
                  Row() {
                    this.mybutton3(item, index)
                  }
                  .margin({ right: 14, bottom: 15 })
                  .padding({ left: 10, right: 10 })
                })
              }
              .margin({ bottom: 64 })
            } else {
              Column({ space: 5 }) {
                Row() {
                  this.mybutton1('(0812)计算机科学与技术', 0)
                }
                .onClick(() => {
                  this.selectedString = '(0812)计算机科学与技术'
                  this.selectedStringIndex = 0
                  this.submitItem.secondaryMajor = '(0812)计算机科学与技术' //zyl
                })

                Row() {
                  this.mybutton1('(0835)软件工程', 1)
                }
                .onClick(() => {
                  this.selectedString = '(0835)软件工程'
                  this.selectedStringIndex = 1
                  this.submitItem.secondaryMajor = '(0835)软件工程' //zyl
                })

                Row() {
                  this.mybutton1('(0854)电子信息', 2)
                }
                .onClick(() => {
                  this.selectedString = '(0854)电子信息'
                  this.selectedStringIndex = 2
                  this.submitItem.secondaryMajor = '(0854)电子信息' //zyl
                })
              }

              Blank().height(15)
              Text('选择' + this.selectedString)
                .width('90%')
                .fontColor(Color.White)
                .fontSize(25)
                .fontWeight(FontWeight.Bolder)
                .textAlign(TextAlign.Start)
              Blank().height(15)
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.specializedList[this.selectedStringIndex], (item: string, index: number) => {
                  Row() {
                    this.mybutton4(item, index)
                  }
                  .margin({ right: 14, bottom: 15 })
                  .padding({ left: 10, right: 10 })
                })
              }
              .margin({ bottom: 64 })
            }
          }
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
    .backgroundColor('#313035')
  }

  httpSearchBackByRegion_axios(page: number, size: number, token: string) {
    this.submitItem.page = page
    this.submitItem.size = size
    axios({
      method: 'POST',
      url: 'http://hellooracle.free.idcfengye.com' + '/university/findRangeSearch',
      data: this.submitItem,
      headers: {
        "Authorization": "Bearer " + token
      }
    }).then((response: AxiosResponse<SearchSchoolResponse>) => {
      console.log('GOT_myDATA:------>' + JSON.stringify(this.submitItem))
      this.responseSchoolData = response.data.data
      console.log('GOT_responseSchoolData:' + JSON.stringify(response.data.data))
    }).catch((error: BusinessError) => {
        console.log('Got_ERR:' + error.message)
      })
  }
}
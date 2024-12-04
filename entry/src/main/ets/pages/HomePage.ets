import { it } from "@ohos/hypium";
import { router } from "@kit.ArkUI";
import { HomePage_head } from "../views/HomePage/HomePage_head";
import { HomePage_sign } from "../views/HomePage/HomePage_sign";
import { HomePage_hotCircle } from "../views/HomePage/HomePage_hotCircle";
import { HomePage_InfFastLook } from "../views/HomePage/HomePage_InfFastLook";
import { HomePage_sidebar } from "../views/HomePage/HomePage_sideBar";


export class week{
  day:number
  isToday:boolean
  isSignned:boolean
  color:string
  constructor(day:number,isToday:boolean,isSignned:boolean,color:string) {
    this.day = day;
    this.isToday = isToday;
    this.isSignned = isSignned;
    this.color = color;
  }
}


@Entry//debug//记得修改main_Pages.json5
@Component
export struct HomePage {
  @State isShowSideBar: boolean = false
  @State sideBarWidth:number = 0
  @State opcityAll:number = 1
  @State userName: string = 'Mr.Ass'
  @State userText: string = 'My name is Mr.Ass'
  @State week:Array<week> = [
    new week(1,false,false,''),
    new week(2,false,true,''),
    new week(3,false,false,''),
    new week(4,false,false,''),
    new week(5,true,false,''),
    new week(6,false,false,''),
    new week(7,false,false,''),
  ]//Mock
  @State circle:Array<number>=[1,2,3,4]//debug
  //@State dayBKcolor:Array<string> = ['#8d87f2','#cac7ff','#ffffff']

  aboutToAppear(): void {
    colorDraw(this.week)
  }

  build() {
    Stack() {
      //stack1
      Scroll() {
        Column() {
          Column({ space: 20 }) {
            Blank().height(0)

            HomePage_head({
              isShowSideBar:$isShowSideBar,
              sideBarWidth:$sideBarWidth,
              userName:$userName,
              userText:$userText,
              opcityAll:$opcityAll
            })

            HomePage_sign({
              week:$week
            })


            HomePage_hotCircle({
              circle:$circle
            })

            HomePage_InfFastLook({
              circle:$circle
            })

          }
          .width('90%')
        }
        .backgroundColor('#353242')
        .width('100%')
      }
      .height('100%')
      .opacity(this.opcityAll)

      //stack2
        HomePage_sidebar({
          isShowSideBar:$isShowSideBar,
          sideBarWidth:$sideBarWidth,
          userName:$userName,
          opcityAll:$opcityAll,
        })
      }
    }
  // }
}

function colorDraw(arr:Array<week>){
  for(let i=0;i<7;i++){
    if(arr[i].isToday){
      arr[i].color = '#8d87f2'
    }else if(arr[i].isSignned){
      arr[i].color = '#cac7ff'
    }else{
      arr[i].color = '#ffffff'
    }
  }
}
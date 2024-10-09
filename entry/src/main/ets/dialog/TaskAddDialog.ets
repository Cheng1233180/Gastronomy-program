import RecordItemModel from '../model/RecordItemModel'
import KeepService from '../service/KeepService'
import DateUtil from '../utils/DateUtil'
import Logger from '../utils/Logger'
import RecordItem from '../viewmodel/RecordItem'
import router from '@ohos.router'

@Extend(GridItem) function btnStyle() {
  .backgroundColor(Color.White)
  .opacity(0.7)
  .height(50)
  .borderRadius(15)
}

@Preview
@CustomDialog
export default struct TaskAddDialog {
  @StorageProp('date') date: number = DateUtil.beginTimeOfDay(new Date())
  @Prop itemId: number
  @State recordItem: RecordItem = RecordItemModel.getById(this.itemId)
  @State show: boolean = true
  numberArr: string[] = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '.']
  controller: CustomDialogController
  @State value: string = ''
  @State num: number = 0

  onConfirm() {
    Logger.debug('运动ID' + this.itemId)
    //将记录想添加到数据库并返回到主页面
    KeepService.insert(this.itemId, this.num)
      .then(() => {
        router.replaceUrl({url: 'pages/MainIndex'})
      })
  }

  @Builder
  saveBtn(text: string, color: ResourceStr, onClick: () => void) {
    Button() {
      Text(text)
        .fontSize(20)
        .fontWeight(800)
        .opacity(0.9)
    }
    .width(80)
    .height(50)
    .type(ButtonType.Normal)
    .backgroundColor(color)
    .borderRadius(5)
    .padding({ left: 3, right: 3 })
    .onClick(onClick)
  }

  clickNumber(num: string) {
    let val = this.value + num

    let firstIndex = val.indexOf('.')
    let lastIndex = val.lastIndexOf('.')
    if(firstIndex !== lastIndex || (lastIndex != -1 && lastIndex < val.length - 2)) {
      return
    }
    let amount = this.parseFloat(val)

    if(amount >= 999.9) {
      this.num = 999.0
      this.value = '999'
    } else {
      this.num = amount
      this.value = val
    }
  }

  clickDel() {
    if(this.value.length <= 0) {
      this.value = ''
      this.num = 0
      return
    }
    this.value = this.value.substring(0, this.value.length - 1)
    this.num = this.parseFloat(this.value)
  }

  parseFloat(str: string) {
    if(!str) {
      return 0
    }
    if(str.endsWith('.')) {
      str = str.substring(0, str.length - 1)
    }
    return parseFloat(str)
  }

  build() {
    Column() {
      Row() {
        Text(DateUtil.formatDate(this.date))
          .fontSize(15)
          .fontWeight(600)
        Blank(10)
        Button() {
          Text('x')
            .fontSize(15)
            .fontColor(Color.White)
            .fontWeight(800)
        }
        .width(20)
        .height(20)
        .backgroundColor(Color.Red)
        .padding({ bottom: 5 })
        .onClick(() => {
          this.controller.close()
        })
      }
      .width('95%')
      .justifyContent(FlexAlign.End)

      Column({ space: 10 }) {
        Image(this.recordItem.image)
          .width(90)
          .height(90)
        Text(this.recordItem.name)
          .fontSize(20)
          .fontWeight(700)
          .backgroundColor($r('app.color.light_gray'))
        Row() {
          TextInput({text: this.num.toFixed(1)})
            .width('35%')
            .fontSize(35)
            .fontColor($r('app.color.task_color'))
            .caretColor(Color.Transparent)
            .textAlign(TextAlign.Center)
            .copyOption(CopyOptions.None)
          Text(this.recordItem.unit)
            .fontSize(35)
            .opacity(0.7)
            .fontWeight(800)
        }

        Panel(this.show) {
          Column() {
            Grid() {
              ForEach(this.numberArr, (item) => {
                GridItem() {
                  Text(item)
                    .fontSize(20)
                    .fontWeight(500)
                }
                .btnStyle()
                .onClick(() => {
                  this.clickNumber(item)
                })
              })
              GridItem() {
                Text('删除')
                  .fontSize(20)
                  .fontWeight(500)
              }
              .btnStyle()
              .onClick(() => {
                this.clickDel()
              })

              GridItem() {
                this.saveBtn('确定', $r('app.color.btn_color'), () => this.show = false)
              }
              .columnStart(1)
              .columnEnd(3)
              .btnStyle()
            }
            .columnsTemplate('1fr 1fr 1fr')
            .columnsGap(5)
            .rowsGap(8)
            .width('95%')
            .padding({ top: 15 })
          }
        }
        .mode(PanelMode.Half)
        .halfHeight(1050)
        .type(PanelType.Temporary)
        .dragBar(false)
        .width('100%')
        Row() {
          Text('预计消耗' + this.recordItem.calorie * this.num + '卡路里')
            .fontSize(20)
            .fontWeight(700)
            .opacity(0.7)
        }
        Row({space: 20}) {
          this.saveBtn('修改', $r('app.color.light_gray'), () => this.show = true)
          this.saveBtn('确定', $r('app.color.btn_color'), () => this.onConfirm())
        }
      }
    }
    .width('95%')
    .height('95%')
    .alignItems(HorizontalAlign.Center)
  }
}
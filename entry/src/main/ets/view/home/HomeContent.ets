import DateDialog from '../../dialog/DateDialog'
import DateUtil from '../../utils/DateUtil'
import AddBtn from './AddBtn'
import router from '@ohos.router'
import Logger from '../../utils/Logger'
import RecordItem from '../../viewmodel/RecordItem'
import RecordVO from '../../viewmodel/RecordVO'
import RecordPO from '../../common/table/RecordPO'
import KeepInfo from '../../viewmodel/KeepInfo'
import KeepService from '../../service/KeepService'

@Preview
@Component
export default struct HomeContent {

  @StorageProp('date')
  @Watch('aboutToAppear')
  date: number = DateUtil.beginTimeOfDay(new Date())

  @State
  @Watch('onRecordsChange')
  records: RecordVO[] = []

  @State
  recordPOs: RecordPO[] = []

  @State keepInfo: KeepInfo = new KeepInfo()

  async aboutToAppear() {
    this.records = await KeepService.selectRecordByDate(this.date)
    Logger.debug('records长度：' + this.records.length)
  }

  onRecordsChange() {
    this.keepInfo = KeepService.calculateKeepInfo(this.records)
  }

  clickDelBtn(id: number) {
    KeepService.deleteById(id)
    this.aboutToAppear()
  }

  @Builder DelBtn(id: number) {
    Button() {
      Image($r('app.media.delete'))
        .width(20)
        .fillColor(Color.Red)
    }
    .width(30)
    .height(30)
    .backgroundColor(Color.White)
    .stateEffect(false)
    .onClick(() => {
      this.clickDelBtn(id)
    })
  }

  addTask() {
    router.pushUrl({url: "pages/AddTaskPage"})
    Logger.debug('跳转到添加任务页面')
  }

  controller: CustomDialogController = new CustomDialogController({
    builder: DateDialog({ date: new Date(this.date)})
  })

  build() {
    Column() {
      Column() {
        Text('百战健身')
          .fontSize(25)
          .fontWeight(600)
          .margin({ top: 10, bottom: 100, left: 20})
        Row() {
          Text(DateUtil.formatDate(this.date))
            .fontSize(15)
            .fontWeight(500)
          Image($r('app.media.arrow_down'))
            .width(20)
        }
        .width('90%')
        .height(50)
        .backgroundColor(Color.White)
        .margin({ left: 19, top: 90})
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.controller.open()
        })
      }
      .backgroundImage($r('app.media.home_bg'))
      .backgroundImageSize({ width: '100%', height: '100%'})
      .width('100%')
      .height('40%')
      .alignItems(HorizontalAlign.Start)
      .borderRadius({ bottomLeft: 20, bottomRight: 20})

      Stack() {
        Column() {
          Text('任务列表')
            .fontSize(13)
            .fontWeight(700)
            .margin({ left: 20, top: 20, bottom: 10})
          if(this.records.length !== 0) {
            Column() {
              List({space: 10}) {
                ForEach(this.records, (item) => {
                  ListItem() {
                    Row() {
                      Row() {
                        Image(item.recordItem.image)
                          .width(50)
                          .height(50)
                        Text(item.recordItem.name)
                          .fontSize(13)
                          .fontWeight(600)
                          .opacity(0.8)
                      }
                      .onClick(() => {
                        if(item.successAmount <= item.amount - item.amount % 1 - 1) {
                          item.successAmount += 1
                          KeepService.update(item)
                          this.aboutToAppear()
                          Logger.debug('完成个数+1')
                        } else if(item.successAmount > item.amount - item.amount % 1 - 1) {
                          item.successAmount = item.amount
                          KeepService.update(item)
                          this.aboutToAppear()
                          Logger.debug('该任务已完成')
                        }
                      })
                      Blank()
                      if(item.amount === item.successAmount) {
                        Text('消耗' + item.calorie + '卡路里')
                          .fontSize(13)
                          .fontWeight(600)
                          .margin({ right: 10})
                          .fontColor($r('app.color.task_color'))
                      } else {
                        Text(item.successAmount + ':' + item.amount + item.recordItem.unit)
                          .fontSize(13)
                          .fontWeight(600)
                          .margin({right: 10})
                      }
                    }
                    .width('100%')
                    .backgroundColor(Color.White)
                    .borderRadius(15)
                  }
                  .width('90%')
                  .swipeAction({end: this.DelBtn(item.id)})
                })
              }
              .width('100%')
              .alignListItem(ListItemAlign.Center)
            }
            .width('100%')
          } else {
            Column({space: 8}) {
              Image($r('app.media.ic_no_data'))
                .width(350)
                .height(220)
              Text('暂无任务，请添加任务')
                .fontSize(20)
                .opacity(0.4)
            }
            .margin({ top: 68, left: 25})
          }
        }
        .width('100%')
        .height('100%')
        .alignItems(HorizontalAlign.Start)

        AddBtn({ clickAction: () => this.addTask()})
      }
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('app.color.light_gray'))
  }
}
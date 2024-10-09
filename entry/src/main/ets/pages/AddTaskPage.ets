import router from '@ohos.router'
import TaskAddDialog from '../dialog/TaskAddDialog'
import RecordItemModel from '../model/RecordItemModel'
import RecordItem from '../viewmodel/RecordItem'
@Entry
@Component
struct AddTaskPage {

  @State itemId: number = 0

  clickAddBtn(id: number) {
    this.itemId = id
    this.controller.open()
  }

  controller: CustomDialogController = new CustomDialogController({
    builder: TaskAddDialog({itemId: this.itemId})
  })

  @State arr: RecordItem[] = RecordItemModel.list()



  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(25)
      }
      .margin({ top: 10, left: 10, bottom: 10})
      .onClick(() => {
        router.back()
      })
      List({ space: 10}) {
        ForEach(this.arr, (item) => {
          ListItem() {
            Row() {
              Image(item.image)
                .width(60)
                .height(60)
                .margin({ right: 15})
              Column() {
                Text(item.name)
                  .fontSize(15)
                  .fontWeight(500)
                Text(item.calorie + '卡路里' + item.unit)
                  .fontSize(10)
                  .fontWeight(600)
                  .opacity(0.7)
              }
              .alignItems(HorizontalAlign.Start)
              Blank()
              Button() {
                Image($r('app.media.add_norm_filled'))
                  .width(20)
              }
              .backgroundColor(Color.Transparent)
              .onClick(() => this.clickAddBtn(item.id))
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('95%')
          .backgroundColor(Color.White)
          .padding(5)
        })
      }
      .width('100%')
      .alignListItem(ListItemAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.light_gray'))
    .alignItems(HorizontalAlign.Start)
  }
}
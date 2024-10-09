import DateDialog from '../../dialog/DateDialog'
import DateUtil from '../../utils/DateUtil'

@Extend(Text)
function textStyle(color: ResourceStr | Color, fw: number | FontWeight) {
  .fontSize(20)
  .fontWeight(fw)
  .fontColor(color)
}

@Preview
@Component
export default struct AchievementTop {
  @Link calorie: number;
  @Link consume: number;
  @StorageProp('date') date: number = DateUtil.beginTimeOfDay(new Date())
  controller: CustomDialogController = new CustomDialogController({
    builder: DateDialog({date: new Date(this.date)})
  })
  build() {
    Column() {
      Column({ space: 5}) {
        Text(DateUtil.formatDate(this.date))
          .fontSize(15)
          .fontColor($r('app.color.dark_gray'))
          .onClick(() => {
            this.controller.open()
          })
        Text('健身记录')
          .textStyle(Color.White, 800)
      }
      .width('95%')
      .margin({top: 30, bottom: 10})
      .alignItems(HorizontalAlign.Start)
      Row() {
        Column({space: 5}) {
          Text('运动消耗')
            .textStyle(Color.White, 500)
          Text(this.consume + '/' + this.calorie + '千卡')
            .textStyle($r('app.color.theme_color'), 800)
            .margin({right: 20, bottom: 30})
          Text('距离目标')
            .textStyle(Color.White, 500)
          Text((this.calorie - this.consume) + '千卡')
            .textStyle($r('app.color.progress_sel'), 800)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({left: 5})
        Progress({
          value: this.consume,
          total: this.calorie,
          type: ProgressType.Ring
        })
          .color($r('app.color.progress_sel'))
          .backgroundColor($r('app.color.progress_normal'))
          .width('50%')
          .height('95%')
          .style({strokeWidth: 25})
      }
      .backgroundColor($r('app.color.dark_gray'))
      .width('95%')
      .height(190)
      .borderRadius(15)
    }
    .width('100%')
    .height('100%')
  }
}
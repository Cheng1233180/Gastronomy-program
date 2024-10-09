@Component
export default struct MineContent {
  @Builder
  item(msg: string) {
    Row() {
      Text(msg)
        .fontSize(20)
        .fontWeight(500)
      Image($r('app.media.ic_right_grey'))
        .objectFit(ImageFit.Contain)
        .height(12)
        .width(7)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({top: 15, bottom: 15})
  }
  build() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.icon_user'))
            .height(66)
            .width(66)
            .objectFit(ImageFit.Contain)
            .margin({top: 71})
          Text('小王')
            .fontSize(20)
            .margin({bottom: 6})
        }
        .width('100%')
      }
      .width('100%')
      .height('25%')
      .backgroundColor($r('app.color.light_gray'))
      Column() {
        this.item('个人资料')
        Divider()
        this.item('检测更新')
        Divider()
        this.item('关于')
        Divider()
      }
      .width('90%')
    }
    .width('100%')
    .height('100%')
  }
}
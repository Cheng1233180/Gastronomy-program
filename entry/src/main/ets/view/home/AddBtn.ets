@Component
export default struct AddBtn {
  clickAction: Function = () => {}
  build() {
    Button({type: ButtonType.Circle, stateEffect: false}) {
      Image($r('app.media.ic_home_add'))
        .borderRadius('50%')
        .width('100%')
        .height('100%')
    }
    .zIndex(2)
    .position({ x: '78%', y: '48%'})
    .width(48)
    .height(48)
    .onClick(() => this.clickAction())
  }
}
import UserPrivacyDialog from '../dialog/UserPrivacyDialog'
import common from '@ohos.app.ability.common'
import data_preferences from '@ohos.data.preferences'
import Logger from '../utils/Logger'
import router from '@ohos.router'


//定义常量存储首选项中的键
const H_STORE: string = 'BaiZhanKeepStore'
const IS_PRIVACY: string = 'isPrivacy'

@Entry
@Component
struct SplashIndex {
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: UserPrivacyDialog({
      cancel: () => {this.exitApp()},
      confirm: () => {this.onConfirm()}
    })
  })

  onConfirm() {
    //定义首选项
    let preferences = data_preferences.getPreferences(this.context, H_STORE)
    //异步处理首选项中的数据
    preferences.then((res) => {
      //记录用户数据到首选项
      res.put(IS_PRIVACY, true).then(() => {
        res.flush();
        //记录日志
        Logger.debug('SplashIndex', 'isPrivacy记录成功')
        this.jumpToMain()
      }).catch((err: Error) => {
        Logger.error('SplashIndex', 'isPrivacy记录失败，原因：' + err)
      })
    })
  }

  exitApp() {
    this.context.terminateSelf()
  }

  aboutToAppear() {
    let preferences = data_preferences.getPreferences(this.context, H_STORE)
    preferences.then((res) => {
      res.get(IS_PRIVACY, false).then((isPrivate) => {
        //判断传入参数值
        if(isPrivate === true) {
          //说明用户已经点击过同意
          this.jumpToMain()
        } else {
          //弹出弹窗
          this.dialogController.open()
        }
      })
    })
  }

  jumpToMain() {
    setTimeout(() => {
      router.replaceUrl({url: "pages/MainIndex"})
    }, 2000)
  }

  aboutToDisappear() {
    clearTimeout()
  }

  build() {
    Column() {
      Image($r('app.media.logo'))
        .width(100)
        .margin({top: 120})
      Text('欢迎进入百战健身')
        .fontSize(15)
        .fontColor('#182431')
        .fontWeight(700)
        .letterSpacing(0.1)
        .opacity(0.6)
        .margin({top: 20, bottom: 140})
      Image($r('app.media.titlePhoto'))
        .width('80%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.welcomeBg'))
    .backgroundImageSize({width: '100%', height: '100%'})
    .backgroundImagePosition({x: 0, y: 0})
  }
}
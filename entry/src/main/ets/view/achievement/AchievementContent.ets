import KeepService from '../../service/KeepService'
import DateUtil from '../../utils/DateUtil'
import Logger from '../../utils/Logger'
import AchievementInfo from '../../viewmodel/AchievementInfo'
import AchievementMapInfo from '../../viewmodel/AchievementMapInfo'
import KeepInfo from '../../viewmodel/KeepInfo'
import RecordVO from '../../viewmodel/RecordVO'
import AchievementTop from './AchievementTop'
@Component
export default struct AchievementContent {
  achievementMapInfo: AchievementMapInfo = new AchievementMapInfo()

  @StorageProp('date')
  @Watch('aboutToAppear')
  date: number = DateUtil.beginTimeOfDay(new Date())

  @State calorie: number = 0
  @State consume: number = 0

  @Link isRefreshing: boolean

  @State successDays: number = 0
  @State success: Array<AchievementInfo> = [
    {
      days: 3,
      icOn: this.achievementMapInfo.on_3,
      icOff: this.achievementMapInfo.off_3
    },
    {
      days: 7,
      icOn: this.achievementMapInfo.on_7,
      icOff: this.achievementMapInfo.off_7
    },
    {
      days: 30,
      icOn: this.achievementMapInfo.on_30,
      icOff: this.achievementMapInfo.off_30
    },
    {
      days: 50,
      icOn: this.achievementMapInfo.on_50,
      icOff: this.achievementMapInfo.off_50
    },
    {
      days: 73,
      icOn: this.achievementMapInfo.on_73,
      icOff: this.achievementMapInfo.off_73
    },
    {
      days: 99,
      icOn: this.achievementMapInfo.on_99,
      icOff: this.achievementMapInfo.off_99
    },
  ]

  @State
  @Watch('onRecordsChange')
  records: RecordVO[] = []

  @State keepInfo: KeepInfo = new KeepInfo()

  @State allRecords: RecordVO[] = []

  async aboutToAppear() {
    //根据日期查询任务
    this.records = await KeepService.selectRecordByDate(this.date)
    Logger.debug('根据日期查询任务')
    //将RecordVO对象数组转换成KeepInfo对象
    this.keepInfo = KeepService.calculateKeepInfo(this.records)

    this.calorie = this.keepInfo.expend

    this.consume = 0

    this.records.forEach(item => {
      //计算消耗掉多少卡路里
      this.consume += item.calorie / item.amount * item.successAmount
      //如果这个任务已经完成，让KeepInfo的successTask+=1
      if(item.successAmount === item.amount) {
        this.keepInfo.successTask += 1
        //日志
        Logger.debug('完成数 + 1, 当日完成任务个数：' + this.keepInfo.successTask)
      }
    })

    this.allRecords = await KeepService.selectAllRecord()
    Logger.debug('查询所有任务')

    this.successDays = 0
    for (let i = 0; i < this.allRecords.length; i++) {
      //判断：如果记录项下标大于0，且当前记录想日期等于上一条记录日期，不执行任何操作
      if(i > 0 && this.allRecords[i].createTime === this.allRecords[i-1].createTime) {

      } else {
        //根据当前记录项的保存日期查询出当天的所有运动项
        let ro: RecordVO[] = await KeepService.selectRecordByDate(this.allRecords[i].createTime)
        //将ro转换成KeepInfo
        let info = KeepService.calculateKeepInfo(ro)
        //如果当天所有任务都完成，successDays += 1
        if(info.isSuccess === true) {
          this.successDays += 1
        }
      }
    }
    Logger.debug('完成天数：' + this.successDays)
  }

  onRecordsChange() {
    this.keepInfo = KeepService.calculateKeepInfo(this.records)
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing}) {
      Column() {
        Row() {AchievementTop({calorie: $calorie, consume: $consume})}
        .height('40%')
        Column() {
          Row() {
            Text('成就')
              .fontSize(20)
              .fontWeight(500)
              .fontColor(Color.White)
          }
          .width('95%')
          Column({space: 10}) {
            Flex({direction: FlexDirection.Row, wrap: FlexWrap.Wrap}) {
              ForEach(this.success, (item) => {
                Column() {
                  Image(this.successDays >= item.days ? item.icOn : item.icOff)
                    .width('100%')
                    .height(88)
                    .objectFit(ImageFit.Contain)
                  Text($r('app.string.task_achievement_level', item.days))
                    .lineHeight(16)
                    .fontSize(12)
                    .fontColor(Color.White)
                }
                .width('33%')
                .padding({top: 38, bottom: 10})
              })
            }
          }
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .onRefreshing(() => {
      this.aboutToAppear()
      setTimeout(() => {
        this.isRefreshing = false
      }, 500)
    })
  }
}
import RecordItemModel from '../model/RecordItemModel'
import RecordModel from '../model/RecordModel'
import DateUtil from '../utils/DateUtil'
import Logger from '../utils/Logger'
import KeepInfo from '../viewmodel/KeepInfo'
import RecordVO from '../viewmodel/RecordVO'
class KeepService {

  /*
  增
   */
  insert(keepId: number, amount: number) {
    let createTime = (AppStorage.Get('selectedDate') || DateUtil.beginTimeOfDay(new Date())) as number
    return RecordModel.insert({keepId: keepId, amount: amount, createTime: createTime, successAmount: 0})
  }

  /*
  删
   */
  deleteById(id: number) {
    return RecordModel.delete(id)
  }

  /*
  改
   */
  update(record: RecordVO) {
    return RecordModel.update({
      id: record.id, keepId: record.keepId, amount: record.amount,
      successAmount: record.successAmount, createTime: record.createTime
    }, record.id)
  }

  /*
  查所有
   */
  async selectAllRecord(): Promise<RecordVO[]> {
    let rps = await RecordModel.queryAll()

    return rps.map(rp => {
      //将RecordPO对象转换成RecordVO
      let rv = {id: rp.id, keepId: rp.keepId, amount: rp.amount, successAmount: rp.successAmount, createTime: rp.createTime} as RecordVO
      //通过ID查询RecordItem对象
      rv.recordItem = RecordItemModel.getById(rp.keepId)
      //计算卡路里
      rv.calorie = rp.amount * rv.recordItem.calorie

      return rv
    })
  }

  /*
  根据日期查询
   */
  async selectRecordByDate(date: number): Promise<RecordVO[]> {
    let rps = await RecordModel.queryByDate(date)
    return rps.map(rp => {
      let rv = {id: rp.id, keepId: rp.keepId, amount: rp.amount, successAmount: rp.successAmount, createTime: rp.createTime} as RecordVO

      rv.recordItem = RecordItemModel.getById(rp.keepId)

      rv.calorie = rp.amount * rv.recordItem.calorie

      return rv
    })
  }

  calculateKeepInfo(records: RecordVO[]): KeepInfo {
    let info = new KeepInfo()
    //如果RecordVO对象数组为空，不执行操作，直接返回KeepInfo对象
    if(!records || records.length <= 0) {
      return info
    }
    //当日总任务个数
    info.task = records.length

    records.forEach(rv => {
      //如果完成任务个数 = 当日任务个数，表示当天所有任务都已经完成
      if(rv.amount !== 0 && rv.successAmount === rv.amount) {
        info.successTask += 1
      }
      info.expend += rv.calorie
      info.day = rv.createTime
    })
    //如果总任务个数=已完成任务个数，将是否完成当天任务属性赋值为true
    if(info.task === info.successTask && info.task !== 0) {
      info.isSuccess = true
    }

    Logger.debug(info.task + '/' + info.successTask + ',任务时间:' + info.day + ', 总任务/已完成任务')

    return info
  }

}

let keepService = new KeepService();

export default keepService as KeepService;
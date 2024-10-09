import RecordItemModel from '../model/RecordItemModel';
import RecordItem from './RecordItem';
export default class RecordVO {
  //记录ID
  id: number;
  //运动ID
  keepId: number;
  //消耗卡路里
  calorie: number;
  //记录运动信息
  recordItem: RecordItem
  //运动时长或个数
  amount: number = 0;
  //已完成运动时长或个数
  successAmount: number = 0;
  //记录日期
  createTime: number;

  constructor(id: number, keepId: number, calorie: number,
              amount: number, successAmount: number, createTime: number) {
    this.id = id;
    this.keepId = keepId;
    this.calorie = calorie;
    this.amount = amount;
    this.successAmount = successAmount;
    this.createTime = createTime;
    this.recordItem = RecordItemModel.getById(this.keepId)
  }
}
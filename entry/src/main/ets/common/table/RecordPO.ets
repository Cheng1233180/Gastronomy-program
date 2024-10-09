export default class RecordPO {
  //序号
  id?: number;
  //运动项ID
  keepId: number;
  //运动时长或者个数
  amount: number = 0;
  //记录日期
  createTime?: number;
  //完成时长或个数
  successAmount: number = 0;
}
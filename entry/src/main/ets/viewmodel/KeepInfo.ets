export default class KeepInfo {
  //日期
  day: number = 0;
  //当日消耗卡路里
  expend: number = 0;
  //当日任务总数
  task: number = 0;
  //当日完成任务数量
  successTask: number = 0;
  //是否全部完成
  isSuccess: boolean = false;

  constructor(day: number = 0, expend: number = 0, task: number = 0, successTask: number = 0) {
    this.day = day;
    this.expend = expend;
    this.task = task;
    this.successTask = successTask;
    if(this.successTask === this.task && this.task !== 0) {
      this.isSuccess = true
    }
  }
}
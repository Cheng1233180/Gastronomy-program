export default class AchievementInfo {
  days: number;
  icOn: ResourceStr;
  icOff: ResourceStr;

  constructor(days: number, icOn: ResourceStr, icOff: ResourceStr) {
    this.days = days;
    this.icOn = icOn;
    this.icOff = icOff;
  }
}
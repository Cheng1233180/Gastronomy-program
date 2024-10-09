export default class RecordItem {
  //运动Id
  id: number;
  //名称
  name: ResourceStr;
  //图片
  image: ResourceStr;
  //单位
  unit: ResourceStr;
  //消耗能量
  calorie: number;

  constructor(id: number, name: ResourceStr, image: ResourceStr, unit: ResourceStr, calorie: number) {
    this.id = id;
    this.name = name;
    this.image = image;
    this.unit = unit;
    this.calorie = calorie;
  }
}
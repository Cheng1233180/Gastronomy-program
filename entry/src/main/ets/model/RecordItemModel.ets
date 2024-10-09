import RecordItem from '../viewmodel/RecordItem'

const keeps: RecordItem[] = [
  new RecordItem(0, '跳绳', $r('app.media.skip'), '/小时', 600),
  new RecordItem(1, '游泳', $r('app.media.swim'), '/小时', 400),
  new RecordItem(2, '卧推', $r('app.media.push'), '/个', 50),
  new RecordItem(3, '慢跑', $r('app.media.jog'), '/小时', 600),
  new RecordItem(4, '动感单车', $r('app.media.bike'), '/小时', 600),
  new RecordItem(5, '杠铃', $r('app.media.barbell'), '/小时', 100),
  new RecordItem(6, '哑铃', $r('app.media.dumbbell'), '/小时', 800),
]

class ItemModel {
  getById(id: number) {
    return keeps[id]
  }

  list(): RecordItem[] {
    return keeps
  }
}

let itemModel = new ItemModel()

export default itemModel as ItemModel
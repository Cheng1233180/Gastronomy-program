import AchievementContent from '../view/achievement/AchievementContent'
import HomeContent from '../view/home/HomeContent'
import MineContent from '../view/mine/MineContent'
@Entry
@Component
struct MainIndex {
  @State selectIndex: number = 0

  @State isRefreshing: boolean = true

  @Builder TabBarBuilder(index: number, normalIcon: ResourceStr, selIcon: ResourceStr, text: string) {
    Column() {
      Image(this.selectIndex === index ? selIcon : normalIcon)
        .width(20)
      Text(text)
        .fontSize(10)
        .fontColor(this.selectIndex === index ? $r('app.color.tab_bar_sel') : $r('app.color.tab_bar_normal'))
    }
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      index: this.selectIndex
    }) {
      //主页
      TabContent() {
        HomeContent()
      }
        .tabBar(this.TabBarBuilder(
          0,
          $r('app.media.ic_tabs_home_normal'),
          $r('app.media.ic_tabs_home_sel'),
          "主页"
        ))
      //成就页
      TabContent() {
        AchievementContent({isRefreshing: $isRefreshing})
      }
        .tabBar(this.TabBarBuilder(
          1,
          $r('app.media.ic_tabs_achievement_normal'),
          $r('app.media.ic_tabs_achievement_sel'),
          "成就"
        ))
      //个人页
      TabContent() {
        MineContent()
      }
        .tabBar(this.TabBarBuilder(
          2,
          $r('app.media.ic_tabs_mine_normal'),
          $r('app.media.ic_tabs_mine_sel'),
          "个人"
        ))
    }
    .onChange((index: number) => {
      this.selectIndex = index
      if(index === 1) {
        this.isRefreshing = true
      }
    })
  }
}
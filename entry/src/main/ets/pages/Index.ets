import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'HarmonyOS 音视频';

  build() {
    Column() {
      Text(this.message)
        .fontSize(30)

      Tabs( { barPosition:BarPosition.End } ){
        TabContent() {
        
        }
        .tabBar('首页')

        TabContent() {

        }.tabBar('发现')

        TabContent() {

        }.tabBar('创建')

        TabContent() {

        }.tabBar('消息')

        TabContent() {

        }.tabBar('我')
      }
    }
    .height('100%')
    .width('100%')
  }
}
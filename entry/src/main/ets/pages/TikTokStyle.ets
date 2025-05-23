import router from '@ohos.router';
import {Videoaction,Videoitem}from '../Support/VideoSupport'
@Entry
@Component
struct TikTokStyle {
  @State currentTab: string = '推荐'
  @State isPlaying: boolean = true
  @State likeCount: number = 12000
  @State commentCount: number = 2312
  @State showFloatingWindow: boolean = true

  build() {
    Stack() {
      // 视频容器
      Video({
        src: $r('app.media.dancing'),
        currentProgressRate: 1.0,
        controller: new VideoController()
      })
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .autoPlay(true)
        .loop(true)
        .muted(true)

      // 顶部导航
      Row() {
        ForEach(['关注', '推荐', '热门'], (tab: string) => {
          Text(tab)
            .fontSize(18)
            .fontWeight(this.currentTab === tab ? FontWeight.Bold : FontWeight.Normal)
            .opacity(this.currentTab === tab ? 1.0 : 0.7)
            .margin({ left: 20, right: 20 })
            .onClick(() => {
              this.currentTab = tab
            })
        })
      }
      .width('100%')
      .height(56)
      .backgroundColor('rgba(0, 0, 0, 0.5)')
      .position({ x: 0, y: 0 })

      // 侧边操作按钮
      Column() {
        ForEach([
          { icon: '❤️', label: this.likeCount.toString() },
          { icon: '💬', label: this.commentCount.toString() },
          { icon: '⤴️', label: '分享' },
          { icon: '♫', label: '音乐' }
        ], (action:Videoaction) => {
          Column() {
            Text(action.icon)
              .fontSize(24)
              .width(40)
              .height(40)
              .backgroundColor('rgba(255, 255, 255, 0.2)')
              .borderRadius(20)
              .textAlign(TextAlign.Center)
            Text(action.label)
              .fontSize(12)
              .margin({ top: 4 })
          }
          .margin({ bottom: 20 })
        })
      }
      .position({ x: '90%', y: '50%' })
      .translate({ x: -20, y: -100 })

      // 底部视频信息
      Column() {
        Row() {
          Image($r('app.media.profile1'))
            .width(50)
            .height(50)
            .borderRadius(25)
          Text('@舞蹈达人')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
        }
        Text('街舞日常练习，一起感受音乐的魅力 #舞蹈 #街舞 #音乐')
          .fontSize(14)
          .margin({ top: 10 })
        Row() {
          Text('♫')
            .fontSize(16)
            .width(16)
            .height(16)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .borderRadius(8)
            .textAlign(TextAlign.Center)
          Text('街舞音乐合集 - DJ炸场')
            .fontSize(14)
            .margin({ left: 10 })
        }
      }
      .width('70%')
      .position({ x: 16, y: '80%' })

      // 动态字幕
      Text('感受节奏 跟随音乐的韵律')
        .fontSize(18)
        .fontColor(Color.White)
        .textShadow({ radius: 4, color: Color.Black, offsetX: 2, offsetY: 2 })
        .position({ x: 0, y: '70%' })
        .width('100%')
        .textAlign(TextAlign.Center)

      // 底部导航栏
      Row() {
        ForEach([
          { icon: '🏠', label: '首页' },
          { icon: '🔍', label: '发现' },
          { icon: '+', label: '创建' },
          { icon: '💬', label: '消息' },
          { icon: '👤', label: '我' }
        ], (item:Videoitem) => {
          Column() {
            if (item.icon === '+') {
              Text(item.icon)
                .fontSize(24)
                .width(40)
                .height(40)
                .backgroundColor('#FF0050')
                .borderRadius(8)
                .textAlign(TextAlign.Center)
            } else {
              Text(item.icon)
                .fontSize(24)
            }
            Text(item.label)
              .fontSize(12)
              .margin({ top: 4 })
          }
          .margin({ left: 20, right: 20 })
        })
      }
      .width('100%')
      .height(56)
      .backgroundColor('rgba(0, 0, 0, 0.5)')
      .position({ x: 0, y: '100%' })
      .translate({ y: -56 })

      // 悬浮窗
      if (this.showFloatingWindow) {
        Video({
          src: $r('app.media.dancing'),
          currentProgressRate: 1.0,
          controller: new VideoController()
        })
          .width(60)
          .height(60)
          .borderRadius(8)
          .position({ x: '90%', y: '90%' })
          .translate({ x: -80, y: -80 })
          .autoPlay(true)
          .loop(true)
          .muted(true)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}

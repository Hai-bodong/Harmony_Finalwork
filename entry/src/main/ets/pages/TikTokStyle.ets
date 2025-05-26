import router from '@ohos.router';
import hilog from '@ohos.hilog';
import {Videoaction,Videoitem}from '../Support/VideoSupport'

const DOMAIN_TIKTOK_STYLE: number = 0x0001;

// 定义视频数据类型
interface VideoItem {
  id: number;
  url: Resource;
  author: string;
  description: string;
  likes: number;
  comments: number;
  avatar: Resource;
}

@Entry
@Component
struct TikTokStyle {
  @State currentTab: string = '推荐'
  @State isPlaying: boolean = true
  @State isLiked: boolean = false // 是否已点赞
  @State showFloatingWindow: boolean = true
  @State currentBottomTab: number = 2
  @State isShareActive: boolean = false; // 是否激活分享功能
  @State isCollected: boolean = false; // 是否已收藏
  @State currentVideoIndex: number = 0; // 当前播放的视频索引
  @State private startY: number = 0
  @State private currentY: number = 0
  @State private videoSrc: Resource = $r('app.media.dancing')
  // 添加视频列表数据
  private videoList: VideoItem[] = [
    {
      id: 1,
      url: $r('app.media.dancing'),
      author: '原神',
      description: '原神启动 #原神 #二次元',
      likes: 12000,
      comments: 2312,
      avatar: $r('app.media.profile1')
    },
    {
      id: 2,
      url: $r('app.media.video1'),
      author: '世界美景',
      description: '一起感受自然的魅力 #风景 #自然 ',
      likes: 15000,
      comments: 3000,
      avatar: $r('app.media.profile1')
    }
  ]


  // 处理视频切换
  private switchVideo(direction: number) {
    const newIndex = this.currentVideoIndex + direction
    if (newIndex >= 0 && newIndex < this.videoList.length) {
      this.currentVideoIndex = newIndex
      this.videoSrc = this.videoList[this.currentVideoIndex].url
    }
  }

  build() {
    Stack() {
      // 视频容器
      Video({
        src: this.videoList[this.currentVideoIndex].url,
        // src: this.videoSrc,
        currentProgressRate: 1.0,
        controller: new VideoController()
      })
        .width('100%')
        .height('85%')
        .objectFit(ImageFit.Cover)
        .autoPlay(true)
        .loop(true)
        .muted(true)
        .gesture(
          PanGesture()
            .onActionStart((event: GestureEvent) => {
              this.startY = event.offsetY
            })
            .onActionUpdate((event: GestureEvent) => {
              this.currentY = event.offsetY
            })
            .onActionEnd(() => {
              const distance = this.currentY - this.startY
              if (Math.abs(distance) > 50) { // 设置最小滑动距离
                if (distance > 0) {
                  // 向下滑动
                  if (this.currentVideoIndex < this.videoList.length - 1) {
                    this.switchVideo(1)
                  }
                } else {
                  // 向上滑动
                  if (this.currentVideoIndex > 0) {
                    this.switchVideo(-1)
                  }
                }
              }
            })
        )

      // 顶部导航
      Row() {
        ForEach(['关注', '推荐', '热门'], (tab: string) => {
          Text(tab)
            .fontSize(18)
            .fontColor(Color.White)
            .fontWeight(this.currentTab === tab ? FontWeight.Bold : FontWeight.Normal)
            .opacity(this.currentTab === tab ? 1.0 : 0.7)
            .margin({ left: 20, right: 20 })
            .onClick(() => {
              this.currentTab = tab
            })
        })
      }
      .width('100%')
      .height('5%')
      .backgroundColor('rgba(0, 0, 0, 0.5)')
      .position({ x: 0, y: 0 })
      .justifyContent(FlexAlign.Center)

      Column(){
        // 点赞按钮
        Column({ space: 5 }) {
          Image(this.isLiked ? $r('app.media.icon_like1') : $r('app.media.icon_liked1'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .onClick(() => {
              this.isLiked = !this.isLiked;
              if (this.isLiked) {
                this.videoList[this.currentVideoIndex].likes += 1;
              } else {
                this.videoList[this.currentVideoIndex].likes -= 1;
              }
            });

          Text(`${this.videoList[this.currentVideoIndex].likes}`)
            .fontSize(12)
            .fontColor(Color.White);
        }
        .margin({ bottom: 20 })

        // 评论按钮
        Column({ space: 5 }) {
          Image($r('app.media.ic_comment'))
            .width(40)
            .height(40)
            .borderRadius(20)
          Text(`${this.videoList[this.currentVideoIndex].comments}`)
            .fontSize(12)
            .fontColor(Color.White);
        }
        .margin({ bottom: 20 })

        // 收藏按钮
        Column({ space: 5 }) {
          Image(this.isCollected ? $r('app.media.icon_collected') : $r('app.media.icon_collect'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .onClick(() => {
              this.isCollected = !this.isCollected;
              if (this.isCollected) {
                hilog.info(DOMAIN_TIKTOK_STYLE, 'TikTokStyle', 'Video added to favorites');
              } else {
                hilog.info(DOMAIN_TIKTOK_STYLE, 'TikTokStyle', 'Video removed from favorites');
              }
            });

          Text(this.isCollected ? '已收藏' : '收藏')
            .fontSize(12)
            .fontColor(Color.White);
        }
        .margin({ bottom: 20 })

        // 分享按钮
        Column({ space: 5 }) {
          Image(this.isShareActive ? $r('app.media.icon_share') : $r('app.media.icon_shared'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .onClick(() => {
              this.isShareActive = !this.isShareActive;
              hilog.info(DOMAIN_TIKTOK_STYLE, 'TikTokStyle', 'Share button clicked');
              // 可以在此处调用系统分享 API 或跳转至分享页面
            });

          Text('分享')
            .fontSize(12)
            .fontColor(Color.White);
        }
        .margin({ bottom: 20 })
      }
      .margin({ bottom: 20 })
      .position({ x: '90%', y: '50%' })
      .translate({ x: -20, y: -100 })


      // 底部视频信息
      Column() {
        Row() {
          Image(this.videoList[this.currentVideoIndex].avatar)
            .width(50)
            .height(50)
            .borderRadius(25)
          Text('@' + this.videoList[this.currentVideoIndex].author)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 10 })
        }
        Text(this.videoList[this.currentVideoIndex].description)
          .fontSize(14)
          .margin({ top: 10 })
      }
      .width('70%')
      .position({ x: 16, y: '80%' })


      // 底部导航栏
      Row() {
        // 首页
        Column() {
          Image($r('app.media.icon_home'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .margin({ bottom: 4 })
            .colorFilter({
              color: this.currentBottomTab === 0 ? '#F0000' : '#FFFFFF'
            });

          Text('首页')
            .fontSize(12)
            .fontColor(this.currentBottomTab === 0 ? '#F0000' : '#FFFFFF');
        }
        .width('20%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentBottomTab = 0;
          router.pushUrl({ url: 'pages/Index' });
        });

        // 发现
        Column() {
          Image($r('app.media.icon_find'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .margin({ bottom: 4 })
            .colorFilter({
              color: this.currentBottomTab === 1 ? '#FF0050' : '#FFFFFF'
            });

          Text('发现')
            .fontSize(12)
            .fontColor(this.currentBottomTab === 1 ? '#FF0050' : '#FFFFFF');
        }
        .width('20%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentBottomTab = 1;
          router.pushUrl({ url: 'pages/Discover' });
        });

        // 创建
        Column() {
          Image($r('app.media.icon_add'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .margin({ bottom: 4 })
            .colorFilter({
              color: this.currentBottomTab === 2 ? '#FF0050' : '#FFFFFF'
            });

          Text('创建')
            .fontSize(12)
            .fontColor(this.currentBottomTab === 2 ? '#FF0050' : '#FFFFFF');
        }
        .width('20%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentBottomTab = 2;
          router.pushUrl({ url: 'pages/Create' });
        });

        // 消息
        Column() {
          Image($r('app.media.icon_message'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .margin({ bottom: 4 })
            .colorFilter({
              color: this.currentBottomTab === 3 ? '#FF0050' : '#FFFFFF'
            });

          Text('消息')
            .fontSize(12)
            .fontColor(this.currentBottomTab === 3 ? '#FF0050' : '#FFFFFF');
        }
        .width('20%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentBottomTab = 3;
          router.pushUrl({ url: 'pages/Message' });
        });

        // 我
        Column() {
          Image($r('app.media.icon_profile'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .margin({ bottom: 4 })
            .colorFilter({
              color: this.currentBottomTab === 4 ? '#FF0050' : '#FFFFFF'
            });

          Text('我')
            .fontSize(12)
            .fontColor(this.currentBottomTab === 4 ? '#FF0050' : '#FFFFFF');
        }
        .width('20%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentBottomTab = 4;
          router.pushUrl({ url: 'pages/ProfileCenter' });
        });
      }
      .width('100%')
      .height(60)
      .backgroundColor('#1E1E1E')
      .position({ x: 0, y: '100%' })
      .translate({ y: -60 });

      // 悬浮窗
      if (this.showFloatingWindow) {
        Video({
          src: this.videoList[this.currentVideoIndex].url,
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




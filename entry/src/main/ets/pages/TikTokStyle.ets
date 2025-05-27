import router from '@ohos.router';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_TIKTOK_STYLE: number = 0x0001
// 定义视频数据类型
interface VideoItem {
  id: number; // 视频ID
  url: Resource; // 视频源
  author: string; //  作者
  description: string; //  视频描述
  likes: number; //点赞数
  comments: number; // 评论数
  avatar: Resource; //头像
  isLiked: boolean; // 添加点赞状态字段
  isCollected: boolean; // 添加收藏状态字段
  isShared: boolean; // 添加分享状态字段
}


@Entry
@Component
struct TikTokStyle {
  @State currentTab: string = '推荐' // 当前选中的标签
  @State isPlaying: boolean = true // 播放状态
  @State showFloatingWindow: boolean = true // 是否显示悬浮窗
  @State currentBottomTab: number = 2 // 默认为推荐页面
  @State currentVideoIndex: number = 0; // 当前播放的视频索引
  @State private startY: number = 0 // 开始Y坐标
  @State private currentY: number = 0  // 当前Y坐标
  @State showCommentInput: boolean = false // 是否显示评论输入框
  @State commentText: string = '' // 评论内容
  @State charCount: number = 0 // 评论字数统计
  
  
  // 将videoList改为响应式状态
  @State videoList: VideoItem[] = [
    {
      id: 1,
      url: $r('app.media.dancing'),
      author: '原神',
      description: '原神启动 #原神 #二次元',
      likes: 12000,
      comments: 2312,
      avatar: $r('app.media.profile1'),
      isLiked: false,
      isCollected: false,
      isShared: false
    },
    {
      id: 2,
      url: $r('app.media.video1'),
      author: '世界美景',
      description: '一起感受自然的魅力 #风景 #自然 ',
      likes: 15000,
      comments: 3000,
      avatar: $r('app.media.profile1'),
      isLiked: false,
      isCollected: false,
      isShared: false
    }
  ]

  // 更新视频状态的方法
  private updateVideoState(index: number, updates: Partial<VideoItem>) {
    let currentVideo = this.videoList[index];
    this.videoList[index] = {
      id: currentVideo.id,
      url: currentVideo.url,
      author: currentVideo.author,
      description: currentVideo.description,
      likes: updates.likes !== undefined ? updates.likes : currentVideo.likes,
      comments: currentVideo.comments,
      avatar: currentVideo.avatar,
      isLiked: updates.isLiked !== undefined ? updates.isLiked : currentVideo.isLiked,
      isCollected: updates.isCollected !== undefined ? updates.isCollected : currentVideo.isCollected,
      isShared: updates.isShared !== undefined ? updates.isShared : currentVideo.isShared
    };
  }

  // 处理视频切换
  private switchVideo(direction: number) {
    const newIndex = this.currentVideoIndex + direction
    if (newIndex >= 0 && newIndex < this.videoList.length) {
      this.currentVideoIndex = newIndex
    }
  }

  build() {
    Stack() {
      // 视频容器
      Video({
        src: this.videoList[this.currentVideoIndex].url,
        currentProgressRate: 1.0,
        controller: new VideoController()
      })
        .width('100%')
        .height('85%')
        .objectFit(ImageFit.Cover)
        .autoPlay(true)
        .loop(true)
        .muted(true)
        .controls(false) //隐藏进度条
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
          Image(this.videoList[this.currentVideoIndex].isLiked ? $r('app.media.icon_like1') : $r('app.media.icon_liked1'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .onClick(() => {
              const newLiked = !this.videoList[this.currentVideoIndex].isLiked;
              this.updateVideoState(this.currentVideoIndex, {
                isLiked: newLiked,
                likes: this.videoList[this.currentVideoIndex].likes + (newLiked ? 1 : -1)
              });
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
            .onClick(() => {
              this.showCommentInput = true;
            })
          Text(`${this.videoList[this.currentVideoIndex].comments}`)
            .fontSize(12)
            .fontColor(Color.White)
        }
        .margin({ bottom: 20 })

        // 收藏按钮
        Column({ space: 5 }) {
          Image(this.videoList[this.currentVideoIndex].isCollected ? $r('app.media.icon_collected') : $r('app.media.icon_collect'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .onClick(() => {
              const newCollected = !this.videoList[this.currentVideoIndex].isCollected;
              this.updateVideoState(this.currentVideoIndex, {
                isCollected: newCollected
              });
              if (newCollected) {
                hilog.info(DOMAIN_TIKTOK_STYLE, 'TikTokStyle', 'Video added to favorites');
              } else {
                hilog.info(DOMAIN_TIKTOK_STYLE, 'TikTokStyle', 'Video removed from favorites');
              }
            });

          Text(this.videoList[this.currentVideoIndex].isCollected ? '已收藏' : '收藏')
            .fontSize(12)
            .fontColor(Color.White);
        }
        .margin({ bottom: 20 })

        // 分享按钮
        Column({ space: 5 }) {
          Image(this.videoList[this.currentVideoIndex].isShared ? $r('app.media.icon_share') : $r('app.media.icon_shared'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .onClick(() => {
              const newShared = !this.videoList[this.currentVideoIndex].isShared;
              this.updateVideoState(this.currentVideoIndex, {
                isShared: newShared
              });
              hilog.info(DOMAIN_TIKTOK_STYLE, 'TikTokStyle', 'Share button clicked');
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
          .controls(false)
        }

      // 评论输入框
      if (this.showCommentInput) {
        Column() {
          Row() {
            TextInput({ placeholder: '说点什么...', text: this.commentText })
              .width('80%')
              .height(40)
              .backgroundColor('#23777777')
              .borderRadius(20)
              .padding({ left: 15, right: 15 })
              .fontColor(Color.Black)
              .placeholderColor('#999999')
              .onChange((value: string) => {
                this.commentText = value;
                this.charCount = value.length;
              })
            
            Button('发送')
              .width(60)
              .height(40)
              .backgroundColor('#FF0050')
              .borderRadius(20)
              .fontColor(Color.White)
              .onClick(() => {
                if (this.commentText.trim() !== '') {
                  // 清空输入框
                  this.commentText = '';
                  this.charCount = 0;
                  // 隐藏输入框
                  this.showCommentInput = false;
                }
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
          .justifyContent(FlexAlign.SpaceBetween)
          
          Text(`${this.charCount}/100`) //显示当前字符数
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 8, right: 16 })
            .alignSelf(ItemAlign.End)
        }
        .width('100%')
        .height(100)
        .backgroundColor(Color.White)
        .position({ x: 0, y: '100%' })
        .translate({ y: -100 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}
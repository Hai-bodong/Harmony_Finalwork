
import { hilog } from '@kit.PerformanceAnalysisKit';// 导入必要的模块
import { router } from '@kit.ArkUI';
const DOMAIN_AUDIO_PLAYER_PAGE = 0x0003;

@Entry
@Component
struct AudioPlayer {
  //图标激活状态
  @State isCollectActive: boolean = false;
  @State isShareActive: boolean = false;
  @State showLikePlusOne: boolean = false;
  @State plusOneOpacity: number = 0;
  @State plusOneOffsetY: number = 0;
  // 专辑封面旋转角度
  @State albumRotation: number = 0;
  // 控制专辑封面旋转动画的开关
  @State isAlbumRotating: boolean = true;
  // 播放/暂停按钮状态
  @State isPlaying: boolean = false;
  // 爱心图标点赞状态
  @State isLiked: boolean = false;
  // 进度条当前进度 (0-100)
  @State progress: number = 0;
  // 当前播放时间 (秒)
  @State currentTime: number = 0;
  // 总时长 (秒)
  @State totalTime: number = 225; // 示例：3分45秒

  // 定时器ID，用于控制专辑封面旋转和进度条
  private albumRotateTimerId: number = -1;
  private progressTimerId: number = -1;

  aboutToAppear() {
    hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'AudioPlayer.ets aboutToAppear called');
    this.startAlbumRotation();
    this.startProgressBarUpdate();
  }

  aboutToDisappear() {
    hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'AudioPlayer.ets aboutToDisappear called');
    this.stopAlbumRotation();
    this.stopProgressBarUpdate();
  }

  // 启动专辑封面旋转动画
  startAlbumRotation() {
    if (this.albumRotateTimerId === -1) {
      this.albumRotateTimerId = setInterval(() => {
        if (this.isAlbumRotating) {
          this.albumRotation = (this.albumRotation + 1) % 360; // 每次增加1度
        }
      }, 50); // 每50毫秒更新一次，实现平滑旋转
    }
  }

  // 停止专辑封面旋转动画
  stopAlbumRotation() {
    if (this.albumRotateTimerId !== -1) {
      clearInterval(this.albumRotateTimerId);
      this.albumRotateTimerId = -1;
    }
  }

  // 启动进度条更新
  startProgressBarUpdate() {
    if (this.progressTimerId === -1) {
      this.progressTimerId = setInterval(() => {
        if (this.isPlaying) {
          this.currentTime += 1;
          this.progress = (this.currentTime / this.totalTime) * 100;
          if (this.currentTime >= this.totalTime) {
            this.currentTime = 0;
            this.progress = 0;
            this.isPlaying = false; // 播放结束，暂停
            this.stopAlbumRotation(); // 停止旋转
          }
        }
      }, 1000); // 每秒更新一次
    }
  }

  // 停止进度条更新
  stopProgressBarUpdate() {
    if (this.progressTimerId !== -1) {
      clearInterval(this.progressTimerId);
      this.progressTimerId = -1;
    }
  }

  // 格式化时间
  formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) { // 调整Stack的对齐方式，方便后续定位
      // 背景渐变动画
      Column() {
        Blank();
      }
      .width('100%')
      .height('100%')
      .linearGradient({
        angle: 45,
        direction: GradientDirection.Left,
        colors: [[0x8A2387, 0.0], [0xE94057, 0.5], [0xF27121, 1.0]] // 渐变颜色
      })
      .animation({
        duration: 5000, // 15秒动画周期
        iterations: -1, // 无限循环
        curve: Curve.Linear,
        playMode: PlayMode.Alternate // 交替播放
      });

      // 顶部导航栏
      Row() {
        Image($r('app.media.icon_back')) // 返回图标
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          })

        Text('音乐播放')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);

        Blank().width(24).margin({ right: 16 }); // 占位符
      }
      .width('100%')
      .height(56)
      .position({ x: 0, y: 0 })
      .backgroundColor(Color.Transparent); // 透明背景

      // 主内容区 (专辑封面、歌曲信息、音律、播放控制、进度条)
      Column() {
        // 专辑封面
        Image($r('app.media.album_cover')) // 专辑封面图片
          .width(200)
          .height(200)
          .borderRadius(10)
          .shadow({ radius: 8, color: '#000000', offsetX: 0, offsetY: 4 })
          .rotate({ angle: this.albumRotation }) // 应用旋转角度
          .margin({ top: 50 }); // 调整顶部边距，使其向下移动

        // 歌曲信息
        Column() {
          Text('让风告诉你') // 歌曲名
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({ bottom: 5 });

          Text('演唱：可莉/温迪/七七/魈') // 歌手
            .fontSize(16)
            .fontColor('rgba(255, 255, 255, 0.8)');

          Text('当你的天空突然下起了大雨...')
            .margin({top:5})
            .fontColor(Color.Orange)
            .fontSize(15)
            //.fontColor('rgba(255, 255, 255, 0.8)');
        }
        .margin({ top: 30 }); // 调整与专辑封面的间距

        // 音律跳动效果 (使用静态图片或 ImageAnimator)
        Image($r('app.media.icon_pause2')) // 静态音律图片
          .width('80%')
          .height(60)
          .objectFit(ImageFit.Contain)
          .margin({ top: 30 }); // 调整与歌曲信息的间距

        // 进度条
        Column() {
          Progress({ value: this.progress, total: 100, type: ProgressType.Linear })
            .width('80%')
            .height(3)
            .color(Color.White) // 进度条颜色
            .backgroundColor('rgba(255, 255, 255, 0.3)'); // 背景颜色

          Row() {
            Text(this.formatTime(this.currentTime))
              .fontSize(12)
              .fontColor('rgba(255, 255, 255, 0.8)');
            Blank().layoutWeight(1);
            Text(this.formatTime(this.totalTime))
              .fontSize(12)
              .fontColor('rgba(255, 255, 255, 0.8)');
          }
          .width('80%')
          .margin({ top: 5 });
        }
        .margin({ top: 20 }); // 调整与音律效果的间距

        // 音乐控制按钮
        Row({ space: 20 }) {
          // 上一首
          Image($r('app.media.ic_prev')) // 上一首图标
            .width(50)
            .height(50)
            .borderRadius(25)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .onClick(() => {
              hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'Previous song clicked');
              // TODO: 上一首功能
            });

          // 播放/暂停
          Image(this.isPlaying ? $r('app.media.ic_paused') : $r('app.media.ic_play')) // 播放/暂停图标
            .width(60)
            .height(60)
            .borderRadius(30)
            .backgroundColor('rgba(255, 255, 255, 0.3)')
            .onClick(() => {
              this.isPlaying = !this.isPlaying;
              if (this.isPlaying) {
                this.startAlbumRotation(); // 开始旋转
                this.startProgressBarUpdate(); // 开始更新进度条
              } else {
                this.stopAlbumRotation(); // 停止旋转
                this.stopProgressBarUpdate(); // 停止更新进度条
              }
              hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Play/Pause clicked, isPlaying: ${this.isPlaying}`);
              // TODO: 播放/暂停功能
            });

          // 下一首
          Image($r('app.media.ic_next')) // 下一首图标
            .width(50)
            .height(50)
            .borderRadius(25)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .onClick(() => {
              hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'Next song clicked');
              // TODO: 下一首功能
            });
        }
        .margin({ top: 40 }); // 调整与进度条的间距
      }
      .margin({top:40})
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center) // 主内容区垂直居中
      .alignItems(HorizontalAlign.Center); // 主内容区水平居中

      // 右侧纵向图标
      Column({ space: 25 }) { // 增加间距
        // 爱心图标
        Column({ space: 5 }) {
          Stack({ alignContent: Alignment.Center }) { // 使用Stack包裹爱心图标和+1提示
            Image(this.isLiked ? $r('app.media.icon_liked') : $r('app.media.icon_like')) // 爱心图标
              .width(40)
              .height(40)
              .borderRadius(20)
              .backgroundColor('rgba(255, 255, 255, 0.2)')
              .onClick(() => {
                this.isLiked = !this.isLiked;
                hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Like clicked, isLiked: ${this.isLiked}`);

                // "+1" 提示动效
                this.showLikePlusOne = true;
                this.plusOneOpacity = 1; // 初始完全不透明
                this.plusOneOffsetY = 0; // 初始位置

                animateTo({ curve: Curve.EaseOut, duration: 500 }, () => {
                  this.plusOneOffsetY = -50; // 向上移动50px
                  this.plusOneOpacity = 0;   // 渐隐
                });

                // 动画结束后重置状态，以便下次点击时再次显示
                setTimeout(() => {
                  this.showLikePlusOne = false;
                  this.plusOneOpacity = 0; // 确保完全隐藏
                  this.plusOneOffsetY = 0; // 重置位置
                }, 5000); // 匹配动画持续时间
              });

            // "+1" 提示文本
            if (this.showLikePlusOne) {
              Text('+1')
                .fontSize(25)
                .fontColor('rgb(0, 135, 189)')
                .fontWeight(FontWeight.Bold)
                .opacity(this.plusOneOpacity)
                .offset({ y: this.plusOneOffsetY })
                .position({ x: '50%', y: '50%' }) // 相对于Stack居中
                .offset({ x: 0, y: -50 }); // 微调位置，使其在图标上方
            }
          }
          .width(40) // Stack宽度与图标一致
          .height(40); // Stack高度与图标一致

          Text('5.7w') // 示例点赞数
            .fontSize(12)
            .fontColor(Color.White);
        }

        // 评论图标
        Column({ space: 5 }) {
          Image($r('app.media.ic_comment')) // 评论图标
            .width(40)
            .height(40)
            .borderRadius(20)
            .backgroundColor('rgba(255, 255, 255, 0.2)');
          Text('3208') // 示例评论数
            .fontSize(12)
            .fontColor(Color.White);
        }

        // 分享图标
        Column({ space: 5 }) {
          Image(this.isShareActive ? $r('app.media.icon_share') : $r('app.media.icon_shared')) // 分享图标
            .width(40)
            .height(40)
            .borderRadius(20)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .onClick(() => {
              this.isShareActive = !this.isShareActive; // 切换状态
              hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Share clicked, isActive: ${this.isShareActive}`);
              // TODO: 分享功能
            });
          Text('分享')
            .fontSize(12)
            .fontColor(Color.White);
        }

        // 收藏图标
        Column({ space: 5 }) {
          Image(this.isCollectActive ? $r('app.media.icon_collected') : $r('app.media.icon_collect')) // 收藏图标
            .width(40)
            .height(40)
            .borderRadius(20)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .onClick(() => {
              this.isCollectActive = !this.isCollectActive; // 切换状态
              hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Collect clicked, isActive: ${this.isCollectActive}`);
              // TODO: 收藏功能
            });
          Text('收藏')
            .fontSize(12)
            .fontColor(Color.White);
        }
      }
      .alignSelf(ItemAlign.End) // 自身对齐到父容器的末尾 (右侧)
      .justifyContent(FlexAlign.Center) // 内部元素垂直居中
      .height('50%') // 占据父容器的全部高度
      .margin({ left: 15,top: 150 }); // 距离右侧的边距
      //.position({ x: '100%', y: '50%' }) // 定位在右侧垂直居中
      //.offset({ x: -80, y: -150 }); // 调整偏移量，使其更靠右，并向上一些
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000') // 确保背景是黑色
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}

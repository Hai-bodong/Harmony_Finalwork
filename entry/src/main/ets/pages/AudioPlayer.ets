//import router from '@ohos.router';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { router } from '@kit.ArkUI'

// 导入必要的模块
const DOMAIN_AUDIO_PLAYER_PAGE = 0x0003;

// SongItemType 接口定义，与 Discover.ets 中保持一致
interface SongItemType {
  image: Resource
  name: string
  author: string
  id: string // 假设歌曲有唯一ID，虽然当前切换逻辑主要依赖索引
}

interface GeneratedTypeLiteralInterface_1 {
  songs: SongItemType[];
  currentIndex: number;
}

@Entry
@Component
struct AudioPlayer {
  // 图标激活状态
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
  // 总时长 (秒) - 注意：这个应该是动态获取当前歌曲的，暂时保持静态
  @State totalTime: number = 225; // 示例：3分45秒

  // 歌曲列表和当前播放索引
  @State songs: SongItemType[] = [];
  @State currentIndex: number = -1;

  // 当前播放的歌曲信息，由 songs 和 currentIndex 派生
  @State currentSongImage: Resource = $r('app.media.album_cover'); // 默认专辑封面
  @State currentSongName: string = '歌曲名'; // 默认歌曲名
  @State currentSongAuthor: string = '歌手'; // 默认歌手

  // 定时器ID
  private albumRotateTimerId: number = -1;
  private progressTimerId: number = -1;

  aboutToAppear() {
    hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'AudioPlayer.ets aboutToAppear called');

    // 获取路由参数
    const params = router.getParams() as GeneratedTypeLiteralInterface_1;
    if (params && params.songs && params.songs.length > 0 && params.currentIndex !== undefined) {
      hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Received params: songs count ${params.songs.length}, index ${params.currentIndex}`);
      this.songs = params.songs;
      this.currentIndex = params.currentIndex;
      this.loadSong(this.currentIndex); // 加载初始歌曲
    } else {
      hilog.warn(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'No valid params received or song list empty');
      // 可以选择返回或显示错误信息
      // router.back();
    }

    this.startAlbumRotation(); // 动画和进度条更新应在歌曲加载后，或根据播放状态决定
    // this.startProgressBarUpdate(); // 移到播放时启动
  }

  aboutToDisappear() {
    hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'AudioPlayer.ets aboutToDisappear called');
    this.stopAlbumRotation();
    this.stopProgressBarUpdate();
  }

  // 加载指定索引的歌曲信息并更新UI
  loadSong(index: number) {
    if (this.songs.length === 0 || index < 0 || index >= this.songs.length) {
      hilog.error(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Invalid index ${index} or empty song list.`);
      return;
    }
    const song = this.songs[index];
    this.currentSongImage = song.image;
    this.currentSongName = song.name;
    this.currentSongAuthor = song.author;
    this.currentIndex = index; // 确保currentIndex也更新

    // 重置播放状态
    this.currentTime = 0;
    this.progress = 0;
    // 如果之前是播放状态，切换歌曲后可以考虑继续播放，或者让用户手动点击播放
    // if (this.isPlaying) {
    //   // 可能需要重新初始化音频播放器实例并播放
    // }
    hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Loaded song: ${song.name} at index ${index}`);
  }

  // 播放下一首
  playNext() {
    if (this.songs.length === 0) return;
    let nextIndex = this.currentIndex + 1;
    if (nextIndex >= this.songs.length) {
      nextIndex = 0; // 循环到第一首
    }
    this.loadSong(nextIndex);
  }

  // 播放上一首
  playPrevious() {
    if (this.songs.length === 0) return;
    let prevIndex = this.currentIndex - 1;
    if (prevIndex < 0) {
      prevIndex = this.songs.length - 1; // 循环到最后一首
    }
    this.loadSong(prevIndex);
  }


  // 启动专辑封面旋转动画
  startAlbumRotation() {
    if (!this.isAlbumRotating) return; // 如果全局开关是关闭的，则不启动
    if (this.albumRotateTimerId === -1) {
      this.albumRotateTimerId = setInterval(() => {
        this.albumRotation = (this.albumRotation + 1) % 360;
      }, 50);
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
        if (this.isPlaying) { // 仅在播放时更新进度
          this.currentTime += 1;
          // 注意: totalTime 应该是当前歌曲的总时长，这里暂时用固定的
          this.progress = (this.currentTime / this.totalTime) * 100;
          if (this.currentTime >= this.totalTime) {
            // 播放完毕，可以自动播放下一首或停止
            hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'Song finished, playing next.');
            this.playNext(); // 自动播放下一首
          }
        }
      }, 1000);
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
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景渐变动画
      Column() {
        Blank();
      }
      .width('100%')
      .height('100%')
      .linearGradient({
        angle: 45,
        direction: GradientDirection.Left,
        colors: [[0x8A2387, 0.0], [0xE94057, 0.5], [0xF27121, 1.0]]
      })
      .animation({
        duration: 5000,
        iterations: -1,
        curve: Curve.Linear,
        playMode: PlayMode.Alternate
      });

      // 顶部导航栏
      Row() {
        Image($r('app.media.icon_back')) // 返回图标
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            hilog.debug(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'Back button clicked.');
            router.back(); // 使用 router.back() 返回上一页
          });
        Text('音乐播放')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);
        Blank().width(24).margin({ right: 16 });
      }
      .width('100%')
      .height(56)
      .position({ x: 0, y: 0 })
      .backgroundColor(Color.Transparent);

      // 主内容区
      Column() {
        // 专辑封面
        Image(this.currentSongImage)
          .width(200)
          .height(200)
          .borderRadius(10)
          .shadow({ radius: 8, color: '#000000', offsetX: 0, offsetY: 4 })
          .rotate({ angle: this.albumRotation })
          .margin({ top: 50 });

        // 歌曲信息
        Column() {
          Text(this.currentSongName)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({ bottom: 5 });
          Text(this.currentSongAuthor)
            .fontSize(16)
            .fontColor('rgba(255, 255, 255, 0.8)');
          Text('当你的天空突然下起了大雨...')
            .margin({top:5})
            .fontColor(Color.Orange)
            .fontSize(15)
        }
        .margin({ top: 30 });

        // 音律跳动效果 (当前为静态图，可替换为 ImageAnimator 或 Lottie)
        Image(this.isPlaying ? $r('app.media.icon_pause2') : $r('app.media.ic_wave3')) // 根据播放状态显示不同音律图或占位
          .width('80%')
          .height(60)
          .objectFit(ImageFit.Contain)
          .margin({ top: 30 });

        // 进度条
        Column() {
          Progress({ value: this.progress, total: 100, type: ProgressType.Linear })
            .width('80%')
            .height(3)
            .color(Color.White)
            .backgroundColor('rgba(255, 255, 255, 0.3)');
          Row() {
            Text(this.formatTime(this.currentTime))
              .fontSize(12)
              .fontColor('rgba(255, 255, 255, 0.8)');
            Blank().layoutWeight(1);
            Text(this.formatTime(this.totalTime)) // 注意：totalTime应为当前歌曲的
              .fontSize(12)
              .fontColor('rgba(255, 255, 255, 0.8)');
          }
          .width('80%')
          .margin({ top: 5 });
        }
        .margin({ top: 20 });

        // 音乐控制按钮
        Row({ space: 20 }) {
          // 上一首
          Image($r('app.media.ic_prev'))
            .width(50)
            .height(50)
            .borderRadius(25)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .onClick(() => {
              hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'Previous song clicked');
              this.playPrevious();
            });
          // 播放/暂停
          Image(this.isPlaying ? $r('app.media.ic_paused') : $r('app.media.ic_play'))
            .width(60)
            .height(60)
            .borderRadius(30)
            .backgroundColor('rgba(255, 255, 255, 0.3)')
            .onClick(() => {
              this.isPlaying = !this.isPlaying;
              if (this.isPlaying) {
                this.isAlbumRotating = true; // 确保动画开关是开的
                this.startAlbumRotation();
                this.startProgressBarUpdate();
                hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'Playback started.');
              } else {
                // this.isAlbumRotating = false; // 暂停时不一定停止旋转，看产品设计
                this.stopAlbumRotation(); // 或者只是暂停旋转的逻辑 this.isAlbumRotating = false;
                this.stopProgressBarUpdate(); // 进度条必须停
                hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'Playback paused.');
              }
            });
          // 下一首
          Image($r('app.media.ic_next'))
            .width(50)
            .height(50)
            .borderRadius(25)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .onClick(() => {
              hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', 'Next song clicked');
              this.playNext();
            });
        }
        .margin({ top: 40 });
      }
      .margin({top:40})
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center);

      // 右侧纵向图标 (省略部分未改动的代码)
      Column({ space: 25 }) {

        // 爱心图标
        Column({ space: 5 }) {
          Stack({ alignContent: Alignment.Center }) {
            Image(this.isLiked ? $r('app.media.icon_liked') : $r('app.media.icon_like'))
              .width(40)
              .height(40)
              .borderRadius(20)
              .backgroundColor('rgba(255, 255, 255, 0.2)')
              .onClick(() => {
                this.isLiked = !this.isLiked;
                hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Like clicked, isLiked: ${this.isLiked}`);
                if (this.isLiked) { // 只有点赞时才显示+1
                  this.showLikePlusOne = true;
                  this.plusOneOpacity = 1;
                  this.plusOneOffsetY = 0;
                  animateTo({ curve: Curve.EaseOut, duration: 500 }, () => {
                    this.plusOneOffsetY = -50;
                    this.plusOneOpacity = 0;
                  });
                  setTimeout(() => {
                    this.showLikePlusOne = false;
                  }, 500); // 动画结束后隐藏
                }
              });
            if (this.showLikePlusOne) {
              Text('+1')
                .fontSize(25)
                .fontColor('rgb(0, 135, 189)')
                .fontWeight(FontWeight.Bold)
                .opacity(this.plusOneOpacity)
                .offset({ y: this.plusOneOffsetY })
                .position({ x: '50%', y: '50%' })
                .offset({ x: 0, y: -50 });
            }
          }
          .width(40)
          .height(40);
          Text('5.7w')
            .fontSize(12)
            .fontColor(Color.White);
        }
        // 评论图标
        Column({ space: 5 }) {
          Image($r('app.media.ic_comment'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .backgroundColor('rgba(255, 255, 255, 0.2)');
          Text('3208')
            .fontSize(12)
            .fontColor(Color.White);
        }
        // 分享图标
        Column({ space: 5 }) {
          Image(this.isShareActive ? $r('app.media.icon_share') : $r('app.media.icon_shared'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .onClick(() => {
              this.isShareActive = !this.isShareActive;
              hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Share clicked, isActive: ${this.isShareActive}`);
            });
          Text('分享')
            .fontSize(12)
            .fontColor(Color.White);
        }
        // 收藏图标
        Column({ space: 5 }) {
          Image(this.isCollectActive ? $r('app.media.icon_collected') : $r('app.media.icon_collect'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .backgroundColor('rgba(255, 255, 255, 0.2)')
            .onClick(() => {
              this.isCollectActive = !this.isCollectActive;
              hilog.info(DOMAIN_AUDIO_PLAYER_PAGE, 'AudioPlayerPage', `Collect clicked, isActive: ${this.isCollectActive}`);
            });
          Text('收藏')
            .fontSize(12)
            .fontColor(Color.White);
        }
      }
      .alignSelf(ItemAlign.End)
      .justifyContent(FlexAlign.Center)
      .height('50%')
      .margin({ right: 15,top: 150 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}

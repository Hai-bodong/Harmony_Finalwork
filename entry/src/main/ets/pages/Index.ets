import router from '@ohos.router';
import { display } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State showPrompt: boolean = true;
  @State cardWidth: number = 280;
  @State cardHeight: number = 400;
  @State currentTabIndex: number = 0;
  @State currentBottomTab: number = 0 // 默认选中"首页"的标签页

  aboutToAppear() {
    this.calculateCardSize();
    setTimeout(() => {
      this.showPrompt = false;
    }, 1000);
  }

  calculateCardSize() {
    // 获取屏幕宽度并计算卡片尺寸
    const displayWidth = display.getDefaultDisplaySync().width;
    const padding = 40; // 两侧总边距
    const gap = 20; // 卡片间距

    // 计算单个卡片宽度（限制在200-320vp之间）
    let calculatedWidth = (displayWidth - padding - gap * 2) / 3;
    calculatedWidth = Math.max(200, Math.min(calculatedWidth, 320));

    // 高度按4:5.7比例计算
    this.cardWidth = calculatedWidth;
    this.cardHeight = calculatedWidth * 1.43;
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      // 首页Tab
      TabContent() {
        Stack({ alignContent: Alignment.Top }) {
          // 背景
          Column() {
            Blank();
          }
          .width('100%')
          .height('100%')
          .backgroundColor(Color.White);

          // Logo
          Text('HarmonyOS 音视频')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Black)
            .margin({ top: 20 })
            .align(Alignment.Top);

          // 卡片容器
          Scroll() {
            Row({ space: 20 }) {
              // 视频播放卡片
              Column() {
                Image($r('app.media.background1'))
                  .width('100%')
                  .height('60%')
                  .objectFit(ImageFit.Cover)
                  .borderRadius(16);

                Column() {
                  Text('视频播放')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .margin({ bottom: 8 });

                  Text('畅享高清视频、精彩内容')
                    .fontSize(12)
                    .opacity(0.8)
                    .margin({ bottom: 8 });

                  Button('立即体验')
                    .width(100)
                    .height(30)
                    .fontSize(12)
                    .backgroundColor('#FF0050')
                    .fontColor(Color.White)
                    .margin({ top: 8 })
                    .onClick(() => {
                      router.pushUrl({ url: 'pages/TikTokStyle' });
                    });
                }
                .width('100%')
                .padding(10);
              }
              .width(this.cardWidth)
              .height(this.cardHeight)
              .backgroundColor('rgba(255,255,255,0.1)')
              .borderRadius(16)
              .shadow({ radius: 8, color: '#00000033', offsetX: 0, offsetY: 4 });

              // 音频播放卡片
              Column() {
                Column()
                  .width('100%')
                  .height('60%')
                  .backgroundImage($r('app.media.gradient_bg'))
                  .backgroundImageSize(ImageSize.Cover)
                  .borderRadius(16);

                Column() {
                  Text('音频播放')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .margin({ bottom: 8 });

                  Text('沉浸式音乐体验')
                    .fontSize(12)
                    .opacity(0.8)
                    .margin({ bottom: 8 });

                  Button('立即体验')
                    .width(100)
                    .height(30)
                    .fontSize(12)
                    .backgroundColor('#FF0050')
                    .fontColor(Color.White)
                    .margin({ top: 8 })
                    .onClick(() => {
                      router.pushUrl({ url: 'pages/AudioPlayer' });
                    });
                }
                .width('100%')
                .padding(10);
              }
              .width(this.cardWidth)
              .height(this.cardHeight)
              .backgroundColor('rgba(255,255,255,0.1)')
              .borderRadius(16)
              .shadow({ radius: 8, color: '#00000033', offsetX: 0, offsetY: 4 });

              // 个人中心卡片
              Column() {
                Image($r('app.media.profile2'))
                  .width('100%')
                  .height('60%')
                  .objectFit(ImageFit.Cover)
                  .borderRadius(16);

                Column() {
                  Text('个人中心')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .margin({ bottom: 8 });

                  Text('管理音视频资源')
                    .fontSize(12)
                    .opacity(0.8)
                    .margin({ bottom: 8 });

                  Button('立即体验')
                    .width(100)
                    .height(30)
                    .fontSize(12)
                    .backgroundColor('#FF0050')
                    .fontColor(Color.White)
                    .margin({ top: 8 })
                    .onClick(() => {
                      router.pushUrl({ url: 'pages/ProfileCenter' });
                    });
                }
                .width('100%')
                .padding(10);
              }
              .width(this.cardWidth)
              .height(this.cardHeight)
              .backgroundColor('rgba(255,255,255,0.1)')
              .borderRadius(16)
              .shadow({ radius: 8, color: '#00000033', offsetX: 0, offsetY: 4 });
            }
            .justifyContent(FlexAlign.Center)
            .padding({ left: 20, right: 20 })
            .margin({ top: 100 });
          }
          .scrollable(ScrollDirection.Horizontal)
          .width('100%')
          .height('100%');

          // 浮动提示
          if (this.showPrompt) {
            Column() {
              Text('👆 点击卡片体验不同的功能')
                .fontSize(14)
                .fontColor(Color.White);
            }
            .width('auto')
            .height(40)
            .padding({ left: 24, right: 24 })
            .backgroundColor('rgba(0,0,0,0.7)')
            .borderRadius(30)
            .position({ x: '50%', y: '80%' })
            .translate({ x: '-50%' })
            .onClick(() => {
              this.showPrompt = false;
            });
          }
        }
        .width('100%')
        .height('100%')
        .onAreaChange(() => {
          this.calculateCardSize();
        });
      }
      .tabBar(this.TabBuilder('首页', 0, $r('app.media.icon_home')));

      // 发现Tab
      TabContent() {
        Column() {
          Text('发现页面内容')
            .fontSize(20)
            .margin({ top: 50 });
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#121212');
      }
      .tabBar(this.TabBuilder('发现', 1, $r('app.media.icon_search')));

      // 创建Tab
      TabContent() {
        Column() {
          Text('创建页面内容')
            .fontSize(20)
            .margin({ top: 50 });
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#121212');
      }
      .tabBar(this.TabBuilder('创建', 2, $r('app.media.icon_add')));

      // 消息Tab
      TabContent() {
        Column() {
          Text('消息页面内容')
            .fontSize(20)
            .margin({ top: 50 });
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#121212');
      }
      .tabBar(this.TabBuilder('消息', 3, $r('app.media.icon_message')));

      // 我的Tab
      TabContent() {
        Column() {
          Text('个人中心页面内容')
            .fontSize(20)
            .margin({ top: 50 });
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#121212');
      }
      .tabBar(this.TabBuilder('我', 4, $r('app.media.icon_profile')));
    }
    .barMode(BarMode.Fixed)
    .barWidth('100%')
    .barHeight(60)
    .onChange((index: number) => {
      this.currentBottomTab = index
      // 这里可以添加页面跳转逻辑
      if (index === 0) {
        router.pushUrl({ url: 'pages/Index' })
      } else if (index === 1) {
        router.pushUrl({ url: 'pages/Discover' })
      } else if (index === 2) {
        router.pushUrl({ url: 'pages/Create' })
      } else if (index === 3) {
        router.pushUrl({ url: 'pages/Message' })
      } else if (index === 4) {
        router.pushUrl({url: 'pages/ProfileCenter'})
      }
    })
  }

  @Builder TabBuilder(title: string, index: number, icon: Resource) {
    Column() {
      Image(icon)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
        .margin({ bottom: 4 });

      Text(title)
        .fontSize(12);
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .opacity(this.currentTabIndex === index ? 1 : 0.6);
  }
}
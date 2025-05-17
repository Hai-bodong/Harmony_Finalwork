import router from '@ohos.router';
import { display } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit'; // 导入 hilog 用于调试

const DOMAIN_INDEX_PAGE = 0x0002; // 为 Index.ets 定义一个单独的DOMAIN

@Entry
@Component
struct Index {
  @State showInitialPrompt: boolean = true; // 控制初始提示弹窗的显示
  @State showMessagePopup: boolean = false; // 控制新消息弹窗的显示
  @State cardWidth: number = 280;
  @State cardHeight: number = 400;
  @State currentTabIndex: number = 0;
  @State currentBottomTab: number = 0;

  aboutToAppear() {
    hilog.info(DOMAIN_INDEX_PAGE, 'IndexPage', 'Index.ets aboutToAppear called');
    this.calculateCardSize();

    // 初始提示弹窗的隐藏逻辑
    setTimeout(() => {
      this.showInitialPrompt = false;
      hilog.info(DOMAIN_INDEX_PAGE, 'IndexPage', 'Initial prompt hidden.');

      // 在初始提示隐藏后，显示新消息弹窗
      this.showMessagePopup = true;
      hilog.info(DOMAIN_INDEX_PAGE, 'IndexPage', 'Message popup shown.');

      // 3秒后隐藏新消息弹窗
      setTimeout(() => {
        this.showMessagePopup = false;
        hilog.info(DOMAIN_INDEX_PAGE, 'IndexPage', 'Message popup hidden after 3 seconds.');
      }, 3000); // 3秒后隐藏
    }, 1000); // 1秒后隐藏初始提示
  }

  calculateCardSize() {
    const displayWidth = display.getDefaultDisplaySync().width;
    const padding = 40;
    const gap = 20;
    let calculatedWidth = (displayWidth - padding - gap * 2) / 3;
    calculatedWidth = Math.max(200, Math.min(calculatedWidth, 320));
    this.cardWidth = calculatedWidth;
    this.cardHeight = calculatedWidth * 1.43;
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 背景改为黑色
      Column() {
        Blank();
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#121212');

      // Logo颜色改为白色
      Text('HarmonyOS 音视频')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White) // 改为白色
        .margin({ top: 20 })
        .align(Alignment.Top);

      // 根据当前选中的底部标签显示对应的内容
      if (this.currentBottomTab === 0) {
        // 首页内容
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
                  .margin({ bottom: 8 })
                  .fontColor(Color.White); // 文字改为白色
                Text('畅享高清视频、精彩内容')
                  .fontSize(12)
                  .opacity(0.8)
                  .margin({ bottom: 8 })
                  .fontColor('#AAAAAA'); // 副标题改为浅灰色
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
            .backgroundColor('#1E1E1E') // 卡片背景改为深灰色
            .borderRadius(16)
            .shadow({ radius: 8, color: '#000000', offsetX: 0, offsetY: 4 });

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
                  .margin({ bottom: 8 })
                  .fontColor(Color.White);
                Text('沉浸式音乐体验')
                  .fontSize(12)
                  .opacity(0.8)
                  .margin({ bottom: 8 })
                  .fontColor('#AAAAAA');
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
            .backgroundColor('#1E1E1E')
            .borderRadius(16)
            .shadow({ radius: 8, color: '#000000', offsetX: 0, offsetY: 4 });

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
                  .margin({ bottom: 8 })
                  .fontColor(Color.White);
                Text('管理音视频资源')
                  .fontSize(12)
                  .opacity(0.8)
                  .margin({ bottom: 8 })
                  .fontColor('#AAAAAA');
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
            .backgroundColor('#1E1E1E')
            .borderRadius(16)
            .shadow({ radius: 8, color: '#000000', offsetX: 0, offsetY: 4 });
          }
          .justifyContent(FlexAlign.Center)
          .padding({ left: 20, right: 20 })
          .margin({ top: 100 });
        }
        .scrollable(ScrollDirection.Horizontal)
        .width('100%')
        .height('100%');
      } else if (this.currentBottomTab === 1) {
        // 发现页面内容
        Column() {
          Text('发现页面内容')
            .fontSize(20)
            .margin({ top: 50 })
            .fontColor(Color.White);
        }
        .width('100%')
        .height('100%');
      } else if (this.currentBottomTab === 2) {
        // 创建页面内容
        Column() {
          Text('创建页面内容')
            .fontSize(20)
            .margin({ top: 50 })
            .fontColor(Color.White);
        }
        .width('100%')
        .height('100%');
      } else if (this.currentBottomTab === 3) {
        // 消息页面内容
        Column() {
          Text('消息页面内容')
            .fontSize(20)
            .margin({ top: 50 })
            .fontColor(Color.White);
        }
        .width('100%')
        .height('100%');
      } else if (this.currentBottomTab === 4) {
        // 个人中心页面内容
        Column() {
          Text('个人中心页面内容')
            .fontSize(20)
            .margin({ top: 50 })
            .fontColor(Color.White);
        }
        .width('100%')
        .height('100%');
      }

      // 初始浮动提示 (保留，但会在新消息弹窗后隐藏)
      if (this.showInitialPrompt) {
        Column() {
          Text('👆 点击卡片体验不同的功能')
            .fontSize(14)
            .fontColor(Color.White);
        }
        .width('auto')
        .height(40)
        .padding({ left: 24, right: 24 })
        .backgroundColor('rgba(255,255,255,0.2)') // 提示框背景改为半透明白色
        .borderRadius(30)
        .position({ x: '50%', y: '80%' })
        .translate({ x: '-50%' })
        .onClick(() => {
          this.showInitialPrompt = false;
          hilog.info(DOMAIN_INDEX_PAGE, 'IndexPage', 'Initial prompt clicked and hidden.');
        });
      }

      // 新消息弹窗
      if (this.showMessagePopup) {
        Row() {
          // 头像 (请替换为你的头像资源)
          Image($r('app.media.logo')) // 示例头像，请替换
            .width(40)
            .height(40)
            .borderRadius(20) // 圆形头像
            .margin({ right: 10 });

          // 消息内容
          Text('原神，启动！')
            .fontSize(16)
            .fontColor(Color.Black); // 消息文本颜色
        }
        .width('90%') // 弹窗宽度
        .padding(15)
        .backgroundColor(Color.White) // 弹窗背景颜色
        .borderRadius(10) // 圆角
        .position({ x: '5%', y: 50 }) // 定位在页面顶部，留出一定边距
        .shadow({ radius: 8, color: '#000000', offsetX: 0, offsetY: 4 }); // 添加阴影效果
      }

      // 自定义底部导航栏
      Row() {
        // 首页
        Column() {
          Image($r('app.media.icon_home'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .margin({ bottom: 4 })
            .colorFilter({
              color: this.currentBottomTab === 0 ? '#FF0050' : '#FFFFFF'
            });
          Text('首页')
            .fontSize(12)
            .fontColor(this.currentBottomTab === 0 ? '#FF0050' : '#FFFFFF');
        }
        .width('20%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentBottomTab = 0;
          // router.pushUrl({ url: 'pages/Index' }); // 在当前页不需要再次跳转
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
    }
    .width('100%')
    .height('100%')
    .onAreaChange(() => {
      this.calculateCardSize();
    });
  }
}

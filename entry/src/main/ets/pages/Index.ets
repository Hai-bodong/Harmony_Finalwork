import router from '@ohos.router';
import { display } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State showInitialPrompt: boolean = true;
  @State showMessagePopup: boolean = false;
  @State cardWidth: number = 280;
  @State cardHeight: number = 400;
  @State currentTabIndex: number = 0;
  @State pageStack: string[] = []; // 初始化页面栈

  // 定义Tab页面对应的路由
  private tabRoutes: string[] = [
    'pages/Index',
    'pages/Discover',
    'pages/Create',
    'pages/Message',
    'pages/ProfileCenter'
  ];

  aboutToAppear() {
    this.calculateCardSize();
    this.showInitialPrompt = false;
    this.showMessagePopup = true;

    setTimeout(() => {
      this.showMessagePopup = false;
    }, 3000);
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

  // 页面跳转处理
  navigateToPage(url: string) {
    if (this.pageStack.length > 0 && this.pageStack[this.pageStack.length - 1] === url) {
      // 如果目标页面已经在栈顶，则刷新当前页面
      router.back();
    } else {
      // 添加新页面到栈中
      this.pageStack.push(url);
      // 跳转到新页面
      router.pushUrl({ url: url }, router.RouterMode.Single);
    }
  }

  // 页面回退处理
  navigateBack() {
    if (this.pageStack.length > 1) {
      // 移除当前页面
      this.pageStack.pop();

      // 获取新的栈顶页面
      const newTopPage = this.pageStack[this.pageStack.length - 1];

      // 更新当前Tab索引
      this.currentTabIndex = this.tabRoutes.indexOf(newTopPage);

      // 跳转到新的栈顶页面
      router.pushUrl({ url: newTopPage }, router.RouterMode.Single);
    } else if (this.pageStack.length === 1) {
      // 如果栈中只剩一个页面，则直接回退到该页面
      router.replaceUrl({ url: 'pages/Index' }, router.RouterMode.Single);

      // 更新当前Tab索引为首页
      this.currentTabIndex = 0;
    }
  }

  // Tab切换处理
  onTabChange(index: number) {
    if (this.currentTabIndex !== index) {
      this.currentTabIndex = 0;
      this.navigateToPage(this.tabRoutes[index]);
    }
  }

  build() {
    Column() {
      // 主内容区域 - 使用Tabs组件
      Tabs({ barPosition: BarPosition.End }) {
        // 首页Tab
        TabContent() {
          this.buildHomeContent();
        }.tabBar(this.buildTabBarItem(0, $r('app.media.icon_home'), '首页'))

        // 发现Tab
        TabContent() {
        }.tabBar(this.buildTabBarItem(1, $r('app.media.icon_discover'), '发现'))

        // 创建Tab
        TabContent() {
        }.tabBar(this.buildTabBarItem(2, $r('app.media.icon_add'), '创建'))

        // 消息Tab
        TabContent() {
        }.tabBar(this.buildTabBarItem(3, $r('app.media.icon_message'), '消息'))

        // 个人中心Tab
        TabContent() {
        }.tabBar(this.buildTabBarItem(4, $r('app.media.icon_profile'), '我'))
      }
      .barWidth('100%')
      .barHeight(60)
      .backgroundColor('#1E1E1E')

      // 初始浮动提示
      if (this.showInitialPrompt) {
        Column() {
          Text('👆 点击卡片体验不同的功能')
            .fontSize(14)
            .fontColor(Color.White);
        }
        .width('auto')
        .height(40)
        .padding({ left: 24, right: 24 })
        .backgroundColor('rgba(255,255,255,0.2)')
        .borderRadius(30)
        .position({ x: '50%', y: '80%' })
        .translate({ x: '-50%' })
        .onClick(() => {
          this.showInitialPrompt = false;
        });
      }

      // 新消息弹窗
      if (this.showMessagePopup) {
        Row() {
          Image($r('app.media.logo'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .margin({ right: 10 });

          Text('原神，启动！')
            .fontSize(16)
            .fontColor(Color.Black);
        }
        .width('90%')
        .padding(15)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .position({ x: '5%', y: 50 })
        .shadow({ radius: 8, color: '#000000', offsetX: 0, offsetY: 4 });
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#121212')
    .onAreaChange(() => {
      this.calculateCardSize();
    });
  }

  // 构建首页内容
  @Builder
  buildHomeContent() {
    Column() {
      // 顶部标题
      Text('HarmonyOS 音视频')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .margin({ top: 20 });

      // 主内容区域
      Scroll() {
        Row({ space: 10 }) {
          // 视频播放卡片
          Column() {
            Image($r('app.media.background1'))
              .width('100%')
              .height('60%')
              .objectFit(ImageFit.Cover)
              .borderRadius(16);
            Column() {
              Text('视频播放')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 8 })
                .fontColor(Color.White);
              Text('畅享高清视频、精彩内容')
                .fontSize(13)
                .opacity(0.8)
                .margin({ bottom: 8 })
                .fontColor('#AAAAAA');
              Button('立即体验')
                .width(100)
                .height(40)
                .fontSize(14)
                .backgroundColor('#FF0050')
                .fontColor(Color.White)
                .margin({ top: 8 })
                .onClick(() => {
                  this.navigateToPage('pages/TikTokStyle');
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
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 8 })
                .fontColor(Color.White);
              Text('沉浸式音乐体验')
                .fontSize(14)
                .opacity(0.8)
                .margin({ bottom: 8 })
                .fontColor('#AAAAAA');
              Button('立即体验')
                .width(100)
                .height(30)
                .fontSize(14)
                .backgroundColor('#FF0050')
                .fontColor(Color.White)
                .margin({ top: 8 })
                .onClick(() => {
                  this.navigateToPage('pages/AudioPlayer');
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
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 8 })
                .fontColor(Color.White);
              Text('管理音视频资源')
                .fontSize(14)
                .opacity(0.8)
                .margin({ bottom: 8 })
                .fontColor('#AAAAAA');
              Button('立即体验')
                .width(100)
                .height(30)
                .fontSize(14)
                .backgroundColor('#FF0050')
                .fontColor(Color.White)
                .margin({ top: 8 })
                .onClick(() => {
                  this.navigateToPage('pages/ProfileCenter');
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
      }
      .scrollable(ScrollDirection.Horizontal)
      .width('100%')
      .height('100%');
    }
    .width('100%')
    .height('100%');
  }

  // 构建TabBar项
  @Builder
  buildTabBarItem(index: number, icon: Resource, text: string) {
    Column() {
      Image(icon)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
        .margin({ bottom: 4 })
        .colorFilter({
          color: this.currentTabIndex === index ? '#FF0050' : '#FFFFFF'
        });
      Text(text)
        .fontSize(12)
        .fontColor(this.currentTabIndex === index ? '#FF0050' : '#FFFFFF');
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.onTabChange(index);
    });
  }
}

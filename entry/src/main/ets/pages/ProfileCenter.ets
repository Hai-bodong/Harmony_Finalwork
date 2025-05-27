import router from '@ohos.router';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_INDEX_PAGE = 0x0002; // 为 Index.ets 定义一个单独的DOMAIN

@Entry
@Component
struct ProfileCenter {
  @State currentTab: string = 'works';
  @State currentBottomTab: number = 4; // 默认选中"我"的标签页
  @State pageStack: string[] = ['pages/ProfileCenter']; // 初始化页面栈

  // 定义Tab页面对应的路由
  private tabRoutes: string[] = [
    'pages/Index',
    'pages/Discover',
    'pages/Create',
    'pages/Message',
    'pages/ProfileCenter'
  ];

  // 页面跳转处理
  navigateToPage(url: string) {
    if (this.pageStack.length > 0 && this.pageStack[this.pageStack.length - 1] === url) {
      // 如果目标页面已经在栈顶，则刷新当前页面
      router.back();
    } else {
      // 添加新页面到栈中
      this.pageStack.push(url);

      // 如果栈中页面超过3个，则移除最早的页面
      if (this.pageStack.length > 3) {
        const removedPage = this.pageStack.shift();
        hilog.info(DOMAIN_INDEX_PAGE, 'ProfileCenter', `Removed page from stack: ${removedPage}`);
      }

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
      this.currentBottomTab = this.getTabRouteIndex(newTopPage);

      // 跳转到新的栈顶页面
      router.pushUrl({ url: newTopPage }, router.RouterMode.Single);
    } else if (this.pageStack.length === 1) {
      // 如果栈中只剩一个页面，则直接回退到该页面
      router.replaceUrl({ url: 'pages/Index' }, router.RouterMode.Single);

      // 更新当前Tab索引为首页
      this.currentBottomTab = 0;
    }
  }

  // 获取Tab页面对应的路由索引
  getTabRouteIndex(url: string): number {
    const tabRoutes = [
      'pages/Index',
      'pages/Discover',
      'pages/Create',
      'pages/Message',
      'pages/ProfileCenter'
    ];
    return tabRoutes.indexOf(url);
  }

  // Tab切换处理
  onTabChange(index: number) {
    if (this.currentBottomTab !== index) {
      this.currentBottomTab = index;
      const url = this.tabRoutes[index];
      this.navigateToPage(url);
    }
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      // 主内容区域
      Column() {
        Row(){
          // 返回按钮
          Image($r('app.media.icon_back'))
            .width(24)
            .height(24)
            .margin({ top: 10, left: 20})
            .onClick(() => {
              router.back()
            })
        }
        .width('100%')
        // 头部信息
        Column() {
          // 头像
          Image($r('app.media.profile2'))
            .width(100)
            .height(100)
            .borderRadius(50)
            .border({ width: 2, color: '#808080' })
            .margin({ bottom: 15 })

          // 用户名
          Text('用户昵称')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({ bottom: 8 })

          // 简介
          TextInput({ placeholder: '这是个人简介，分享你的个人生活与态度' })
            .type(InputType.Normal)
            .fontSize(14)
            .fontColor(Color.White)
            .margin({ bottom: 15 })
            .textAlign(TextAlign.Center)
            .backgroundColor(Color.Gray)

          // 统计数据
          Row({ space: 20 }) {
            Column() {
              Text('168')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('关注')
                .fontSize(12)
                .fontColor(Color.White)
            }

            Column() {
              Text('286')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('粉丝')
                .fontSize(12)
                .fontColor(Color.White)
            }

            Column() {
              Text('42')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('获赞')
                .fontSize(12)
                .fontColor(Color.White)
            }
          }
          .margin({ bottom: 20 })

          // 编辑资料按钮
          Button('编辑资料', { type: ButtonType.Normal })
            .width(120)
            .height(30)
            .fontSize(14)
            .backgroundColor('#FF0050')
            .fontColor(Color.White)
            .borderRadius(4.5)
            .margin({ bottom: 20 })

          // 内容标签页
          Row({ space: 0 }) {
            Text('收藏')
              .fontSize(16)
              .fontColor(this.currentTab === 'collections' ? '#FF0050' : '#FFF')
              .padding(10)
              .border({ width: { bottom: this.currentTab === 'collections' ? 2 : 0 }, color: '#FF0050' })
              .onClick(() => {
                this.currentTab = 'collections'
              })

            Text('作品')
              .fontSize(16)
              .fontColor(this.currentTab === 'works' ? '#FF0050' : '#FFF')
              .padding(10)
              .border({ width: { bottom: this.currentTab === 'works' ? 2 : 0 }, color: '#FF0050' })
              .onClick(() => {
                this.currentTab = 'works'
              })

            Text('喜欢')
              .fontSize(16)
              .fontColor(this.currentTab === 'likes' ? '#FF0050' : '#FFF')
              .padding(10)
              .border({ width: { bottom: this.currentTab === 'likes' ? 2 : 0 }, color: '#FF0050' })
              .onClick(() => {
                this.currentTab = 'likes'
              })

            Text('历史')
              .fontSize(16)
              .fontColor(this.currentTab === 'history' ? '#FF0050' : '#FFF')
              .padding(10)
              .border({ width: { bottom: this.currentTab === 'history' ? 2 : 0 }, color: '#FF0050' })
              .onClick(() => {
                this.currentTab = 'history'
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
          .border({ width: { bottom: 1 }, color: 'rgba(0,0,0,0.1)' })
        }
        .width('100%')
        .padding(20)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')

      // 底部Tab栏 - 使用Stack布局覆盖在内容上方
      Column() {
        // 主内容区域 - 使用Tabs组件
        Tabs({ barPosition: BarPosition.End }) {
          // 首页Tab
          TabContent() {
          }.tabBar(this.buildTabBarItem(0, $r('app.media.icon_home'), '首页'))

          // 发现Tab
          TabContent() {
          }.tabBar(this.buildTabBarItem(1, $r('app.media.icon_find'), '发现'))

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
        .width('100%')
        .onChange((index: number) => {
          this.onTabChange(index);
        })
      }
      .width('100%')
      .height(60)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  // 构建TabBar项
  @Builder
  buildTabBarItem(index: number, icon: ResourceStr, text: string) {
    Column() {
      Image(icon)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
        .margin({ bottom: 4 })
        .colorFilter({
          color: this.currentBottomTab === index ? '#FF0050' : '#FFFFFF'
        });

      Text(text)
        .fontSize(12)
        .fontColor(this.currentBottomTab === index ? '#FF0050' : '#FFFFFF');
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

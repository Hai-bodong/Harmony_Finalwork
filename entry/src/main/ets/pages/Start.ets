// 文件路径: /src/main/ets/pages/Start.ets
import router from '@ohos.router'; // ***** 新增：导入 router *****
import { hilog } from '@kit.PerformanceAnalysisKit'; // 建议添加 hilog 用于调试

const DOMAIN_START_PAGE = 0x0001; // 为 Start.ets 定义一个单独的DOMAIN，方便日志筛选


interface Errorinfo {
  code:number;
  message:string;
}

@Entry
@Component
struct Start {
  // NavPathStack 和相关的 NavDestination 通常用于 <Navigation> 组件内部，
  // 对于根页面跳转，直接使用 router 更合适。
  // pathStack: NavPathStack = new NavPathStack(); // ***** 移除或注释掉 *****

  aboutToAppear(): void {
    hilog.info(DOMAIN_START_PAGE, 'StartPage', 'Start.ets aboutToAppear called');
    setTimeout(() => {
      hilog.info(DOMAIN_START_PAGE, 'StartPage', 'Attempting to navigate to Index page after 3 seconds.');
      // ***** 修改点：使用 router.replaceUrl 进行跳转 *****
      router.replaceUrl({
        url: 'pages/Index' // 确保这个路径与 main_pages.json 中的配置一致
      })
        .then(() => {
          hilog.info(DOMAIN_START_PAGE, 'StartPage', 'Successfully navigated to Index page.');
        })
        .catch((err:Errorinfo) => {
          // 输出详细错误日志，方便排查问题
          hilog.error(DOMAIN_START_PAGE, 'StartPage', `Failed to navigate to Index page. Code: ${err.code}, message: ${err.message}`);
        });
    }, 3000);
  }

  build() {
    // 如果 Start.ets 只是一个简单的广告展示页，并且不包含复杂的导航结构，
    // NavDestination 可能不是必需的。但如果你的UI结构需要它，可以保留。
    // 为了简单起见，这里直接使用 Stack。
    Stack({ alignContent: Alignment.TopEnd }) {
      Image($r('app.media.ad')) // 确保图片资源路径正确
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover) // 使图片覆盖整个区域，保持比例
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);

      Button('跳过')
        .backgroundColor(Color.Gray)
        .margin(15)
        .onClick(() => {
          hilog.info(DOMAIN_START_PAGE, 'StartPage', 'Skip button clicked. Navigating to Index page.');
          // ***** 修改点：跳过按钮也使用 router.replaceUrl *****
          router.replaceUrl({
            url: 'pages/Index'
          })
            .then(() => {
              hilog.info(DOMAIN_START_PAGE, 'StartPage', 'Successfully navigated to Index page via skip button.');
            })
            .catch((err:Errorinfo) => {
              hilog.error(DOMAIN_START_PAGE, 'StartPage', `Failed to navigate to Index page via skip button. Code: ${err.code}, message: ${err.message}`);
            });
        });
    }
    .width('100%')
    .height('100%');
    // .onReady((context: NavDestinationContext) => { // ***** 如果移除了 NavDestination，这个也需要移除或注释 *****
    //   this.pathStack = context.pathStack;
    // })
  }
}

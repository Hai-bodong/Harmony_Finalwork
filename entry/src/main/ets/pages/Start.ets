import router from '@ohos.router';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_START_PAGE = 0x0001; // 为 Start.ets 定义一个单独的DOMAIN，方便日志筛选


interface Errorinfo {
  code:number;
  message:string;
}

@Entry
@Component
struct Start {

  aboutToAppear(): void {
    hilog.info(DOMAIN_START_PAGE, 'StartPage', 'Start.ets aboutToAppear called');
    setTimeout(() => {
      hilog.info(DOMAIN_START_PAGE, 'StartPage', 'Attempting to navigate to Index page after 3 seconds.');
      router.replaceUrl({
        url: 'pages/Index'
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
    //   this.pathStack = context.pathStack;
    // })
  }
}

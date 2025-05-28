import router from '@ohos.router';

@Entry
@Component
struct Start {

  aboutToAppear(): void {
    setTimeout(() => {
      router.replaceUrl({
        url: 'pages/Index'
      })
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
          router.replaceUrl({
            url: 'pages/Index'
          })
        });
    }
    .width('100%')
    .height('100%');
  }
}

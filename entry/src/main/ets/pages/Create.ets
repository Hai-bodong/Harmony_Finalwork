import router from '@ohos.router'

// CreatePage.ets
@Entry
@Component
struct CreatePage {
  @State currentTab: string = 'video'
  @State charCount: number = 0
  @State description: string = ''
  @State currentBottomTab: number = 2 // 默认选中"创建"页（索引2）

  build() {
    Column() {
      // 头部区域
      Row() {
        // 返回按钮
        Image($r('app.media.icon_back'))
          .width(30)
          .height(30)
          .margin({ top: 10 })
          .onClick(() => {
            router.back()
          })

        // 标题
        Text('创建内容')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .layoutWeight(3)
          .textAlign(TextAlign.Center)

        // 发布按钮
        Text('发布')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#FF0050')
          .padding(8)
          .borderRadius(10)
          .width(60)
          .textAlign(TextAlign.Center)
      }
      .padding(20)
      .border({ width: { bottom: 1.5 }, color: 'rgba(255, 255, 255, 0.1)' })

      // 创建标签页
      Row() {
        ForEach(['video', 'photo', 'music', 'text'], (item: string) => {
          Column({ space: 4 }) {
            Text(this.getTabLabel(item))
              .fontSize(18)
              .fontWeight(this.currentTab === item ? FontWeight.Bold : FontWeight.Normal)
              .opacity(this.currentTab === item ? 1 : 0.7)
              .fontColor(Color.White)
              .padding({ top: 10, bottom: 10, left: 5, right: 5 })
              .textAlign(TextAlign.Center)
              .maxLines(1)

            if (this.currentTab === item) {
              Divider()
                .height(2)
                .backgroundColor('#FF0050')
                .width('60%')
            }
          }
          .width('25%')
          .onClick(() => this.currentTab = item)
        })
      }
      .padding({ top: 10, bottom: 10 })
      .border({ width: { bottom: 1.5 }, color: 'rgba(255, 255, 255, 0.1)' })

      // 预览区域
      Stack() {
        Column()
          .width('100%')
          // .aspectRatio(9/16)
          .height(100)
          .backgroundColor('#1a1a1a')

        Column() {
          Text(this.getPreviewIcon())
            .fontSize(40)
            .fontColor(Color.White)
        }
        .width(80)
        .height(80)
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .borderRadius(40)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .margin({ top: 5, bottom: 5 })

      // 编辑工具
      Row() {
        ForEach(['裁剪', '滤镜', '特效', '调节', '字幕'], (label: string, index: number) => {
          Column() {
            Text(this.getToolIcon(index))
              .fontSize(20)
              .width(40)
              .height(40)
              .backgroundColor('rgba(255, 255, 255, 0.1)')
              .borderRadius(20)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)

            Text(label)
              .fontSize(12)
              .opacity(0.8)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
              .maxLines(1)
          }
          .width('20%')
          .justifyContent(FlexAlign.Center)
        })
      }
      .justifyContent(FlexAlign.SpaceAround)
      .padding(10)
      .border({ width: { bottom: 1.5 }, color: 'rgba(255, 255, 255, 0.1)' })

      // 音乐部分
      Column() {
        // 标题行
        Row() {
          Text('音乐')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .layoutWeight(1)

          Text('更多')
            .fontSize(14)
            .fontColor('#FF0050')
            .margin({ right: 10 })
        }
        .margin({ bottom: 15 })

        // 音乐项
        Row() {
          Image($r('app.media.gradient_bg'))
            .width(50)
            .height(50)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)

          Column() {
            Text('晚风轻抚')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 3 })
              .fontColor(Color.White)
              .maxLines(1)

            Text('轻音乐大师 - 心灵治愈系列')
              .fontSize(12)
              .opacity(0.7)
              .fontColor(Color.White)
              .maxLines(1)
          }
          .layoutWeight(1)
          .margin({ left: 15 })
          .justifyContent(FlexAlign.Center)

          Text('♫')
            .fontSize(18)
            .width(30)
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .margin({ right: 10 })
        }
      }
      .padding(15)
      .border({ width: { bottom: 1.5 }, color: 'rgba(255, 255, 255, 0.1)' })

      // 文本输入
      Column() {
        TextArea({ placeholder: '添加视频描述...' })
          .width('100%')
          .height(100)
          .backgroundColor('rgba(255, 255, 255, 0.1)')
          .fontColor(Color.White)
          .fontSize(16)
          .placeholderFont({ size: 16, weight: FontWeight.Normal })
          .placeholderColor('rgba(255, 255, 255, 0.5)')
          .onChange((value: string) => {
            this.description = value
            this.charCount = value.length
          })

        Row() {
          Text('#')
            .fontSize(20)
            .opacity(0.7)
            .fontColor(Color.White)

          Text(`${this.charCount}/200`)
            .fontSize(14)
            .opacity(0.7)
            .fontColor(Color.White)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 10 })
        .width('100%')
      }
      .padding(15)
      .backgroundColor('rgba(255, 255, 255, 0.1)')
      .borderRadius(8)
      .margin(15)

      // 发布选项
      Column() {
        ForEach(['谁可以看', '允许评论', '分享到动态'], (label: string) => {
          Row() {
            Text(label)
              .fontSize(14)
              .fontColor(Color.White)
              .layoutWeight(1)
              .textAlign(TextAlign.Start)
              .maxLines(1)

            Text(this.getOptionValue(label))
              .fontSize(14)
              .opacity(0.7)
              .fontColor(Color.White)
              .margin({ right: 10 })
              .maxLines(1)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ top: 12, bottom: 12 })
          .width('100%')
          .border({ width: { bottom: 1.5 }, color: 'rgba(255, 255, 255, 0.1)' })
        })
      }
      .margin(15)

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
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000')
  }

  @Builder
  buildNavItem(title: string, index: number, icon: Resource, isActive?: boolean) {
    Column() {
      Image(icon)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
        .margin({ bottom: 4 })
        .colorFilter({
          color: isActive ? '#FF0050' : '#FFFFFF'
        })

      Text(title)
        .fontSize(12)
        .fontColor(isActive ? '#FF0050' : '#FFFFFF')
        .maxLines(1)
    }
    .width('20%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentBottomTab = index
      if (index !== 2) {
        router.pushUrl({
          url: `pages/${index === 0 ? 'Index' : index === 1 ? 'Discover' : index === 3 ? 'Messages' : 'Profile'}`
        })
      }
    })
  }

  // 获取标签页文字
  getTabLabel(type: string): string {
    switch (type) {
      case 'video': return '视频'
      case 'photo': return '照片'
      case 'music': return '音乐'
      case 'text': return '文字'
      default: return ''
    }
  }

  // 获取发布选项值
  getOptionValue(label: string): string {
    switch (label) {
      case '谁可以看': return '公开 ›'
      case '允许评论': return '所有人 ›'
      case '分享到动态': return '开启 ›'
      default: return ''
    }
  }

  // 获取预览图标
  getPreviewIcon(): string {
    switch (this.currentTab) {
      case 'video': return '+'
      case 'photo': return '📷'
      case 'music': return '🎵'
      case 'text': return '📝'
      default: return '+'
    }
  }

  // 获取工具图标
  getToolIcon(index: number): string {
    const icons: string[] = ['✂️', '🎨', '✨', '⚡', '💬']
    return icons[index]
  }
}

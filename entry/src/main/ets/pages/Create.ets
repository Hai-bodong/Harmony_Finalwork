// CreatePage.ets
@Entry
@Component
struct CreatePage {
  @State currentTab: string = 'video'
  @State charCount: number = 0
  @State description: string = ''

  build() {
    Column() {
      // 头部
      this.buildHeader()

      // 创建标签页
      this.buildCreateTabs()

      // 预览区域
      this.buildPreviewContainer()

      // 编辑工具
      this.buildEditTools()

      // 音乐部分
      this.buildMusicSection()

      // 文本输入
      this.buildTextInput()

      // 发布选项
      this.buildPublishOptions()

      // 底部导航
      this.buildBottomNav()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000')
  }

  @Builder
  buildHeader() {
    Row() {
      // 返回按钮
      Image($r('app.media.icon_back'))
        .width(20)
        .height(20)
        .onClick(() => {
          // 返回逻辑
        })

      // 标题
      Text('创建内容')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 发布按钮
      Button('发布', { type: ButtonType.Normal })
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#FF0050')
        .borderRadius(20)
        .width(80)
        .height(30)
    }
    .padding(20)
    // .border({ bottom: { width: 1, color: 'rgba(255, 255, 255, 0.1)' } })
    .width('100%')
  }

  @Builder
  buildCreateTabs() {
    Row() {
      this.buildCreateTab('video', '视频')
      this.buildCreateTab('photo', '照片')
      this.buildCreateTab('music', '音乐')
      this.buildCreateTab('text', '文字')
    }
    .padding({ top: 10, bottom: 10 })
    // .border({ bottom: { width: 1, color: 'rgba(255, 255, 255, 0.1)' } })
    .width('100%')
  }

  @Builder
  buildCreateTab(type: string, label: string) {
    Column() {
      Text(label)
        .fontSize(16)
        .fontWeight(this.currentTab === type ? FontWeight.Bold : FontWeight.Normal)
        .opacity(this.currentTab === type ? 1 : 0.7)

      if (this.currentTab === type) {
        Divider()
          .width(30)
          .height(3)
          .color('#FF0050')
          .margin({ top: 5 })
      }
    }
    .width('25%')
    .onClick(() => {
      this.currentTab = type
    })
  }

  @Builder
  buildPreviewContainer() {
    Stack() {
      // 背景
      Column()
        .width('100%')
        .aspectRatio(9/16)
        .backgroundColor('#1a1a1a')

      // 预览占位符
      Column() {
        Text(this.getPreviewIcon())
          .fontSize(40)
      }
      .width(80)
      .height(80)
      .borderRadius(40)
      .backgroundColor('rgba(255, 255, 255, 0.1)')
    }
    .width('100%')
    .aspectRatio(9/16)
  }

  getPreviewIcon(): string {
    switch (this.currentTab) {
      case 'video': return '+'
      case 'photo': return '📷'
      case 'music': return '🎵'
      case 'text': return '📝'
      default: return '+'
    }
  }

  @Builder
  buildEditTools() {
    Row() {
      this.buildEditTool('✂️', '裁剪')
      this.buildEditTool('🎨', '滤镜')
      this.buildEditTool('✨', '特效')
      this.buildEditTool('⚡', '调节')
      this.buildEditTool('💬', '字幕')
    }
    .justifyContent(FlexAlign.SpaceAround)
    .padding(20)
    // .border({ bottom: { width: 1, color: 'rgba(255, 255, 255, 0.1)' } })
    .width('100%')
  }

  @Builder
  buildEditTool(icon: string, label: string) {
    Column() {
      Text(icon)
        .fontSize(20)
        .width(40)
        .height(40)
        .textAlign(TextAlign.Center)
        .backgroundColor('rgba(255, 255, 255, 0.1)')
        .borderRadius(20)

      Text(label)
        .fontSize(12)
        .opacity(0.8)
    }
  }

  @Builder
  buildMusicSection() {
    Column() {
      // 标题行
      Row() {
        Text('音乐')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Text('更多')
          .fontSize(14)
          .fontColor('#FF0050')
      }
      .margin({ bottom: 15 })

      // 音乐项
      Row() {
        // 封面
        // Image($r('app.media.album_cover1'))
        //   .width(50)
        //   .height(50)
        //   .borderRadius(8)
        //   .objectFit(ImageFit.Cover)

        // 信息
        Column() {
          Text('晚风轻抚')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 3 })

          Text('轻音乐大师 - 心灵治愈系列')
            .fontSize(12)
            .opacity(0.7)
        }
        .layoutWeight(1)
        .margin({ left: 15 })

        // 波形图标
        Text('♫')
          .fontSize(18)
          .width(30)
          .textAlign(TextAlign.Center)
      }
    }
    .padding(15)
    // .border({ bottom: { width: 1, color: 'rgba(255, 255, 255, 0.1)' } })
    .width('100%')
  }

  @Builder
  buildTextInput() {
    Column() {
      TextArea({ placeholder: '添加视频描述...' })
        .width('100%')
        .height(100)
        .backgroundColor('rgba(255, 255, 255, 0)')
        .fontColor('#fff')
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

        Text(`${this.charCount}/200`)
          .fontSize(14)
          .opacity(0.7)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 10 })
      .width('100%')
    }
    .padding(15)
    .backgroundColor('rgba(255, 255, 255, 0.1)')
    .borderRadius(8)
    .margin(15)
  }

  @Builder
  buildPublishOptions() {
    Column() {
      this.buildOptionItem('谁可以看', '公开 ›')
      this.buildOptionItem('允许评论', '所有人 ›')
      this.buildOptionItem('分享到动态', '开启 ›')
    }
    .margin(15)
  }

  @Builder
  buildOptionItem(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(14)

      Text(value)
        .fontSize(14)
        .opacity(0.7)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ top: 12, bottom: 12 })
    // .border({ bottom: { width: 1, color: 'rgba(255, 255, 255, 0.1)' } })
    .width('100%')
  }

  @Builder
  buildBottomNav() {
    Row() {
      this.buildNavItem('🏠', '首页', false)
      this.buildNavItem('🔍', '发现', false)
      this.buildNavItem('+', '创建', true)
      this.buildNavItem('💬', '消息', false)
      this.buildNavItem('👤', '我', false)
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor('rgba(0, 0, 0, 0.8)')
    .padding(16)
    // .border({ top: { width: 1, color: 'rgba(255, 255, 255, 0.1)' } })
    .width('100%')
    .position({ x: 0, y: 0 })
  }

  @Builder
  buildNavItem(icon: string, label: string, isActive: boolean) {
    Column() {
      Text(icon)
        .fontSize(24)
        .fontColor(isActive ? '#FF0050' : '#fff')

      Text(label)
        .fontSize(12)
        .fontColor(isActive ? '#FF0050' : '#fff')
    }
  }
}
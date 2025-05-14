import router from '@ohos.router';

@Entry
@Component
struct ProfileCenter {
  @State currentTab: string = 'works'
  @State currentBottomTab: number = 4 // 默认选中"我"的标签页

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 返回按钮
      Image($r('app.media.icon_back'))
        .width(30)
        .height(30)
        .margin({ top: 20, left: 20 })
        .onClick(() => {
          router.back()
        })

      // 头部信息
      Column() {
        // 头像
        Image($r('app.media.profile2'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .border({ width: 2, color: 'rgba(255,255,255,0.2)' })
          .margin({ bottom: 15 })

        // 用户名
        Text('用户昵称')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ bottom: 8 })

        // 简介
        TextInput({placeholder:'这是个人简介，分享你的个人生活与态度'})
          .type(InputType.Normal)
          .fontSize(14)
          .fontColor(Color.White)
          .margin({ bottom: 15 })
          .textAlign(TextAlign.Center)

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
          .fontColor(Color.Black)
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
      .padding(30)
      .alignItems(HorizontalAlign.Center)

      // 内容网格
      Scroll() {
        if (this.currentTab === 'collections') {
          Grid() {
            GridItem() {
              // this.ContentItem($r('app.media.album_cover2'), 58)
            }
            GridItem() {
              // this.ContentItem($r('app.media.background1'), 36)
            }
            GridItem() {
              // this.ContentItem($r('app.media.profile1'), 24)
            }
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .columnsGap(2)
          .rowsGap(2)
          .width('100%')
          .height('100%')
        } else if (this.currentTab === 'works') {
          Grid() {
            GridItem() {
              // this.ContentItem($r('app.media.background1'), 42)
            }
            GridItem() {
              // this.ContentItem($r('app.media.album_cover1'), 18)
            }
            GridItem() {
              // this.ContentItem($r('app.media.album_cover2'), 26)
            }
            GridItem() {
              // this.ContentItem($r('app.media.profile1'), 32)
            }
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .columnsGap(2)
          .rowsGap(2)
          .width('100%')
          .height('100%')
        } else if (this.currentTab === 'likes') {
          Grid() {
            GridItem() {
              // this.ContentItem($r('app.media.profile2'), 87)
            }
            GridItem() {
              // this.ContentItem($r('app.media.album_cover1'), 65)
            }
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .columnsGap(2)
          .rowsGap(2)
          .width('100%')
          .height('100%')
        } else {
          Grid() {
            GridItem() {
              // this.ContentItem($r('app.media.background1'), 42)
            }
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .columnsGap(2)
          .rowsGap(2)
          .width('100%')
          .height('100%')
        }
      }
      .width('100%')
      .height('50%')
      .margin({ top: '40%' })

      // 底部导航栏
      Tabs({ barPosition: BarPosition.End, index: this.currentBottomTab }) {
        TabContent() {}.tabBar(this.TabBuilder('首页', 0, $r('app.media.icon_home')))
        TabContent() {}.tabBar(this.TabBuilder('发现', 1, $r('app.media.icon_search')))
        TabContent() {}.tabBar(this.TabBuilder('创建', 2, $r('app.media.icon_add')))
        TabContent() {}.tabBar(this.TabBuilder('消息', 3, $r('app.media.icon_message')))
        TabContent() {}.tabBar(this.TabBuilder('我', 4, $r('app.media.icon_profile')))
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
        }
      })
      .position({ x: 0, y: '100% - 60vp' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  @Builder ContentItem(image: Resource, likes: number) {
    Stack() {
      Image(image)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Row() {
        Image($r('app.media.icon_heart'))
          .width(12)
          .height(12)
        Text(likes.toString())
          .fontSize(12)
          .fontColor(Color.White)
      }
      .position({ x: '85%', y: '85%' })
    }
    .aspectRatio(1)
    .backgroundColor('#333')
  }

  @Builder TabBuilder(title: string, index: number, icon: Resource) {
    Column() {
      Image(icon)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
        .margin({ bottom: 4 })
        .colorBlend(this.currentBottomTab === index ? '#FF0050' : '#666')

      Text(title)
        .fontSize(12)
        .fontColor(this.currentBottomTab === index ? '#FF0050' : '#666')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
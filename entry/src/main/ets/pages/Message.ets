import router from '@ohos.router';
import { PrivateMessage, NotificationGroup, NotificationItem } from '../Support/MessageData'


@Entry
@Component
struct Messages {
  @State currentTab: string = 'private'
  @State expandedMessages: number[] = []
  @State currentBottomTab: number = 3 // 消息tab默认选中

  // 消息数据
  privateMessages: PrivateMessage[] = [
    {
      id: 1,
      avatar: $r('app.media.profile2'),
      name: '舞蹈达人',
      time: '12:30',
      preview: '你好，请问你对最新的舞蹈视频有什么建议吗？我觉得你的动作编排很专业！希望能和你多交流学习一下...',
      unread: 2,
      fullText: '你好，请问你对最新的舞蹈视频有什么建议吗？我觉得你的动作编排很专业！希望能和你多交流学习一下，我最近在排练一个新的舞蹈作品，关于现代舞与传统民族舞结合的主题。'
    },
  // 其他消息数据...
  ]

  notifications: NotificationGroup[] = [
    {
      type: 'today',
      items: [
        {
          id: 1,
          avatar: $r('app.media.profile2'),
          name: '舞蹈达人',
          action: '评论了你的视频',
          time: '30分钟前',
          comment: '这个动作编排真不错，我很喜欢！'
        },
      ]
    }
  ]

  build() {
    Column() {
      // 头部区域
      Column() {
        Row() {
          Image($r('app.media.icon_back'))
            .width(24)
            .height(24)
            .onClick(() => {
              router.back()
            })

          Text('消息')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .padding(10)

        // 标签页
        Row() {
          Text('私信')
            .fontSize(16)
            .fontColor(this.currentTab === 'private' ? '#FF0050' : Color.White)
            .padding(10)
            .border({ width: { bottom: this.currentTab === 'private' ? 2 : 0 }, color: '#FF0050' })
            .onClick(() => {
              this.currentTab = 'private'
            })

          Text('通知')
            .fontSize(16)
            .fontColor(this.currentTab === 'notification' ? '#FF0050' : Color.White)
            .padding(10)
            .border({ width: { bottom: this.currentTab === 'notification' ? 2 : 0 }, color: '#FF0050' })
            .onClick(() => {
              this.currentTab = 'notification'
            })

          Text('@我')
            .fontSize(16)
            .fontColor(this.currentTab === 'mention' ? '#FF0050' : Color.White)
            .padding(10)
            .border({ width: { bottom: this.currentTab === 'mention' ? 2 : 0 }, color: '#FF0050' })
            .onClick(() => {
              this.currentTab = 'mention'
            })

          Text('评论')
            .fontSize(16)
            .fontColor(this.currentTab === 'comment' ? '#FF0050' : Color.White)
            .padding(10)
            .border({ width: { bottom: this.currentTab === 'comment' ? 2 : 0 }, color: '#FF0050' })
            .onClick(() => {
              this.currentTab = 'comment'
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)

        // 搜索栏
        Row() {
          Image($r('app.media.search'))
            .width(16)
            .height(16)
            .margin({ right: 10 })
            .colorFilter(Color.White)

          TextInput({ placeholder: '搜索联系人或消息' })
            .fontSize(14)
            .fontColor(Color.White)
            .placeholderColor('rgba(255,255,255,0.5)')
            .width('90%')
            .height(32)
        }
        .width('90%')
        .height(40)
        .backgroundColor('rgba(255,255,255,0.1)')
        .borderRadius(20)
        .padding(10)
        .margin({ top: 10, bottom: 10 })
        .alignSelf(ItemAlign.Center)
      }
      .backgroundColor(Color.Black) // 确保头部区域背景为黑色

      // 内容区域
      Column() {
        Scroll() {
          if (this.currentTab === 'private') {
            Column() {
              ForEach(this.privateMessages, (item: PrivateMessage) => {
                Column() {
                  Row() {
                    Image(item.avatar)
                      .width(50)
                      .height(50)
                      .borderRadius(25)
                      .margin({ right: 15 })

                    Column() {
                      Row() {
                        Text(item.name)
                          .fontSize(16)
                          .fontWeight(FontWeight.Bold)
                          .fontColor(Color.White)
                          .layoutWeight(1)
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })

                        Text(item.time)
                          .fontSize(12)
                          .fontColor('rgba(255,255,255,0.7)')
                      }

                      Column() {
                        Text(this.expandedMessages.includes(item.id) ? item.fullText : item.preview)
                          .fontSize(14)
                          .fontColor('rgba(255,255,255,0.8)')
                          .maxLines(this.expandedMessages.includes(item.id) ? undefined : 2)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                      }
                      .border({
                        width: 1,
                        color: 'rgba(255,255,255,0.1)',
                        radius: 8
                      })
                      .padding(8)
                      .width('100%')
                      .margin({ top: 8 })

                      if (item.fullText.length > 100) {
                        Text(this.expandedMessages.includes(item.id) ? '收起' : '展开')
                          .fontSize(12)
                          .fontColor('#FF0050')
                          .margin({ top: 8 })
                          .onClick(() => {
                            if (this.expandedMessages.includes(item.id)) {
                              this.expandedMessages = this.expandedMessages.filter(id => id !== item.id)
                            } else {
                              this.expandedMessages.push(item.id)
                            }
                          })
                      }
                    }
                    .width('70%')
                  }
                  .width('100%')
                  .padding(15)
                }
                .border({
                  width: 1,
                  color: 'rgba(255,255,255,0.1)',
                  radius: 12
                })
                .margin({ bottom: 12 })
                .onClick(() => {
                  if (this.expandedMessages.includes(item.id)) {
                    this.expandedMessages = this.expandedMessages.filter(id => id !== item.id)
                  } else {
                    this.expandedMessages.push(item.id)
                  }
                })
              })
            }
          } else if (this.currentTab === 'notification') {
            Column() {
              ForEach(this.notifications, (group: NotificationGroup) => {
                Column() {
                  Row() {
                    Text('今天')
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(Color.White)
                      .layoutWeight(1)

                    Text('清空')
                      .fontSize(14)
                      .fontColor('#FF0050')
                  }
                  .padding(15)

                  ForEach(group.items, (item: NotificationItem) => {
                    Column() {
                      Row() {
                        Image(item.avatar)
                          .width(40)
                          .height(40)
                          .borderRadius(20)
                          .margin({ right: 10 })

                        Column() {
                          Row() {
                            Text(item.name)
                              .fontSize(14)
                              .fontWeight(FontWeight.Bold)
                              .fontColor(Color.White)

                            Text(item.action)
                              .fontSize(14)
                              .fontColor('rgba(255,255,255,0.8)')
                          }

                          Text(item.time)
                            .fontSize(12)
                            .fontColor('rgba(255,255,255,0.7)')

                          if (item.comment) {
                            Text(item.comment)
                              .fontSize(13)
                              .fontColor('rgba(255,255,255,0.8)')
                              .backgroundColor('rgba(255,255,255,0.1)')
                              .borderRadius(8)
                              .padding(10)
                              .margin({ top: 5 })
                          }
                        }
                      }
                    }
                    .padding(15)
                    .border({ width: { bottom: 1 }, color: 'rgba(255,255,255,0.1)' })
                  })
                }
              })
            }
          } else if (this.currentTab === 'mention') {
            Column() {
              Text('@')
                .fontSize(60)
                .fontColor('rgba(255,255,255,0.5)')
                .margin({ top: 100, bottom: 20 })
                .textAlign(TextAlign.Center)
                .width('100%')

              Text('暂无@提及')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
                .width('100%')

              Text('当有人@你时，会显示在这里')
                .fontSize(14)
                .fontColor('rgba(255,255,255,0.7)')
                .textAlign(TextAlign.Center)
                .width('100%')
            }
            .height(300)
            .justifyContent(FlexAlign.Center)
          } else {
            Column() {
              // 评论内容...
            }
          }
        }
        .width('100%')
        .flexGrow(1)
      }
      .flexGrow(1)
      .backgroundColor(Color.Black) // 确保内容区域背景为黑色

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
    .backgroundColor(Color.Black)
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

import router from '@ohos.router';
import { PrivateMessage,NotificationGroup,NotificationItem } from '../Support/MessageData'

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
    {
      id: 2,
      avatar: $r('app.media.profile2'),
      name: '舞蹈达人',
      time: '12:30',
      preview: '你好，请问你对最新的舞蹈视频有什么建议吗？我觉得你的动作编排很专业！希望能和你多交流学习一下...',
      unread: 3,
      fullText: '你好，请问你对最新的舞蹈视频有什么建议吗？我觉得你的动作编排很专业！希望能和你多交流学习一下，我最近在排练一个新的舞蹈作品，关于现代舞与传统民族舞结合的主题。'
    },
    {
      id: 3,
      avatar: $r('app.media.profile2'),
      name: '舞蹈达人',
      time: '12:30',
      preview: '你好，请问你对最新的舞蹈视频有什么建议吗？我觉得你的动作编排很专业！希望能和你多交流学习一下...',
      unread: 3,
      fullText: '你好，请问你对最新的舞蹈视频有什么建议吗？我觉得你的动作编排很专业！希望能和你多交流学习一下，我最近在排练一个新的舞蹈作品，关于现代舞与传统民族舞结合的主题。'
    },
    {
      id: 4,
      avatar: $r('app.media.profile2'),
      name: '舞蹈达人',
      time: '12:30',
      preview: '你好，请问你对最新的舞蹈视频有什么建议吗？我觉得你的动作编排很专业！希望能和你多交流学习一下...',
      unread: 3,
      fullText: '你好，请问你对最新的舞蹈视频有什么建议吗？我觉得你的动作编排很专业！希望能和你多交流学习一下，我最近在排练一个新的舞蹈作品，关于现代舞与传统民族舞结合的主题。'
    },
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
      // 其他通知数据...
      ]
    },
  // 其他日期分组...
  ]

  build() {
    Column() {
      // 头部区域
      Column() {
        Row() {
          Image($r('app.media.icon_back'))
            .width(24)
            .height(24)
            .onClick(() => { router.back() })

          Text('消息')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Black)
            .layoutWeight(0.5)
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .padding(20)

        // 标签页
        Row() {
          Text('私信')
            .fontSize(16)
            .fontColor(this.currentTab === 'private' ? '#FF0050' : '#000')
            .padding(10)
            .border({ width: { bottom: this.currentTab === 'private' ? 2 : 0 }, color: '#FF0050' })
            .onClick(() => { this.currentTab = 'private' })

          Text('通知')
            .fontSize(16)
            .fontColor(this.currentTab === 'notification' ? '#FF0050' : '#000')
            .padding(10)
            .border({ width: { bottom: this.currentTab === 'notification' ? 2 : 0 }, color: '#FF0050' })
            .onClick(() => { this.currentTab = 'notification' })

          Text('@我')
            .fontSize(16)
            .fontColor(this.currentTab === 'mention' ? '#FF0050' : '#000')
            .padding(10)
            .border({ width: { bottom: this.currentTab === 'mention' ? 2 : 0 }, color: '#FF0050' })
            .onClick(() => { this.currentTab = 'mention' })

          Text('评论')
            .fontSize(16)
            .fontColor(this.currentTab === 'comment' ? '#FF0050' : '#000')
            .padding(10)
            .border({ width: { bottom: this.currentTab === 'comment' ? 2 : 0 }, color: '#FF0050' })
            .onClick(() => { this.currentTab = 'comment' })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)

        // 搜索栏
        Row() {
          Image($r('app.media.search'))
            .width(16)
            .height(16)
            .margin({ right: 10 })

          TextInput({ placeholder: '搜索联系人或消息' })
            .fontSize(14)
            .fontColor(Color.Gray)
            .placeholderColor(Color.White)
            .width('90%')
            .height(32)
        }
        .width('90%')
        .height(40)
        .backgroundColor(Color.Gray)
        .borderRadius(20)
        .padding(10)
        .margin({ top: 10, bottom: 10 })
        .alignSelf(ItemAlign.Center)
      }


      // 内容区域
      Column(){
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
                        .fontColor(Color.Black)
                        .layoutWeight(1)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })

                      Text(item.time)
                        .fontSize(12)
                        .fontColor(Color.Black)
                    }

                    // 消息内容部分添加边框
                    Column() {
                      Text(this.expandedMessages.includes(item.id) ? item.fullText : item.preview)
                        .fontSize(14)
                        .fontColor(Color.Gray)
                        .maxLines(this.expandedMessages.includes(item.id) ? undefined : 2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .border({
                      width: 1,
                      color: '#EEEEEE',
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
                color: '#EEEEEE',
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
                    .fontColor(Color.Black)
                    .layoutWeight(1)

                  Text('清空')
                    .fontSize(14)
                    .fontColor(Color.Black)
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
                            .fontColor(Color.Black)

                          Text(item.action)
                            .fontSize(14)
                            .fontColor(Color.Black)
                        }

                        Text(item.time)
                          .fontSize(12)
                          .fontColor(Color.Black)

                        if (item.comment) {
                          Text(item.comment)
                            .fontSize(13)
                            .fontColor(Color.Gray)
                            .backgroundColor(Color.Black)
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
      .flexGrow(1) // 填充剩余空间
    }
    .flexGrow(1) // 填充剩余空间

      Column() {
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
          if (index === 0) {
            router.pushUrl({ url: 'pages/Index' })
          } else if (index === 1) {
            router.pushUrl({ url: 'pages/Discover' })
          } else if (index === 2) {
            router.pushUrl({ url: 'pages/Create' })
          } else if (index === 4) {
            router.pushUrl({ url: 'pages/ProfileCenter' })
          }
        })
      }
      .width('100%')
      .height(60)
    }
    .width('100%')
    .height('100%')
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
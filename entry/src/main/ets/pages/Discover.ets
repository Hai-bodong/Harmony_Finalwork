import router from '@ohos.router';

// SongItemType 接口定义，增加 audioSrc
interface SongItemType {
  image: Resource // 图像路径
  name: string // 名称
  author: string // 作者
  id: string
  audioSrc: Resource // 音频文件资源路径
}

@Entry
@ComponentV2
struct Discover {
  @Local playIndex: number = -1
  songs: SongItemType[] = [
    {
      image: $r('app.media.logo'),
      name: '让风告诉你',
      author: '《原神》',
      id: '0000',
      audioSrc: $rawfile('song_2.mp3')
    },
    {
      image: $r('app.media.song_cover4'),
      name: '轻涟',
      author: '芙宁娜',
      id: '0001',
      audioSrc: $rawfile('song_1.mp3')
    },
    {
      image: $r('app.media.song_cover5'),
      name: '我不曾忘记',
      author: '可莉',
      id: '0002',
      audioSrc: $rawfile('song_2.mp3')
    },
    {
      image: $r('app.media.song_cover6'),
      name: '下一个远方',
      author: '丽莎',
      id: '0003',
      audioSrc: $rawfile('song_1.mp3')
    },
    {
      image: $r('app.media.song_cover7'),
      name: '经过',
      author: '芭芭拉',
      id: '0004',
      audioSrc: $rawfile('song_2.mp3')
    },
    {
      image: $r('app.media.song_cover8'),
      name: '你呀你呀',
      author: '凯亚 ',
      id: '0005',
      audioSrc: $rawfile('song_1.mp3')
    }
    // {
    //   image: $r('app.media.song_cover9'),
    //   name: '珍珠之歌',
    //   author: '雷泽',
    //   id: '0006',
    //   audioSrc: $rawfile('song_6.mp3')
    // },
    // {
    //   image: $r('app.media.song_cover10'),
    //   name: '冰封交响曲',
    //   author: '神里绫华',
    //   id: '0007',
    //   audioSrc: $rawfile('song_7.mp3')
    // },
    // {
    //   image: $r('app.media.song_cover11'),
    //   name: '同伴的力量',
    //   author: '琴',
    //   id: '0008',
    //   audioSrc: $rawfile('song_8.mp3')
    // },
    // {
    //   image: $r('app.media.song_cover12'),
    //   name: '皎洁的笑颜',
    //   author: '温迪',
    //   id: '0009',
    //   audioSrc: $rawfile('song_9.mp3')
    // },
    // {
    //   image: $r('app.media.song_cover13'),
    //   name: '璃月',
    //   author: '行秋 ',
    //   id: '0010',
    //   audioSrc: $rawfile('song_10.mp3')
    // },
    // {
    //   image: $r('app.media.song_cover14'),
    //   name: '稻妻',
    //   author: '珊瑚宫心海',
    //   id: '0011',
    //   audioSrc: $rawfile('song_11.mp3')
    // },
    // {
    //   image: $r('app.media.song_cover15'),
    //   name: '须弥',
    //   author: '纳西妲',
    //   id: '0012',
    //   audioSrc: $rawfile('song_12.mp3')
    // },
    // {
    //   image: $r('app.media.song_cover16'),
    //   name: '枫丹',
    //   author: '流浪者',
    //   id: '0013',
    //   audioSrc: $rawfile('song_13.mp3')
    // },
    // {
    //   image: $r('app.media.song_cover17'),
    //   name: '纳塔',
    //   author: '娜维娅',
    //   id: '0014',
    //   audioSrc: $rawfile('song_14.mp3')
    // },
    // {
    //   image: $r('app.media.song_cover18'),
    //   name: '阿瑠的歌',
    //   author: '枫原万叶',
    //   id: '0015',
    //   audioSrc: $rawfile('song_15.mp3')
    // }
  ]

  build() {
    Column() {
      Text('发现你喜欢')
        .fontColor('black')
        .width('100%')
        .margin({ bottom: 10 })
      List() {
        ForEach(this.songs, (item: SongItemType, index: number) => {
          ListItem() {
            Row() {
              // 图
              Stack() {
                Image(item.image)
                  .width(80)
                  .border({ radius: 8 })
                  .margin({ right: 10 })
                if (this.playIndex === index) { // 这个playIndex主要用于Discover页面的UI指示，播放器状态由AudioPlayer管理
                  Image($r('app.media.ic_wave'))
                    .width(24)
                }
              }
              // 字
              Column() {
                Text(item.name)
                  .fontColor('#F3F3F3')
                  .width('100%')
                  .fontWeight(700)
                  .margin({ bottom: 15 })
                Row() {
                  Text('VIP')
                    .fontColor('#9A8E28')
                    .border({ width: 1, color: '#9A8E28', radius: 12 })
                    .padding({
                      left: 5,
                      right: 5,
                      top: 3,
                      bottom: 3
                    })
                    .margin({ right: 10 })
                  Text(item.author)
                    .fontColor('#696969')
                }
                .width('100%')
              }
              .layoutWeight(1)
              // 更多
              Image($r('app.media.ic_more'))
                .width(24)
                .fillColor('#FEFEFE')
            }
            .width('100%')
            .height(80)
            .backgroundColor(Color.Black)
            .margin({ bottom: 10 })
            .onClick(() => {
              this.playIndex = index;
              router.pushUrl({
                url: 'pages/AudioPlayer',
                params: {
                  songs: this.songs,
                  currentIndex: index,
                }
              });
            })
          }
        })
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('white')
    .padding({ left: 10, right: 10 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])


  }
}

import router from '@ohos.router';
import { SongItemType } from '../Support/SongItemType'

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
  ]

  build() {
    Column() {
      Row(){
        Image($r('app.media.icon_back'))
          .width(24)
          .height(24)
          .margin({left:16})
          .onClick(()=>{
            if (Number(router.getLength()) > 1) {
              router.back();
            }
          });
        Text('发现你喜欢')
          .fontColor('#fff')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1) // 占据剩余空间
          .textAlign(TextAlign.Center)
          .margin({ right: 24 }); // 留出右侧返回按钮的占位空间
      }
      .width('100%')
      .height(56)
      .backgroundColor('#1E1E1E')
      .alignItems(VerticalAlign.Center)

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

// SongItemType 接口定义，增加 audioSrc
export interface  SongItemType {
  image: Resource // 图像路径
  name: string // 名称
  author: string // 作者
  id: string
  audioSrc: Resource // 音频文件资源路径
}
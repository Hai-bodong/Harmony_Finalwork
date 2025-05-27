// 定义视频数据类型
export interface VideoItem {
  id: number
  url: Resource
  author: string
  description: string
  likes: number
  comments: number
  avatar: Resource
}
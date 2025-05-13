// 在组件顶部添加类型定义
export interface  PrivateMessage {
  id: number;
  avatar: Resource;
  name: string;
  time: string;
  preview: string;
  unread: number;
  fullText: string;
}

export interface NotificationItem {
  id: number;
  avatar: Resource;
  name: string;
  action: string;
  time: string;
  comment?: string;
}

export interface NotificationGroup {
  type: string;
  items: NotificationItem[];
}
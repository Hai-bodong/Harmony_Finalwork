
@Entry
@Component
struct AudioPlayer {
  @State message:string = 'Hello World!';

  build() {
    Text(this.message)
  }
}


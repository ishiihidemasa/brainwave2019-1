public class recommendState extends State{
  void drawState() {
    background(100);
    textSize(64);
    text("あなたへのオススメ", width * 0.5, height * 0.3);
    textSize(32);
    text("sキーを押してスタートに戻る", width * 0.5, height * 0.8);    
  }
  
  State decideState() {
    if (keyPressed && key == 's'){  // もしスペースキーが押されたら
      background(basic);
      return new StartState();
    }
    return this;
  }
  
}

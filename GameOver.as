package {
  import org.flixel.*;
  public class GameOver extends FlxState {
    private var _scoreText:FlxText;

    override public function create():void {
      _scoreText = new FlxText(0,FlxG.height / 2, 480);
      _scoreText.size = 30;
      _scoreText.text = "FINAL SCORE\n" + String(FlxG.score);
      _scoreText.x = (FlxG.width - _scoreText.width) / 2
      _scoreText.y = (FlxG.height - _scoreText.height) / 2
    
      add(_scoreText);
    } 
  }
}

package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;

  public class GameOver extends FlxState {
    private var _scoreText:FlxText;
    private var _resetButton:FlxButton;

    override public function create():void {

      FlxG.mouse.show();

      FlxKongregate.submitStats("Score",FlxG.score);

      _scoreText = new FlxText(0,FlxG.height / 2, 480);
      _scoreText.size = 30;
      _scoreText.text = "FINAL SCORE\n" + String(FlxG.score);
      _scoreText.x = (FlxG.width - _scoreText.width) / 2
      _scoreText.y = (FlxG.height - _scoreText.height) / 2
      _scoreText.alignment = 'center'

      _resetButton = new FlxButton(FlxG.width/2-40, 300, 'Play again!', switchToPlayState); 
    
      add(_scoreText);
      add(_resetButton);
    } 

    private function switchToPlayState():void {
      FlxG.switchState(new PlayState);
    }
  }
}

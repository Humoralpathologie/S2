package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;

  public class SwitchLevel extends FlxState {
    private var _scoreText:FlxText;
    private var _storyBeat:FlxText;
    private var _playNextLevel:FlxButton;
    private var _replay:FlxButton;
    private var _backToMenu:FlxButton;

    private var _timer:FlxText;

    private var _preState:Class;
    private var _nextState:Class;    

    public function SwitchLevel(StoryBeat:String, preState:Class, nextState:Class, timer:String) {
      super();
      FlxG.mouse.show();

      _storyBeat = new FlxText(0, 30, 480);
      _storyBeat.size = 20;
      _storyBeat.text = StoryBeat;
      _storyBeat.x = (FlxG.width - _storyBeat.width) / 2;
      _storyBeat.alignment = 'center';



      FlxKongregate.submitStats("Score",FlxG.score);

      _scoreText = new FlxText(0,FlxG.height / 2, 480);
      _scoreText.size = 20;
      _scoreText.text = "FINAL SCORE: " + String(FlxG.score);
      _scoreText.x = (FlxG.width - _scoreText.width) / 2
      _scoreText.y = (FlxG.height - _scoreText.height) / 2
      _scoreText.alignment = 'center'

    
      _timer = new FlxText(0, 260, 480);
      _timer.size = 20;
      _timer.text = "DURATION: " + timer;
      _timer.x = (FlxG.width - _timer.width) / 2;
      _timer.alignment = 'center';
      
      _preState = preState;
      _nextState = nextState;

      
      _playNextLevel = new FlxButton(FlxG.width/2-40, 300, 'Next Level', switchToState(_nextState)); 
      _replay = new FlxButton(FlxG.width/2-40, 300 + 20, 'Replay', switchToState(_preState)); 
      _backToMenu = new FlxButton(FlxG.width/2-40, 320 + 20, 'Menu', switchToState(MenuState));      

      add(_scoreText);
      add(_storyBeat);
      add(_timer);

      add(_playNextLevel);
      add(_replay);
      add(_backToMenu);

    
    }

    public function switchToState(state:Class):Function {
      return function():void { FlxG.switchState(new state);}
    }

    public function gameOver():void {
      remove(_storyBeat);
      remove(_playNextLevel);      


    }

  }
}

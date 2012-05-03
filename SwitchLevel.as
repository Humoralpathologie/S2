package {
  import org.flixel.*;

  public class SwitchLevel extends FlxState {
    [Embed(source='assets/images/menu.png')] protected var Background:Class;
    [Embed(source='assets/images/replay.png')] protected var Replay:Class;
    [Embed(source='assets/images/back.png')] protected var Back:Class;
    [Embed(source='assets/images/next.png')] protected var Next:Class;
    //[Embed(source='assets/SnakeSounds/TailWhip.mp3')] protected var Whip:Class;
    [Embed(source='assets/SnakeSounds/mouseclick.mp3')] protected var ClickSound:Class;

    private var _scoreText:FlxText;
    private var _storyBeat:FlxText;
    private var _playNextLevel:FlxButton;
    private var _replay:FlxButton;
    private var _backToMenu:FlxButton;

    private var _scaled:Boolean;
    private var _resetScaled:Boolean;
    private var _background:FlxSprite;

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


      _background = new FlxSprite(10, -10);
      _background.loadGraphic(Background);      

      _playNextLevel = new FlxButton(FlxG.width/2+90, 400, '', switchToState(_nextState)); 
      _playNextLevel.loadGraphic(Next);
      _playNextLevel.onOver = scaleButton(_playNextLevel);
      _playNextLevel.onOut = resetScale(_playNextLevel);

      _replay = new FlxButton(FlxG.width/2-40, 350, '', switchToState(_preState)); 
      _replay.loadGraphic(Replay);
      _replay.onOver = scaleButton(_replay);
      _replay.onOut = resetScale(_replay);

      _backToMenu = new FlxButton(FlxG.width/2-120, 400, '', switchToState(MenuState));      
      _backToMenu.loadGraphic(Back);
      _backToMenu.onOver = scaleButton(_backToMenu);
      _backToMenu.onOut = resetScale(_backToMenu);
      add(_scoreText);
      add(_storyBeat);
      add(_timer);
      
      add(_background);

      add(_playNextLevel);
      add(_replay);
      add(_backToMenu);
      
    
    }

    public function switchToState(state:Class):Function {
      return function():void { FlxG.switchState(new state);}
    }

    public function gameOver():void {
      _storyBeat.text = "You failed T_T\nTry again!";
      remove(_playNextLevel);      
    }

    private function scaleButton(button:FlxButton):Function{
      return function ():void{
        if (!_scaled) {
          button.scale.x = 1.3;
          button.scale.y = 1.3;
          button.angle = 30;
          button.setSounds(null, 1.0, null, 1.0, ClickSound);
          _scaled = true;
          _resetScaled = false;
        } 
      }
    }

    private function resetScale(button:FlxButton):Function{
      return function ():void{
        if (!_resetScaled) {
          button.scale.x = 1;
          button.scale.y = 1;
          button.angle = 0;
          _resetScaled = true;
          _scaled = false;
        }

      }

    }

  } 
}

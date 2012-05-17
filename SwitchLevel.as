package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;
  import org.axgl.util.*;
  import com.gskinner.motion.*;
  import com.gskinner.motion.easing.*;

  public class SwitchLevel extends AxState {
    [Embed(source='assets/images/menu/menu_iphone_background.png')] protected var Background:Class;
    [Embed(source='assets/images/menu/menu_board.png')] protected var Board:Class;
    [Embed(source='assets/images/menu/menu-egg-redo.png')] protected var Replay:Class;
    [Embed(source='assets/images/menu/menu-egg-back.png')] protected var Back:Class;
    [Embed(source='assets/images/menu/menu-egg-next.png')] protected var Next:Class;
    //[Embed(source='assets/SnakeSounds/TailWhip.mp3')] protected var Whip:Class;
    [Embed(source='assets/SnakeSounds/mouseclick.mp3')] protected var ClickSound:Class;

    private var _playNextLevel:AxButton;
    private var _replay:AxButton;
    private var _backToMenu:AxButton;

    private var _background:AxSprite;
    private var _boardLeft:AxSprite;
    private var _boardRight:AxSprite;
    
    private var _scoreText:AxText;
    private var _counter:Object;
    private var _score:int;

    private var _preState:Class;
    private var _nextState:Class;    
    private var _tweens:Vector.<GTween>;

    public function SwitchLevel(preState:Class, nextState:Class) {
      super();
      
      _tweens = new Vector.<GTween>;
      _preState = preState;
      _nextState = nextState;

      _background = new AxSprite(0, 0, Background);

      _boardLeft = new AxSprite(60, 30, Board);    
      _boardRight = new AxSprite(_boardLeft.x + _boardLeft.width + 40, 30, Board);    
      
      _counter = {i: 0}
      _scoreText = new AxText(_boardLeft.x + 10, _boardLeft.y + 10, null, "Score: ");
      _scoreText.scale.x = _scoreText.scale.y = 2;

      var mid:int = 640 / 2 - 60;      

      _replay = new AxButton(mid, 330); 
      _replay.load(Replay, 120, 147)
      _replay.onClick(switchToState(_preState, _replay));

      _playNextLevel = new AxButton(mid + _replay.width + 10, _replay.y + 40);
      _playNextLevel.load(Next, 100, 110)
      _playNextLevel.onClick(switchToState(_nextState, _playNextLevel));

      _backToMenu = new AxButton(mid - 110, _replay.y + 40);
      _backToMenu.load(Back, 100, 110);
      _backToMenu.onClick(switchToState(MenuState, _backToMenu));

      add(_background);
      add(_boardLeft);
      add(_boardRight);
      
      add(_playNextLevel);
      add(_replay);
      add(_backToMenu);
      
      add(_scoreText);
    
    }
    
    public function set score(score:int):void {
      _score = score;
      var tween:GTween = new GTween(_counter, 3, {i: _score}, {ease: Exponential.easeOut});
      _tweens.push(tween);
    }

    override public function update():void {
      super.update();
        _scoreText.text = "Score: " + String(Math.floor(_counter.i));
    }

    public function switchToState(state:Class, button:AxButton):Function {
      return function():void { 
        Ax.switchState(new state);
      }
    }

    public function gameOver():void {
      remove(_playNextLevel);      
    }

  } 
}

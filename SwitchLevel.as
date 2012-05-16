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
    [Embed(source='assets/images/menu/bird.png')] protected var Bird:Class;
    //[Embed(source='assets/SnakeSounds/TailWhip.mp3')] protected var Whip:Class;
    [Embed(source='assets/SnakeSounds/mouseclick.mp3')] protected var ClickSound:Class;

    private var _playNextLevel:AxButton;
    private var _replay:AxButton;
    private var _backToMenu:AxButton;

    private var _background:AxSprite;
    private var _boardLeft:AxSprite;
    private var _boardRight:AxSprite;

    //birdemic birds
    private var _bird1:AxSprite;
    private var _bird2:AxSprite;
    private var _bird3:AxSprite;
    private var _birds:Object;
    private var triggered:Boolean = false;    

    private var _scoreText:AxText;
    private var _counter:Object;
    private var _score:int;
    private var _timeBonus:int;
    private var _liveBonus:int;
    private var _EXP:int;

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

      var mid:int = Ax.width / 2 - 60;      

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

      birdemic();

      add(_boardLeft);
      add(_boardRight);
      
  
      add(_playNextLevel);
      add(_replay);
      add(_backToMenu);
      
      add(_scoreText);
    
    }
    
    private function birdemic():void {
      _bird1 = new AxSprite(500, 50);
      _bird1.load(Bird, 140, 50);
      _bird1.scale.x = _bird1.scale.y = 0.3;
      _bird1.addAnimation("fly", [0,1,1,1,2,2,1], 4);

      _bird2 = new AxSprite(530, 40);
      _bird2.load(Bird, 140, 50);
      _bird2.scale.x = _bird2.scale.y = 0.5;
      _bird2.addAnimation("fly", [0,0,0,1,2,2,2,1], 4);

      _bird3 = new AxSprite(520, 80);
      _bird3.load(Bird, 140, 50);
      _bird3.scale.x = _bird3.scale.y = 0.2;
      _bird3.addAnimation("fly", [0,1,2,2], 4);

      _birds = {
        alpha1: 0,
        alpha2: 0,
        alpha3: 0
      }      
      _bird1.alpha = 0.0;
      _bird2.alpha = 0.0;
      _bird3.alpha = 0.0;

      add(_bird1);
      add(_bird2);
      add(_bird3);
    }
    
    private function trigger():void {
      if (_bird1.alpha > 0 && _bird2.alpha > 0 && _bird3.alpha > 0) {
        _bird1.animate("fly");
        _bird2.animate("fly");
        _bird3.animate("fly");

      }

      if ( !triggered && (_bird1.clicked() || _bird2.clicked() || _bird3.clicked())) {
        
        var func:Function = function(tween:GTween):void {
          triggered = false; 
          _tween.setValues({alpha1: 0, alpha2: 0, alpha3: 0});
          _tween.autoPlay = false;
        }
        triggered = true;
        var _tween:GTween = new GTween(_birds, 5, {alpha1: 1, alpha2: 1, alpha3: 1}, {onComplete: func});
        _tweens.push(_tween);
      }
      
        _bird1.alpha = Number(_birds.alpha1);
        _bird2.alpha = Number(_birds.alpha2);
        _bird3.alpha = Number(_birds.alpha3);
    }
    
    public function submitPoints(score:int, timeBonus:int, liveBonus:int, EXP:int):void {
      _score = score;
      _timeBonus = timeBonus;
      _liveBonus = liveBonus;
      _EXP = EXP;
    }
    public function set score(score:int):void {
      _score = score;
      var tween:GTween = new GTween(_counter, 3, {i: _score}, {ease: Exponential.easeOut});
      _tweens.push(tween);
    }

    override public function update():void {
      super.update();
      trigger();
        _scoreText.text = "SCORE: " + String(Math.floor(_counter.i));
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

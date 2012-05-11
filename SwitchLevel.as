package {
  import org.axgl.*;

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

    private var _scaled:Boolean;
    private var _resetScaled:Boolean;
    private var _background:AxSprite;
    private var _boardLeft:AxSprite;
    private var _boardRight:AxSprite;

    private var _preState:Class;
    private var _nextState:Class;    

    public function SwitchLevel(preState:Class, nextState:Class) {
      super();
      
      _preState = preState;
      _nextState = nextState;

      _background = new AxSprite(0, 0, Background);

      _boardLeft = new AxSprite(60, 30, Board);    
      _boardRight = new AxSprite(_boardLeft.x + _boardLeft.width + 40, 30, Board);    

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
      add(_boardLeft);
      add(_boardRight);
      
      add(_playNextLevel);
      add(_replay);
      add(_backToMenu);
      
    
    }

    public function switchToState(state:Class, button:AxButton):Function {
      return function():void { 
        Ax.switchState(new state);
      }
    }

    public function gameOver():void {
      remove(_playNextLevel);      
    }

    private function scaleButton(button:AxButton):Function{
      return function ():void{
        if (!_scaled) {
          button.scale.x = 1.3;
          button.scale.y = 1.3;
          button.angle = 30;
          //Button.setSounds(null, 1.0, null, 1.0, ClickSound);
          _scaled = true;
          _resetScaled = false;
        } 
      }
    }

    private function resetScale(button:AxButton):Function{
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

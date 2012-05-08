package {
  import org.axgl.*;

  public class SwitchLevel extends AxState {
    [Embed(source='assets/images/menu.png')] protected var Background:Class;
    [Embed(source='assets/images/replay.png')] protected var Replay:Class;
    [Embed(source='assets/images/back.png')] protected var Back:Class;
    [Embed(source='assets/images/next.png')] protected var Next:Class;
    //[Embed(source='assets/SnakeSounds/TailWhip.mp3')] protected var Whip:Class;
    [Embed(source='assets/SnakeSounds/mouseclick.mp3')] protected var ClickSound:Class;

    private var _playNextLevel:AxButton;
    private var _replay:AxButton;
    private var _backToMenu:AxButton;

    private var _scaled:Boolean;
    private var _resetScaled:Boolean;
    private var _background:AxSprite;


    private var _preState:Class;
    private var _nextState:Class;    

    public function SwitchLevel(StoryBeat:String, preState:Class, nextState:Class, timer:String) {
      super();
      
      _preState = preState;
      _nextState = nextState;

      _background = new AxSprite(10, -10);
      _background.load(Background);      

      _playNextLevel = new AxButton(Ax.width/2+90, 400);//, '', switchToState(_nextState)); 
      _playNextLevel.load(Next);
      _playNextLevel.onClick(switchToState(_nextState));
      //_playNextLevel.onOver(scaleButton(_playNextLevel));
      //_playNextLevel.onOut = resetScale(_playNextLevel);

      _replay = new AxButton(Ax.width/2-40, 350);//, '', switchToState(_preState)); 
      _replay.load(Replay);
      _replay.onClick(switchToState(_preState));
      //_replay.onOver(scaleButton(_replay));
      //_replay.onOut = resetScale(_replay);

      _backToMenu = new AxButton(Ax.width/2-120, 400);//, '', switchToState(MenuState));      
      _backToMenu.load(Back);
      _backToMenu.onClick(switchToState(MenuState));
      //_backToMenu.onOver(scaleButton(_backToMenu));
      //_backToMenu.onOut = resetScale(_backToMenu);
      add(_background);

      add(_playNextLevel);
      add(_replay);
      add(_backToMenu);
      
    
    }

    public function switchToState(state:Class):Function {
      return function():void { Ax.switchState(new state);}
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

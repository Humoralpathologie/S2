package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;
  import flash.text.*;
  import com.gskinner.motion.*;
  import com.gskinner.motion.easing.*;
  import flash.utils.*;
  
  public class MenuState extends AxState {

  [Embed(source='assets/SnakeSounds/SuperSnakeLoop.mp3')] protected var Music:Class;
  [Embed(source='assets/images/cover_schrift_gelb.png')] protected var Title:Class;
  [Embed(source='assets/images/cover_iphone4.png')] protected var Background:Class;
    
    private var _snakeTitleText:AxSprite;
    private var _bg:AxSprite;
    private var _playButton:AxButton;
    private var _playLevel:AxButton;    
    private var _lbButton:AxButton;    
    private var _arcadeButton:AxButton;
    private var _setting:AxButton;

    private var _menuBoard:AxSprite;
    private var _boardTween:GTween;
    private var _settingTween:GTween;
 
    override public function create():void {
      super.create();
      Ax.background = new AxColor(0,0,0);

      _bg = new AxSprite(0,0, Background);
      //_bg.load(Background);
     

      //_snakeTitleText = new AxSprite(0,0);
      //_snakeTitleText.load(Title);
  
      //Ax.music(Music);
      add(_bg);
      //add(_snakeTitleText);

      //Ax.mouse.show();
     
      makeButtons();
      menuSelections();
    }

    private function makeButtons():void{
      _playButton = new AxButton(640/2-40, 300); //, "New Story", switchToState(MovieState));
      _playButton.x = (640 - _playButton.width) / 2;
      _playButton.text("New Story");
      _playButton.onClick(switchToState(MovieState));
      _playLevel = new AxButton(640/2-40, 300 + 40); //, "Select Level", switchToState(LevelSelect));
      _playLevel.x = (640 - _playLevel.width) / 2;
      _playLevel.text("Select Level");
      _playLevel.onClick(switchToState(LevelSelect));
      _lbButton = new AxButton(640/2-40, 300 + 80); //, "Select Level", switchToState(LevelSelect));
      _lbButton.x = (640 - _lbButton.width) / 2;
      _lbButton.text("Leaderboard");
      _lbButton.onClick(switchToState(LeaderBoard));
      _arcadeButton = new AxButton(640/2-40, 300 + 120); //, "Select Level", switchToState(LevelSelect));
      _arcadeButton.x = (640 - _arcadeButton.width) / 2;
      _arcadeButton.text("ARCADE MODE YEAH");
      _arcadeButton.onClick(switchToState(ArcadeMenu));
      add(_playButton);
      add(_playLevel);   
      add(_arcadeButton);
      add(_lbButton);
    }

    private function menuSelections():void {
      _menuBoard = new AxSprite(0, Ax.height);
      _menuBoard.create(640, 30, 0xffffffff);
      add(_menuBoard);  
      _setting = new AxButton(_menuBoard.x + 10, _menuBoard.y + 5);
      _setting.text("SETTING");
      _setting.onClick(switchToState(ArcadeMenu));
      add(_setting);    
      _boardTween = new GTween(_menuBoard, 2, {y: Ax.height - 50});
      _settingTween = new GTween(_setting, 2, {y: Ax.height - 45});
    }

    private function switchToState(state:Class):Function {
      return function ():void {
        Ax.switchState(new state);
      }
    }

  }
}

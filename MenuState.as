package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;
  import flash.text.*;
  
  public class MenuState extends AxState {

  [Embed(source='assets/SnakeSounds/SuperSnakeLoop.mp3')] protected var Music:Class;
  [Embed(source='assets/images/cover_schrift_gelb.png')] protected var Title:Class;
  [Embed(source='assets/images/cover_hintergrund.png')] protected var Background:Class;
    
    private var _snakeTitleText:AxSprite;
    private var _bg:AxSprite;
    private var _playButton:AxButton;
    private var _playLevel:AxButton;    
    private var _lbButton:AxButton;    
    
    override public function create():void {
      super.create();
      Ax.background = new AxColor(0,0,0);

      _bg = new AxSprite(0,0);
      _bg.load(Background);
     

      _snakeTitleText = new AxSprite(0,0);
      _snakeTitleText.load(Title);
  
      //Ax.music(Music);
      add(_bg);     
      add(_snakeTitleText);

      //Ax.mouse.show();
     
      makeButtons();
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
      //var debugBtn:FlxButton = new FlxButton(0, _playLevel.y + _playLevel.height + 10, "Debug", switchToState(DebugState));
      //debugBtn.x = (FlxG.width - debugBtn.width) / 2; 
      add(_playButton);
      add(_playLevel);   
      add(_lbButton);
      //add(debugBtn);
    }

    private function switchToState(state:Class):Function {
      return function ():void {
        Ax.switchState(new state);
      }
    }

  }
}

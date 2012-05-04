package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;
  
  public class MenuState extends AxState {

  [Embed(source='assets/SnakeSounds/SuperSnakeLoop.mp3')] protected var Music:Class;
    
    private var _snakeTitleText:AxText;
    private var _playButton:AxButton;
    private var _playLevel:AxButton;    
    
    override public function create():void {
      super.create();
      Ax.background = new AxColor(0,0,0);

      _snakeTitleText = new AxText(0, 50, null,'SNAKE',Ax.width / 5, 'center');
      _snakeTitleText.scale.x = 5;
      _snakeTitleText.scale.y = 5;
  
      //Ax.music(Music);
      
      add(_snakeTitleText);

      //Ax.mouse.show();
      
      makeButtons();
    }

    private function makeButtons():void{
      _playButton = new AxButton(Ax.width/2-40, 300); //, "New Story", switchToState(MovieState));
      _playButton.x = (Ax.width - _playButton.width) / 2;
      _playButton.text("New Story");
      _playButton.onClick(switchToState(MovieState));
      _playLevel = new AxButton(Ax.width/2-40, 300 + 40); //, "Select Level", switchToState(LevelSelect));
      _playLevel.x = (Ax.width - _playLevel.width) / 2;
      _playLevel.text("Select Level");
      _playLevel.onClick(switchToState(LevelSelect));
      //var debugBtn:FlxButton = new FlxButton(0, _playLevel.y + _playLevel.height + 10, "Debug", switchToState(DebugState));
      //debugBtn.x = (FlxG.width - debugBtn.width) / 2; 
      add(_playButton);
      add(_playLevel);   
      //add(debugBtn);
    }

    private function switchToState(state:Class):Function {
      return function ():void {
        Ax.switchState(new state);
      }
    }

  }
}

package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;
  
  public class MenuState extends AxState {

  [Embed(source='assets/SnakeSounds/SuperSnakeLoop.mp3')] protected var Music:Class;
  [Embed(source='assets/images/SNAKE1.png')] protected var Title:Class;
    
    private var _snakeTitleText:AxSprite;
    private var _playButton:AxButton;
    private var _playLevel:AxButton;    
    
    override public function create():void {
      super.create();
      Ax.background = new AxColor(0,0,0);

      _snakeTitleText = new AxSprite(40,40);
      _snakeTitleText.load(Title,550,220);
      _snakeTitleText.addAnimation('nod', [2, 1, 0], 1);
      _snakeTitleText.animate('nod');
  
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
        Ax.pushState(new state);
      }
    }

  }
}

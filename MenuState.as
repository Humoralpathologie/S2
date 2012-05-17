package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;
  
  public class MenuState extends AxState {

  [Embed(source='assets/SnakeSounds/SuperSnakeLoop.mp3')] protected var Music:Class;
  [Embed(source='assets/images/cover_schrift_gelb.png')] protected var Title:Class;
  [Embed(source='assets/images/cover_hintergrund.png')] protected var Background:Class;
    
    private var _snakeTitleText:AxSprite;
    private var _bg:AxSprite;
    private var _playButton:AxButton;
    private var _playLevel:AxButton;    
    private var _arcadeButton:AxButton;
    
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
      _arcadeButton = new AxButton(640/2-40, 300 + 80); //, "Select Level", switchToState(LevelSelect));
      _arcadeButton.x = (640 - _arcadeButton.width) / 2;
      _arcadeButton.text("ARCADE MODE YEAH");
      _arcadeButton.onClick(switchToState(Arcade));
      add(_playButton);
      add(_playLevel);   
      add(_arcadeButton);
    }

    private function switchToState(state:Class):Function {
      return function ():void {
        Ax.switchState(new state);
      }
    }

  }
}

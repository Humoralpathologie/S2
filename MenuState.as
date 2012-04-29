package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;
  import org.flixel.plugin.photonstorm.FX.*;
  
  public class MenuState extends FlxState {

  [Embed(source='assets/SnakeSounds/SuperSnakeLoop.mp3')] protected var Music:Class;
    
    private var _sound:FlxSound;
    private var _snakeTitleFX:SineWaveFX;
    private var _snakeTitleText:FlxText;
    private var _snakeTitleSprite:FlxSprite;
    private var _playButton:FlxButton;
    private var _playLevel:FlxButton;    
    
    override public function create():void {

      if (FlxG.getPlugin(FlxSpecialFX) == null)
      {
        FlxG.addPlugin(new FlxSpecialFX);
      }

      _snakeTitleFX = FlxSpecialFX.sineWave();     
      _snakeTitleText = new FlxText(120,50,400,'SNAKE');
      _snakeTitleText.size = 100;
      _snakeTitleText.antialiasing = true;
      _snakeTitleText.alignment = 'center';
  
      _snakeTitleSprite = _snakeTitleFX.createFromFlxSprite(_snakeTitleText, SineWaveFX.WAVETYPE_VERTICAL_SINE,32, _snakeTitleText.width, 8);

      _snakeTitleFX.start();

      _sound = new FlxSound;
      _sound.loadEmbedded(Music, true);
      
      add(_sound);
      add(_snakeTitleSprite);

      _sound.fadeIn(5);
      FlxG.mouse.show();
      
      makeButtons();
    }

    private function makeButtons():void{
      _playButton = new FlxButton(FlxG.width/2-40, 300, "New Story", switchToState(Level1));
      _playLevel = new FlxButton(FlxG.width/2-40, 300 + 20, "Select Level", switchToState(LevelSelect));
      var debugBtn:FlxButton = new FlxButton(0, _playLevel.y + _playLevel.height + 10, "Debug", switchToState(DebugState));
      debugBtn.x = (FlxG.width - debugBtn.width) / 2; 
      add(_playButton);
      add(_playLevel);   
      add(debugBtn);
    }

    private function switchToState(state:Class):Function {
      return function ():void {
        FlxG.switchState(new state);
      }
    }

    override public function destroy():void {
      FlxSpecialFX.clear();
      super.destroy();
    }
  }
}

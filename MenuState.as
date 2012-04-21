package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;
  import org.flixel.plugin.photonstorm.FX.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
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

      FlxKongregate.init(apiHasLoaded);
      _sound.fadeIn(5);
      FlxG.mouse.show();
      
    }

    private function makeButtons():void{
      
    }

    private function apiHasLoaded():void
    {
      FlxKongregate.connect();
      _playButton = new FlxButton(FlxG.width/2-40, 300, 'Play Snake!', switchToState(PlayState, 'PlayState', 'None', 'None')); 
      _playLevel = new FlxButton(FlxG.width/2-40, 300 + 20, 'Portal!', switchToState(LevelState, 'Portal', 'None', 'None')); 
      add(_playButton);
      add(_playLevel);
    }

    private function switchToState(state:Class, title:String, objective:String, timeLimit:String):Function {
      return function ():void {
        var levelDescr:LevelDescription = new LevelDescription();
        levelDescr.initial(state, title, objective, timeLimit);
        FlxG.switchState(levelDescr);
      }

    }

    override public function destroy():void {
      FlxSpecialFX.clear();
      super.destroy();
    }
  }
}

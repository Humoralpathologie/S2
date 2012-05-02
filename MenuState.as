package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;
  import org.flixel.plugin.photonstorm.FX.*;
<<<<<<< HEAD
=======
  import flash.media.SoundMixer;
>>>>>>> aac9180f3ca820b70d636e1fa967794737cac4f2
  
  public class MenuState extends FlxState {

  [Embed(source='assets/SnakeSounds/SuperSnakeLoop.mp3')] protected var Music:Class;
  [Embed(source='assets/images/SNAKE1.png')] protected var Title:Class;
    
    private var _sound:FlxSound;
    //private var _snakeTitleFX:SineWaveFX;
    private var _snakeTitleFX:FloodFillFX;
    private var _snakeTitleText:FlxSprite;
    private var _snakeTitleSprite:FlxSprite;
    private var _playButton:FlxButton;
    private var _playLevel:FlxButton;    
<<<<<<< HEAD
    private var _updateRate:int;    

=======
    
>>>>>>> aac9180f3ca820b70d636e1fa967794737cac4f2
    override public function create():void {

      if (FlxG.getPlugin(FlxSpecialFX) == null)
      {
        FlxG.addPlugin(new FlxSpecialFX);
      }

      //_snakeTitleFX = FlxSpecialFX.sineWave();     
      _snakeTitleFX = FlxSpecialFX.floodFill();     

      _snakeTitleText = new FlxSprite(FlxG.width/2 - 275, 50);
      _snakeTitleText.loadGraphic(Title, true, false, 550, 220);
  
      _snakeTitleText = _snakeTitleFX.create(_snakeTitleText, _snakeTitleText.x, _snakeTitleText.y, _snakeTitleText.width, _snakeTitleText.height, 0, 5, true);

      _snakeTitleFX.start(0);
      
      _updateRate = 0;

      _sound = new FlxSound;
      _sound.loadEmbedded(Music, true);
      
      add(_sound);
      add(_snakeTitleText);

<<<<<<< HEAD
      makeButtons();
=======
      _sound.fadeIn(5);
>>>>>>> aac9180f3ca820b70d636e1fa967794737cac4f2
      FlxG.mouse.show();
      _sound.fadeIn(5);
      
      makeButtons();
    }

    override public function update():void {
      super.update();

      if (_updateRate == 70) {
        FlxG.log("updated 100");
        FlxG.shake();
        _snakeTitleText.addAnimation('nod', [2, 1, 0], 1);
        _snakeTitleText.play('nod');   
      }
  
      if (_updateRate <= 80) {
        _updateRate++
      }
    }

    private function makeButtons():void{
      _playButton = new FlxButton(FlxG.width/2-40, 300, "New Story", switchToState(MovieState));
      _playLevel = new FlxButton(FlxG.width/2-40, 300 + 20, "Select Level", switchToState(LevelSelect));
      var debugBtn:FlxButton = new FlxButton(0, _playLevel.y + _playLevel.height + 10, "Debug", switchToState(DebugState));
      debugBtn.x = (FlxG.width - debugBtn.width) / 2; 
      add(_playButton);
      add(_playLevel);   
<<<<<<< HEAD
      
    }

    
=======
      add(debugBtn);
    }

>>>>>>> aac9180f3ca820b70d636e1fa967794737cac4f2
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

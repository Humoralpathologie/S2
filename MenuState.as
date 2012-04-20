package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;
  import org.flixel.plugin.photonstorm.FX.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class MenuState extends FlxState {

    private var _snakeTitleFX:SineWaveFX;
    private var _snakeTitleText:FlxText;
    private var _snakeTitleSprite:FlxSprite;
    private var _playButton:FlxButton;

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

      add(_snakeTitleSprite);

      FlxKongregate.init(apiHasLoaded);

      FlxG.mouse.show();
      
    }

    private function apiHasLoaded():void
    {
      FlxKongregate.connect();
      _playButton = new FlxButton(FlxG.width/2-40, 300, 'Play Snake!', switchToState(PlayState)); 
      add(_playButton);
    }

    private function switchToState(state:Class):Function {
      return function():void{FlxG.switchState(new state)};
    }

    override public function destroy():void {
      FlxSpecialFX.clear();
      super.destroy();
    }
  }
}

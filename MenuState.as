package {
  import flash.utils.Dictionary;
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
    
    //Level description  
    private static var _level1:Array = [new Level1, "Level1", "Crossroads of Carnage", "Devour 100 Eggs", "None"];
    private static var _level2:Array = [new Level2, "Level2", "Make 20 Combos of 3(or more if you dare)", "None"];
//    private static var _level3:Array = [new Level3, "Snaking on Speed", "Survive the Food Poisoning", "None"];
    
    private static var _levels:Object = {l1: _level1, l2: _level2}; 

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
      var h:int = 300;
      for (var level:Object in _levels) {
        var levelButton:FlxButton;
        levelButton = new FlxButton(FlxG.width/2-40, h + 20, _levels[level][1], switchToState(_levels[level][0], _levels[level][2], _levels[level][3],  _levels[level][4]));
        h += 20;
        add(levelButton);
      } 
      
    }

    

    private function apiHasLoaded():void
    {
      FlxKongregate.connect();
      makeButtons();
    }

    private function switchToState(state:FlxState, title:String, objective:String, timeLimit:String):Function {
      return function ():void {
        var levelDescr:LevelDescription = new LevelDescription(state, title, objective, timeLimit);
        FlxG.switchState(levelDescr);
      }
    }

    override public function destroy():void {
      FlxSpecialFX.clear();
      super.destroy();
    }
  }
}

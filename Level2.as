package {
  import org.flixel.*;

  public class Level2 extends LevelState {
    // Assets
    [Embed(source='assets/images/level02bg.jpg')] protected var Background:Class;
    // Variablen
    protected var _background:FlxSprite = null;

    override protected function addBackgrounds():void {
      _background = new FlxSprite(0,0);
      _background.loadGraphic(Background);
      add(_background);
    }

    override protected function addObstacles():void {
      var stone:FlxSprite = new FlxSprite(180,225);      
      stone.makeGraphic(90,60,0x44ff00ff);
      _obstacles.add(stone);
      add(_obstacles);
    }

    override protected function spawnFood():void {
      reallySpawnFood(2);
    }
  }
}

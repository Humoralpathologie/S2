package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;
  import org.flixel.plugin.photonstorm.FX.*;

  public class Level3 extends LevelState {
    // Assets
    [Embed(source='assets/images/level02bg.jpg')] protected var Background:Class;
    // Variablen
    protected var _background:FlxSprite = null;
    protected var _hudText:FlxText;
    private var _snakePlasma:PlasmaFX;
    private var _snakePlasmaSprite:FlxSprite;

    private var _snakeGlitch:GlitchFX;    
    //private var _snakeStar:StarfieldFX;
    //private var _snakeStarSprite:FlxSprite;
 
    override public function create():void {
      super.create();
      if (FlxG.getPlugin(FlxSpecialFX) == null)
      {
        FlxG.addPlugin(new FlxSpecialFX);
      }

//      _snakeStar = FlxSpecialFX.starfield();
//      _snakeStar.setBackgroundColor(0x00);
//      _snakeStarSprite = _snakeStar.create(0, 0, 640, 480);
      _snakePlasma = FlxSpecialFX.plasma();
      _snakePlasmaSprite = _snakePlasma.create(0,0,160,120,8,8);
    
      add(_snakePlasmaSprite);
//      add(_snakeStarSprite);
    }

    override protected function addBackgrounds():void {
      _background = new FlxSprite(0,0);
      _background.loadGraphic(Background);
      _snakeGlitch = FlxSpecialFX.glitch();
      _background = _snakeGlitch.createFromFlxSprite(_background, 10, 10, true);
      _snakeGlitch.start(2);    
  
      add(_background);
    }

    override protected function addObstacles():void {
      var stone:FlxSprite = new FlxSprite(180,225);      
      stone.makeGraphic(75,45,0x00ff0000);
      _obstacles.add(stone);
      stone = new FlxSprite(195,240);
      stone.makeGraphic(75,45,0x000000ff);
      _obstacles.add(stone);
      add(_obstacles);
    }

    override protected function spawnFood():void {
      var newEgg:Egg;
      var n:Number = Math.random();
      if(n < 0.1) {
        newEgg = new Egg(Egg.ROTTEN);
      } else if(n < 0.4) {
        newEgg = new Egg(0);
      } else {
        newEgg = new Egg(1);
      }
      spawnEgg(newEgg);
    }

    override protected function addHud():void {
      _hudText = new FlxText(15,15, 640 - 60, "Nothing yet...");
      _hudText.size = 16;
      add(_hudText);
    }

    override protected function checkWinConditions():void {
      if(_combos >= 10 || _eggAmount >= 100 || _timerMin >= 4) {
        var switcher:SwitchLevel = new SwitchLevel("Conglaturation !!!\nYou have completed a great game.\nAnd prooved the justice of our culture.\nNow go and rest our heroes !", Level3, Level3, "111");
        FlxG.switchState(switcher); 
      }
    }

    override protected function updateHud():void {
      _hudText.text = "Score: " + String(_score) + "\n" + "Combos: " + String(_combos);
      _hudText.text += "\nTimer: " + _timerHud;
      _hudText.text += "\nSpeed: " + _snake.mps;
    }

    override protected function levelOver():void {
      FlxG.score = _score;
      _switchLevel = new SwitchLevel("You failed!\nTry again", Level3, Level3, _timerHud);
      _switchLevel.gameOver();
      FlxG.switchState(_switchLevel);
      
    }

    override protected function checkCombos(arr:Array):Array {
      var res:Array;

      var largerThanThree:Function = function(el:Array, i:int, arr:Array):Boolean { 
        return el.length >= 3;
      };
      
      var sameEggType:Function = function(currArr:Array, el:Object):Boolean{
        return ((currArr[0] as Egg).type == (el as Egg).type) && ((currArr[0] as Egg).type == 1);
      };

      res = groupArray(sameEggType,arr); 

      return res.filter(largerThanThree);
    }

    override public function destroy():void {
      FlxSpecialFX.clear();
      super.destroy();
    }
  }
}

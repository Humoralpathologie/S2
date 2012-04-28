package {
  import org.flixel.*;

  public class Level3 extends LevelState {
    // Assets
    [Embed(source='assets/images/level02bg.jpg')] protected var Background:Class;
    // Variablen
    protected var _background:FlxSprite = null;
    protected var _hudText:FlxText;

    override protected function addBackgrounds():void {
      _background = new FlxSprite(0,0);
      _background.loadGraphic(Background);
      add(_background);
    }

    override protected function addObstacles():void {
      var stone:FlxSprite = new FlxSprite(180,225);      
      stone.makeGraphic(75,45,0x44ff0000);
      _obstacles.add(stone);
      stone = new FlxSprite(195,240);
      stone.makeGraphic(75,45,0x440000ff);
      _obstacles.add(stone);
      add(_obstacles);
    }

    override protected function spawnFood():void {
      var newEgg:Egg;
      var n:Number = Math.random();
      if(n < 0.2) {
        newEgg = new Egg(Egg.ROTTEN);
      } else if(n < 0.5) {
        newEgg = new Egg(1);
      } else {
        newEgg = new Egg(0);
      }
      spawnEgg(newEgg);
    }

    override protected function addHud():void {
      _hudText = new FlxText(15,15, 640 - 60, "Nothing yet...");
      _hudText.size = 16;
      add(_hudText);
    }

    override protected function checkWinConditions():void {
      if(_combos >= 10) {
        var switcher:SwitchLevel = new SwitchLevel("Conglaturation !!!\nYou have completed a great game.\nAnd prooved the justice of our culture.\nNow go and rest our heroes !", Level2, Level2, "111");
        FlxG.switchState(switcher); 
      }
    }

    override protected function updateHud():void {
      _hudText.text = "Score: " + String(_score) + "\n" + "Combos: " + String(_combos);
      _hudText.text += "\nTimer: " + _timerHud;
      _hudText.text += "\nSpeed: " + _snake.mps;
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

  }
}

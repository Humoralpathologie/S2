package {
  import org.axgl.*;
  import org.axgl.text.*;

  public class Level2 extends LevelState {
    // Assets
    [Embed(source='assets/images/level02bg.jpg')] protected var Background:Class;
    // Variablen
    protected var _background:AxSprite = null;
    protected var _hudText:AxText;

    override protected function addBackgrounds():void {
      _background = new AxSprite(0,0);
      _background.load(Background);
      add(_background);
    }

    override protected function addObstacles():void {
      var stone:AxSprite = new AxSprite(180,225);      
      stone.create(75,45,0x00ff0000);
      _obstacles.add(stone);
      stone = new AxSprite(195,240);
      stone.create(75,45,0x000000ff);
      _obstacles.add(stone);
      add(_obstacles);
    }

    override protected function spawnFood():void {
      reallySpawnFood(2);
    }

    override protected function addHud():void {
      _hudText = new AxText(15,15,null,"Nothing yet") //, 640 - 60, "Nothing yet...");
      add(_hudText);
    }

    override protected function levelOver():void {
      _switchLevel = new SwitchLevel("You failed!\nTry again", Level2, Level2, _timerHud);
      _switchLevel.gameOver();
      Ax.switchState(_switchLevel);
      
    }

    override protected function checkWinConditions():void {
      if(_combos >= 10) {
        var switcher:SwitchLevel = new SwitchLevel("Conglaturation !!!\nYou have completed a great game.\nAnd prooved the justice of our culture.\nNow go and rest our heroes !", Level2, Level2, _timerHud);
        SaveGame.unlockLevel(2);
        Ax.switchState(switcher); 
      }
    }

    override protected function updateHud():void {
      var str:String = "Score: " + String(_score) + "\n" + "Combos: " + String(_combos);
      str += "\nTimer: " + _timerHud;
      str += "\nSpeed: " + _snake.mps;
      _hudText.text = str; 
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

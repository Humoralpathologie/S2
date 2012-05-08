package {
  import org.axgl.*;
  import org.axgl.text.*;

  public class Level3 extends LevelState {
    // Assets
    [Embed(source='assets/images/level3bg.png')] protected var Background:Class;
    // Variablen
    protected var _background:AxSprite = null;
    protected var _hudText:AxText;

    override protected function addBackgrounds():void {
      _background = new AxSprite(0,0);
      _background.load(Background, 640, 480);
      _background.addAnimation('morph',[0,1],8);
      _background.animate('morph');
      add(_background);
    }

    override protected function addObstacles():void {
      /*
      var stone:AxSprite = new AxSprite(180,225);      
      stone.create(75,45,0x00ff0000);
      _obstacles.add(stone);
      stone = new AxSprite(195,240);
      stone.create(75,45,0x000000ff);
      _obstacles.add(stone);
      add(_obstacles);
      */
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
      _hudText = new AxText(15,15, null, "Nothing yet...");
      add(_hudText);
    }

    override protected function checkWinConditions():void {
      if(_combos >= 10 || _eggAmount >= 100 || _timerMin >= 4) {
        var switcher:SwitchLevel = new SwitchLevel("Conglaturation !!!\nYou have completed a great game.\nAnd prooved the justice of our culture.\nNow go and rest our heroes !", Level3, Level3, "111");
        Ax.switchState(switcher); 
      }
    }

    override protected function updateHud():void {
      _hudText.text = "Score: " + String(_score) + "\n" + "Combos: " + String(_combos);
      _hudText.text += "\nTimer: " + _timerHud;
      _hudText.text += "\nSpeed: " + _snake.mps;
    }

    override protected function levelOver():void {
      _switchLevel = new SwitchLevel("You failed!\nTry again", Level3, Level3, _timerHud);
      _switchLevel.gameOver();
      Ax.switchState(_switchLevel);
      
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

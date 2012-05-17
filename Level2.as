package {
  import org.axgl.*;
  import org.axgl.text.*;

  public class Level2 extends LevelState {
    // Assets
    [Embed(source='assets/images/level02bg.jpg')] protected var Background:Class;
    // Variablen
    protected var _background:AxSprite = null;

    override public function create():void {
      super.create();
      _snake.lives = 3;
      Egg.ROTTEN = 100;      
      _switchLevel = new SwitchLevel( Level2, Level3);
    }

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
      var rand:int = Math.floor(Math.random() * 10);
      var egg:Egg;

      if (rand > 4) {
        egg = new Egg(2);  
      } else {
        egg = new Egg(Math.floor(Math.random() * 2)); 
      }

      spawnEgg(egg);
      
    }


    override protected function levelOver():void {
      SaveGame.saveScore(2, _score);
      _switchLevel.gameOver();
      _switchLevel.score = _score;
      Ax.switchState(_switchLevel);
      
    }

    override protected function checkWinConditions():void {
      if(_combos >= 10) {
        SaveGame.saveScore(2, _score);
        SaveGame.unlockLevel(3);
        _switchLevel.score = _score;
        Ax.switchState(_switchLevel);
      }
    }

    override protected function addHud():void {
      _hud = new Hud(["lives", "speed", "time", "score", "combo"]); 
      add(_hud);
    }

    override protected function updateHud():void {
      _hud.livesText = String(_snake.lives);
      _hud.timeText = _timerHud;
      _hud.speedText = (_snakeSpeed < 10) ? "0" + String(_snakeSpeed) : String(_snakeSpeed);
      _hud.scoreText = String(_score); 
      _hud.comboText = String(_combos) + "/10"; 
    }

    override protected function checkCombos(arr:Array):Array {
      var res:Array;

      var largerThanThree:Function = function(el:Array, i:int, arr:Array):Boolean { 
        return el.length >= 3;
      };
      
      var sameEggType:Function = function(currArr:Array, el:Object):Boolean{
        return ((currArr[0] as Egg).type == (el as Egg).type) && ((currArr[0] as Egg).type == 2);
      };

      res = groupArray(sameEggType,arr); 

      return res.filter(largerThanThree);
    }

  }
}

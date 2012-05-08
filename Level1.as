package {
  import org.axgl.*;
  import org.axgl.text.*;
  
  public class Level1 extends LevelState {
    // Assets
    [Embed(source='assets/images/level01bg.png')] protected var Background:Class;
    // Variablen
    private var _background:AxSprite = null;
    
    private var _hudText:AxText; 

    private var _storyBeat:String = "Level1 completed!";

    override public function create():void {
      super.create();
      _snake.lives = 1;
      Egg.ROTTEN = 100;      
    
    }

    override public function update():void {
      super.update();
      if (_eggAmount == 35 && _snake.lives != 2) {
        _snake.lives++;
        //_bup.play();
      }
    }
    
    override protected function addBackgrounds():void {
      _background = new AxSprite(0, 0, Background);
      add(_background);
    }
    
    override protected function addObstacles():void {
      var stone1:AxSprite = new AxSprite(135,0);      
      stone1.create(90,45,0x00ff00ff);
      var stone2:AxSprite = new AxSprite(150,15);      
      stone2.create(45,45,0x000000ff);
      _obstacles.add(stone1);
      _obstacles.add(stone2);
      add(_obstacles);
    }
    
    override protected function addHud():void {
      _hudText = new AxText(15,15, null, "Nothing yet...");
      add(_hudText);
    }
    override protected function updateHud():void {
      _hudText.text = "Score: " + String(_score) + "  Lives: " + _snake.lives;
      _hudText.text += "\nDevoured Eggs: " + String(_eggAmount) + "/50";
      _hudText.text += "\nTimer: " + _timerHud;
    }

    override protected function switchLevel():void {
      _switchLevel = new SwitchLevel("Level1 completed!", Level1, Level1, _timerHud);
      SaveGame.unlockLevel(1);
      Ax.switchState(_switchLevel);
    }

    override protected function levelOver():void {
      _switchLevel = new SwitchLevel(_storyBeat, Level1, Level1, _timerHud);
      _switchLevel.gameOver();
      Ax.switchState(_switchLevel);
    }

    override protected function spawnFood():void {
      var rand:int = Math.floor(Math.random() * 10);
      var egg:Egg;

      if (rand > 6) {
        egg = new Egg(2);  
      } else {
        egg = new Egg(Math.floor(Math.random() * 2)); 
      }

      spawnEgg(egg);
      
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

    override protected function checkWinConditions():void {
      if(_eggAmount >= 50) {
        switchLevel();
      }
    }

  }
}

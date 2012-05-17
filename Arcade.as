package {
  import org.axgl.*;
  import org.axgl.text.*;
  
  public class Arcade extends LevelState {
    // Assets
    [Embed(source='assets/images/arcade.png')] protected var Background:Class;
    // Variablen
    private var _background:AxSprite = null;
    
    override public function create():void {
      super.create();
      _snake.lives = 2;
      Ax.camera.bounds = new AxRect(0,0,990,900);
    }

    override public function update():void {
      super.update();
      if (_eggAmount == 35 && _snake.lives != 2) {
        _snake.lives++;
      }
    }
    
    override protected function onScreen(sprite:AxSprite):Boolean {
      return sprite.x > 0 && sprite.x < 990 && sprite.y > 0 && sprite.y < 900; 
    }
    
    override protected function addBackgrounds():void {
      _background = new AxSprite(0, 0, Background);
      add(_background);
    }
    
    override protected function addObstacles():void {
    }
    
    override protected function addHud():void {
      _hud = new Hud(["lives", "time", "score"]); 
      add(_hud);
    }
    override protected function updateHud():void {
      _hud.livesText = String(_snake.lives);
      _hud.timeText = _timerHud;
      _hud.scoreText = String(_score); 
    }

    override protected function switchLevel():void {
      SaveGame.saveScore(100, _score);
      Ax.switchState(new SwitchLevel(Arcade, MenuState));
    }

    override protected function levelOver():void {
      _switchLevel.gameOver();
      SaveGame.saveScore(100, _score);
      Ax.switchState(new MenuState);
    }

    override protected function spawnFood():void {
      var rand:int = Math.floor(Math.random() * 10);
      var egg:Egg;

      if (rand > 6) {
        egg = new Egg(2);  
      } else {
        egg = new Egg(Math.floor(Math.random() * 2)); 
      }
      egg.points = 2;
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
      if(_timerMin >= 3) {
        switchLevel();
      }
    }

  }
}

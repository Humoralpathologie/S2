package {
  import org.axgl.*;
  import org.axgl.text.*;

  public class Level3 extends LevelState {
    // Assets
    [Embed(source='assets/images/level3bg.png')] protected var Background:Class;
    // Variablen
    protected var _background:AxSprite = null;

    override public function create():void {
      super.create();
      _comboSet.addCombo(new FasterCombo);
      _snake.lives = 3;
      _levelNumber = 3;
      _switchLevel = new SwitchLevel(Level3, Level3);
    }
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
        newEgg = new Egg(2);
      }
      
      spawnEgg(newEgg);
    }

    override protected function addHud():void {
      _hud = new Hud(["lives", "speed", "time", "score", "combo", "poison"]); 
      add(_hud);
    }

    override protected function updateHud():void {
      _hud.livesText = String(_snake.lives);
      _hud.timeText = _timerHud;
      _hud.speedText = (_snakeSpeed < 10) ? "0" + String(_snakeSpeed) : String(_snakeSpeed);
      _hud.scoreText = String(111); 
      _hud.comboText = String(_combos) + "/10"; 
      _hud.poisonText = String(_poisonEgg);
    }

    override protected function checkWinConditions():Boolean {
      return(_combos >= 10 || _eggAmount >= 100 || _timerMin >= 4)
    }

    override protected function levelOver():void {
      _switchLevel.gameOver();
      Ax.switchState(_switchLevel);
      
    }

  }
}

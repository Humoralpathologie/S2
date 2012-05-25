package {
  import org.axgl.*;
  import org.axgl.text.*;
  
  public class Arcade extends LevelState {
    // Assets
    [Embed(source='assets/images/arcade.png')] protected var Background:Class;
    // Variablen
    private var _background:AxSprite = null;
    
    public function Arcade():void {
      super();
      _levelWidth = 990;
      _levelHeight = 900;
    }
    
    override public function create():void {
      super.create();
      
      _comboSet.addCombo(new FasterCombo);
      _comboSet.addCombo(new ShuffleCombo);
      _comboSet.addCombo(new ExtraLifeCombo);
      _comboSet.addCombo(new ExtraTimeCombo);
      _comboSet.addCombo(new NoRottenCombo);
      _comboSet.addCombo(new GoldenCombo);
      
      _switchLevel = new SwitchLevel(Arcade, MenuState);
      
      _snake.lives = 2;
      _levelNumber = 100;
      _timeLeft = 3 * 60;
    }

    override public function update():void {
      super.update();
      if (_eggAmount == 35 && _snake.lives != 2) {
        _snake.lives++;
      }
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
      _hud.timeText = String(_timeLeft.toFixed(1));
      _hud.scoreText = String(_score); 
    }

    override protected function switchLevel():void {
      SaveGame.saveScore(100, _score);
      _switchLevel.score = _score;
      Ax.switchState(_switchLevel);
    }

    override protected function levelOver():void {
      _switchLevel.gameOver();
      SaveGame.saveScore(100, _score);
      Ax.switchState(new MenuState);
    }

    override protected function spawnFood():void {
      var rand:int = Math.floor(Math.random() * 5);
      var egg:Egg;
      egg = new Egg(rand);
      spawnEgg(egg);
    }

    override protected function checkWinConditions():Boolean {
      return(_timeLeft < 0);
    }
  }
}

package {
  import org.axgl.*;
  import org.axgl.text.*;
  import com.gskinner.motion.*;
  import com.gskinner.motion.easing.*;
  
  public class Level1 extends LevelState {
    // Assets
    [Embed(source='assets/images/level01bg.png')] protected var Background:Class;
    [Embed(source='assets/images/BaumschattenAußenLV1.png')] protected var ShadowOut:Class;
    [Embed(source='assets/images/BaumschattenInnenLV1.png')] protected var ShadowIn:Class;
    // Variablen
    private var _background:AxSprite = null;
    private var _treeShadow1:AxSprite;
    private var _treeShadow2:AxSprite;
    private var _timer:int = 0;
    private var t1:GTween;
    private var t2:GTween;
    override public function create():void {
      super.create();

      _treeShadow1 = new AxSprite(Ax.width/2 - 600, Ax.height/2 - 450, ShadowOut);
      _treeShadow1.origin.x = Ax.width/2;
      _treeShadow1.origin.y = Ax.height/2;
      _treeShadow1.angle = -3;
      _treeShadow2 = new AxSprite(Ax.width/2 - 600, Ax.height/2 - 450, ShadowIn);
      _treeShadow2.origin.x = Ax.width/2;
      _treeShadow2.origin.y = Ax.height/2;
      _treeShadow2.angle = 4;
      _switchLevel = new SwitchLevel(Level1, Level2);
      _snake.lives = 1;
      animateShadow();     
      
      add(_treeShadow1);
      add(_treeShadow2);
    
    }

    private function animateShadow():void {
      t1 = new GTween(_treeShadow1, 5, {angle:5}, {reflect:true});
      t2 = new GTween(_treeShadow2, 5, {angle:-10}, {reflect:true});
      _tweens.push(t1); 
      _tweens.push(t2); 
    }


    override public function update():void {
      super.update();
      _timer++;
      if (_timer == 30) {
        t1.setValue("angle", Math.floor(Math.random() * 10) + 2);
        t2.setValue("angle", (Math.floor(Math.random() * 5) + 2) * -1);
        _timer = 0;
      }
      if (_eggAmount == 40 && _snake.lives != 2) {
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
      _hud = new Hud(["lives", "time", "score", "egg"]); 
      add(_hud);
    }
    override protected function updateHud():void {
      _hud.livesText = String(_snake.lives);
      _hud.timeText = _timerHud;
      _hud.eggText = String(_eggAmount) + "/50";
      _hud.scoreText = String(_score); 
    }

    override protected function switchLevel():void {
      SaveGame.unlockLevel(2);
      SaveGame.saveScore(1, _score);
      _switchLevel.score = _score;
      Ax.switchState(_switchLevel);
    }

    override protected function levelOver():void {
      _switchLevel.score = _score;
      _switchLevel.gameOver();
      SaveGame.saveScore(1, _score);
      Ax.switchState(_switchLevel);
    }

    override protected function spawnFood():void {
      var rand:int = Math.floor(Math.random() * 11);
      var egg:Egg;

      if (rand > 5) {
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
      if(_eggAmount >= 50) {
        switchLevel();
      }
    }

  }
}

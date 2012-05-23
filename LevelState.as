package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.particle.*;
  import org.axgl.render.*;
  import org.axgl.util.*;
  import org.axgl.input.*;
  import com.gskinner.motion.*;
  import com.gskinner.motion.easing.*;
  import flash.utils.*;
  import flash.debugger.enterDebugger;
  
  public class LevelState extends AxState {
    [Embed(source='assets/SnakeSounds/schluck2tiefer.mp3')] protected var BiteSound:Class;
    [Embed(source='assets/SnakeSounds/bup.mp3')] protected var Bup:Class;
    [Embed(source='assets/images/shell.png')] protected static var Shell:Class;
    [Embed(source='assets/images/hole.png')] protected var Hole:Class;
    
    /* 
    protected var _biteSound:FlxSound;
    protected var _bup:FlxSound;
    */

    protected var _hole:AxSprite;
    protected var _holeTween:GTween;    
  
    protected var _snake:Snake;
    protected var _food:AxGroup;
    protected var _score:int;
    protected var _bonusTimer:Number = 0;
    protected var _bonusTimerPoints:Number = 0;
    protected var _bonusBar:AxSprite;
    protected var _bonusBarColor:AxColor;
    protected var _bonusBack:AxSprite;
    protected var _obstacles:AxGroup;
    protected var _unspawnable:AxGroup;
    protected var _currentCombos:Array;
    protected var _comboTimer:Number = 0;
    protected var _combos:int = 0;
    protected var _eggAmount:int = 0;
    protected var _poisonEgg:int = 0;
    protected var _levelNumber:int = 0;

    protected var _timerSec:Number = 0;
    protected var _timerMin:Number = 0;    
    protected var _timerHud:String;

    protected var _snakeSpeed:int;
    protected var _hud:Hud;

    protected var _switchLevel:SwitchLevel;
    protected var _particles:AxGroup;

    protected var _shownDeathScreen:Boolean = false;
    protected var _shownWinScreen:Boolean = false;

    protected var _pointDirection:uint = 0;
    protected var _tweens:Vector.<GTween>;

    override public function create():void {
      super.create();
      
      Ax.zoom = 1.5;

      _tweens = new Vector.<GTween>;

      _particles = new AxGroup();
      var effect:AxParticleEffect = new AxParticleEffect('eat-egg', Shell, 5);
      effect.xVelocity = new AxRange(-70, 70);
      effect.yVelocity = new AxRange(-70, 70);
      effect.lifetime = new AxRange(0.5, 1.5);
      effect.amount = 4;
      effect.blend = AxBlendMode.PARTICLE;
      effect.color(new AxColor(0.3, 0.3, 0.3), new AxColor(1, 1, 1), new AxColor(0.3, 0.3, 0.3), new AxColor(1, 1, 1));
      _particles.add(AxParticleSystem.register(effect));

      effect = new AxParticleEffect('combo', Shell, 10);
      effect.amount = 100;
      effect.blend = AxBlendMode.PARTICLE;
      effect.aVelocity = new AxRange(170, 240);
      effect.color(new AxColor(0.3, 0.3, 0.3), new AxColor(0, 1, 1), new AxColor(1, 0, 0), new AxColor(1, 1, 1));
      
      _particles.add(AxParticleSystem.register(effect));

      _score = 0;
      _snake = new Snake(10);
      Ax.camera.follow(_snake.followBox);
      Ax.camera.bounds = new AxRect(0,0,640,480);
      _food = new AxGroup();

      _bonusBar = new AxSprite(450,32);
      _bonusBar.scale.x = 0;
      _bonusBar.create(1, 8, 0xffffffff);
      
      _bonusBack = new AxSprite(0, 0);
      _bonusBack.visible = false;
      _bonusBack.create(27, 10, 0x70000000);
      
      _bonusBarColor = new AxColor(0, 1, 0);
      _bonusBar.color = _bonusBarColor;

      _obstacles = new AxGroup();
      
      _hole = new AxSprite(150, 150);
      _hole.load(Hole);      
      _hole.width = 15;
      _hole.height = 15;
      _hole.offset.x = 15;

      _holeTween = new GTween(_hole, 2, {alpha: 1}, {ease: Exponential.easeOut});  
    
      _tweens.push(_holeTween);

      addBackgrounds();
      addObstacles();
  
      _unspawnable = new AxGroup();
      _unspawnable.add(_food);
      _unspawnable.add(_snake);
      _unspawnable.add(_obstacles);

      add(_hole);

      spawnFoods(3);
      add(_snake);
      add(_food);
      add(_particles);
      add(_bonusBack);
      add(_bonusBar);
      addHud();
    }

    /* Sort of abstract functions */
    protected function addBackgrounds():void {
    }

    protected function addObstacles():void {
    }

    protected function addHud():void {
    }

    protected function updateHud():void {
    }

    protected function spawnFoods(count:int):void {
      for(var i:int = 0; i < count; i++) {
        spawnFood();
      }
    }

    //to override in each level along with switchLevel()
    protected function levelOver():void {
    }
    
    protected function switchLevel():void {
      SaveGame.unlockLevel(_levelNumber + 1);
      SaveGame.saveScore(_levelNumber, _score);
      _switchLevel.score = _score;
      Ax.switchState(_switchLevel);
    }

    protected function updateTimers():void {
      _bonusTimer -= Ax.dt;
      _comboTimer -= Ax.dt;

      //for duration of the play
      //TODO: This should only seconds.
      _timerSec += Ax.dt;
      if (_timerSec >= 60) {
        _timerMin += 1;
        _timerSec = 0;
      }
      _timerHud = convertTimer();
    }

    protected function convertTimer():String {
      var _sec:String;
      var _min:String;
      //TODO: Use built-in functions
      if (Math.floor(_timerSec) < 10) {
        _sec = "0" + String(Math.floor(_timerSec));
      } else {
        _sec = String(Math.floor(_timerSec));
      }

      if (_timerMin < 10) {
        _min = "0" + String(_timerMin);
      } else {
        _min = String(_timerMin);
      }

      return _min + ":" + _sec;
    }    

    protected function updateBonusBar():void {
      // Displays as if bonus time ran for 2 seconds, even if it's actually 2.5
      if (_bonusTimer > 0.5) {
        _bonusBar.scale.x = ((_bonusTimer - 0.5) / 2) * 25;
        _bonusBar.color.green = ((_bonusTimer - 0.5) / 2);
        _bonusBar.color.red = 1 - _bonusBar.color.green;
      } else {
        if(_bonusTimer <= 0) {
          _bonusTimerPoints = 0;
        }
        _bonusBar.scale.x = 0;
        _bonusBack.visible = false;
      }

      _bonusBar.x = _snake.head.x - 5;
      _bonusBar.y = _snake.head.y - 24;
      _bonusBack.x = _bonusBar.x - 1;
      _bonusBack.y = _bonusBar.y - 1;
    }

    protected function collideFood():void {
      for(var i:int = 0; i < _food.members.length; i++){
        if(_snake.head.overlaps(_food.members[i])){
          eat(_snake.head, (_food.members[i] as Egg));
        }
      }
    }

    protected function onScreen(sprite:AxSprite):Boolean {
      return sprite.x > 0 && sprite.x < 640 && sprite.y > 0 && sprite.y < 480; 
    }

    protected function collideScreen():void {
      if(_snake.alive && !onScreen(_snake.head)) {
        _snake.die();
      }
    }

    protected function collideObstacles():void {
      if(_snake.alive && Ax.overlap(_snake.head, _obstacles)) {
        _snake.die();
      }
    }

    protected function fadeInHole():void {
      if (!_snake.alive) {
        _hole.alpha = 1;
      }
     }
    
    protected function fadeOutHole():void {
      if (_snake.tail.x >= 0 && _hole.alpha >= 1) {
        //enterDebugger(); 
        _snake.tail.alpha = 1;
        _holeTween.setValue("alpha", 0);
      }
      
    }

    protected function zoomKeys():void {
      if(Ax.keys.pressed(AxKey.PLUS)) {
        Ax.zoom += 0.1;
      }
      if(Ax.keys.pressed(AxKey.MINUS)) {
        Ax.zoom -= 0.1;
      }
    }

    override public function update():void {
      super.update();

      zoomKeys();

      _snakeSpeed = _snake.mps - 9;

      if (checkWinConditions()) {
       if (_shownWinScreen) {
         _switchLevel.score = _score;
          Ax.switchState(_switchLevel);
        } else {
          Ax.pushState(new SnakeWin);
          _shownWinScreen = true;
        }
      };      

      updateTimers();
      updateBonusBar();
      
      collideFood();
      collideScreen();
      collideObstacles();

      fadeInHole();
      if(_snake.lives <= 0) {
        levelOver();
      } else if(_snake.alive) {
        fadeOutHole();
        _shownDeathScreen = false;
      } else {
        if(_shownDeathScreen) {
          _snake.resurrectNext = true;
        } else {
          _shownDeathScreen = true;
          Ax.pushState(new SnakeDeath);
        }
      }

      doCombos();

      updateHud();
      //Ax.camera.follow(_snake.head);
    }

    protected function checkWinConditions():Boolean {
      return false;
    }

    protected function showPoints(egg:AxSprite, points:String, color:AxColor = null, dx:int = 0, dy:int = 0 ):void {
      var pointo:AxText = new AxText(egg.screen.x + dx, egg.screen.y + dy, null, points);
      pointo.scroll.x = 0;
      pointo.scroll.y = 0;
      pointo.scale.x = 2;
      pointo.scale.y = 2;
      if(color) {
        pointo.color = color;
      }
      var func:Function = function(tween:GTween):void {
        pointo.exists = false; 
      }
      //var tween:GTween = new GTween(pointo, 2, {x:(((_pointDirection + 1) % 4 < 2) ? 640 : 0), y:((_pointDirection % 4 < 2) ? 480 : 0), alpha: 0}, {onComplete: func});
      var tween:GTween = new GTween(pointo, 1, { x: 320, y: 0, alpha: 0 }, { onComplete: func, ease:Exponential.easeIn } );
      _tweens.push(tween);
      tween = new GTween(pointo.scale, 1, {x: 6, y: 6} );
      _tweens.push(tween);
      _pointDirection = (_pointDirection + 1) % 4
      add(pointo);
    } 


    protected function eat(snakeHead:AxSprite, egg:Egg):void {
      spawnFood();
      //_biteSound.play();

      var points:int = 0;
      _eggAmount++;

      AxParticleSystem.emit("eat-egg", snakeHead.x, snakeHead.y);

      _food.remove(egg);
            
      //if(egg.type != Egg.ROTTEN)
      if(egg.points > 0) {
        _snake.swallow(egg);
      } else {
        _poisonEgg++;
      }
      points += egg.points;
     
    
      if(_bonusTimer > 0) {
        _bonusTimerPoints += 2;
        showPoints(egg, '+' + String(_bonusTimerPoints), new AxColor(1,1,0,1),20,20);
        _score += _bonusTimerPoints;
      }

      _score += points;
      showPoints(egg, egg.points.toString(), ((points < 0) ? new AxColor(1,0,0,1) : null ));
      _bonusTimer = 2.5;
      _bonusBack.visible = true;

    }

    protected function removeAndExplodeCombo(combo:Array):void {
      var interval:int;
      var prefib:int = 1;
      var fib:int = 1;
      var temp:int = 0;

      for(var i:int = 0; i < combo.length; i++) {
        combo[i].removing = true;
      }

      var func:Function = function():void {
        if(combo.length > 0) {
          var egg:Egg = (combo.pop() as Egg);
          if(egg) {
            _score += fib;
            showPoints(egg, '+' + String(fib), new AxColor(Math.random(), Math.random(), Math.random(), 1));
            temp = fib; 
            fib+= prefib;
            prefib = temp;
            AxParticleSystem.emit("combo", egg.x, egg.y);
            _snake.body.remove(egg);
            
          } else {
            clearInterval(interval);
          }
        } else {
          clearInterval(interval);
        }
      }

      func();
      interval = setInterval(func, 300);
    }
    
    /*
     * Should be overridden for different scoring.
     */
    protected function doCombos():void {
      var combo:Array;
      var j:int, i:int;
      if(_currentCombos && _comboTimer <= 0) {
        for(j = 0; j < _currentCombos.length; j++) {
          combo = _currentCombos[j];
          _combos += 1;
          removeAndExplodeCombo(combo);
        }
        _snake.faster();
        _currentCombos = null;
      }
      if(_snake.justAte) {
        trace("checking for combos");
        //FlxG.log("checking for combos...");
        var bodyArray:Array = new Array();
        for(i = 0; i < _snake.body.members.length - 1; i++) {
          if(!(_snake.body.members[i] as Egg).removing) {
            bodyArray.push(_snake.body.members[i]);
          }
        }
        var combos:Array = checkCombos(bodyArray);
        if(combos.length > 0) {
          _currentCombos = combos;
          for(j = 0; j < _currentCombos.length; j++) {
            combo = _currentCombos[j];
            for(i = 0; i < combo.length; i++) {
              combo[i].flicker(2);
            }
          }
        }
        _comboTimer = 2;
      }
      
      //FlxG.score = _score;
    }

    /**
     * A generic helper function for grouping arrays.
     * You need to write a group function that takes two arguments:
     * - The current array
     * - The new element
     * The function then has to return true if the new element
     * belongs into the current array and false if it belongs
     * in a new one.
     */
    protected function groupArray(group:Function, arr:Array):Array {
      if(arr.length == 0) {
        return [];
      }

      var groups:Array = [[arr[0]]];
      for(var j:int = 1; j < arr.length; j++){
        var el:Object = arr[j];
        var currArr:Array = groups[groups.length - 1];
        if(group(currArr, el)) {
          currArr.push(el);
        } else {
          groups.push([el]);
        }
      }
      return groups;
    }
    
    /**
     * This has to be overridden in your level to actually check any combos.
     * It should check for all possible combos and return them in an array
     * of arrays.
     */
    protected function checkCombos(arr:Array):Array {
      return [];
    }

    protected function spawnFood():void {
      reallySpawnFood(3);
    }
    
    protected function reallySpawnFood(n:int):void {
      var egg:Egg = new Egg(Math.floor(Math.random() * n));
      spawnEgg(egg);
    }

    protected function spawnEgg(egg:Egg):void {
      var wTiles:int = 640 / 15;
      var hTiles:int = 480 / 15;
      wTiles -= 2; // Left and right;
      hTiles -= 7; // 6 top, 1 bottom;
      do {
        egg.x = int(1 + (Math.random() * wTiles)) * 15;
        egg.y = int(6 + (Math.random() * hTiles)) * 15;
      } while(Ax.overlap(egg,_unspawnable));
      _food.add(egg);
    }

    override public function dispose():void {
      for each(var tween:GTween in _tweens) {
        tween.end();
      }
      _tweens = null;
      Ax.zoom = 1;
      Ax.camera.reset();
      super.dispose();
    }
  }
}

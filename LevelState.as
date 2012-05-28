package {
  import org.axgl.*;
  import org.axgl.collision.AxGrid;
  import org.axgl.sound.*;
  import org.axgl.text.*;
  import org.axgl.particle.*;
  import org.axgl.render.*;
  import org.axgl.util.*;
  import org.axgl.input.*;
  import com.gskinner.motion.*;
  import com.gskinner.motion.easing.*;
  import flash.utils.*;
  import flash.debugger.enterDebugger;
  import flash.system.Capabilities;
  
  public class LevelState extends AxState {
    [Embed(source="/org/axgl/resource/Kroeger0665_Kopie.ttf", advancedAntiAliasing="true", fontFamily = "Kroeger", embedAsCFF="false")] public static const font:String;
    [Embed(source='assets/SoundFX/Fressen/Biss1.mp3')] protected var BiteSound:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt1.mp3')] protected var Bup1:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt2.mp3')] protected var Bup2:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt3.mp3')] protected var Bup3:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt4.mp3')] protected var Bup4:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt5.mp3')] protected var Bup5:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt6.mp3')] protected var Bup6:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt7.mp3')] protected var Bup7:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt8.mp3')] protected var Bup8:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt9.mp3')] protected var Bup9:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt10.mp3')] protected var Bup10:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt11.mp3')] protected var Bup11:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt12.mp3')] protected var Bup12:Class;
    [Embed(source='assets/SoundFX/KomboSounds/SchwanzEffekt13.mp3')] protected var Bup13:Class;
    [Embed(source='assets/images/shell.png')] protected static var Shell:Class;
    [Embed(source='assets/images/hole.png')] protected var Hole:Class;
    
    private var _font:AxFont;

    protected var _biteSound:AxSound;
    protected var _bup1:AxSound;
    protected var _bup2:AxSound;
    protected var _bup3:AxSound;
    protected var _bup4:AxSound;
    protected var _bup5:AxSound;
    protected var _bup6:AxSound;
    protected var _bup7:AxSound;
    protected var _bup8:AxSound;
    protected var _bup9:AxSound;
    protected var _bup10:AxSound;
    protected var _soundEffects:Array;

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
    
    protected var _levelWidth:int = 640;
    protected var _levelHeight:int = 480;

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
    
    protected var _comboSet:ComboSet = null;
    
    protected var _shuffleCount:int = -1;
    protected var _timeLeft:Number = -1;
    
    protected var _spawnRotten:Boolean = false;
    protected var _rottenEggs:AxGroup;
    protected var _rottenFrequency:Number = 10;
    protected var _rottenSpawnTimer:Number = 10;
    
    protected var _startPosition:AxPoint;
    
    public function LevelState() {
      super();
      _startPosition = new AxPoint(10, 10);
    }
    
    override public function create():void {
      super.create();
      
      _font = AxFont.fromFont("Kroeger", true, 25, true);      

      //sound effects
      _biteSound = new AxSound(BiteSound);
      _bup1 = new AxSound(Bup1);
      _bup2 = new AxSound(Bup2);
      _bup3 = new AxSound(Bup3);
      _bup4 = new AxSound(Bup4);
      _bup5 = new AxSound(Bup5);
      _bup6 = new AxSound(Bup6);
      _bup7 = new AxSound(Bup7);
      _bup8 = new AxSound(Bup8);
      _bup9 = new AxSound(Bup9);
      _bup10 = new AxSound(Bup10);
      _soundEffects = [_bup1, _bup2, _bup3, _bup4, _bup5, _bup6, _bup7, _bup8, _bup9, _bup10];     

      Ax.zoom = 1.5;
      
      _tweens = new Vector.<GTween>;
      
      _comboSet = new ComboSet();
      
      _rottenEggs = new AxGroup();

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
      _snake = new Snake(10, _startPosition);
      Ax.camera.follow(_snake.followBox);
      Ax.camera.bounds = new AxRect(0,0,_levelWidth,_levelHeight);
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
      add(_rottenEggs);
      add(_particles);
      add(_bonusBack);
      add(_bonusBar);
      addHud();
    }

    public function get snake():Snake {
      return _snake;
    }
    
    public function set timeLeft(time:Number):void {
      _timeLeft = time;
    }
    
    public function get timeLeft():Number {
      return _timeLeft;
    }
    
    public function get rottenEggs():AxGroup {
      return _rottenEggs;
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

    protected function submitPoints():void {
      var timeBonus:int = 30;
      var liveBonus:int = _snake.lives * 100;
      var _EXP:int = timeBonus + liveBonus + _score;
      _switchLevel.submitPoints(_score, timeBonus, liveBonus, _EXP);
    }
    
    //to override in each level along with switchLevel()
    protected function levelOver():void {
      _switchLevel.score = _score;
      _switchLevel.tweenPoints();
      _switchLevel.gameOver();
      Ax.switchState(_switchLevel);
    }
    
    protected function switchLevel():void {
      SaveGame.unlockLevel(_levelNumber + 1);
      SaveGame.saveScore(_levelNumber, _score);
      submitPoints();
      _switchLevel.tweenPoints();
      Ax.switchState(_switchLevel);
    }

    protected function updateTimers():void {
      _bonusTimer -= Ax.dt;
      _comboTimer -= Ax.dt;
      _rottenSpawnTimer -= Ax.dt;

      //for duration of the play
      //TODO: This should only count seconds.
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
        if(_snake.head.tileX == (_food.members[i] as SmoothBlock).tileX && _snake.head.tileY == (_food.members[i] as SmoothBlock).tileY) {
          _biteSound.play();
          eat(_snake.head, (_food.members[i] as Egg));
        }
      }
    }
    
    protected function collideRotten():void {
      for(var i:int = 0; i < _rottenEggs.members.length; i++){
        if(_snake.head.tileX == (_rottenEggs.members[i] as SmoothBlock).tileX && _snake.head.tileY == (_rottenEggs.members[i] as SmoothBlock).tileY) {
          eatRotten(_snake.head, (_rottenEggs.members[i] as Egg));
        }
      }
    }

    protected function onScreen(sprite:SmoothBlock):Boolean {
      return sprite.tileX * 15 >= 0 && sprite.tileX * 15 < _levelWidth && sprite.tileY * 15 >= 0 && sprite.tileY * 15 < _levelHeight; 
    }

    protected function collideScreen():void {
      if(_snake.alive && !onScreen(_snake.head)) {
        _snake.die();
      }
    }
    
    protected function collideObstacles():void {
      var spr:AxSprite = new AxSprite(_snake.head.tileX * 15, _snake.head.tileY * 15);
      spr.width = 15;
      spr.height = 15;
      if (_snake.alive && Ax.overlap(spr, _obstacles, null, new AxGrid(_levelWidth, _levelHeight))) {
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
    
    protected function debugKeys():void {
      if (Ax.keys.pressed(AxKey.A)) {
        spawnEgg(new Egg(EggTypes.EGGA));
      }
      if (Ax.keys.pressed(AxKey.B)) {
        spawnEgg(new Egg(EggTypes.EGGB));
      }
      if (Ax.keys.pressed(AxKey.C)) {
        spawnEgg(new Egg(EggTypes.EGGC));
      }
      if (Ax.keys.pressed(AxKey.S)) {
        spawnEgg(new Egg(EggTypes.SHUFFLE));
      }
      if (Ax.keys.pressed(AxKey.G)) {
        spawnEgg(new Egg(EggTypes.GOLDEN));
      }
      if (Ax.keys.pressed(AxKey.R)) {
        spawnEgg(new Egg(EggTypes.ROTTEN));
      }
    }

    override public function update():void {
      super.update();
      
      _timeLeft -= Ax.dt;

      zoomKeys();
      //if (Capabilities.isDebugger) {
        debugKeys();
      //}
      
      Ax.camera.follow(_snake.followBox);

      _snakeSpeed = _snake.mps - 9;

      if (checkWinConditions()) {
       if (_shownWinScreen) {
          switchLevel();
        } else {
          Ax.pushState(new SnakeWin);
          _shownWinScreen = true;
        }
      };      

      updateTimers();
      updateBonusBar();
      
      collideFood();
      collideRotten();
      collideScreen();
      collideObstacles();
      
      if (_spawnRotten) {
        spawnRotten();
      }

      fadeInHole();
      if (_snake.lives <= 0) {
        if(_shownDeathScreen) {
          levelOver();
        } else {
          _shownDeathScreen = true;
          Ax.pushState(new SnakeDeath);
        }
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
      var pointo:AxText = new AxText(egg.screen.x + dx, egg.screen.y + dy, _font, points);
      pointo.scroll.x = 0;
      pointo.scroll.y = 0;
      pointo.scale.x = 0.5;
      pointo.scale.y = 0.5;
      pointo.alpha = 0.7;
      if(color) {
        pointo.color = color;
      }
      var func:Function = function(tween:GTween):void {
        pointo.exists = false; 
      }
      //var tween:GTween = new GTween(pointo, 2, {x:(((_pointDirection + 1) % 4 < 2) ? 640 : 0), y:((_pointDirection % 4 < 2) ? 480 : 0), alpha: 0}, {onComplete: func});
      var tween1:GTween = new GTween(pointo, 1, {x: 320, y: 0, alpha: 0}, {onComplete: func, ease:Exponential.easeIn});
      var tween2:GTween = new GTween(pointo.scale, 1, {x: 4, y: 4} );
      _tweens.push(tween1);
      _tweens.push(tween2);
      _pointDirection = (_pointDirection + 1) % 4
      add(pointo);
    } 


    protected function eatRotten(snakeHead:AxSprite, egg:Egg):void {
      _poisonEgg++;
      _bonusTimer = 0;
      _bonusBack.visible = false;
      _score += egg.points;
      showPoints(egg, egg.points.toString(), new AxColor(1, 0, 0, 1));
      _rottenEggs.remove(egg);
    }
    
    protected function spawnRotten():void {
      if (_rottenSpawnTimer <= 0) {
        spawnEgg(new Egg(EggTypes.ROTTEN), true);
        _rottenSpawnTimer += _rottenFrequency;
      }
    }
    
    protected function eat(snakeHead:AxSprite, egg:Egg):void {
      spawnFood();

      var points:int = 0;
      _eggAmount++;

      AxParticleSystem.emit("eat-egg", snakeHead.x, snakeHead.y);

      _food.remove(egg);
            
      if(egg.points > 0 && egg.type < 5) {
        _snake.swallow(egg);
      }
      
      if (egg.type == EggTypes.SHUFFLE) {
        // http://www.milkisevil.com/blog/2010/as3-vector-shuffle-randomize/
        function shuffleVector( a:Object, b:Object ):int
        {
          return Math.floor( Math.random() * 3 - 1 );
        }
        var tail:AxSprite = _snake.tail;
        _snake.body.remove(tail);
        _snake.body.members.sort(shuffleVector);
        _snake.body.add(tail);
        _shuffleCount = _snake.body.members.length;
        _snake.justAte = true;
      }
      
      points += egg.points;
         
      if(_bonusTimer > 0) {
        _bonusTimerPoints += 2;
        showPoints(egg, '+' + String(_bonusTimerPoints), new AxColor(1,1,0,1),20,20);
        _score += _bonusTimerPoints;
      }

      _score += points;
      
      showPoints(egg, egg.points.toString(), ((points < 0) ? new AxColor(1, 0, 0, 1) : null ));
      _bonusTimer = 2.5;
      _bonusBack.visible = true; 
    }
    
    public function showMessage(message:String):void {
      var text:AxText = new AxText(snake.head.screen.x, snake.head.screen.y , _font, message);
      text.scroll.x = 0;
      text.scroll.y = 0;
      text.scale.x = 2;
      text.scale.y = 2;
      
      var func:Function = function(tween:GTween):void {
        text.exists = false; 
      }
      //var tween:GTween = new GTween(pointo, 2, {x:(((_pointDirection + 1) % 4 < 2) ? 640 : 0), y:((_pointDirection % 4 < 2) ? 480 : 0), alpha: 0}, {onComplete: func});
      var tween:GTween = new GTween(text, 1, { x: 320, y: 0, alpha: 0 }, { onComplete: func, ease:Exponential.easeIn } );
      _tweens.push(tween);
      
      add(text);
    }

    protected function removeAndExplodeCombo(combo:Array):void {
      var interval:int;
      var prefib:int = 2;
      var fib:int = 3;
      var temp:int = 0;
      var soundCounter:int = 0;
      var expoCounter:int = 0;

      for(var i:int = 0; i < combo.length; i++) {
        combo[i].removing = true;
      }

      var func:Function = function():void {
        if(combo.length > 0) {
          var egg:Egg = (combo.pop() as Egg);
          if(egg) {
            expoCounter++;
            _score += fib;
            showPoints(egg, '+' + String(fib), new AxColor(Math.random(), Math.random(), Math.random(), 1));
            temp = fib; 
            fib+= prefib;
            prefib = temp;
            _soundEffects[soundCounter].play();
            AxParticleSystem.emit("combo", egg.x, egg.y);
            _snake.body.remove(egg);
            soundCounter++;
            setTimeout(func, (300 / (expoCounter * expoCounter)) + 100 );
          } else {
            _combos += 1;
            //clearInterval(interval);
          }
        } else {
          _combos += 1;
          //clearInterval(interval);
        }
      }

      func();
      //interval = setInterval(func, 300);
    }
    
    /*
     * Should be overridden for different scoring.
     */
    protected function doCombos():void {
      var combo:Object;
      var j:int, i:int;
      if(_currentCombos && _comboTimer <= 0) {
        for(j = 0; j < _currentCombos.length; j++) {
          combo = _currentCombos[j];
          removeAndExplodeCombo(combo.eggs);
          combo.combo.effect(this);
          _combos += 1;
        }
        _currentCombos = null;
      }
      if(_snake.justAte) {
        trace("checking for combos");
        var bodyArray:Array = new Array();
        
        for(i = 0; i < _snake.body.members.length - 1; i++) {
          if(!(_snake.body.members[i] as Egg).removing) {
            bodyArray.push(_snake.body.members[i]);
          }
        }
        
        var combos:Array = _comboSet.checkCombos(bodyArray);
        if(combos.length > 0) {
          _currentCombos = combos;
          for(j = 0; j < _currentCombos.length; j++) {
            combo = _currentCombos[j].eggs;
            for(i = 0; i < combo.length; i++) {
              combo[i].flicker(2);
            }
          }
        }
        _comboTimer = 2;
      }
      
    }

    protected function spawnFood():void {
      reallySpawnFood(3);
    }
    
    protected function reallySpawnFood(n:int):void {
      var egg:Egg = new Egg(Math.floor(Math.random() * n));
      spawnEgg(egg);
    }

    public function spawnEgg(egg:Egg, rotten:Boolean = false):void {
      var wTiles:int = _levelWidth / 15;
      var hTiles:int = _levelHeight / 15;
      wTiles -= 2; // Left and right;
      hTiles -= 7; // 6 top, 1 bottom;
      do {
        egg.tileX = int(1 + (Math.random() * wTiles));
        egg.tileY = int(6 + (Math.random() * hTiles));
      } while (Ax.overlap(egg, _unspawnable, null, new AxGrid(_levelWidth, _levelHeight)));
      if (rotten) {
        _rottenEggs.add(egg);
      } else {
        _food.add(egg);
      }
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

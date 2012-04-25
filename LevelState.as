package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class LevelState extends FlxState {
    [Embed(source='assets/SnakeSounds/schluck2tiefer.mp3')] protected var BiteSound:Class;
    [Embed(source='assets/SnakeSounds/bup.mp3')] protected var Bup:Class;
    
  
    protected var _biteSound:FlxSound;
    protected var _bup:FlxSound;

    protected var _snake:Snake;
    protected var _food:FlxGroup;
    protected var _pointHud:Tween;
    protected var _score:int;
    protected var _map:FlxTilemap;
    protected var _level:FlxGroup;
    protected var _bonusTimer:Number = 0;
    protected var _bonusTimerPoints:Number = 0;
    protected var _bonusBar:FlxSprite;
    protected var _obstacles:FlxGroup;
    protected var _unspawnable:FlxGroup;
      
    override public function create():void {

      FlxG.log("Starting game");
     
      _bup = new FlxSound;
      _bup.loadEmbedded(Bup);

      _biteSound = new FlxSound;
      _biteSound.loadEmbedded(BiteSound);
      
      FlxG.mouse.hide();

      _score = 0;
      
      _snake = new Snake(8);
      _food = new FlxGroup();

      _hud = new FlxText(32,32,600,'0');
      _hud.size = 16;

      _bonusBar = new FlxSprite(450,32);
      _bonusBar.makeGraphic(1,8,0xffff0000);
      _bonusBar.origin.x = _bonusBar.origin.y = 0;
      _bonusBar.scale.x = 0;

      
      add(_bup);
      add(_biteSound);
      _obstacles = new FlxGroup();

      addBackgrounds();
      addObstacles();
  
      _unspawnable = new FlxGroup();
      _unspawnable.add(_food);
      _unspawnable.add(_snake);
      _unspawnable.add(_obstacles);

      spawnFoods(3);
      add(_snake);
      add(_food);
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

    protected function levelOver():void {
      FlxG.score = _score;
      FlxG.switchState(new GameOver);
    }
    
    protected function switchLevel():void {
    }

    override public function update():void {
      super.update();

      _bonusTimer -= FlxG.elapsed;


      if(_bonusTimer > 0) {
        _bonusBar.scale.x = (_bonusTimer / 2) * 25;
      } else {
        _bonusTimerPoints = 0;
        _bonusBar.scale.x = 0;
      }

      _bonusBar.x = _snake.head.x - 5;
      _bonusBar.y = _snake.head.y - 24;
      // I tried to use FlxG.overlap for this, but sometimes, the callback will
      // be called twice. This works, so leave it like this.
      for(var i:int = 0; i < _food.length; i++){
        if(_snake.head.overlaps(_food.members[i])){
          eat(_snake.head, _food.members[i]);
        }
      }
      if(_snake.alive && !_snake.head.onScreen()) {
        _snake.die();
      }
      if(_snake.alive && _snake.head.overlaps(_obstacles)) {
        _snake.die();
      }
      if(_snake.lives < 0) {
        levelOver();
      }

      updateHud();
    }

    protected function initPointHUD(egg:Egg, points:String, Color:uint = 0xffffffff, Delay:Number = 0.5, Speed:int = 1):void { 
      _pointHud = new Tween(Delay, 20, egg.x, egg.y, 40, Color, points, Speed); 
      add(_pointHud);  
    } 


    protected function eat(snakeHead:FlxSprite, egg:Egg):void {
      FlxG.log("Eating at " + snakeHead.x + ", " + snakeHead.y);
      spawnFood();
      _biteSound.play();

      // TODO: This allocates too many objects. Think about how to reduce this.
      var shells:FlxEmitter = egg.shells;
      var points:int = 0;
      shells.at(snakeHead);
      shells.start(true, 3);
      add(shells);

      _food.remove(egg, true);
      
      _snake.swallow(egg);
      points += egg.points;
     
        
      if(_bonusTimer > 0) {
        _bonusTimerPoints += 2;
        initPointHUD(egg, '+' + String(_bonusTimerPoints), 0xffedf249, 1.5, 2); 
        _score += _bonusTimerPoints;
      }

      _score += points;
      initPointHUD(egg, egg.points.toString());
      _bonusTimer = 2;
    
      var combo:Array = _snake.doCombos(egg);
      for(var i:int = 0; i < combo.length; i++) {
        initPointHUD(combo[i], '+5', 0xffff0000, 1.5, 2); 
        _score += 5;
      }
    }

    protected function spawnFood():void {
      reallySpawnFood(3);
    }
    
    protected function reallySpawnFood(n:int):void {
      var egg:Egg = new Egg(Math.floor(Math.random() * n));

      var wTiles:int = FlxG.width / 15;
      var hTiles:int = FlxG.height / 15;
      wTiles -= 2; // Left and right;
      hTiles -= 7; // 6 top, 1 bottom;
      do {
        egg.x = int(1 + (Math.random() * wTiles)) * 15;
        egg.y = int(6 + (Math.random() * hTiles)) * 15;
      } while(egg.overlaps(_unspawnable));
      _food.add(egg);

    }
    
    override public function destroy():void {
      super.destroy();
    }
  }
}
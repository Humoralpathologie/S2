package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class LevelOne extends FlxState {
    [Embed(source='assets/SnakeSounds/schluck2tiefer.mp3')] protected var BiteSound:Class;
    [Embed(source='assets/SnakeSounds/bup.mp3')] protected var Bup:Class;
    
    [Embed(source='assets/background.png')] protected var Background:Class;
  
    private var _biteSound:FlxSound;
    private var _bup:FlxSound;

    private var _snake:Snake;
    private var _food:FlxGroup;
    private var _pointHud:Tween;
    private var _hud:FlxText;
    private var _score:int;
    private var _map:FlxTilemap;
    private var _level:FlxGroup;
    private var _background:FlxSprite;
    private var _bonusTimer:Number = 0;
    private var _bonusBar:FlxSprite;
    private var _portal1:Portal;  
    private var _portal2:Portal;  
      
    override public function create():void {

      FlxG.log("Starting game");
     
      _bup = new FlxSound;
      _bup.loadEmbedded(Bup);

      _biteSound = new FlxSound;
      _biteSound.loadEmbedded(BiteSound);
      
      _background = new FlxSprite;
      _background.loadGraphic(Background); 

      FlxG.mouse.hide();

      _score = 0;
      
      _snake = new Snake(8);
      _food = new FlxGroup();
      spawnFoods(3);

      _hud = new FlxText(32,32,400,'0');
      _hud.size = 16;

      _bonusBar = new FlxSprite(450,32);
      _bonusBar.makeGraphic(1,8,0xffff0000);
      _bonusBar.origin.x = _bonusBar.origin.y = 0;
      _bonusBar.scale.x = 0;

      
      add(_bup);
      add(_biteSound);
      add(_background);
      add(_food);
      add(_snake);
      add(_snake.tailCam);
      FlxG.addCamera(_snake.tailCam);
      initialPortals();
      
      add(_hud);
      add(_bonusBar);
      
    }

    private function initialPortals():void {
      _portal1 = new Portal(25, 10, 1);
      _portal1.play('twinkle');

      _portal2 = new Portal(10, 28, 2);
      _portal2.play('twinkle');
       
      add(_portal1);
      add(_portal2);

    }

    private function hitPortal():void {
      if (_snake.head.overlaps(_portal1) && !_portal1.inUse) {
        _bup.play();
        _portal1.teleport(_snake, _portal2);
        _portal2.inUse = true;
      }
      if (_snake.head.overlaps(_portal2) && !_portal2.inUse) {
        _bup.play();
        _portal2.teleport(_snake, _portal1);
        _portal1.inUse = true;
      }
    }

    private function updateHud():void {
      _hud.text = "Hi, " + FlxKongregate.getUserName +"! Score: " + String(_score) + "\nLives: " + String(_snake.lives);
      _hud.y = ((64 - _hud.height) / 2) + 16;
    }

    private function spawnFoods(count:int):void {
      for(var i:int = 0; i < count; i++) {
        spawnFood();
      }
    }

    override public function update():void {
      hitPortal();
      super.update();
      _bonusTimer -= FlxG.elapsed;

      if(_snake.lives < 0) {
        FlxG.score = _score;
        FlxG.switchState(new GameOver);
      }
      
      updateHud();

      if (!_snake.head.overlaps(_portal1) && !_snake.head.overlaps(_portal2)) {
        _portal1.inUse = false;
        _portal2.inUse = false;

      }

      if(_bonusTimer > 0) {
        _bonusBar.scale.x = (_bonusTimer / 2) * 25;
      } else {
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
    }

    private function initPointHUD(egg:Egg, points:String, Color:uint = 0xffffffff, Delay:Number = 0.5, Speed:int = 1):void { 
      _pointHud = new Tween(Delay, 20, egg.x, egg.y, 40, Color, points, Speed); 
      add(_pointHud);  
    } 

    private function movePortal(egg:Egg):void {
      if (_portal1.alive) {
        _portal2.revive();
        _portal2.inUse = true;
        _portal2.reset(egg.x, egg.y);
      } else 
      if (_portal2.alive){
        _portal1.revive();
        _portal1.inUse = true;
        _portal1.reset(egg.x, egg.y);
      } 


    }

    private function eat(snakeHead:FlxSprite, egg:Egg):void {
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
      
      _snake.faster();
      _snake.swallow(egg);
      points += egg.points;
     

      if(_bonusTimer > 0) {
        initPointHUD(egg, '+2', 0xffedf249, 1.5, 2); 
        _score += 2;
        
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

    private function hitBoundary(snakeHead:FlxObject, tile:FlxObject):void {
      FlxG.log("Hitting at " + tile.x + ", " + tile.y);
      _snake.die(); 
    }

    private function spawnFood():void {
      var egg:Egg = new Egg(Math.floor(Math.random() * 3));

      var wTiles:int = FlxG.width / 15;
      var hTiles:int = FlxG.height / 15;
      wTiles -= 2; // Left and right;
      hTiles -= 7; // 6 top, 1 bottom;
      do {
        egg.x = int(1 + (Math.random() * wTiles)) * 15;
        egg.y = int(6 + (Math.random() * hTiles)) * 15;
      } while(egg.overlaps(_snake));
      _food.add(egg);
    }
  }
}

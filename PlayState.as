package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class PlayState extends FlxState {

    [Embed(source='assets/images/eggs.png')] protected var Eggs:Class;
    [Embed(source='assets/images/shell.png')] protected var Shell:Class;
    [Embed(source='assets/background.png')] protected var Background:Class;
  
    private var _snake:Snake;
    private var _food:FlxGroup;
    private var _shells:FlxEmitter;
    private var _hud:FlxText;
    private var _score:int;
    private var _map:FlxTilemap;
    private var _level:FlxGroup;
    private var _background:FlxSprite;
    
    override public function create():void {

      FlxG.log("Starting game");

      _background = new FlxSprite;
      _background.loadGraphic(Background); 

      FlxG.mouse.hide();

      _score = 0;
      
      _snake = new Snake(8);
      _food = new FlxGroup;
      spawnFoods(4);
      _shells = new FlxEmitter();
      _shells.makeParticles(Shell,4);

      _hud = new FlxText(32,32,400,'0');
      _hud.size = 16;

      add(_background);
      add(_food);
      add(_snake);
      add(_shells);
      add(_hud);
      
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
      super.update();

      if(_snake.lives < 0) {
        FlxG.score = _score;
        FlxG.switchState(new GameOver);
      }
      
      updateHud();

      // I tried to use FlxG.overlap for this, but sometimes, the callback will
      // be called twice. This works, so leave it like this.
      for(var i:int = 0; i < _food.length; i++){
        if(_snake.head.overlaps(_food.members[i])){
          eat(_snake.head, _food.members[i]);
        }
      }
    }

    private function eat(snakeHead:FlxSprite, food:FlxSprite):void {
      FlxG.log("Eating at " + snakeHead.x + ", " + snakeHead.y);
      _food.remove(food, true);
      spawnFood();
      FlxG.shake();
      _shells.at(snakeHead);
      _shells.start(true, 3);
      _snake.faster();
      _snake.swallow(food);
      _score++;
    }

    private function hitBoundary(snakeHead:FlxObject, tile:FlxObject):void {
      FlxG.log("Hitting at " + tile.x + ", " + tile.y);
      _snake.die(); 
    }

    private function spawnFood():void{
      var food:FlxSprite = new FlxSprite;
      food.loadGraphic(Eggs,true,false,15,15);
      food.addAnimation('eggone',[0]);
      food.addAnimation('eggtwo',[1]);
      food.addAnimation('eggthree',[2]);
      switch(Math.floor(Math.random() * 3)) {
        case 0:
          food.play('eggone');
          break;
        case 1:
          food.play('eggtwo');
          break;
        case 2:
          food.play('eggthree');
          break
      }
      var wTiles:int = FlxG.width / 15;
      var hTiles:int = FlxG.height / 15;
      wTiles -= 2; // Left and right;
      hTiles -= 7; // 6 top, 1 bottom;
      do {
        food.x = int(1 + (Math.random() * wTiles)) * 15;
        food.y = int(6 + (Math.random() * hTiles)) * 15;
      } while(food.overlaps(_snake));
      _food.add(food);
    }
     
  }
}

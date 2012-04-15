package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class PlayState extends FlxState {

    [Embed(source='assets/images/eggA.png')] protected var EggA:Class;
    [Embed(source='assets/images/eggB.png')] protected var EggB:Class;
    [Embed(source='assets/images/eggC.png')] protected var EggC:Class;
    [Embed(source='assets/images/shell.png')] protected var ShellB:Class;
    [Embed(source='assets/background.png')] protected var Background:Class;
  
    private var _snake:Snake;
    private var _food:FlxGroup;
    private var _pointHud:Tween;
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
      _food = new FlxGroup();
      spawnFoods(3);

      _hud = new FlxText(32,32,400,'0');
      _hud.size = 16;

      add(_background);
      add(_food);
      add(_snake);
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

   private function initPointHUD(egg:Egg):void{ 
      var points:int = egg.points; 
      _pointHud = new Tween(0.5, 20, egg.x, egg.y, 40, points.toString()); 
      add(_pointHud);  
       
    } 


    private function eat(snakeHead:FlxSprite, egg:Egg):void {
      FlxG.log("Eating at " + snakeHead.x + ", " + snakeHead.y);
      spawnFood();
      FlxG.shake();

      var shells:FlxEmitter = egg.shells;
      shells.at(snakeHead);
      shells.start(true, 3);

      initPointHUD(egg);
      _food.remove(egg, true);
      
      _snake.faster();
      _snake.swallow(egg);
      _score += egg.points;
    }

    private function hitBoundary(snakeHead:FlxObject, tile:FlxObject):void {
      FlxG.log("Hitting at " + tile.x + ", " + tile.y);
      _snake.die(); 
    }

    private function spawnFood():void{
      /*
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
      }*/
     
      var eggs:Array = [new Egg(EggA, ShellB), new Egg(EggB, ShellB), new Egg(EggC, ShellB)];
      var egg:Egg = eggs[Math.floor(Math.random() * 3)]; 

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

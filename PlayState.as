package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class PlayState extends FlxState {

    [Embed(source='assets/images/egg.png')] protected var Egg:Class;
    [Embed(source='assets/images/shell.png')] protected var Shell:Class;
    [Embed(source='map/level.png')] protected var LevelTiles:Class;
    [Embed(source='map/level.csv', mimeType='application/octet-stream')] protected var LevelCSV:Class;
  
    private var _snake:Snake;
    private var _food:FlxGroup;
    private var _shells:FlxEmitter;
    private var _hud:FlxText;
    private var _score:int;
    private var _map:FlxTilemap;
    private var _level:FlxGroup;
    
    override public function create():void {

      FlxG.log("Starting game");

      FlxG.mouse.hide();

      _score = 0;
      
      _map = new FlxTilemap(); 
      _map.loadMap(new LevelCSV, LevelTiles, 16, 16);
      _level = new FlxGroup();
      _level.add(_map);
      
      _snake = new Snake(8);

      _food = initialFood();

      _shells = new FlxEmitter();
      _shells.makeParticles(Shell,4);

      _hud = new FlxText(32,32,400,'0');
      _hud.size = 16;

      add(_level);
      add(_snake);
      add(_food);
      add(_shells);
      add(_hud);

      FlxKongregate.init(apiHasLoaded);
      
    }

    private function apiHasLoaded():void
    {
      FlxKongregate.connect();
      FlxG.log(FlxKongregate.isLocal);
      FlxG.log(FlxKongregate.getUserName);
      updateHud();
    }

    private function updateHud():void {
      _hud.text = "Hi, " + FlxKongregate.getUserName +"! Score: " + String(_score) + "\nLives: " + String(_snake.lives);
      _hud.y = ((64 - _hud.height) / 2) + 16;
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
      FlxG.collide(_snake.head, _level, hitBoundary);
    }

    private function eat(snakeHead:FlxSprite, food:FlxSprite):void {
      FlxG.log("Eating at " + snakeHead.x + ", " + snakeHead.y);
      randomPlace(food);
      FlxG.shake();
      _shells.at(snakeHead);
      _shells.start(true, 3);
      _snake.faster();
      _snake.swallow();
      _score++;
    }

    private function hitBoundary(snakeHead:FlxObject, tile:FlxObject):void {
      FlxG.log("Hitting at " + tile.x + ", " + tile.y);
      _snake.die(); 
    }

    private function randomPlace(food:FlxSprite):void{
      var wTiles:int = FlxG.width / 16;
      var hTiles:int = FlxG.height / 16;
      wTiles -= 2; // Left and right;
      hTiles -= 7; // 6 top, 1 bottom;
      do {
        food.x = int(1 + (Math.random() * wTiles)) * 16;
        food.y = int(6 + (Math.random() * hTiles)) * 16;
      } while(food.overlaps(_snake.head));
    }

    private function initialFood():FlxGroup{
      var group:FlxGroup = new FlxGroup;
      var food:FlxSprite = new FlxSprite(16*5,16*5);
      food.loadGraphic(Egg);
      randomPlace(food);
      group.add(food);
      return group;
    }
     
  }
}

package {
  import org.flixel.*;
  
  public class PlayState extends FlxState {

    [Embed(source='assets/images/egg.png')] protected var Egg:Class;
    [Embed(source='assets/images/shell.png')] protected var Shell:Class;
  
    private var _snake:Snake;
    private var _food:FlxGroup;
    private var _shells:FlxEmitter;
    
    override public function create():void {
    
      _snake = new Snake(2);
      _food = initialFood();

      _shells = new FlxEmitter();
      _shells.makeParticles(Shell,4);

      add(_snake);
      add(_food);
      add(_shells);
      
    }

    override public function update():void {
      for(var i:int = 0; i < _food.members.length; i++){
        var food:FlxSprite;
        food = _food.members[i];
        if(_snake.head().overlaps(food))
          eat(_snake.head(), food);
      }
      super.update();
    }

    private function eat(snakeHead:FlxSprite, food:FlxSprite):void {
      FlxG.shake();
      _shells.at(food);
      _shells.start();
      food.kill();
    }

    private function initialFood():FlxGroup{
      var group:FlxGroup = new FlxGroup;
      var food:FlxSprite = new FlxSprite(16*5,16*5);
      food.makeGraphic(16,16,0xff00ff00);//loadGraphic(Egg);
      group.add(food);
      return group;
    }
     
  }
}

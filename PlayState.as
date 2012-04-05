package {
  import org.flixel.*;
  
  public class PlayState extends FlxState {
  
    private var _snake:Snake;
    private var _food:FlxGroup;
    
    override public function create():void {
    
      _snake = new Snake(8);
      _food = initialFood();

      add(_snake);
      add(_food);
      
    }

    override public function update():void {
      super.update();
      FlxG.overlap(_snake.head(), _food, eat);
    }

    private function eat(snakeHead:FlxSprite, food:FlxSprite):void {
      FlxG.shake();
      food.kill();
    }

    private function initialFood():FlxGroup{
      var group:FlxGroup = new FlxGroup;
      var food:FlxSprite = new FlxSprite(16,16);
      food.makeGraphic(16,16,0xffff0000);
      group.add(food);
      return group;
    }
     
  }
}

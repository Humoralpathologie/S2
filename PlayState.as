package {
  import org.flixel.*;
  
  public class PlayState extends FlxState {

    [Embed(source='assets/images/egg.png')] protected var Egg:Class;
    [Embed(source='assets/images/shell.png')] protected var Shell:Class;
  
    private var _snake:Snake;
    private var _food:FlxGroup;
    private var _shells:FlxEmitter;
    
    override public function create():void {
    
      _snake = new Snake(8);
      _food = initialFood();

      _shells = new FlxEmitter();
      _shells.makeParticles(Shell,4);

      add(_snake);
      add(_food);
      add(_shells);
      
    }

    override public function update():void {
      FlxG.overlap(_snake.head(), _food, eat);
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
      food.loadGraphic(Egg);
      group.add(food);
      return group;
    }
     
  }
}

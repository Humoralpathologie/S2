package {
  import org.flixel.*;

  public class Egg extends FlxSprite {
   
    private var _points:int;
    private var _shells:FlxEmitter;
    private var _type:Class;
    private var _shellType:Class;
    
    public function Egg(EggType:Class, ShellType:Class, point:int = 2, X:int = 160, Y:int = 160){
      super(X, Y);
      
      //_type = EggType;
      //_shellType = ShellType;

      loadGraphic(EggType);

      _shells = new FlxEmitter();
      _shells.makeParticles(ShellType, 4);

      _points = point;

    }

    public function get shells():FlxEmitter{
      return _shells;
    }

    public function get points():int{
      return _points;
    }

    public function randomPlace(snake:Snake):void{
      var wTiles:int = FlxG.width / 16;
      var hTiles:int = FlxG.height / 16;
      wTiles -= 2; // Left and right;
      hTiles -= 7; // 6 top, 1 bottom;
      do {
        this.x = int(1 + (Math.random() * wTiles)) * 16;
        this.y = int(6 + (Math.random() * hTiles)) * 16;
      } while(this.overlaps(snake));
      
    } 

  }
}

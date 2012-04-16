package {
  import org.flixel.*;

  public class Egg extends FlxSprite {

    [Embed(source='assets/images/eggA.png')] protected static var EggA:Class;
    [Embed(source='assets/images/eggB.png')] protected static var EggB:Class;
    [Embed(source='assets/images/eggC.png')] protected static var EggC:Class;
    [Embed(source='assets/images/shell.png')] protected static var ShellB:Class;

    private static var eggGraphics:Array = [EggA, EggB, EggC];
    private static var shellGraphics:Array = [ShellB, ShellB, ShellB];
   
    private var _points:int;
    private var _eggType:int;
    private var _shells:FlxEmitter;
    
    public function Egg(eggType:int = 0, x:int = 0, y:int = 0 ){
      super(x, y);
      
      _eggType = eggType;
      loadGraphic(eggGraphics[eggType]);

      _shells = new FlxEmitter();
      _shells.makeParticles(shellGraphics[eggType], 4);

      _points = 2; // Can be switched later by eggType

    }

    public function get shells():FlxEmitter{
      return _shells;
    }

    public function get points():int{
      return _points;
    }

    public function get type():int {
      return _eggType;
    }
  }
}

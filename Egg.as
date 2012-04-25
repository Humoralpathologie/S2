package {
  import org.flixel.*;

  public class Egg extends FlxSprite {

    [Embed(source='assets/images/eggA.png')] protected static var EatenEggA:Class;
    [Embed(source='assets/images/eggB.png')] protected static var EatenEggB:Class;
    [Embed(source='assets/images/eggC.png')] protected static var EatenEggC:Class;
    [Embed(source='assets/images/egg-tilemap.png')] protected static var EggA:Class;
    [Embed(source='assets/images/egg02-tilemap.png')] protected static var EggB:Class;
    [Embed(source='assets/images/egg03-tilemap.png')] protected static var EggC:Class;
    [Embed(source='assets/images/shell.png')] protected static var ShellB:Class;

    private static var eatenGraphics:Array = [EatenEggA, EatenEggB, EatenEggC];
    private static var eggGraphics:Array = [EggA, EggB, EggC]
    private static var shellGraphics:Array = [ShellB, ShellB, ShellB];
   
    private var _points:int;
    private var _eggType:int;
    private var _shells:FlxEmitter;
    
    public function Egg(eggType:int = 0, x:int = 0, y:int = 0 ){
      super(x, y);
      
      _eggType = eggType;
      loadGraphic(eggGraphics[eggType], true, false, 30, 30);
      addAnimation('wiggle',[0,1],2);
      play('wiggle');

      width = 15;
      height = 15;
      offset.y = 6;
      offset.x = 1;

      _shells = new FlxEmitter();
      _shells.makeParticles(shellGraphics[eggType], 4);

      _points = 2; // Can be switched later by eggType

    }

    public function get shells():FlxEmitter{
      return _shells;
    }

    public function eat():void{
      offset.y = 0;
      offset.x = 0;
      loadGraphic(eatenGraphics[_eggType]);
    }

    public function get points():int{
      return _points;
    }

    public function get type():int {
      return _eggType;
    }
  }
}

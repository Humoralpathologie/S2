package {
  import org.axgl.*;

  public class Egg extends AxSprite {

    [Embed(source='assets/images/eggA.png')] protected static var EatenEggA:Class;
    [Embed(source='assets/images/eggB.png')] protected static var EatenEggB:Class;
    [Embed(source='assets/images/eggC.png')] protected static var EatenEggC:Class;
    [Embed(source='assets/images/eggBlank.png')] protected static var EatenEggBlanc:Class;

    [Embed(source='assets/images/egg-tilemap.png')] protected static var EggA:Class;
    [Embed(source='assets/images/egg02-tilemap.png')] protected static var EggB:Class;
    [Embed(source='assets/images/egg03-tilemap.png')] protected static var EggBlanc:Class;
    [Embed(source='assets/images/rotten-eggs.png')] protected static var EggRotten:Class 
    [Embed(source='assets/images/shell.png')] protected static var ShellB:Class;

    protected static var eatenGraphics:Array = [EatenEggBlanc, EatenEggA, EatenEggB, EatenEggC];
    protected static var eggGraphics:Array = [EggBlanc, EggA, EggB, null, EggRotten]
    protected static var shellGraphics:Array = [ShellB, ShellB, ShellB, ShellB, ShellB];

    public static const ROTTEN:uint = 4;
   
    protected var _points:int;
    protected var _eggType:int;
    // protected var _shells:AxEmitter;
    
    public function Egg(eggType:int = 0, x:int = 0, y:int = 0 ){
      super(x, y);
      
      _eggType = eggType;
      load(eggGraphics[eggType], 30, 30);
      addAnimation('wiggle',[0,1],2);
      animate('wiggle');

      width = 15;
      height = 15;
      offset.y = 6;
      offset.x = 1;

      //_shells = new FlxEmitter();
      //_shells.makeParticles(shellGraphics[eggType], 4);

      _points = 2; // Can be switched later by eggType

    }

    /*
    public function get shells():FlxEmitter{
      return _shells;
    }
    */

    public function eat():void{
      offset.y = 0;
      offset.x = 0;
      load(eatenGraphics[_eggType]);
      show(0);
      // X-Tina style
      dirty = true;
    }

    public function get points():int{
      if(_eggType == ROTTEN){
        return -5;
      } else {
        return 2;
      }
    }

    public function get type():int {
      return _eggType;
    }
  }
}

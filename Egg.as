package {
  import flash.text.engine.BreakOpportunity;
  import org.axgl.*;

  public class Egg extends SmoothBlock {  

    [Embed(source = "assets/images/egg00-tilemap.png")] protected static var EggZero:Class;
    [Embed(source='assets/images/egg_a-tilemap.png')] protected static var EggA:Class;
    [Embed(source='assets/images/egg_b-tilemap.png')] protected static var EggB:Class;
    [Embed(source = 'assets/images/egg_c-tilemap.png')] protected static var EggC:Class;
    
    [Embed(source = "assets/images/eatenEggZero.png")] protected static var EatenEggZero:Class;
    [Embed(source = "assets/images/eatenEggA.png")] protected static var EatenEggA:Class;
    [Embed(source = "assets/images/eatenEggB.png")] protected static var EatenEggB:Class;
    [Embed(source = "assets/images/eatenEggC.png")] protected static var EatenEggC:Class;
    [Embed(source = "assets/images/eatenEggRotten.png")] protected static var EatenEggRotten:Class;
    
    [Embed(source = 'assets/images/egg_rotten-tilemap.png')] protected static var EggRotten:Class 

    [Embed(source = 'assets/images/egg_gold-tilemap.png')] protected static var EggGolden:Class;
    [Embed(source = "assets/images/egg_shuffle-tilemap.png")] protected static var EggShuffle:Class;
    
    [Embed(source='assets/images/shell.png')] protected static var ShellB:Class;

    protected static var eatenGraphics:Array = [EatenEggZero, EatenEggA, EatenEggB, EatenEggC, EatenEggRotten];
    protected static var eggGraphics:Array = [EggZero, EggA, EggB, EggC, EggRotten, EggGolden, EggShuffle]

    public static const EGGZERO:uint = 0;
    public static const EGGA:uint = 1;
    public static const EGGB:uint = 2;
    public static const EGGC:uint = 3;   
    public static const ROTTEN:uint = 4;
    public static const GOLDEN:uint = 5;
    public static const SHUFFLE:uint = 6;
   
    
    protected var _points:int;
    protected var _eggType:int;
    
    // Set this to true when starting to remove the egg from the body.
    public var removing:Boolean = false;  
    
    public function Egg(eggType:int = 0, x:int = 0, y:int = 0 ){
      super(x, y);
      
      // Don't flippin' flip it.
      flip = AxEntity.NONE;
      
      _eggType = eggType;
      load(eggGraphics[eggType], 30, 30);
      addAnimation('wiggle',[0,1],2);
      animate('wiggle');

      width = 15;
      height = 15;
      offset.y = 6;
      offset.x = 1;
    }

    public function eat():void{
      load(eatenGraphics[_eggType], 30, 45);
      width = 15;
      height = 15;
      offset.x = 15;
      offset.y = 15;
      addAnimation("horizontal", [0], 1);
      addAnimation("vertical", [1], 1);
      addAnimation("angle", [2], 1);
    }

    public function get points():int{
      if(_points) {
        return _points;
      } else {
        var ret:int = 2;
        switch(_eggType) {
          case EggTypes.ROTTEN:
              ret = -5;
              break;
          case EggTypes.GOLDEN:
              ret = 100;
              break;
        }
        return ret;
      }
    }

    public function set points(n:int):void {
      _points = n;
    }

    public function get type():int {
      return _eggType;
    }
  }
}

package {
  import org.axgl.*;

  public class Egg extends AxSprite {

    [Embed(source='assets/images/eatenEggBlue.png')] protected static var EatenEggBlue:Class;
    [Embed(source='assets/images/eatenEggGreenPointed.png')] protected static var EatenEggGreenPointed:Class;
    [Embed(source='assets/images/eatenEggCross.png')] protected static var EatenEggCross:Class;
    [Embed(source='assets/images/eatenEggWhite.png')] protected static var EatenEggWhite:Class;
    [Embed(source='assets/images/eatenEggGreen.png')] protected static var EatenEggGreen:Class;

    [Embed(source='assets/images/eggBlue.png')] protected static var EggBlue:Class;
    [Embed(source='assets/images/eggGreenPointed.png')] protected static var EggGreenPointed:Class;
    [Embed(source='assets/images/eggCross.png')] protected static var EggCross:Class;
    [Embed(source='assets/images/eggWhite.png')] protected static var EggWhite:Class;
    [Embed(source='assets/images/eggGreen.png')] protected static var EggGreen:Class 
    [Embed(source='assets/images/shell.png')] protected static var ShellB:Class;

    protected static var eatenGraphics:Array = [EatenEggGreen, EatenEggWhite, EatenEggBlue, EatenEggGreenPointed, EatenEggCross];
    protected static var eggGraphics:Array = [EggGreen, EggWhite, EggBlue, EggGreenPointed, EggCross]

    public static var ROTTEN:uint = 1;
   
    protected var _points:int;
    protected var _eggType:int;
    
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

      _points = 2;

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
        if(_eggType == ROTTEN){
          return -5;
        } else {
          return 2;
        }
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

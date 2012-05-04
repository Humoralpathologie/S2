package {
  import org.flixel.*;

  public class Egg extends FlxSprite {

    [Embed(source='assets/images/eatenEggBlue_shadow.png')] protected static var EatenEggBlue:Class;
    [Embed(source='assets/images/eatenEggGreenPointed_shadow.png')] protected static var EatenEggGreenPointed:Class;
    [Embed(source='assets/images/eatenEggCross.png')] protected static var EatenEggCross:Class;
    [Embed(source='assets/images/eatenEggWhite_shadow.png')] protected static var EatenEggWhite:Class;
    [Embed(source='assets/images/eatenEggGreen_shadow.png')] protected static var EatenEggGreen:Class;

    [Embed(source='assets/images/eggBlue.png')] protected static var EggBlue:Class;
    [Embed(source='assets/images/eggGreenPointed.png')] protected static var EggGreenPointed:Class;
    [Embed(source='assets/images/eggCross.png')] protected static var EggCross:Class;
    [Embed(source='assets/images/eggWhite.png')] protected static var EggWhite:Class;
    [Embed(source='assets/images/eggGreen.png')] protected static var EggGreen:Class 
    [Embed(source='assets/images/shell.png')] protected static var ShellB:Class;

    protected static var eatenGraphics:Array = [EatenEggGreen, EatenEggWhite, EatenEggBlue, EatenEggGreenPointed, EatenEggCross];
    protected static var eggGraphics:Array = [EggGreen, EggWhite, EggBlue, EggGreenPointed, EggCross]
    protected static var shellGraphics:Array = [ShellB, ShellB, ShellB, ShellB, ShellB];

    public static var ROTTEN:uint = 1;
   
    protected var _points:int;
    protected var _eggType:int;
    protected var _shells:FlxEmitter;
    
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
      loadGraphic(eatenGraphics[_eggType], true, false, 19, 17);
      addAnimation("horizontal", [1], 1);
      addAnimation("vertical", [0], 1);
      width = 15;
      height = 15;
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

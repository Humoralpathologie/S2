package {
  import org.flixel.*;

  public class Portal extends FlxSprite{
    [Embed(source='assets/images/target.png')] protected static var GreenP:Class;
    [Embed(source='assets/images/target2.png')] protected static var RedP:Class;
    public var inUse:Boolean; 
   
    public function Portal(wTiles:int, hTiles:int, Type:int){
      super(wTiles * 15, hTiles * 15);
      inUse = false;
      if (Type == 1) {
        loadGraphic(GreenP, true, false, 32, 32);
      } else {
        loadGraphic(RedP, true, false, 32, 32);
      };
      width = 10;
      height = 10;
      offset.x = 11;
      offset.y = 11;

      addAnimation('twinkle', [0,1,2,3], 3);
         
    }     

    public function teleport(snake:Snake, portal2:Portal):void{
      snake.nextPos = new FlxPoint(portal2.x, portal2.y);

      switch(snake.head.facing){
        case FlxObject.DOWN:
          snake.head.facing = FlxObject.UP;
        break;
 
        case FlxObject.UP:
          snake.head.facing = FlxObject.DOWN;
        break;

        case FlxObject.RIGHT:
          snake.head.facing = FlxObject.LEFT;
        break;
  
        case FlxObject.LEFT:
          snake.head.facing = FlxObject.RIGHT;
        break;
      } 

    }



  }
}

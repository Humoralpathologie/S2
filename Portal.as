package {
  import org.flixel.*;

  public class Portal extends FlxSprite{
    [Embed(source='assets/images/target.png')] protected static var GreenP:Class;
    [Embed(source='assets/images/target2.png')] protected static var RedP:Class;
    public var inUse:Boolean; 
   
    public function Portal(wTiles:int, hTiles:int, Type:int){
      super(wTiles * 15 - 8, hTiles * 15 - 9);
      inUse = false;
      if (Type == 1) {
        loadGraphic(GreenP, true, false, 32, 32);
      } else {
        loadGraphic(RedP, true, false, 32, 32);
      };
      offset.x = 11;
      offset.y = 11;
      width = 10;
      height = 10;

      addAnimation('twinkle', [0,1,2,3], 3);
         
    }     

    public function teleport(snake:Snake, portal2:Portal):void{
      snake.head.reset(portal2.x - 10, portal2.y - 10);

      switch(snake.head.facing){
        case FlxObject.DOWN:
          snake.head.facing = FlxObject.UP;
          snake.head.play('up');
        break;
 
        case FlxObject.UP:
          snake.head.facing = FlxObject.DOWN;
          snake.head.play('down');
        break;

        case FlxObject.RIGHT:
          snake.head.facing = FlxObject.LEFT;
          snake.head.play('left');
        break;
  
        case FlxObject.LEFT:
          snake.head.facing = FlxObject.RIGHT;
          snake.head.play('right');
        break;
      } 

    }



  }
}

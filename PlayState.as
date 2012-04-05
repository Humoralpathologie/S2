package {
  import org.flixel.*;
  
  public class PlayState extends FlxState {
  
    private var _snake:Snake;
    
    override public function create():void {
    
      _snake = new Snake(8);
      add(_snake);

    }
     
  }
}

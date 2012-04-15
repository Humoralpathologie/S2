package {
  import org.flixel.*;
  //import org.flixel.plugin.photonstorm.*;

  public class Tween extends FlxText {
    private var _timer:Number;
    private var _delay:Number;

    public function Tween(Delay:Number, Size:int, X:Number, Y:Number, Width:uint, Text:String = null, EmbeddedFont:Boolean = true ){
      super(X, Y, Width, Text, EmbeddedFont);
      size = Size;
      this.blend = 'hardlight';

      _timer = 0;
      _delay = Delay;
    }
    
    override public function update():void {
      super.update();
        
      x += 1;
      y -= 1;
      
      _timer += FlxG.elapsed;
      if(_timer >= _delay) {
        alpha -= 0.02; 
      }
      
      if(alpha <= 0) {
        kill();
      }

    }



  }
}


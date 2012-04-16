package {
  import org.flixel.*;
  //import org.flixel.plugin.photonstorm.*;

  public class Tween extends FlxText {
    private var _timer:Number;
    private var _delay:Number;
    private var _speed:int;

    public function Tween(Delay:Number, Size:int, X:Number, Y:Number, Width:uint, Color:uint = 0xffffff, Text:String = null, Speed:int = 1){
      super(X, Y, Width, Text);
      size = Size;
      color = Color;
      this.blend = 'hardlight';

      _timer = 0;
      _delay = Delay;
      
      _speed = Speed;
    }
    
    override public function update():void {
      super.update();
        
      x += _speed;
      y -= _speed;
      
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


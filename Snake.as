package {
  import org.flixel.*;

  public class Snake extends FlxGroup {
    private var _head:FlxSprite;
    private var _body:FlxGroup;
    private var _timer:Number;
    private var _speed:Number;
    
    public function Snake(movesPerSecond:Number = 1) { 
      super();

      _speed = 1 / movesPerSecond;
      _timer = 0;

      _head = new FlxSprite(32,32);
      _head.makeGraphic(16,16);
      _head.facing = FlxObject.RIGHT;

      _body = makeBody();

      add(_head);
      add(_body);
    }

    public function head():FlxSprite {
      return _head;
    }

    private function makeBody():FlxGroup {
      var group:FlxGroup;
      group = new FlxGroup();
      var i:int;
      for(i = 1; i <= 4; i++){
        var part:FlxSprite;
        part = new FlxSprite(_head.x - (i * 16), _head.y);
        part.makeGraphic(16,16);
        group.add(part);
      } 
      return group;      
    }

    private function move():void {

      for(var i:int = _body.members.length - 1 ; i >= 0; i--){
        var part:FlxSprite;
        part = _body.members[i];
        if(i == 0){
          part.x = _head.x;
          part.y = _head.y; 
        } else {
          part.x = _body.members[i - 1].x;
          part.y = _body.members[i - 1].y;
        }
      }

      var xSpeed:int = 0;
      var ySpeed:int = 0;

      switch(_head.facing) {
        case FlxObject.RIGHT:
          xSpeed = 16;
          break;
        case FlxObject.LEFT:
          xSpeed = -16;
          break;
        case FlxObject.UP:
          ySpeed = -16;
          break;
        case FlxObject.DOWN:
          ySpeed = 16;
          break;
      }
  
      _head.x += xSpeed;
      _head.y += ySpeed;

    }
     
    override public function update():void {
      super.update();

      if(FlxG.keys.UP){
        _head.facing = FlxObject.UP;
      } else
      if(FlxG.keys.DOWN){
        _head.facing = FlxObject.DOWN;
      } else 
      if(FlxG.keys.RIGHT){
        _head.facing = FlxObject.RIGHT;
      } else 
      if(FlxG.keys.LEFT){
        _head.facing = FlxObject.LEFT;
      } 

      _timer += FlxG.elapsed;

      if(_timer >= _speed){
        move();
        _timer -= _speed;
      }
    }
  }
  
}

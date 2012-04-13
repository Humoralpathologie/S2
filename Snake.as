package {
  import org.flixel.*;

  public class Snake extends FlxGroup {
    [Embed(source='assets/head.png')] protected var Head:Class;
    [Embed(source='assets/images/tail.png')] protected var Tail:Class;
    [Embed(source='assets/images/eggs.png')] protected var Eggs:Class;

    private var _head:FlxSprite;
    private var _tail:FlxSprite;
    private var _body:FlxGroup;
    private var _timer:Number;
    private var _speed:Number;
    private var _mps:Number;
    private var _newPart:FlxSprite;
    private var _lives:int = 3;
    
    public function Snake(movesPerSecond:Number = 1) { 
      super();

      _mps = movesPerSecond;
      _speed = 1 / _mps;
      _timer = 0;

      _head = new FlxSprite(15 * 10, 15 * 10);
      //_head.makeGraphic(16,16);
      _head.loadGraphic(Head, true, false, 30, 30);
      _head.addAnimation('left',[0,1], 2);
      _head.addAnimation('right',[10,11], 2);
      _head.addAnimation('right-eat',[10,11,12,13,14,15,16,17,18,19], 10);
      _head.addAnimation('up',[20,21], 2);
      _head.addAnimation('down',[30]);
      _head.width = 15;
      _head.height = 15;

      _body = new FlxGroup();

      resurrect();


      add(_body);
      add(_head);
    }

    public function die():void {
      alive = false;
      _lives--;
    }

    private function resurrect():void {
      _body.clear();
      _head.x = 150;
      _head.y = 150;
      _head.facing = FlxObject.RIGHT;
      _head.play('right');
      _head.offset.x = 0;
      _head.offset.y = 15;
      fillBody(_body);
      _mps = 8;
      _speed = 1 / _mps;
      alive = true;
    }

    public function get head():FlxSprite {
      return _head;
    }

    public function get lives():int {
      return _lives;
    }

    public function faster():void {
      if(_mps < 30)
        _mps += 1;
      
      _speed = 1 / _mps;
    }

    private function fillBody(group:FlxGroup):void {
      var i:int;
      for(i = 1; i <= 4; i++){
        var part:FlxSprite;
        part = new FlxSprite(_head.x - (i * 15), _head.y);
        if(i == 4) {
          // This should be somewhere else.
          part.loadGraphic(Tail, true, false, 15, 15);
          part.addAnimation('left',[0,1],7);
          part.addAnimation('right',[2,3],7);
          part.addAnimation('up',[4,5],7);
          part.addAnimation('down',[6,7],7);
          _tail = part;
        } else {
          //part.makeGraphic(15,15);
          part.loadGraphic(Eggs,true,false,15,15);
          part.addAnimation('eggone',[0]);
          part.addAnimation('eggtwo',[1]);
          part.addAnimation('eggthree',[2]);
        }
        part.facing = FlxObject.RIGHT;
        group.add(part);
      } 
    }

    public function swallow(food:FlxSprite):void {
      _newPart = food;
      switch(_head.facing) {
        case FlxObject.RIGHT:
            _head.play('right-eat');
          break;
        case FlxObject.LEFT:
            _head.play('left');
          break;
        case FlxObject.UP:
            _head.play('up');
          break;
        case FlxObject.DOWN:
            _head.play('down');
          break;
      }
    }

    private function move():void {
      if(_newPart){ 
        var swap:FlxSprite;
        _body.remove(_tail);
        _body.add(_newPart);
        _body.add(_tail);
        _newPart = null;
      }  

      for(var i:int = _body.members.length - 1 ; i >= 0; i--){
        var part:FlxSprite;
        part = _body.members[i];
        if(part) {
          if(i == 0){
            part.x = _head.x;
            part.y = _head.y; 
            part.facing = head.facing;
          } else {
            part.x = _body.members[i - 1].x;
            part.y = _body.members[i - 1].y;
            part.facing = _body.members[i - 1].facing;
          }
        }
      }

      var xSpeed:int = 0;
      var ySpeed:int = 0;
      
      switch(_head.facing) {
        case FlxObject.RIGHT:
            xSpeed = 15;
          break;
        case FlxObject.LEFT:
            xSpeed = -15;
          break;
        case FlxObject.UP:
            ySpeed = -15;
          break;
        case FlxObject.DOWN:
            ySpeed = 15;
          break;
      }

      switch(_tail.facing) {
        case FlxObject.RIGHT:
            _tail.play('right');
          break;
        case FlxObject.LEFT:
            _tail.play('left');
          break;
        case FlxObject.UP:
            _tail.play('up');
          break;
        case FlxObject.DOWN:
            _tail.play('down');
          break;
      }

      _head.x += xSpeed;
      _head.y += ySpeed;

    }

    public function get body():FlxGroup {
      return _body;
    }
     
    override public function update():void {
      super.update();

      if(FlxG.keys.UP && _head.facing != FlxObject.DOWN){
        _head.facing = FlxObject.UP;
        _head.offset.x = 4;
        _head.offset.y = 15;
        _head.play('up');
      } else
      if(FlxG.keys.DOWN && _head.facing != FlxObject.UP){
        _head.facing = FlxObject.DOWN;
        _head.offset.x = 4;
        _head.offset.y = 0;
        _head.play('down');
      } else 
      if(FlxG.keys.RIGHT && _head.facing != FlxObject.LEFT){
        _head.facing = FlxObject.RIGHT;
        _head.offset.x = 0;
        _head.offset.y = 15;
        _head.play('right');
      } else 
      if(FlxG.keys.LEFT && _head.facing != FlxObject.RIGHT){
        _head.facing = FlxObject.LEFT;
        _head.offset.x = 15;
        _head.offset.y = 15;
        _head.play('left');
      } 

      _timer += FlxG.elapsed;
      if(_timer >= _speed){
        if(alive){
          if(_head.overlaps(_body)){
            die();
          }
          move();
        } else {
          resurrect();
        }
        _timer -= _speed;
      }
    }
  }
  
}

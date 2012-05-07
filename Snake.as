package {
  import org.axgl.*;
  import org.axgl.input.*;

  public class Snake extends AxGroup {
    [Embed(source='assets/head.png')] protected var Head:Class;
    [Embed(source='assets/images/tail.png')] protected var Tail:Class;
    [Embed(source='assets/images/eggs.png')] protected var Eggs:Class;
    [Embed(source='assets/SnakeSounds/Pickup_Coin.mp3')] protected var Bling:Class;

    private var _head:AxSprite;
    private var _tail:AxSprite;
    private var _body:AxGroup;
    private var _timer:Number;
    private var _speed:Number;
    private var _mps:Number;
    private var _newPart:AxSprite;
    private var _lives:int = 3;
    private var _previousFacing:uint = AxEntity.RIGHT;
    private var _nextPos:AxPoint = null;
    //private var _bling:FlxSound = new FlxSound;    
    private var _justAte:Boolean = false;
    public var alive:Boolean = false;
    
    public function Snake(movesPerSecond:Number = 1) { 
      super();

      _mps = movesPerSecond;
      _speed = 1 / _mps;
      _timer = 0;

      _head = new AxSprite(15 * 10, 15 * 10);
      _head.load(Head, 30, 30);
      _head.addAnimation('left',[0,1,2,3,4,5,6,7,8,9], 10);
      _head.addAnimation('right',[10,11,12,13,14,15,16,17,18,19], 10);
      _head.addAnimation('right-eat',[10,11,12,13,14,15,16,17,18,19], 10);
      _head.addAnimation('up',[20,21,22,23,24,25,26,27,28,29], 10);
      _head.addAnimation('down',[30]);
      _head.width = 15;
      _head.height = 15;
      _head.flip = AxEntity.NONE;

      _body = new AxGroup();

      resurrect();

      add(_body);
      add(_head);
    }

    public function get mps():Number {
      return 1 / _speed; 
    }

    public function set nextPos(pos:AxPoint):void {
      _nextPos = pos;
    }

    public function get justAte():Boolean {
      if(_justAte){
        _justAte = false;
        return true;
      } else {
        return false;
      }
    }

    private function tailEgg():Egg {
      if(_body.members.length >= 2){
        return (_body.members[_body.members.length - 2] as Egg);
      } else {
        return null;
      }
    }

    public function die():void {
      alive = false;
      _lives--;
    }

    private function resurrect():void {
      _body.clear();
      _head.x = 150;
      _head.y = 150;
      _head.facing = AxEntity.RIGHT;
      _previousFacing = _head.facing;
      _head.animate('right');
      _head.offset.x = 0;
      _head.offset.y = 15;
      fillBody(_body);
      _mps = 8;
      _speed = 1 / _mps;
      alive = true;
    }

    public function get head():AxSprite {
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

    private function fillBody(group:AxGroup):void {
      var i:int;
      for(i = 1; i <= 4; i++){
        var part:AxSprite;
        if(i == 4) {
          part = new AxSprite(_head.x - (i * 15), _head.y);
          // This should be somewhere else.
          part.load(Tail, 15, 15);
          part.addAnimation('left',[0,1],7);
          part.addAnimation('right',[2,3],7);
          part.addAnimation('up',[4,5],7);
          part.addAnimation('down',[6,7],7);
          _tail = part;
          _tail.flip = AxEntity.NONE;
        } else {
          part = new Egg(i % 3, _head.x - (i * 15), _head.y);
          (part as Egg).eat();
        }
        part.facing = AxEntity.RIGHT;
        group.add(part);
      } 
    }

    public function swallow(food:AxSprite):void {
      _newPart = food;
      switch(_head.facing) {
        case AxEntity.RIGHT:
            _head.animate('right-eat');
          break;
        case AxEntity.LEFT:
            _head.animate('left');
          break;
        case AxEntity.UP:
            _head.animate('up');
          break;
        case AxEntity.DOWN:
            _head.animate('down');
          break;
      }
    }

    private function move():void {
      _previousFacing = _head.facing;
      if(_newPart){ 
        (_newPart as Egg).eat();
        var swap:AxSprite;
        _body.remove(_tail);
        _body.add(_newPart);
        _body.add(_tail);
        _newPart = null;
        _justAte = true;
      }  

      for(var i:int = _body.members.length - 1 ; i >= 0; i--){
        var part:AxSprite;
        var lastPart:AxSprite;
        part = (_body.members[i] as AxSprite); 
        if(i == 0){
          lastPart = _head;
        } else {
          lastPart = (_body.members[i - 1] as AxSprite);
        }
        part.x = lastPart.x;
        part.y = lastPart.y; 
        part.facing = lastPart.facing;
      }

      var xSpeed:int = 0;
      var ySpeed:int = 0;
      
      switch(_head.facing) {
        case AxEntity.RIGHT:
            xSpeed = 15;
          break;
        case AxEntity.LEFT:
            xSpeed = -15;
          break;
        case AxEntity.UP:
            ySpeed = -15;
          break;
        case AxEntity.DOWN:
            ySpeed = 15;
          break;
      }

      switch(_tail.facing) {
        case AxEntity.RIGHT:
            _tail.animate('right');
          break;
        case AxEntity.LEFT:
            _tail.animate('left');
          break;
        case AxEntity.UP:
            _tail.animate('up');
          break;
        case AxEntity.DOWN:
            _tail.animate('down');
          break;
      }

      if(_nextPos) {
        _head.x = _nextPos.x;
        _head.y = _nextPos.y;
        _nextPos = null;
      } else {
        _head.x += xSpeed;
        _head.y += ySpeed;
      }

    }

    public function get body():AxGroup {
      return _body;
    }
     
    override public function update():void {
      super.update();
      
      if(Ax.keys.pressed(AxKey.UP) && _previousFacing != AxEntity.DOWN){
        _head.facing = AxEntity.UP;
      } else
      if(Ax.keys.pressed(AxKey.DOWN) && _previousFacing != AxEntity.UP){
        _head.facing = AxEntity.DOWN;
      } else 
      if(Ax.keys.pressed(AxKey.RIGHT) && _previousFacing != AxEntity.LEFT){
        _head.facing = AxEntity.RIGHT;
      } else 
      if(Ax.keys.pressed(AxKey.LEFT) && _previousFacing != AxEntity.RIGHT){
        _head.facing = AxEntity.LEFT;
      } 

      if(Ax.mouse.pressed(0)){
        if(Math.abs(Ax.mouse.x - _head.x) < Math.abs(Ax.mouse.y - _head.y)){
          if(Ax.mouse.y > _head.y) {
            _head.facing = AxEntity.DOWN;
          } else {
            _head.facing = AxEntity.UP;
          } 
        } else {
          if(Ax.mouse.x < _head.x) {
            _head.facing = AxEntity.LEFT;
          } else {
            _head.facing = AxEntity.RIGHT;
          }
        }
      }

      switch(_head.facing) {
        case AxEntity.UP:
          _head.offset.x = 4;
          _head.offset.y = 15;
          _head.animate('up');
          break;
        case AxEntity.DOWN: 
          _head.offset.x = 4;
          _head.offset.y = 0;
          _head.animate('down');
          break;
        case AxEntity.RIGHT:
          _head.offset.x = 0;
          _head.offset.y = 15;
          _head.animate('right');
          break;
        case AxEntity.LEFT:
          _head.offset.x = 15;
          _head.offset.y = 15;
          _head.animate('left');
          break;
      }

      _timer += Ax.dt;
      if(_timer >= _speed){
        if(alive){
          if(Ax.overlap(_head, _body)){
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

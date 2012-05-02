package {
  import org.flixel.*;

  public class Snake extends FlxGroup {
    [Embed(source='assets/images/head.png')] protected var Head:Class;
    [Embed(source='assets/images/tail.png')] protected var Tail:Class;
    [Embed(source='assets/SnakeSounds/Pickup_Coin.mp3')] protected var Bling:Class;

    private var _head:FlxSprite;
    private var _tail:FlxSprite;
    private var _body:FlxGroup;
    private var _timer:Number;
    private var _speed:Number;
    private var _mps:Number;
    private var _newPart:FlxSprite;
    private var _lives:int = 3;
    private var _previousFacing:uint = FlxObject.RIGHT;
    private var _tailCam:FlxCamera;
    private var _nextPos:FlxPoint = null;
    private var _bling:FlxSound = new FlxSound;    
    private var _justAte:Boolean = false;
    private var _startMps:Number;
    
    public function Snake(movesPerSecond:Number = 1) { 
      super();
      
      _startMps = movesPerSecond;
      _mps = _startMps;
      _speed = 1 / _mps;
      _timer = 0;

      _head = new FlxSprite(15 * 10, 15 * 10);
      //_head.makeGraphic(16,16);
      _head.loadGraphic(Head, true, false, 30, 30);
      _head.addAnimation('left',[0,6,9], 5);
      _head.addAnimation('right',[10,16,19], 5);
      _head.addAnimation('right-eat',[10,16,19], 5);
      _head.addAnimation('up',[20,26,29], 5);
      _head.addAnimation('down',[30]);
      _head.width = 15;
      _head.height = 15;

      _body = new FlxGroup();
      _tailCam = new FlxCamera(300,30,30,30,2);
      _bling.loadEmbedded(Bling);

      resurrect();
      fillBody(_body);

      add(_body);
      add(_head);
    }
/********************************************
    //getter and setter
********************************************/
    public function get head():FlxSprite {
      return _head;
    }

    public function get lives():int {
      return _lives;
    }

    public function set lives(n:int):void {
      _lives = n;
    }    

    public function get tailCam():FlxCamera {
      return _tailCam;
    }

    public function get mps():Number {
      return 1 / _speed; 
    }

    public function get body():FlxGroup {
      return _body;
    }

    public function set nextPos(pos:FlxPoint):void {
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
/*******************************************/

    private function tailEgg():Egg {
      if(_body.length >= 2){
        return _body.members[_body.length - 2];
      } else {
        return null;
      }
    }

    public function die():void {
      alive = false;
      _lives--;
    }

    private function resurrect():void {
      _head.x = 150;
      _head.y = 150;
      _head.facing = FlxObject.RIGHT;
      _previousFacing = _head.facing;
      _head.play('right');
      _head.offset.x = 0;
      _head.offset.y = 15;
      _mps = _startMps;
      _speed = 1 / _mps;
      alive = true;
      _tailCam.follow(tailEgg());
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
        if(i == 4) {
          part = new FlxSprite(_head.x - (i * 15), _head.y);
          // This should be somewhere else.
          part.loadGraphic(Tail, true, false, 15, 15);
          part.addAnimation('left',[0,1],7);
          part.addAnimation('right',[2,3],7);
          part.addAnimation('up',[4,5],7);
          part.addAnimation('down',[6,7],7);
          _tail = part;
        } else {
          part = new Egg(i % 3, _head.x - (i * 15), _head.y);
          (part as Egg).eat();
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
      _previousFacing = _head.facing;
      if(_newPart){ 
        (_newPart as Egg).eat();
        var swap:FlxSprite;
        _body.remove(_tail);
        _body.add(_newPart);
        _body.add(_tail);
        _tailCam.follow(_newPart);
        _newPart = null;
        _justAte = true;
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

      if(_nextPos) {
        _head.x = _nextPos.x;
        _head.y = _nextPos.y;
        _nextPos = null;
      } else {
        _head.x += xSpeed;
        _head.y += ySpeed;
      }

    }

     
    override public function update():void {
      super.update();

      if(FlxG.keys.UP && _previousFacing != FlxObject.DOWN){
        _head.facing = FlxObject.UP;
      } else
      if(FlxG.keys.DOWN && _previousFacing != FlxObject.UP){
        _head.facing = FlxObject.DOWN;
      } else 
      if(FlxG.keys.RIGHT && _previousFacing != FlxObject.LEFT){
        _head.facing = FlxObject.RIGHT;
      } else 
      if(FlxG.keys.LEFT && _previousFacing != FlxObject.RIGHT){
        _head.facing = FlxObject.LEFT;
      } 

      switch(_head.facing) {
        case FlxObject.UP:
          _head.offset.x = 4;
          _head.offset.y = 15;
          _head.play('up');
          break;
        case FlxObject.DOWN: 
          _head.offset.x = 4;
          _head.offset.y = 0;
          _head.play('down');
          break;
        case FlxObject.RIGHT:
          _head.offset.x = 0;
          _head.offset.y = 15;
          _head.play('right');
          break;
        case FlxObject.LEFT:
          _head.offset.x = 15;
          _head.offset.y = 15;
          _head.play('left');
          break;
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

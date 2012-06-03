package {
  import org.axgl.*;
  import org.axgl.input.*;

  public class Snake extends AxGroup {
    [Embed(source='assets/images/snake_head_tilemap.png')] protected var Head:Class;
    [Embed(source='assets/images/snake_tail_tilemap.png')] protected var Tail:Class;
    [Embed(source='assets/SnakeSounds/Pickup_Coin.mp3')] protected var Bling:Class;

    private var _head:SmoothBlock;
    private var _tail:SmoothBlock;
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
    private var _alive:Boolean;
    private var _resurrect:Boolean = false;
    private var _cameraHead:AxSprite;
    private var _nextDirection:uint = AxEntity.RIGHT;
    private var _followBox:AxEntity;
    
    private var _startMps:Number;
    private var _emoLevel:int;    
    
    private var _startPosition:AxPoint;

    public function Snake(movesPerSecond:Number = 1, startPosition:AxPoint = null) { 
      super();
      _startMps = movesPerSecond;
      _timer = 0;
      
      _startPosition = startPosition;

      _head = new SmoothBlock(2, 2);

      _head.load(Head, 45, 75);
      _head.addAnimation('right_0',[0,1], 3);
      _head.addAnimation('left_0',[2,3], 3);
      _head.addAnimation('up_0',[4,5], 4);
      _head.addAnimation('down_0',[6,7], 4);

      _head.addAnimation('right_1',[8,9], 3);
      _head.addAnimation('left_1',[10,11], 3);
      _head.addAnimation('up_1',[12,13], 4);
      _head.addAnimation('down_1',[14,15], 4);

      _head.addAnimation('right_2',[16,17], 3);
      _head.addAnimation('left_2',[18,19], 3);
      _head.addAnimation('up_2',[20,21], 4);
      _head.addAnimation('down_2',[22,23], 4);

      _head.addAnimation('right_3',[24,25], 3);
      _head.addAnimation('left_3',[26,27], 3);
      _head.addAnimation('up_3',[28,29], 4);
      _head.addAnimation('down_3',[30,31], 4);
      _head.width = 15;
      _head.height = 15;
      _head.flip = AxEntity.NONE;

      _body = new AxGroup();
      
      _followBox = new AxEntity(0,0);
      _followBox.width = 100;
      _followBox.height = 100;

      fillBody();
      resurrect();

      add(_body);
      //add(_followBox);
      add(_head);
    }
/********************************************
    //getter and setter
********************************************/
    public function get alive():Boolean {
      return _alive;
    }
    
    public function set alive(b:Boolean):void {
      _alive = b; 
    }

    public function get resurrectNext():Boolean {
      return _resurrect;
    }
    
    public function set resurrectNext(b:Boolean):void {
      _resurrect = b; 
    }
    
    public function get followBox():AxEntity {
      return _followBox;
    }

    public function get tail():AxSprite {
      return _tail;
    }

    public function get head():SmoothBlock {
      return _head;
    }

    public function get lives():int {
      return _lives;
    }

    public function get tileY():int {
      return int(y / 15);
    }

    public function get tileX():int {
      return int(y / 15);
    }

    public function set lives(n:int):void {
      _lives = n;
    }    

    public function get mps():Number {
      return 1 / _speed; 
    }

    public function set mps(n:Number):void {
      _speed = 1 / n;
      _mps = n;
    }

    public function set nextPos(pos:AxPoint):void {
      _nextPos = pos;
    }

    public function get body():AxGroup {
      return _body;
    }

    public function get justAte():Boolean {
      if(_justAte){
        _justAte = false;
        return true;
      } else {
        return false;
      }
    }
    
    public function set justAte(b:Boolean):void {
      _justAte = b;
    }
/*******************************************/

    private function tailEgg():Egg {
      if(_body.members.length >= 2){
        return (_body.members[_body.members.length - 2] as Egg);
      } else {
        return null;
      }
    }

    public function die():void {
      _alive = false;
      _lives--;
    }

    private function resurrect():void {
      _head.tileX = _startPosition.x;
      _head.tileY = _startPosition.y;
      _head.offset.x = 15;
      _head.offset.y = 30;
      _previousFacing = _head.facing;
      _head.direction = AxEntity.RIGHT;
      _nextDirection = AxEntity.RIGHT;
      _head.animate('right_0');

      for (var i:int = 0; i < _body.members.length; i++) {
        // Put them offscreen
        (_body.members[i] as SmoothBlock).tileX = -10;
        (_body.members[i] as SmoothBlock).tileY = -10;
        (_body.members[i] as SmoothBlock).direction = AxEntity.RIGHT;
        (_body.members[i] as SmoothBlock).mps = _startMps;
      }
      _tail.alpha == 0;
      _head.mps = _startMps;
      mps = _startMps;
      setEmoLevel();
      _alive = true;
    }

    private function fillBody():void {
      var i:int;
      for(i = 1; i <= 4; i++){
        var part:SmoothBlock;
        if(i == 4) {
          part = new SmoothBlock(_head.tileX - 1, _head.tileY);
          // This should be somewhere else.
          part.load(Tail, 45, 45);
          part.width = 15;
          part.height = 15;
          part.offset.x = 15;
          part.offset.y = 15
          part.addAnimation('left',[0],1);
          part.addAnimation('right',[1],1);
          part.addAnimation('up',[2],1);
          part.addAnimation('down',[3],1);
          _tail = part;
          _tail.flip = AxEntity.NONE;
        } else {
          part = new Egg(0, _head.x - 15, _head.y);
          (part as Egg).eat();
        }
        part.facing = AxEntity.RIGHT;
        _body.add(part);
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

    private function animateBodyMovement(part:AxSprite):void {
        if (part.facing == AxEntity.UP || part.facing == AxEntity.DOWN) {
          (part as Egg).animate("vertical");
        } else {
          (part as Egg).animate("horizontal");
        }
    }

    private function move():void {
      _previousFacing = _head.facing;
      _tail.visible = true;
      if(_newPart){ 
        (_newPart as Egg).eat();
        (_newPart as Egg).mps = mps;
        _body.remove(_tail);
        _body.add(_newPart);
        _body.add(_tail);

        _tail.visible = false;
        
        _newPart = null;
        _justAte = true;
      }  

      _head.direction = _nextDirection;
      for(var i:int = _body.members.length - 1 ; i >= 0; i--){
        var part:SmoothBlock;
        var prePart:SmoothBlock;
        var preFacing:uint;
        part = (_body.members[i] as SmoothBlock);
        preFacing = part.facing;

          if (i != _body.members.length - 1) {
            animateBodyMovement(part);
          }

          if(i == 0){
            part.tileX = _head.tileX;
            part.tileY = _head.tileY; 
            part.direction = head.facing;
          } else {
            prePart = (_body.members[i - 1] as SmoothBlock);
            part.tileX = prePart.tileX;
            part.tileY = prePart.tileY;
            part.direction = prePart.facing;
            //body tile in angle
            if (i != _body.members.length - 1 && preFacing != part.facing) {
              (part as Egg).animate("angle");
            } 
          }

      }

      animateTail();      
      _head.step();

    }

    private function animateTail():void {
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
    }

    private function setEmoLevel():void {
      switch(_mps) {
        case 10:
          _emoLevel = 0;
        break;
        case 15:
          _emoLevel = 1;
        break;
        case 20:
          _emoLevel = 2;
        break;
        case 25:
          _emoLevel = 3;
        break;

      }

    }
     
    public function faster():void {
      if(mps < 30) {
        mps += 1;
      }
      for each(var block:SmoothBlock in _body.members) {
        block.mps = mps;
      }
      _head.mps = mps;
      setEmoLevel();
    }

    private function selfOverlap():Boolean {
      var ret:Boolean = false;
      for each(var block:SmoothBlock in _body.members) {
        ret = ret || (block.tileX == _head.tileX && block.tileY == _head.tileY);
      }
      return ret;
    }

    private function updateFollowBox():void {
      if (_head.x < followBox.x) {
        _followBox.x = _head.x;
      } else if (_head.x + _head.width > _followBox.x + _followBox.width) {
        _followBox.x = _head.x - (_followBox.width - _head.width);
      } 
      if (_head.y < _followBox.y) {
        _followBox.y = _head.y;
      } else if (_head.y + _head.height > _followBox.y + _followBox.height) {
        _followBox.y = _head.y - (_followBox.height - _head.height);
      }      
      // To get center etc.
      //_followBox.update();
    }
    override public function update():void {
      super.update();
      
      
      if(Ax.keys.pressed(AxKey.UP) && _previousFacing != AxEntity.DOWN){
        _head.facing = AxEntity.UP;
        _nextDirection = AxEntity.UP;
      } else
      if(Ax.keys.pressed(AxKey.DOWN) && _previousFacing != AxEntity.UP){
        _head.facing = AxEntity.DOWN;
        _nextDirection = AxEntity.DOWN;
      } else 
      if(Ax.keys.pressed(AxKey.RIGHT) && _previousFacing != AxEntity.LEFT){
        _head.facing = AxEntity.RIGHT;
        _nextDirection = AxEntity.RIGHT;
      } else 
      if(Ax.keys.pressed(AxKey.LEFT) && _previousFacing != AxEntity.RIGHT){
        _head.facing = AxEntity.LEFT;
        _nextDirection = AxEntity.LEFT;
      } 

      if(Ax.mouse.pressed(0)){
        if(Ax.mouse.screen.x > Ax.width / 2){
          switch(_head.facing) {
            case AxEntity.UP:
              _head.facing = AxEntity.RIGHT;
              _nextDirection = AxEntity.RIGHT;
              break;
            case AxEntity.DOWN: 
              _head.facing = AxEntity.LEFT;
              _nextDirection = AxEntity.LEFT;
              break;
            case AxEntity.RIGHT:
              _head.facing = AxEntity.DOWN;
              _nextDirection = AxEntity.DOWN;
              break;
            case AxEntity.LEFT:
              _head.facing = AxEntity.UP;
              _nextDirection = AxEntity.UP;
              break;
          }
        } else {
          switch(_head.facing) {
            case AxEntity.UP:
              _head.facing = AxEntity.LEFT;
              _nextDirection = AxEntity.LEFT;
              break;
            case AxEntity.DOWN: 
              _head.facing = AxEntity.RIGHT;
              _nextDirection = AxEntity.RIGHT;
              break;
            case AxEntity.RIGHT:
              _head.facing = AxEntity.UP;
              _nextDirection = AxEntity.UP;
              break;
            case AxEntity.LEFT:
              _head.facing = AxEntity.DOWN;
              _nextDirection = AxEntity.DOWN;
              break;
          }
        }
      }

      switch(_head.facing) {
        case AxEntity.UP:
          _head.animate('up_' + String(_emoLevel));
          break;
        case AxEntity.DOWN: 
          _head.animate('down_' + String(_emoLevel));
          break;
        case AxEntity.RIGHT:
          _head.animate('right_' + String(_emoLevel));
          break;
        case AxEntity.LEFT:
          _head.animate('left_' + String(_emoLevel));
          break;
      }

      _timer += Ax.dt;
      if(_timer >= _speed){
        if(_alive){
          if(selfOverlap()){
            die();
          }
          move();
        } else {// if(_resurrect) {
          resurrect();
        }
        _timer -= _speed;
      }
      updateFollowBox();

    }
  }
  
}

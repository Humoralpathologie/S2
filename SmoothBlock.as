package {
  import org.axgl.*;
  
  public class SmoothBlock extends AxSprite {
    private var _tileX:int;
    private var _tileY:int;
    private var _size:int;
    private var _speed:int = 10;

    public function SmoothBlock(tileX:int, tileY:int, size:int = 15) {
      super(tileX * size, tileY * size);
      tileX = tileX;
      _tileY = tileY;
      _size = size;
      create(size,size,0xff0ff0ff);
      facing = AxEntity.RIGHT;
    }

    public function set direction(dir:uint):void {
      this.facing = dir;
      switch(dir) {
        case AxEntity.UP:
          velocity.x = 0;
          velocity.y = -1 * size * _speed;
          break;
        case AxEntity.DOWN:
          velocity.x = 0;
          velocity.y = size * _speed;
          break;
        case AxEntity.LEFT:
          velocity.x = -1 * size * _speed;
          velocity.y = 0;
          break;
        case AxEntity.RIGHT:
          velocity.x = size * _speed;
          velocity.y = 0;
          break;
      }  
    }

    public function step():void {
      switch(facing) {
        case AxEntity.UP:
          tileY -= 1;
          break;
        case AxEntity.DOWN:
          tileY += 1;
          break;
        case AxEntity.LEFT:
          tileX -= 1;
          break;
        case AxEntity.RIGHT:
          tileX += 1;
          break;
      }  
      x = tileX * _size;
      y = tileY * _size;
    }

    public function set mps(n:int):void {
      _speed = n;
    }
   
    public function get tileX():int {
      return _tileX;
    }
    
    public function get tileY():int {
      return _tileY;
    }

    public function get size():int {
      return _size;
    }
  
    public function set tileX(n:int):void {
      _tileX = n;
      x = n * size; 
    } 

    public function set tileY(n:int):void {
      _tileY = n;
      y = n * size;
    }
  }
}

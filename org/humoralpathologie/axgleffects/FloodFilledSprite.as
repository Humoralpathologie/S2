package org.humoralpathologie.axgleffects {
  import org.axgl.*;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  public class FloodFilledSprite extends AxSprite {

    private var _canvas:BitmapData;
    private var _fullImage:BitmapData;
    private var _currY:int;
    private var _step:int = 1;

    public function FloodFilledSprite(x:Number, y:Number, resource:*, step:int = 1) {
      super(x,y); 
      _step = step;

			if (resource is Class) {
				_fullImage = (new resource() as Bitmap).bitmapData;
			} else if (resource is BitmapData) {
				_fullImage = resource;
			} else {
				throw new Error("Invalid resource:", resource);
			}

      _canvas = new BitmapData(_fullImage.width, _fullImage.height, true, 0x00000000);
      _currY = 0;
      load(_canvas);
    }

    override public function update():void {
    
      for(var j:int = 0; j < _step; j++){
        if(_currY + 1 < height) {
          var r:Rectangle;
          var p:Point = new Point(0,0); 
          r = new Rectangle(0,height - (_currY + 1),width,1);
          for(var i:int = 0; i <= height - _currY; i++) {
            p.y = i;        
            _canvas.copyPixels(_fullImage,r,p);
          }
          _currY++;
          load(_canvas);
        }
      }
      
    super.update();
    }
  } 
}

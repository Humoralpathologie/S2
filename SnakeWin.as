package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.input.*;
  import org.humoralpathologie.axgleffects.*;
  public class SnakeWin extends AxState {
    // TODO: Use better image
    [Embed(source='assets/images/doofy-lion.png')] protected var sadSnake:Class;
    private var _timer:Number = 0;
    private var _addedText:Boolean = false;

    override public function create():void {
      var fsprite:FloodFilledSprite = new FloodFilledSprite(0,0,sadSnake,8);
      fsprite.x = (640 - fsprite.width) / 2;

      add(fsprite);
    }

    override public function update():void {
      super.update();
      _timer += Ax.dt;
      if(_addedText) {
        if(Ax.keys.pressed(AxKey.SPACE) || Ax.mouse.pressed(0)) {
          Ax.popState();
        }
      } else if(_timer >= 2) {
        var text:AxText = new AxText(0,350,null, "PRESS SPACE", 640 / 4, 'center');
        text.scale.x = 4;
        text.scale.y = 4;
        add(text);
        _addedText = true;
      }
    }
  }
}

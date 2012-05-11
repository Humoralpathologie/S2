package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.input.*;
  import org.humoralpathologie.axgleffects.*;
  public class SnakeDeath extends AxState {
    // TODO: Use better image
    [Embed(source='assets/images/introsnake.png')] protected var sadSnake:Class;

    override public function create():void {
      var fsprite:FloodFilledSprite = new FloodFilledSprite(0,0,sadSnake,8);
      fsprite.x = (640 - fsprite.width) / 2;

      var text:AxText = new AxText(0,350,null, "PRESS SPACE", 640 / 4, 'center');
      text.scale.x = 4;
      text.scale.y = 4;
      add(fsprite);
      add(text);
    }

    override public function update():void {
      super.update();
      if(Ax.keys.pressed(AxKey.SPACE)) {
        Ax.popState();
      }
    }
  }
}

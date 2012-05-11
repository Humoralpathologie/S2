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
      //var fsprite:AxSprite = new AxSprite(0,0,sadSnake);
      fsprite.x = (640 - fsprite.width) / 2;
      add(fsprite);
    }

    override public function update():void {
      super.update();
      if(Ax.keys.pressed(AxKey.SPACE)) {
        Ax.popState();
      }
    }
  }
}

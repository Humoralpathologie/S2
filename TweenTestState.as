package {
  import org.axgl.*;
  import com.gskinner.motion.*;
  import com.gskinner.motion.easing.*;

  public class TweenTestState extends AxState {
    override public function create():void {
      var testsprite:AxSprite = new AxSprite(20,20);
      testsprite.create(20,20,0xff00ff00);
      add(testsprite);
      GTweener.to(testsprite,2,{x: 500, y:400},{ease:Exponential.easeInOut});
      GTweener.to(testsprite.scale,2,{x: 4, y:3},{ease:Sine.easeInOut});
      GTweener.to(testsprite,1,{alpha: 0.5});
    }
  }
}

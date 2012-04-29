package {
  import org.flixel.*;

  [SWF(width='640', height='480', backgroundColor='#aa0000')]
  public class ScreenDebug extends FlxGame {
    public function ScreenDebug() {
      super(640, 480, DebugState);
      forceDebugger = true;
    }
  }
}

package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;

  [SWF(width='640', height='480', backgroundColor='#aa0000')]
  public class Main extends FlxGame {
    public function Main() {
      super(640, 480, MenuState);
      forceDebugger = true;
    }
  }
}

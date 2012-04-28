package
{
  import org.flixel.system.*;
 
  public class Preloader extends FlxPreloader
  {
    public function Preloader():void
    {
      className = "Main";
      minDisplayTime = 3;
      super();
    }
  }
}

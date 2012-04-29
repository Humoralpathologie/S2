package {
  import org.flixel.*;
  import flash.display.MovieClip;
  import flash.media.SoundMixer;
  import flash.events.Event;

  public class MovieState extends FlxState {
    [Embed(source="assets/movies/intro.swf")] private var SWFMovie:Class;
    protected var movie:MovieClip;
    protected var movieLength:Number;
    
    override public function create():void {
      movie = new SWFMovie;
      FlxG.stage.addChild(movie);
      // This returns zero, no idea why.
      movieLength = 349;
      movie.addEventListener(Event.EXIT_FRAME, next);
    }

    private function next(e:Event):void {
      if(movieLength-- <= 0){
        movie.removeEventListener(Event.EXIT_FRAME, next);
        FlxG.stage.removeChild(movie);
        FlxG.switchState(new MenuState);
      }
    }
  }
}

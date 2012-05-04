package {
  import org.axgl.*;
  import flash.display.MovieClip;
  import flash.media.SoundMixer;
  import flash.events.Event;

  public class MovieState extends AxState {
    [Embed(source="assets/movies/intro.swf")] private var SWFMovie:Class;
    protected var movie:MovieClip;
    protected var movieLength:Number;
    
    override public function create():void {
      movie = new SWFMovie;
      Ax.stage2D.addChild(movie);
      movieLength = 349;
      movie.addEventListener(Event.EXIT_FRAME, next);
    }

    private function next(e:Event):void {
      if(movieLength-- <= 0){
        movie.removeEventListener(Event.EXIT_FRAME, next);
        SoundMixer.stopAll();
        Ax.stage2D.removeChild(movie);

        Ax.switchState(new MenuState);
      }
    }
  }
}

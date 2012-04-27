package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;

  public class SwitchLevel extends GameOver {
    private var _storyBeat:FlxText;
    private var _playNextLevel:FlxButton;

    public function initStory(text:String):void {
      _storyBeat = new FlxText(0, 30, 480);
      _storyBeat.size = 20;
      _storyBeat.text = text;
      _storyBeat.x = (FlxG.width - _storyBeat.width) / 2;
      _storyBeat.alignment = 'center';

      add(_storyBeat);
    }

    public function initPlayNext(state:Class):void {
      _playNextLevel = new FlxButton(FlxG.width/2-40, 300 + 20, 'Next Level!', switchToState(state)); 
      add(_playNextLevel);
    }

  }
}

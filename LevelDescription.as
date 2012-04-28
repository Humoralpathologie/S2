package {
  import org.flixel.*;

  public class LevelDescription extends FlxState {
    [Embed(source='assets/SnakeSounds/mouseclick.mp3')] protected var ClickSound:Class;
    
    private var _LevelState:FlxState;
    private var _title:FlxText;
    private var _objective:FlxText;
    private var _timeLimit:FlxText;
    private var _middleX:int;
    private var _play:FlxButton;
    private var _back:FlxButton;
    private var _clickSound:FlxSound;
   
    public function LevelDescription(levelState:FlxState, Title:String, Objective:String, TimeLimit:String) {
      super();
      _LevelState = levelState;
      
      _middleX = FlxG.width / 2 - 300;      

      _title = new FlxText(_middleX, 50, 600, Title);
      _title.size = 50;
      _title.antialiasing = true;
      _title.alignment = 'center';

      _objective = new FlxText(_middleX, _title.y + 200, 600, 'Objective: ' + Objective);
      _objective.size = 20;
      _objective.antialiasing = true;
      _objective.alignment = 'center';


      _timeLimit = new FlxText(_middleX, _objective.y + 40, 600, 'Time Limit: ' + TimeLimit);
      _timeLimit.size = 20;
      _timeLimit.antialiasing = true;
      _timeLimit.alignment = 'center';

      _clickSound = new FlxSound;
      _clickSound.loadEmbedded(ClickSound);
      
      _play = new FlxButton(FlxG.width/2 - 40, _timeLimit.y + 40, 'Play ' + Title, switchToState(_LevelState));
      _back = new FlxButton(FlxG.width/2 - 40, _play.y + 20, 'Back to Menu', switchToState(new MenuState));

      _play.soundDown = _clickSound;
      _back.soundDown = _clickSound;

      add(_title);
      add(_objective);
      add(_timeLimit);
      add(_play);
      add(_back);
    } 

    private function switchToState(state:FlxState):Function {
      return function ():void {FlxG.switchState(state);}
    }
  }
}

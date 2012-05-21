package {
  import org.axgl.*;
  public class DebugState extends AxState {
    override public function create():void {
      var screens:Array = [ ["Level Select", switcher(LevelSelect)],
                            ["Level End", switcher(SwitchLevel)],
                            ["Intro Movie", switcher(MovieState)],
                            ["Leaderboard", switcher(LeaderBoard)],
                            ["Unlock Levels", function():void{SaveGame.unlockLevels();}],
                            ["Lock Levels", function():void{SaveGame.initializeData();}],
                            ["Tweening test", switcher(TweenTestState)]
                          ]
      var btn:AxButton;
      var pos:int = 100;
      for each (var buttonStuff:Array in screens) {
        btn = new AxButton(0, pos)//, buttonStuff[0], buttonStuff[1]);
        btn.onClick(buttonStuff[1]);
        btn.x = (640 - btn.width) / 2;
        btn.text(buttonStuff[0]);
        add(btn);
        pos += btn.height + 10;
      }
    }

    public function switcher(to:Class):Function {
      if(to == SwitchLevel){
        return function():void{Ax.switchState(new to( DebugState, DebugState))};
      } else {
        return function():void{Ax.switchState(new to)};
      }
    }
  }
}

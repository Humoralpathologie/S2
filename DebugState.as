package {
  import org.flixel.*;
  public class DebugState extends FlxState {
    override public function create():void {
      var screens:Array = [ ["Level Select", LevelSelect],
                            ["Level End", SwitchLevel],
                            ["Intro Movie", MovieState]
                          ]
      var btn:FlxButton;
      var pos:int = 100;
      for each (var buttonStuff:Array in screens) {
        btn = new FlxButton(0, pos, buttonStuff[0], switcher(buttonStuff[1]));
        btn.x = (FlxG.width - btn.width) / 2;
        add(btn);     
        pos += btn.height + 10;
      }
      FlxG.mouse.show();
    }

    public function switcher(to:Class):Function {
      if(to == SwitchLevel){
        return function():void{FlxG.switchState(new to("Just some text about whatever", DebugState, DebugState, "No Time"))};
      } else {
        return function():void{FlxG.switchState(new to)};
      }
    }
  }
}

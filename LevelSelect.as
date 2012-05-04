package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;
  
  public class LevelSelect extends AxState {

    [Embed(source='assets/images/level1.png')] protected static var L1:Class;
    [Embed(source='assets/images/level2.png')] protected static var L2:Class;
    [Embed(source='assets/images/level3.png')] protected static var L3:Class;
    [Embed(source='assets/images/levelNo.png')] protected static var LNo:Class;
    [Embed(source='assets/SnakeSounds/mouseclick.mp3')] protected var ClickSound:Class;


    private static var _levelPics:Array = [LNo, L1, L2, L3];
    //level description
   
    private static var _level1:Array = [null, "Level1", "Crossroads of Carnage", "Devour 50 Eggs", "None"];
    private static var _level2:Array = [null, "Level2", "Make 20 Combos of 3(or more if you dare)", "None"];
 
    private static var _level3:Array = [null, "Level3", "Snaking on Speed", "Survive the Food Poisoning", "None"];
    
    private static var _levels:Array = [_level1, _level2, _level3, false, false, false, false, false, false, false];

    private var _title:AxText;    

    override public function create():void {
      super.create();
      Ax.background = new AxColor(0,0,0);
      _title = new AxText(Ax.width / 2 - 300, 50, null, "SELECT LEVEL");
      // _title.size = 50;
      
      makeButtons();
      add(_title);
    }

    private function makeButtons():void{
      var xPos:int = 95;
      var yPos:int = 200;
      

      for (var i:int = 0; i < _levels.length; i++) {
        var levelButton:AxButton;
        var levelSprite:AxSprite;

        if (i == 5) { 
          xPos = 95; 
          yPos += 90; 
        }

        if (_levels[i] && SaveGame.levelUnlocked(i)) {
          levelButton = new AxButton(xPos, yPos, _levelPics[i+1],90,90);//"", switchToState(_levels[i][0], _levels[i][2], _levels[i][3], _levels[i][4]));
          //levelButton.soundDown = _clickSound;
          levelButton.onClick(function ():void { Ax.sound(ClickSound); })
          add(levelButton);
        } else {
          levelSprite = new AxSprite(xPos, yPos);
          levelSprite.load(_levelPics[0]);
          add(levelSprite);
        }
        
        xPos += 90;

      }
      
    }


    private function switchToState(state:Class, title:String, objective:String, timeLimit:String):Function {
      return function ():void {
        //var levelDescr:LevelDescription = new LevelDescription(state, title, objective, timeLimit);
        ////FlxG.switchState(levelDescr);
      }
    }

  }
} 

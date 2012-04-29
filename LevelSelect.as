package {
  import org.flixel.*;
  
  public class LevelSelect extends FlxState {

    [Embed(source='assets/images/level1.png')] protected static var L1:Class;
    [Embed(source='assets/images/level2.png')] protected static var L2:Class;
    [Embed(source='assets/images/level3.png')] protected static var L3:Class;
    [Embed(source='assets/images/levelNo.png')] protected static var LNo:Class;
    [Embed(source='assets/SnakeSounds/mouseclick.mp3')] protected var ClickSound:Class;


    private static var _levelPics:Array = [LNo, L1, L2, L3];
    //level description
    private static var _level1:Array = [new Level1, "Level1", "Crossroads of Carnage", "Devour 50 Eggs", "None"];
    private static var _level2:Array = [new Level2, "Level2", "Make 20 Combos of 3(or more if you dare)", "None"];
 
    private static var _level3:Array = [Level3, "Level3", "Snaking on Speed", "Survive the Food Poisoning", "None"];
    
    private static var _levels:Array = [_level1, _level2, _level3, false, false, false, false, false, false, false];

    private var _title:FlxText;    
    private var _clickSound:FlxSound;

    public function LevelSelect() {
      super();

      _title = new FlxText(FlxG.width / 2 - 300, 50, 600, "SELECT LEVEL");
      _title.size = 50;
      _title.antialiasing = true;
      _title.alignment = 'center';

      _clickSound = new FlxSound;
      _clickSound.loadEmbedded(ClickSound);
      
      makeButtons();
      add(_title);

    }


    private function makeButtons():void{
      var xPos:int = 95;
      var yPos:int = 200;
      

      for (var i:int = 0; i < _levels.length; i++) {
        var levelButton:FlxButton;
        var levelSprite:FlxSprite;

        if (i == 5) { 
          xPos = 95; 
          yPos += 90; 
        }

        if (_levels[i] && SaveGame.levelUnlocked(i)) {
          levelButton = new FlxButton(xPos, yPos, "", switchToState(_levels[i][0], _levels[i][2], _levels[i][3], _levels[i][4]));
          levelButton.loadGraphic(_levelPics[i+1]);
          levelButton.soundDown = _clickSound;
          add(levelButton);
        } else {
          levelSprite = new FlxSprite(xPos, yPos);
          levelSprite.loadGraphic(_levelPics[0]);
          add(levelSprite);
        }
        
        xPos += 90;


      }

      
    }


    private function switchToState(state:Class, title:String, objective:String, timeLimit:String):Function {
      return function ():void {
        var levelDescr:LevelDescription = new LevelDescription(state, title, objective, timeLimit);
        FlxG.switchState(levelDescr);
      }
    }

  }
} 

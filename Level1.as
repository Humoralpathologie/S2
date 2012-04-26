package {
  import org.flixel.*;
  
  public class Level1 extends LevelState {
    // Assets
    [Embed(source='assets/background.png')] protected var Background:Class;
    // Variablen
    private var _background:FlxSprite = null;
    
    private var _hudText:FlxText; 
    private var _eggAmount:int = 0;
    private var _timerSec:Number = 0;
    private var _timerMin:Number = 0;    
    private var _timerHud:String;

    override protected function addBackgrounds():void {
      _background = new FlxSprite(0,0);
      _background.loadGraphic(Background);
      add(_background);
    }

    
    override protected function addObstacles():void {
      var stone1:FlxSprite = new FlxSprite(135,0);      
      stone1.makeGraphic(90,45,0x00ff00ff);
      var stone2:FlxSprite = new FlxSprite(150,15);      
      stone2.makeGraphic(45,45,0x000000ff);
      _obstacles.add(stone1);
      _obstacles.add(stone2);
      add(_obstacles);
    }
    
    private function updateTimer():void {
      _timerSec += FlxG.elapsed;
      if (_timerSec >= 60) {
        _timerMin += 1;
        _timerSec = 0;
      }
      _timerHud = convertTimer();
    }
    
    private function convertTimer():String {
      var _sec:String;
      var _min:String;
      
      if (Math.floor(_timerSec) < 10) {
        _sec = "0" + String(Math.floor(_timerSec));
      } else {
        _sec = String(Math.floor(_timerSec));
      }

      if (_timerMin < 10) {
        _min = "0" + String(_timerMin);
      } else {
        _min = String(_timerMin);
      }

      return _min + ":" + _sec;
    }    

    override protected function addHud():void {
      _hudText = new FlxText(15,15, 640 - 60);
      _hudText.size = 16;
      add(_hudText);
    }
    override protected function updateHud():void {
      _hudText.text = "Score: " + String(FlxG.score);
      _hudText.text += "\nDevoured Eggs: " + String(_eggAmount) + "/70";
      _hudText.text += "\nTimer: " + _timerHud;
    }
    
    override protected function eat(snakeHead:FlxSprite, egg:Egg):void {
      super.eat(snakeHead, egg);
      _eggAmount++;

      if (_eggAmount > 0 && _eggAmount % 4 == 0) {
        _snake.faster();
      }
    }

    override protected function switchLevel():void {
      FlxG.score = _score;
      var _text:String = "Little Snake bemerkt, dass sie bei Verdrücken von drei Eiern des Typ A nicht nur kürzer, sondern auch schlauer wird.";
      var _switchLevel:SwitchLevel = new SwitchLevel;
      _switchLevel.initStory(_text);
      _switchLevel.initReset(Level1);
      _switchLevel.initPlayNext(Level2);      
      FlxG.switchState(_switchLevel);
    }

    override protected function spawnFood():void {
      var rand:int = Math.floor(Math.random() * 10);
      var egg:Egg;

      if (rand > 6) {
        egg = new Egg(1);  
      } else {
        egg = new Egg(0); 
      }

      spawnEgg(egg);
      _food.add(egg);
      
    }


    override protected function checkCombos(arr:Array):Array {
      var res:Array;

      var largerThanThree:Function = function(el:Array, i:int, arr:Array):Boolean { 
        return el.length >= 3;
      };
      
      var isBlanc:Function = function(el:Egg):Boolean {
        return el.type == 0;
      };
      
      var sameEggType:Function = function(currArr:Array, el:Object):Boolean{
        return ((currArr[0] as Egg).type == (el as Egg).type) && ((currArr[0] as Egg).type == 1);
      };

      res = groupArray(sameEggType,arr); 

      return res.filter(largerThanThree);
    }

    override public function update():void {
      updateTimer();
      super.update();
      
      if (_eggAmount >= 70) {  
        switchLevel();
      }

    } 


  }
}

package {
  import org.flixel.*;

  public class SaveGame {
    private static var _save:FlxSave;
    private static var _loaded:Boolean = false;
    
    public static function load():void {
      if(!_loaded) {
        _save = new FlxSave();
        _loaded = _save.bind('SSSSNAKEsavedata');
        // Initialize if new.
        // Levels are 0-indexed.
        if(_loaded && _save.data.unlockedLevels == null) {
          initializeData();
        }
      }
    } 
  
    public static function initializeData():void {
      _save.data.unlockedLevels = [0];
      _save.data.levelScores = {0: 0};
    }

    public static function unlockLevels():void {
      for(var x:int = 0; x <= 100; x++) {
        _save.data.unlockedLevels.push(x);
      }
      _save.flush();
    }

    public static function get unlockedLevels():Array{
      return _save.data.unlockedLevels;
    }

    public static function levelUnlocked(n:Number):Boolean {
      return (_save.data.unlockedLevels.indexOf(n) >= 0);
    }

    public static function unlockLevel(n:Number):void {
      _save.data.unlockedLevels.push(n);
    } 
  }
}

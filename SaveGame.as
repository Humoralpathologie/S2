package {

  public class SaveGame {
   // private static var _save:FlxSave;
    private static var _loaded:Boolean = false;
    
    public static function load():void {
    } 
  
    public static function initializeData():void {
    }

    public static function unlockLevels():void {
    }

    public static function get unlockedLevels():Array{
      return [0,1,2];
    }

    public static function levelUnlocked(n:Number):Boolean {
      return true;
    }

    public static function unlockLevel(n:Number):void {
    } 

    public static function saveScore(n:Number, score:Number):void {
    }
  }
}

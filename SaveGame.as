package {

  import flash.net.*;
   

  public class SaveGame {
    private static var _sharedObject:SharedObject = null;
    
    public static function load():void {
      _sharedObject = SharedObject.getLocal('snakeSaveData');
      if(!_sharedObject.data.initialized) {
        initializeData(); 
      }
    } 
  
    public static function initializeData():void {
      _sharedObject.data.levels = {};
      for(var i:int = 1; i <= 100; i++) {
        _sharedObject.data.levels[i] = {};
        _sharedObject.data.levels[i].score = 0;
        _sharedObject.data.levels[i].unlocked = (i == 1 ? true : false);
      } 
      _sharedObject.data.initialized = true;
      _sharedObject.flush();
    }

    public static function unlockLevels():void {
      for(var i:int = 1; i <= 100; i++) {
        _sharedObject.data.levels[i].unlocked = true;
      }
      _sharedObject.flush();
    }

    public static function get unlockedLevels():Array{
      var unlocked:Array = [];
      for(var i:int = 1; i <= 100; i++) {
        if(_sharedObject.data.levels[i].unlocked == true){
          unlocked.push(i);
        }
      }
      return unlocked;
    }

    public static function levelUnlocked(n:Number):Boolean {
      return _sharedObject.data.levels[n].unlocked;
    }

    public static function unlockLevel(n:Number):void {
      _sharedObject.data.levels[n].unlocked = true;
      _sharedObject.flush();
    } 

    public static function saveScore(n:Number, score:Number):void {
      _sharedObject.data.levels[n].score = score;
      _sharedObject.flush();
      publishScore();
    }

    public static function fullScore():Number {
      var n:Number = 0;
      for(var i:int = 1; i <= 100; i++) {
        if(_sharedObject.data.levels[i].unlocked == true){
          n += _sharedObject.data.levels[i].score;
        }
      }
      return n; 
    }

    private static function publishScore():void {
      var user:String = _sharedObject.data.user ? _sharedObject.data.user : "anonymous";    
      var url:String = "https://www.scoreoid.com/api/createScore";
      var request:URLRequest = new URLRequest(url);
      var requestVars:URLVariables = new URLVariables();
      request.data = requestVars;
      requestVars.api_key = "7bb1d7f5ac027ae81b6c42649fddc490b3eef755";
      requestVars.game_id = "2RCmMyKmt";
      requestVars.response ="XML"
      requestVars.username = user;
      requestVars.score = fullScore();
       
      request.method = URLRequestMethod.POST;
   
      var urlLoader:URLLoader = new URLLoader();
      urlLoader = new URLLoader();
      urlLoader.dataFormat = URLLoaderDataFormat.TEXT;

      urlLoader.load(request);
    }
  }
}

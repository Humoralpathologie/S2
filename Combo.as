package  
{  
  import org.axgl.AxState;
  public class Combo 
  {
    private var _trigger:Array;
    private var _triggerRegexp:RegExp;
    public var repeat:Boolean = false;
    
    public function Combo() {
    }
    
    public function effect(state:LevelState):void {
    }
    
    public function set trigger(trig:Array):void {
      _trigger = trig;
      var triggerStr:String = _trigger.join("");
      if (repeat) {
        triggerStr += "+";
      }
      _triggerRegexp = new RegExp(triggerStr, "g");
    }
    
    public function check(eggs:Array):Array {
      
      // Reset RegExp
      _triggerRegexp.lastIndex = 0;
      
      var results:Array = [];
     
      var eggsStr:String = "";
      
      for each(var egg:Object in eggs) {
        eggsStr += String(egg.type);
      }

      var res:Object = _triggerRegexp.exec(eggsStr);

      while (res != null) {
        results.push([res.index, res[0].length + res.index]);
        res = _triggerRegexp.exec(eggsStr);
      }
      
      return results;
    }
    
  }

}
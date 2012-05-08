package {
  import org.axgl.*;
  
  public class Hud extends AxGroup{
    [Embed(source='assets/images/icons/anzeigenbalken.png')] protected var Background:Class;
    [Embed(source='assets/images/icons/icon-combo.png')] protected var Combo:Class;
    [Embed(source='assets/images/icons/icon-lives.png')] protected var Lives:Class;
    [Embed(source='assets/images/icons/icon-poison.png')] protected var Poison:Class;
    [Embed(source='assets/images/icons/icon-speed.png')] protected var Speed:Class;
    [Embed(source='assets/images/icons/icon-time.png')] protected var Time:Class;

    private var _bg:AxSprite;
    private var _lives:AxSprite;
    private var _livesText:AxText;

    private var _combo:AxSprite;
    private var _comboText:AxText;

    private var _poison:AxSprite;
    private var _poisonText:AxText;

    private var _speed:AxSprite;
    private var _speedText:AxText;

    private var _time:AxSprite;
    private var _timeText:AxText;

    private var _hash:Object;

    public function Hud(huds:Array) {
      super();
      _bg = new AxSprite(10, 5);
      _bg.load(Background);

      _lives = new AxSprite(10, 5);
      _lives.load(Lives);
      _livesText = new AxSprite(30, 5, 30);

      _time = new AxSprite(10, 25);
      _time.load(Time);
      _timeText = new AxSprite(30, 25, 50);


      _speed = new AxSprite(10, 45);
      _speed.load(Speed);
      _speedText = new AxSprite(30, 45, 30);


      _combo = new AxSprite(Ax.width/2 - 20, 25);
      _combo.load(Combo);
      _comboText = new AxSprite(Ax.width/2, 45, 30);

      _poison = new AxSprite(Ax.width - 50, 5);
      _poison.load(Poison);
      _poisonText = new AxSprite(Ax.width - 30, 45, 30);

      add(_bg);
      add(_comboText); 
      add(_timeText); 
      add(_speedText); 
      add(_poisonText); 
      add(_livesText); 

      _hash = { lives: _lives,
                time: _time,
                speed: _speed,
                combo: _combo,
                poison: _poison }
/*        
      for (var x in huds) {
        if(_hash[x]) {
          _hash[x].last.text = huds[x];
          _hash[x].last.alignment =;
          _hash[x].last.size = 16;

          add(_hash[x].last);
          add(_hash[x].first);
        }  
      }     
*/                  
    
      for (var i:int = 0; i < huds.length; i++) {
        if (_hash[huds[i]]) {
          add(_hash[huds[i]]) 
        }  
      }


    }
    
    public function set livesText(l:String):void {
      _livesText.text = l;
    }

    public function set speedText(sp:String):void {
      _speedText.text = sp;
    }

    public function set comboText(combo:String):void {
      _comboText = combo;
    }

    public function set 

  }
}
    

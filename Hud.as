package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.util.*;
  
  public class Hud extends AxGroup {
    [Embed(source='assets/images/icons/anzeigenbalken.png')] protected var Background:Class;
    [Embed(source='assets/images/icons/icon-combo.png')] protected var Combo:Class;
    [Embed(source='assets/images/icons/icon-lives.png')] protected var Lives:Class;
    [Embed(source='assets/images/icons/icon-poison.png')] protected var Poison:Class;
    [Embed(source='assets/images/icons/icon-speed.png')] protected var Speed:Class;
    [Embed(source='assets/images/icons/icon-time.png')] protected var Time:Class;
    [Embed(source='assets/images/icons/icon-score.png')] protected var Score:Class;
    [Embed(source='assets/images/icons/icon-egg.png')] protected var EEgg:Class;

    private var _bg:AxSprite;
    private var _lives:AxSprite = new AxSprite(0,0,Lives);
    private var _livesText:AxText = new AxText(0,0,null,"");

    private var _combo:AxSprite = new AxSprite(0,0,Combo);
    private var _comboText:AxText = new AxText(0,0,null,"");

    private var _poison:AxSprite = new AxSprite(0,0,Poison);
    private var _poisonText:AxText = new AxText(0,0,null,"");

    private var _speed:AxSprite = new AxSprite(0,0,Speed);
    private var _speedText:AxText = new AxText(0,0,null,"");

    private var _time:AxSprite = new AxSprite(0,0,Time);
    private var _timeText:AxText = new AxText(0,0,null,"");

    private var _score:AxSprite = new AxSprite(0,0,Score);
    private var _scoreText:AxText = new AxText(0,0,null,"");

    private var _egg:AxSprite = new AxSprite(0,0,EEgg);
    private var _eggText:AxText = new AxText(0,0,null,"");

    private var _hash:Object;
    private var _xPos:int = 15;
    private var _yPos:int = 10;

    public function Hud(huds:Array) {
      super();
      _bg = new AxSprite(10, 5);
      _bg.load(Background);
      add(_bg);

      _hash = { lives: [_lives, _livesText, 12],
                speed: [_speed, _speedText, 24],
                combo: [_combo,_comboText, 60],
                poison: [_poison, _poisonText, 24], 
                score: [_score, _scoreText, 36], 
                egg: [_egg, _eggText, 60], 
                time: [_time, _timeText, 60]
                }
      for (var i:int = 0; i < huds.length; i++) {
        if (_hash[huds[i]]) {
          displayIcon(_hash[huds[i]]);
        }  
      }
      
      var rect:AxRect = new AxRect(0,0);
      for each(var sprite:AxModel in members) {
        sprite.scroll = rect;
      }
    }

    private function displayIcon(lis:Array):void {
      var sp:AxSprite = lis[0];
      var txt:AxText = lis[1];
      var txtWidth:int = lis[2];
 
      sp.x = _xPos;
      sp.y = _yPos;
      
      txt.scale.x = txt.scale.y = 2;
      txt.x = _xPos + sp.width + 5;
      txt.y = _yPos;
      txt.width = txtWidth;
      txt.align = "left";
      
      _xPos += sp.width + 5 + txt.width;
      
      add(sp);
      add(txt);
    }
    
    public function set livesText(l:String):void {
      _livesText.text = l;
    }

    public function set speedText(sp:String):void {
      _speedText.text = sp;
    }

    public function set comboText(combo:String):void {
      _comboText.text = combo;
    }

    public function set poisonText(poison:String):void {
      _poisonText.text = poison; 
    }

    public function set timeText(time:String):void {
      _timeText.text = time; 
    }

    public function set scoreText(score:String):void {
      _scoreText.text = score;
    }

    public function set eggText(eggAmount:String):void {
      _eggText.text = eggAmount;
    }
    
    override public function draw():void {
      // HACK! This keeps the HUD from zooming.
      var tempZoom:Number = Ax.zoom;
      Ax.zoom = 1;
      super.draw();
      Ax.zoom = tempZoom;
    }
  }
}
   

package {
  import org.flixel.*;
  
  public class Hud extends FlxGroup{
    [Embed(source='assets/images/icons/anzeigenbalken.png')] protected var Background:Class;
    [Embed(source='assets/images/icons/icon-combo.png')] protected var Combo:Class;
    [Embed(source='assets/images/icons/icon-lives.png')] protected var Lives:Class;
    [Embed(source='assets/images/icons/icon-poison.png')] protected var Poison:Class;
    [Embed(source='assets/images/icons/icon-speed.png')] protected var Speed:Class;
    [Embed(source='assets/images/icons/icon-time.png')] protected var Time:Class;

    private var _bg:FlxSprite;
    private var _lives:FlxSprite;
    private var _livesText:FlxText;

    private var _combo:FlxSprite;
    private var _comboText:FlxText;

    private var _poison:FlxSprite;
    private var _poisonText:FlxText;

    private var _speed:FlxSprite;
    private var _speedText:FlxText;

    private var _time:FlxSprite;
    private var _timeText:FlxText;

    private var _hash:Object;

    public function Hud(huds:Object) {
      super();
      _bg = new FlxSprite(10, 5);
      _bg.loadGraphic(Background);

      _lives = new FlxSprite(10, 5);
      _lives.loadGraphic(Lives);

      _time = new FlxSprite(10, 25);
      _time.loadGraphic(Time);

      _speed = new FlxSprite(10, 45);
      _speed.loadGraphic(Speed);

      _combo = new FlxSprite(FlxG.width/2 - 20, 25);
      _combo.loadGraphic(Combo);

      _poison = new FlxSprite(FlxG.width - 50, 5);
      _poison.loadGraphic(Poison);

      add(_bg);
      
      _hash = { lives: _lives,
                time: _time,
                speed: _speed,
                combo: _combo,
                poison: _poison }
        
      for (var x in huds) {
        

      }     
                  



    }
    


  }
}
    

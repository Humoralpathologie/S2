package 
{
  import org.axgl.*;
  public class ArcadeMenu extends AxState
  {
    [Embed(source = "assets/images/arcade-background_iphone4.png")] private var _bg:Class;
    [Embed(source = "assets/images/arcade-box-710.png")] private var _greyBox:Class;
    [Embed(source = "assets/images/combo-speed.png")] private var _comboSpeed:Class;
    [Embed(source = "assets/images/combo-time.png")] private var _comboTime:Class;
    [Embed(source = "assets/images/combo-fouleggs.png")] private var _comboFouleggs:Class;
    [Embed(source = "assets/images/combo-shuffle.png")] private var _comboShuffle:Class;
    [Embed(source = "assets/images/combo-gold.png")] private var _comboGold:Class;
    [Embed(source = "assets/images/combo-xtralife.png")] private var _comboXtralife:Class;
    [Embed(source = "assets/images/info-button.png")] private var _infoButton:Class;
    [Embed(source = "assets/images/combo-special.png")] private var _comboSpecial:Class;
    [Embed(source = "assets/images/text_arcade mode.png")] private var _textArcadeMode:Class;
    
    
    override public function create():void {
      var _bgSprite:AxSprite = new AxSprite(0, 0, _bg);
      var _greyBoxSprite:AxSprite = new AxSprite(65 + 60, 40 + 30, _greyBox);
      var _comboSpeedSprite:AxSprite = new AxSprite(96 + 60, 352 + 30, _comboSpeed);
      var _comboTimeSprite:AxSprite = new AxSprite(96 + 60 + 112, 352 + 30, _comboTime);
      var _comboFouleggsSprite:AxSprite = new AxSprite(96 + 60 + (2 * 112), 352 + 30, _comboFouleggs);
      var _comboShuffleSprite:AxSprite = new AxSprite(96 + 60 + (3 * 112), 352 + 30, _comboShuffle);
      var _comboGoldSprite:AxSprite = new  AxSprite(96 + 60 + (4 * 112), 352 + 30, _comboGold);
      var _comboXtralifeSprite:AxSprite = new AxSprite(96 + 60 + (5 * 112), 352 + 30, _comboXtralife);
      
      var _infoButtonSprite:AxSprite = new AxSprite(860, 30, _infoButton);
      
      var _comboSpecialSprite1:AxSprite = new AxSprite(165 + 60, 112 + 30, _comboSpecial);
      var _comboSpecialSprite2:AxSprite = new AxSprite(376 + 60, 112 + 30, _comboSpecial);
      var _comboSpecialSprite3:AxSprite = new AxSprite(587 + 60, 112 + 30, _comboSpecial);
      
      var _textArcadeModeSprite:AxSprite = new AxSprite(0, 20, _textArcadeMode);
      _textArcadeModeSprite.x = (960 - _textArcadeModeSprite.width) / 2;
      
      add(_bgSprite);
      add(_greyBoxSprite);
      add(_comboSpeedSprite);
      add(_comboTimeSprite);
      add(_comboFouleggsSprite);
      add(_comboShuffleSprite);
      add(_comboGoldSprite);
      add(_comboXtralifeSprite);
      
      add(_infoButtonSprite);
      
      add(_comboSpecialSprite1);
      add(_comboSpecialSprite2);
      add(_comboSpecialSprite3);
      
      add(_textArcadeModeSprite);
    }
  }
    
}
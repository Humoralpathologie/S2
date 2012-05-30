package 
{
  import org.axgl.*;
  import org.humoralpathologie.axgl.MenuButton;
  import flash.utils.*;
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
    [Embed(source = "assets/images/arcademenu/info-arcade.png")] private var _textInfo:Class;
    [Embed(source = "assets/images/arcademenu/text_play.png")] private var _textPlay:Class;
    [Embed(source = "assets/images/arcademenu/info-gold.png")] private var _infoBoxGold:Class;
    [Embed(source = "assets/images/arcademenu/info-speed.png")] private var _infoBoxSpeed:Class;
    [Embed(source = "assets/images/arcademenu/info-rotteneggs.png")] private var _infoBoxRotten:Class;
    [Embed(source = "assets/images/arcademenu/info-shuffle.png")] private var _infoBoxShuffle:Class;
    [Embed(source = "assets/images/arcademenu/info-time.png")] private var _infoBoxTime:Class;
    [Embed(source = "assets/images/arcademenu/info-xtralife.png")] private var _infoBoxXtralife:Class;
   
    private var _menuLevel:int = 0;
    private var _mainMenuButtons:AxGroup;
    
    private var _infoScreen:AxGroup;
    
    private var _infoGold:AxGroup;
    private var _infoRotten:AxGroup;
    private var _infoShuffle:AxGroup;
    private var _infoSpeed:AxGroup;
    private var _infoTime:AxGroup;
    private var _infoXtralife:AxGroup;
    
    private var _buttons:AxGroup;
    
    private var _screens:Object = { };
    
    
    override public function create():void {
      var _bgSprite:AxSprite = new AxSprite(0, 0, _bg);
      var _greyBoxSprite:AxSprite = new AxSprite(65 + 60, 40 + 30, _greyBox);

      
      
      var _comboSpecialSprite1:AxSprite = new AxSprite(165 + 60, 112 + 30, _comboSpecial);
      var _comboSpecialSprite2:AxSprite = new AxSprite(376 + 60, 112 + 30, _comboSpecial);
      var _comboSpecialSprite3:AxSprite = new AxSprite(587 + 60, 112 + 30, _comboSpecial);
      
      var _textArcadeModeSprite:AxSprite = new AxSprite(0, 20, _textArcadeMode);
      _textArcadeModeSprite.x = (960 - _textArcadeModeSprite.width) / 2;
      
      
      _buttons = new AxGroup();
      
      add(_bgSprite);
      add(_greyBoxSprite);
            
      add(_comboSpecialSprite1);
      add(_comboSpecialSprite2);
      add(_comboSpecialSprite3);
      
      add(_textArcadeModeSprite);
      
      createMainMenuButtons();
      
      createScreens();
    }
    
    private function createScreens():void {
      createInfoScreen();
      createInfo("InfoBoxGold", _infoBoxGold);
      createInfo("InfoBoxSpeed", _infoBoxSpeed);
      createInfo("InfoBoxRotten", _infoBoxRotten);
      createInfo("InfoBoxShuffle", _infoBoxShuffle);
      createInfo("InfoBoxTime", _infoBoxTime);
      createInfo("InfoBoxXtralife", _infoBoxXtralife);

    }
    
    private function createInfo(name:String, image:Class) {
      var temp:AxGroup = new AxGroup();
      var _textBox:AxSprite = new MenuButton(300, 200, 1, image, closeScreen(name));
      _textBox.x = (Ax.width - _textBox.width) / 2;
      _textBox.y = (Ax.height - _textBox.height) / 2;
      _buttons.add(_textBox);
      temp.add(_textBox);
      _screens[name] = temp;
    }
        
    private function createInfoScreen():void {
      _infoScreen = new AxGroup();
      var _textBox:AxSprite = new MenuButton(80, 40, 1, _textInfo, closeScreen("InfoScreen"));
      _buttons.add(_textBox);
      _infoScreen.add(_textBox);
      
      _screens["InfoScreen"] = _infoScreen;
    }
    
    private function showScreen(name:String):Function {
      return function() {
        setTimeout(function() {
          add(_screens[name]);
          _menuLevel += 1;
          updateButtonLevel();
      }, 200);
      }
    }
   
    private function closeScreen(name:String):Function {
      return function() {
        remove(_screens[name]);
        _menuLevel -= 1;
        updateButtonLevel();
      }
    }
    
    private function updateButtonLevel():void {
      for each(var b:MenuButton in _buttons.members) {
        b.currentLevel = _menuLevel;
      }
    }
    
    private function createMainMenuButtons():void {
      _mainMenuButtons = new AxGroup();

      // Game buttons
      var _infoButtonSprite:AxSprite = new MenuButton(860, 30, 0, _infoButton, showScreen("InfoScreen"));
      var _playButton:AxSprite = new MenuButton(65 + 60, 540, 0, _textPlay, startArcade);

      _mainMenuButtons.add(_infoButtonSprite);
      _mainMenuButtons.add(_playButton);
      _buttons.add(_infoButtonSprite);
      _buttons.add(_playButton);
      
      // Combo info
      
      var _comboSpeedSprite:AxSprite = new MenuButton(96 + 60, 352 + 30, 0, _comboSpeed, showScreen("InfoBoxSpeed"));
      var _comboTimeSprite:AxSprite = new MenuButton(96 + 60 + 112, 352 + 30,0, _comboTime, showScreen("InfoBoxTime"));
      var _comboFouleggsSprite:AxSprite = new MenuButton(96 + 60 + (2 * 112), 352 + 30,0, _comboFouleggs, showScreen("InfoBoxRotten"));
      var _comboShuffleSprite:AxSprite = new MenuButton(96 + 60 + (3 * 112), 352 + 30, 0,_comboShuffle,showScreen("InfoBoxShuffle"));
      var _comboGoldSprite:AxSprite = new  MenuButton(96 + 60 + (4 * 112), 352 + 30,0, _comboGold,showScreen("InfoBoxGold"));
      var _comboXtralifeSprite:AxSprite = new MenuButton(96 + 60 + (5 * 112), 352 + 30,0, _comboXtralife, showScreen("InfoBoxXtralife"));
      
      _mainMenuButtons.add(_comboSpeedSprite);
      _mainMenuButtons.add(_comboTimeSprite);
      _mainMenuButtons.add(_comboFouleggsSprite);
      _mainMenuButtons.add(_comboShuffleSprite);
      _mainMenuButtons.add(_comboGoldSprite);
      _mainMenuButtons.add(_comboXtralifeSprite);
      
      _buttons.add(_comboSpeedSprite);
      _buttons.add(_comboTimeSprite);
      _buttons.add(_comboFouleggsSprite);
      _buttons.add(_comboShuffleSprite);
      _buttons.add(_comboGoldSprite);
      _buttons.add(_comboXtralifeSprite);
      
      add(_mainMenuButtons);
    }
    
    private function startArcade():void {
      Ax.switchState(new Arcade);
    }
        
  }
    
}
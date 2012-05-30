package 
{
  import com.adobe.utils.AGALMiniAssembler;
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
    [Embed(source = "assets/images/combo-boost.png")] private var _specialBoost:Class;
    [Embed(source = "assets/images/combo-brake.png")] private var _specialBrake:Class;
    [Embed(source = "assets/images/combo-leveluptime.png")] private var _specialUptime:Class;
    [Embed(source = "assets/images/combo-chaintime.png")] private var _specialChaintime:Class;
    [Embed(source = "assets/images/combo-xtraspawn.png")] private var _specialXtraspawn:Class;
    [Embed(source = "assets/images/arcademenu/Text-Boost.png")] private var _specialBoostText:Class;
    [Embed(source = "assets/images/arcademenu/Text-Brake.png")] private var _specialBrakeText:Class;
    [Embed(source = "assets/images/arcademenu/Text-BonusTimePlus.png")] private var _specialUptimeText:Class;
    [Embed(source = "assets/images/arcademenu/Text-ChainTimePlus.png")] private var _specialChaintimeText:Class;
    [Embed(source = "assets/images/arcademenu/Text-ExtraEgg.png")] private var _specialXtraspawnText:Class;
    [Embed(source = "assets/images/combo_acba.png")] private var _comboACBA:Class;
    [Embed(source = "assets/images/combo_abcb.png")] private var _comboABCB:Class;
    [Embed(source = "assets/images/combo_bccb.png")] private var _comboBCCB:Class;
    [Embed(source = "assets/images/combo_abbca.png")] private var _comboABBCA:Class;
    [Embed(source = "assets/images/combo_bcaac.png")] private var _comboBCAAC:Class;
    [Embed(source = "assets/images/combo_ccbba.png")] private var _comboCCBBA:Class;
    [Embed(source = "assets/images/bccb.png")] private var _eggsBCCB:Class;
    [Embed(source = "assets/images/abcb.png")] private var _eggsABCB:Class;
    [Embed(source = "assets/images/acba.png")] private var _eggsACBA:Class;
    [Embed(source = "assets/images/abbca.png")] private var _eggsABBCA:Class;
    [Embed(source = "assets/images/bcaac.png")] private var _eggsBCAAC:Class;
    [Embed(source = "assets/images/ccbba.png")] private var _eggsCCBBA:Class;
    [Embed(source = "assets/images/arcademenu/arcade-slotbox01.png")] private var _slotBox1:Class;
    [Embed(source = "assets/images/arcademenu/arcade-slotbox02.png")] private var _slotBox2:Class;
    
     
    
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
    private var _specialBox:Array = [];
    private var _selectedBox:int = 0;
    private var _selectedSpecial:String = "";
    private var _comboBoxes:AxGroup;
    private var _comboOverlays:AxGroup;
    
    private var bccb:AxSprite;
    private var abcb:AxSprite;
    private var acba:AxSprite;
    
    private var abbca:AxSprite;
    private var bcaac:AxSprite;
    private var ccbba:AxSprite;
    
    
    override public function create():void {
      var _bgSprite:AxSprite = new AxSprite(0, 0, _bg);
      
      _buttons = new AxGroup();
      _comboBoxes = new AxGroup();
      _comboOverlays = new AxGroup();
      
      _specialBox = SaveGame.getSpecial();
      
      add(_bgSprite);
      
      createScreens();
      updateComboBoxes();

      add(_screens["Main"]);
    }
    
    private function switchScreen(prev:String, curr:String):Function {
      return function():void {
        setTimeout(function():void {
          remove(_screens[prev]);
          add(_screens[curr]);
        }, 100);
      }
    }
    
    private function selectSpecialBox(n:int):Function {
      return function():void {
        _selectedBox = n;
        switchScreen("Main", "ComboSelect1")();
      }
    }
    
    private function createMainScreen():void {
      var temp:AxGroup = new AxGroup;
      
      var _greyBoxSprite:AxSprite = new AxSprite(65 + 60, 40 + 30, _greyBox);
      temp.add(_greyBoxSprite);
      
      var _comboSpecialSprite1:AxSprite = new MenuButton(165 + 60, 112 + 30, 0, _comboSpecial, selectSpecialBox(0));
      var _comboSpecialSprite2:AxSprite = new MenuButton(376 + 60, 112 + 30,0, _comboSpecial, selectSpecialBox(1));
      var _comboSpecialSprite3:AxSprite = new MenuButton(587 + 60, 112 + 30,0, _comboSpecial, selectSpecialBox(2));
      
      var _textArcadeModeSprite:AxSprite = new AxSprite(0, 20, _textArcadeMode);
      _textArcadeModeSprite.x = (960 - _textArcadeModeSprite.width) / 2;      
      
      _comboBoxes.add(_comboSpecialSprite1);
      _comboBoxes.add(_comboSpecialSprite2);
      _comboBoxes.add(_comboSpecialSprite3);
      
      temp.add(_comboBoxes);
      temp.add(_comboOverlays);
      
      _buttons.add(_comboSpecialSprite1);
      _buttons.add(_comboSpecialSprite2);
      _buttons.add(_comboSpecialSprite3);
      
      temp.add(_textArcadeModeSprite);
      
      // Game buttons
      var _infoButtonSprite:AxSprite = new MenuButton(860, 30, 0, _infoButton, showScreen("InfoScreen"));
      var _playButton:AxSprite = new MenuButton(65 + 60, 540, 0, _textPlay, startArcade);

      temp.add(_infoButtonSprite);
      temp.add(_playButton);
      _buttons.add(_infoButtonSprite);
      _buttons.add(_playButton);
      
      // Combo info
      
      var _comboSpeedSprite:AxSprite = new MenuButton(96 + 60, 352 + 30, 0, _comboSpeed, showScreen("InfoBoxSpeed"));
      var _comboTimeSprite:AxSprite = new MenuButton(96 + 60 + 112, 352 + 30,0, _comboTime, showScreen("InfoBoxTime"));
      var _comboFouleggsSprite:AxSprite = new MenuButton(96 + 60 + (2 * 112), 352 + 30,0, _comboFouleggs, showScreen("InfoBoxRotten"));
      var _comboShuffleSprite:AxSprite = new MenuButton(96 + 60 + (3 * 112), 352 + 30, 0,_comboShuffle,showScreen("InfoBoxShuffle"));
      var _comboGoldSprite:AxSprite = new  MenuButton(96 + 60 + (4 * 112), 352 + 30,0, _comboGold,showScreen("InfoBoxGold"));
      var _comboXtralifeSprite:AxSprite = new MenuButton(96 + 60 + (5 * 112), 352 + 30,0, _comboXtralife, showScreen("InfoBoxXtralife"));
      
      temp.add(_comboSpeedSprite);
      temp.add(_comboTimeSprite);
      temp.add(_comboFouleggsSprite);
      temp.add(_comboShuffleSprite);
      temp.add(_comboGoldSprite);
      temp.add(_comboXtralifeSprite);
      
      _buttons.add(_comboSpeedSprite);
      _buttons.add(_comboTimeSprite);
      _buttons.add(_comboFouleggsSprite);
      _buttons.add(_comboShuffleSprite);
      _buttons.add(_comboGoldSprite);
      _buttons.add(_comboXtralifeSprite);
      
      _screens["Main"] = temp;
    }
    
    private function createScreens():void {
      createMainScreen();
      createInfoScreen();
      createInfo("InfoBoxGold", _infoBoxGold);
      createInfo("InfoBoxSpeed", _infoBoxSpeed);
      createInfo("InfoBoxRotten", _infoBoxRotten);
      createInfo("InfoBoxShuffle", _infoBoxShuffle);
      createInfo("InfoBoxTime", _infoBoxTime);
      createInfo("InfoBoxXtralife", _infoBoxXtralife);
      createComboSelect1();
      createComboSelect2();
      createPossibleCombos();
      createPossibleFiveCombos();
    }
    
    private function removeDuplicateCombos():void {
      for (var i:int = 0; i < _specialBox.length; i++) {
        if (_specialBox[i] && i != _selectedBox) {
          if (_specialBox[i].comboType == _specialBox[_selectedBox].comboType || _specialBox[i].trigger == _specialBox[_selectedBox].trigger) {
            _specialBox[i] = null;
          }
        }
      }
    }
    
    private function createPossibleCombos():void {
      
      var temp:AxGroup = new AxGroup;
      
      function eggCallback(trigger:String):Function {
        return function():void {
          _specialBox[_selectedBox].trigger = trigger; 
          removeDuplicateCombos();
          closeScreen("PossibleCombos")(); 
          closeScreen("ComboSelect1")(); 
          showScreen("Main")();
        }
      }
      
      bccb = new MenuButton(278, 0, 1, _comboBCCB, eggCallback("bccb") );
      abcb = new MenuButton(399, 0, 1, _comboABCB, eggCallback("abcb") );
      acba = new MenuButton(520, 0, 1, _comboACBA, eggCallback("acba"));
           
      _buttons.add(bccb);
      _buttons.add(abcb);
      _buttons.add(acba);
      
      temp.add(bccb);
      temp.add(abcb);
      temp.add(acba);
      
      _screens["PossibleCombos"] = temp;
    }
    
    private function createPossibleFiveCombos():void {
      
      var temp:AxGroup = new AxGroup;
      
      function eggCallback(trigger:String):Function {
        return function():void {
          _specialBox[_selectedBox].trigger = trigger; 
          removeDuplicateCombos();
          closeScreen("PossibleFiveCombos")(); 
          closeScreen("ComboSelect2")(); 
          showScreen("Main")();
        }
      }
      
      abbca = new MenuButton(278, 0, 1, _comboABBCA, eggCallback("abbca") );
      bcaac = new MenuButton(399, 0, 1, _comboBCAAC, eggCallback("bcaac") );
      ccbba = new MenuButton(520, 0, 1, _comboCCBBA, eggCallback("ccbba"));
           
      _buttons.add(abbca);
      _buttons.add(bcaac);
      _buttons.add(ccbba);
      
      temp.add(abbca);
      temp.add(bcaac);
      temp.add(ccbba);
      
      _screens["PossibleFiveCombos"] = temp;
    }    
    
    private function showPossibleCombos(pos:int, comboType:String):Function {
      return function():void {
        
        bccb.y = pos + 20;
        abcb.y = pos + 20;
        acba.y = pos + 20;

        _specialBox[_selectedBox] = { comboType: comboType };
        
        showScreen("PossibleCombos")();          
      }
    }
    
    private function showPossibleFiveCombos(pos:int, comboType:String):Function {
      return function():void {
        
        abbca.y = pos + 20;
        bcaac.y = pos + 20;
        ccbba.y = pos + 20;

        _specialBox[_selectedBox] = { comboType: comboType };
        
        showScreen("PossibleFiveCombos")();          
      }
    }    
    
    
    private function createComboSelect1():void {
      var temp:AxGroup = new AxGroup();
      
      var graybackground:AxSprite = new AxSprite(125, 70, _slotBox1);
      var nextScreen:AxSprite = new MenuButton(650 + 125, 400 + 60, 0, null, switchScreen("ComboSelect1", "ComboSelect2"));
      nextScreen.create(50, 50, 0x00ff0000);
      
      var boost:AxSprite = new MenuButton(156, 152, 0, _specialBoost, function() { _specialBox[_selectedBox] = { comboType:"Boost" }; removeDuplicateCombos();  closeScreen("ComboSelect1")(); showScreen("Main")(); } );
      var brake:AxSprite = new MenuButton(156, 285,0, _specialBrake, showPossibleCombos(285, "Brake"));
      var uptime:AxSprite = new MenuButton(156, 389, 0, _specialUptime, showPossibleCombos(389, "Uptime"));
      
      
      var boostText:AxSprite = new AxSprite(263, 154, _specialBoostText);
      var brakeText:AxSprite = new AxSprite(264, 299, _specialBrakeText);
      var uptimeText:AxSprite = new AxSprite(263, 404, _specialUptimeText);
      
      _buttons.add(boost);
      _buttons.add(brake);
      _buttons.add(uptime);
      
      _buttons.add(nextScreen);
      
      
      temp.add(graybackground);
      temp.add(nextScreen);
      
      temp.add(boost);
      temp.add(brake);
      temp.add(uptime);
      
      temp.add(boostText);
      temp.add(brakeText);
      temp.add(uptimeText);
      
      _screens["ComboSelect1"] = temp;
    }
    
    private function createComboSelect2():void {
      var temp:AxGroup = new AxGroup();
      
      var bg:AxSprite = new AxSprite(125, 70, _slotBox2);
      var prevButton:AxSprite = new MenuButton(130, 460, 0, null, switchScreen("ComboSelect2", "ComboSelect1"));
      prevButton.create(50, 50, 0x00ff0000);
      
      var chainTime:AxSprite = new MenuButton(156, 152, 0, _specialChaintime, showPossibleFiveCombos(152, "ChainTime"));
      var xtraspawn:AxSprite = new MenuButton(156, 280, 0, _specialXtraspawn, showPossibleFiveCombos(280, "Xtraspawn"));
      
      var chainTimeText:AxSprite = new AxSprite(264, 165, _specialChaintimeText);
      var xtraspawnText:AxSprite = new AxSprite(264, 280, _specialXtraspawnText);
      
      temp.add(bg);      
      temp.add(prevButton);
      
      temp.add(chainTime);
      temp.add(xtraspawn);
      
      temp.add(chainTimeText);
      temp.add(xtraspawnText);
      
      _buttons.add(prevButton);
      _buttons.add(chainTime);
      _buttons.add(xtraspawn);
     
      
      _screens["ComboSelect2"] = temp;
    }
    
    private function createInfo(name:String, image:Class):void {
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
    
    private function updateComboBoxes():void {
      var sprite:AxSprite;

      _comboOverlays.clear();
      function addEggs(k:int):void {
        switch(_specialBox[i].trigger) {
          case "bccb":
            sprite = new AxSprite(165 + 60 + (i * 211), 142, _eggsBCCB);
            break;
          case "abcb":
            sprite = new AxSprite(165 + 60 + (i * 211), 142, _eggsABCB);
            break;     
          case "acba":
            sprite = new AxSprite(165 + 60 + (i * 211), 142, _eggsACBA);
            break;      
          case "abbca":
            sprite = new AxSprite(165 + 60 + (i * 211), 142, _eggsABBCA);
            break;
          case "bcaac":
            sprite = new AxSprite(165 + 60 + (i * 211), 142, _eggsBCAAC);
            break;
          case "ccbba":
            sprite = new AxSprite(165 + 60 + (i * 211), 142, _eggsCCBBA);
            break;
        }
        _comboOverlays.add(sprite);
      }
      
      for (var i:int = 0; i < _specialBox.length; i++ ) {
        if(_specialBox[i]) {
          switch(_specialBox[i].comboType) {
            case "Boost":
              sprite = new AxSprite(165 + 60 + (i * 211), 142, _specialBoost);
              _comboOverlays.add(sprite);
              break;
            case "Brake":
              sprite = new AxSprite(165 + 60 + (i * 211), 142, _specialBrake);
              _comboOverlays.add(sprite);
              addEggs(i);
              break;
            case "Uptime":
              sprite = new AxSprite(165 + 60 + (i * 211), 142, _specialUptime);
              _comboOverlays.add(sprite);
              addEggs(i);
              break;
            case "ChainTime":
              sprite = new AxSprite(165 + 60 + (i * 211), 142, _specialChaintime);
              _comboOverlays.add(sprite);
              addEggs(i);
              break;
            case "Xtraspawn":
              sprite = new AxSprite(165 + 60 + (i * 211), 142, _specialXtraspawn);
              _comboOverlays.add(sprite);
              addEggs(i);
              break;
          }                      
        }
      }
    }
    
    private function showScreen(name:String):Function {
      if (name == "Main") {
        updateComboBoxes();
      }
      return function():void {
        setTimeout(function():void {
          add(_screens[name]);
          _menuLevel += 1;
          updateButtonLevel();
      }, 100);
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
    
    private function startArcade():void {
      SaveGame.saveSpecial(_specialBox);
      Ax.switchState(new Arcade);
    }
        
  }
    
}
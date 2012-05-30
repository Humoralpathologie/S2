package org.humoralpathologie.axgl 
{
	import org.axgl.AxSprite;
	
	/**
     * ...
     * @author 
     */
  public class MenuButton extends AxSprite 
  {
      
    private var _onClick:Function = null;
    private var _menuLevel:int = 0;
    private var _currentLevel:int = 0;
    
    public function MenuButton(x:int, y:int, menuLevel:int, image:*, callback:Function) {
      super(x, y, image);
      _onClick = callback;
      _menuLevel = menuLevel;
    }
    
    override public function update():void {
      super.update();
      if (clicked()) {
        trace("clicked");
        trace(_menuLevel, _currentLevel);
      }
      if (_menuLevel == _currentLevel && clicked()) {
        _onClick();
      }
    }
    
    public function get currentLevel():int 
    {
      return _currentLevel;
     }
  
    public function set currentLevel(value:int):void 
    {
      _currentLevel = value;
    }
  }
}

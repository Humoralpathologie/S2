package {

  import org.axgl.*;
  import org.axgl.text.*;
  import flash.events.*;
  import flash.net.*;

  public class LeaderBoard extends AxState {
    [Embed(source='assets/images/menu/menu_iphone_background.png')] protected var Background:Class;
    [Embed(source='assets/images/menu/menu_board.png')] protected var Board:Class;
    [Embed(source='assets/images/menu/menu-egg-back.png')] protected var Back:Class;
    
    private var _background:AxSprite;
    private var _boardLeft:AxSprite;
    private var _boardRight:AxSprite;
    private var _backToMenu:AxButton;


    override public function create():void {
      _background = new AxSprite(0, 0, Background);

      _boardLeft = new AxSprite(60, 30, Board);    
      _boardRight = new AxSprite(_boardLeft.x + _boardLeft.width + 40, 30, Board);    
     
      var mid:int = 640 / 2 - 60;      

      _backToMenu = new AxButton(mid, 330);
      _backToMenu.load(Back, 100, 110);
      _backToMenu.onClick(switchToState(MenuState, _backToMenu));

      add(_background);
      add(_boardLeft);
      add(_boardRight); 
      add(_backToMenu);

      getScores();
    }

    public function switchToState(state:Class, button:AxButton):Function {
      return function():void { 
        Ax.switchState(new state);
      }
    }
   
    private function getScores():void {
      var url:String = "https://www.scoreoid.com/api/getBestScores";
      var request:URLRequest = new URLRequest(url);
      var requestVars:URLVariables = new URLVariables();
      request.data = requestVars;
      requestVars.api_key = "7bb1d7f5ac027ae81b6c42649fddc490b3eef755";
      requestVars.game_id = "2RCmMyKmt";
      requestVars.response ="JSON"
      requestVars.limit = "5";
                         
      request.method = URLRequestMethod.POST;
   
      var urlLoader:URLLoader = new URLLoader();
      urlLoader = new URLLoader();
      urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
      urlLoader.addEventListener(Event.COMPLETE, showScores);

      urlLoader.load(request);

    }

    private function showScores(event:Event):void {
      var text:AxText;
      var pos:int = 40;
      var arr:Array = (JSON.parse(event.target.data) as Array);
      for each(var el:* in arr) {
        text = new AxText(70, pos, null, "");
        text.text = el["Player"]["username"] + ": " + el["Score"]["score"];
        text.scale.x = 2;
        text.scale.y = 2;
        pos += 20;
        add(text);
      }
    }
  }
}

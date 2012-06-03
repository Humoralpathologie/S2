package  
{
  import org.axgl.AxGroup;
  import org.axgl.AxPoint;
  import org.axgl.AxRect;
  import org.axgl.AxSprite;
  import org.axgl.Ax;

  public class Radar extends AxGroup 
  {
    
    private var _foodGroup:AxGroup;
    private var _center:AxPoint;
    private var _radius:int = 150;
    private var _noScroll:AxPoint;
    private var _snake:Snake;
    private var _egg2Radar:Object;
    private var _circle:AxSprite;
    private var _cameraCenter:AxPoint;
    
    [Embed(source = "assets/images/Radar/radar_a.png")] private var radarA:Class;
    [Embed(source = "assets/images/Radar/radar_b.png")] private var radarB:Class;
    [Embed(source = "assets/images/Radar/radar_c.png")] private var radarC:Class;
    
    [Embed(source = "assets/images/Radar/radar_gold.png")] private var radarGold:Class;
    [Embed(source = "assets/images/Radar/radar_green.png")] private var radarGreen:Class;
    [Embed(source = "assets/images/Radar/radar_rotten.png")] private var radarRotten:Class;
    [Embed(source = "assets/images/Radar/radar_shuffle.png")] private var radarShuffle:Class;
    
    [Embed(source = "assets/images/Radar/KreisRadar.png")] private var _circleGraphic:Class;
    
    private var _radarPool:AxGroup;
        
    public function Radar(foodGroup:AxGroup, snake:Snake) 
    {
      super();
      
      _circle = new AxSprite(Ax.width / 2 - _radius, Ax.height / 2 - _radius, _circleGraphic);
      _radarPool = new AxGroup();
      _noScroll = new AxPoint(0, 0);
      _cameraCenter = new AxPoint(0, 0);


      _circle.alpha = 0.2;
      _circle.zooms = false;
      _circle.scroll = _noScroll;
      add(_circle);
      add(_radarPool);
      
     
      // Fill the Radar egg pool because the iPhone is just too slow to do it dynamically.
      
      for (var i:int = 0; i < 10; i++) {
        var sprite:AxSprite = new AxSprite(0, 0);
        sprite.exists = false;
        sprite.scroll = _noScroll;
        sprite.zooms = false;
        sprite.alpha = 0.8;
        
        _radarPool.add(sprite);
      }

      _egg2Radar = { 
        (int(EggTypes.EGGA)): radarA,
        (int(EggTypes.EGGB)): radarB,
        (int(EggTypes.EGGC)): radarC,
        (int(EggTypes.EGGZERO)): radarGreen,
        (int(EggTypes.GOLDEN)): radarGold,
        (int(EggTypes.ROTTEN)): radarRotten,
        (int(EggTypes.SHUFFLE)): radarShuffle
      };
      _foodGroup = foodGroup;
      _snake = snake;
      
    }
   
    override public function update():void {
      _cameraCenter.x = Ax.camera.x + (Ax.width / (2 * Ax.zoom));
      _cameraCenter.y = Ax.camera.y + (Ax.height / (2 * Ax.zoom));
      
      for (var i:int = 0; i < _radarPool.members.length; i++) {
        _radarPool.members[i].exists = false;
      }
      
      var theta:Number;
      var sprite:AxSprite;
      
      for each(var egg:Egg in _foodGroup.members) {
        sprite = (_radarPool.recycle() as AxSprite);
        if(sprite == null) {
          sprite = new AxSprite(0, 0, _egg2Radar[egg.type]);
          sprite.scroll = _noScroll;
          sprite.zooms = false;
          sprite.alpha = 0.8;

          _radarPool.add(sprite);
        } else {
          trace("Recycling radar egg.");
          sprite.load(_egg2Radar[egg.type]);
          sprite.exists = true;

        }
        theta = Math.atan2(egg.y - _cameraCenter.y, egg.x - _cameraCenter.x);
        
        sprite.x = ((Ax.width - sprite.width) / 2) + (_radius * Math.cos(theta));
        sprite.y = ((Ax.height - sprite.height) / 2) + (_radius * Math.sin(theta));
      }
      //super.update();
    }
    
  }
}
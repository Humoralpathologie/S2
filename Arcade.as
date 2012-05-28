package {
  import com.gskinner.motion.GTween;
  import org.axgl.*;
  import org.axgl.text.*;
  import com.rafaelrinaldi.sound.*;
  
  public class Arcade extends LevelState {
    // Assets
    [Embed(source = 'assets/images/arcade.png')] protected var Background:Class;
    [Embed(source = "assets/music/eile_arcade1.mp3")] protected var BGM:Class;
    // Variablen
    private var _background:AxSprite = null;
    
    public function Arcade():void {
      super();
      _levelWidth = 990;
      _levelHeight = 900;
      _startPosition.x = 20;
      _startPosition.y = 20;
    }
    
    override public function create():void {
      super.create();
      
      sound().group("BGM").add("Arcade", BGM);
      var bgm:SoundItem = sound().group("BGM").item("Arcade");
      bgm.onPlay(function() { bgm.volume = 0.3; } );
      bgm.play();
      
      _comboSet.addCombo(new FasterCombo);
      _comboSet.addCombo(new ShuffleCombo);
      _comboSet.addCombo(new ExtraLifeCombo);
      _comboSet.addCombo(new ExtraTimeCombo);
      _comboSet.addCombo(new NoRottenCombo);
      _comboSet.addCombo(new GoldenCombo);
      
      _switchLevel = new SwitchLevel(Arcade, MenuState);
      
      _snake.lives = 2;
      _levelNumber = 99;
      _timeLeft = 3 * 60;
      
      _spawnRotten = true;
      
      // Spawn 6 food (adds to spawnFoods in LevelState).
      spawnFoods(3);
      
      // Visible obstacles for debugging
      // add(_obstacles);
    }

    override public function update():void {
      super.update();
    }
    
    override protected function addBackgrounds():void {
      _background = new AxSprite(0, 0, Background);
      add(_background);
    }
    
    override protected function addObstacles():void {
      var obstacle:AxSprite;
      obstacle = new AxSprite(0, 0);
      obstacle.create(165, _levelHeight, 0x9900ff00);
      _obstacles.add(obstacle);
      
      obstacle = new AxSprite(840, 0);
      obstacle.create(_levelWidth - 840, _levelHeight, 0x9900ff00);
      _obstacles.add(obstacle);
      
      var down:Array = [
        [165, 615, 30],
        [195, 630, 15],
        [210, 645, 45],
        [255, 660, 15],
        [270, 675, 45],
        [315, 690, 15],
        [330, 750, 90],
        [420, 765, 15],
        [435, 780, 15],
        [450, 795, 15 * 7],
        [555, 780, 15 * 2],
        [585, 765, 15 * 2],
        [615, 750, 15 * 2],
        [645, 735, 15 * 11],
        [810, 525, 15 * 1],
        [825, 510, 15 * 1]
        
      ];
      
      for each(var el:Array in down) {
        obstacle = new AxSprite(el[0], el[1]);
        obstacle.create(el[2], _levelHeight - obstacle.y, 0x9900ff00);
        _obstacles.add(obstacle); 
      }
      
      var up:Array = [
        [165, 570, 15],
        [180, 555, 15],
        [195, 330, 15],
        [210, 300, 15],
        [225, 285, 15],
        [240, 210, 15 * 8],
        [360, 195, 15 * 10],
        [510, 180, 15 * 9],
        [645, 150, 4 * 15],
        [705, 180, 7 * 15],
        [810, 420, 2 * 15]
        
      ];
      
      for each(var el:Array in up) {
        obstacle = new AxSprite(el[0], 0);
        obstacle.create(el[2], el[1], 0x9900ff00);
        _obstacles.add(obstacle); 
      }
          
      var special:Array = [
        [780, 540, 2 * 15, 8 * 15],
        [750, 255, 4 * 15, 9 * 15],
        [765, 240, 15, 15],
        [780, 225, 15 * 2, 15 * 2]
      ];
      
      for each(var el:Array in special) {
        obstacle = new AxSprite(el[0], el[1]);
        obstacle.create(el[2], el[3], 0x9900ff00);
        _obstacles.add(obstacle);
      }
      
    }
    
    override protected function addHud():void {
      _hud = new Hud(["lives", "time", "score"]); 
      add(_hud);
    }
    
    override protected function updateHud():void {
      _hud.livesText = String(_snake.lives);
      _hud.timeText = String(_timeLeft.toFixed(1));
      _hud.scoreText = String(_score); 
    }

    override protected function spawnFood():void {
      var rand:int = Math.floor(Math.random() * 4);
      var egg:Egg;
      egg = new Egg(rand);
      spawnEgg(egg);
    }

    override protected function checkWinConditions():Boolean {
      return(_timeLeft < 0);
    }
    
    override public function dispose():void {
      sound().group("BGM").item("Arcade").fade();
      super.dispose();
    }
  }
}

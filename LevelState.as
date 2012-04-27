package {
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.API.FlxKongregate;
  
  public class LevelState extends FlxState {
    [Embed(source='assets/SnakeSounds/schluck2tiefer.mp3')] protected var BiteSound:Class;
    [Embed(source='assets/SnakeSounds/bup.mp3')] protected var Bup:Class;
    
  
    protected var _biteSound:FlxSound;
    protected var _bup:FlxSound;

    protected var _snake:Snake;
    protected var _food:FlxGroup;
    protected var _pointHud:Tween;
    protected var _score:int;
    protected var _map:FlxTilemap;
    protected var _level:FlxGroup;
    protected var _bonusTimer:Number = 0;
    protected var _bonusTimerPoints:Number = 0;
    protected var _bonusBar:FlxSprite;
    protected var _obstacles:FlxGroup;
    protected var _unspawnable:FlxGroup;
    protected var _currentCombos:Array;
    protected var _comboTimer:Number = 0;
    protected var _combos:int = 0;
      
    override public function create():void {

      FlxG.log("Starting game");
     
      _bup = new FlxSound;
      _bup.loadEmbedded(Bup);

      _biteSound = new FlxSound;
      _biteSound.loadEmbedded(BiteSound);
      
      FlxG.mouse.hide();

      _score = 0;
      
      _snake = new Snake(8);
      _food = new FlxGroup();

      _bonusBar = new FlxSprite(450,32);
      _bonusBar.makeGraphic(1,8,0xffff0000);
      _bonusBar.origin.x = _bonusBar.origin.y = 0;
      _bonusBar.scale.x = 0;

      
      add(_bup);
      add(_biteSound);
      _obstacles = new FlxGroup();

      addBackgrounds();
      addObstacles();
  
      _unspawnable = new FlxGroup();
      _unspawnable.add(_food);
      _unspawnable.add(_snake);
      _unspawnable.add(_obstacles);

      spawnFoods(3);
      add(_snake);
      add(_food);
      add(_bonusBar);
      addHud();
    }

    /* Sort of abstract functions */
    protected function addBackgrounds():void {
    }

    protected function addObstacles():void {
    }

    protected function addHud():void {
    }

    protected function updateHud():void {
    }

    protected function spawnFoods(count:int):void {
      for(var i:int = 0; i < count; i++) {
        spawnFood();
      }
    }

    //to override in each level along with switchLevel()
    protected function levelOver():void {
    }
    
    protected function switchLevel():void {
    }


    protected function updateTimers():void {
      _bonusTimer -= FlxG.elapsed;
      _comboTimer -= FlxG.elapsed;
    }

    protected function updateBonusBar():void {
      if(_bonusTimer > 0) {
        _bonusBar.scale.x = (_bonusTimer / 2) * 25;
      } else {
        _bonusTimerPoints = 0;
        _bonusBar.scale.x = 0;
      }

      _bonusBar.x = _snake.head.x - 5;
      _bonusBar.y = _snake.head.y - 24;
    }

    protected function collideFood():void {
      // I tried to use FlxG.overlap for this, but sometimes, the callback will
      // be called twice. This works, so leave it like this.
      for(var i:int = 0; i < _food.length; i++){
        if(_snake.head.overlaps(_food.members[i])){
          eat(_snake.head, _food.members[i]);
        }
      }
    }

    protected function collideScreen():void {
      if(_snake.alive && !_snake.head.onScreen()) {
        _snake.die();
      }
    }

    protected function collideObstacles():void {
      if(_snake.alive && _snake.head.overlaps(_obstacles)) {
        _snake.die();
      }
    }

    override public function update():void {
      super.update();

      checkWinConditions();      

      updateTimers();
      updateBonusBar();
      
      collideFood();
      collideScreen();
      collideObstacles();

      if(_snake.lives < 0) {
        levelOver();
      }

      doCombos();

      updateHud();
    }

    protected function checkWinConditions():void {

    }

    protected function showPoints(egg:FlxSprite, points:String, Color:uint = 0xffffffff, Delay:Number = 0.5, Speed:int = 1):void { 
      _pointHud = new Tween(Delay, 20, egg.x, egg.y, 40, Color, points, Speed); 
      add(_pointHud);  
    } 


    protected function eat(snakeHead:FlxSprite, egg:Egg):void {
      FlxG.log("Eating at " + snakeHead.x + ", " + snakeHead.y);
      spawnFood();
      _biteSound.play();

      // TODO: This allocates too many objects. Think about how to reduce this.
      var shells:FlxEmitter = egg.shells;
      var points:int = 0;
      shells.at(snakeHead);
      shells.start(true, 3);
      add(shells);

      _food.remove(egg, true);
      
      _snake.swallow(egg);
      points += egg.points;
     
        
      if(_bonusTimer > 0) {
        _bonusTimerPoints += 2;
        showPoints(egg, '+' + String(_bonusTimerPoints), 0xffedf249, 1.5, 2); 
        _score += _bonusTimerPoints;
      }

      _score += points;
      showPoints(egg, egg.points.toString());
      _bonusTimer = 2;

    }
    
    /*
     * Should be overridden for different scoring.
     */
    protected function doCombos():void {
      var combo:Array;
      var j:int, i:int;
      if(_currentCombos && _comboTimer <= 0) {
        for(j = 0; j < _currentCombos.length; j++) {
          combo = _currentCombos[j];
          _combos += 1;
          for(i = 0; i < combo.length; i++) {
            showPoints(combo[i], '+5', 0xffff0000, 1.5, 2); 
            _score += 5;
            _snake.body.remove(combo[i], true);
          }
        }
        _snake.faster();
        _currentCombos = null;
      }
      if(_snake.justAte) {
        FlxG.log("checking for combos...");
        var combos:Array = checkCombos(_snake.body.members.slice(0,_snake.body.length - 1));
        if(combos.length > 0) {
          _currentCombos = combos;
          for(j = 0; j < _currentCombos.length; j++) {
            combo = _currentCombos[j];
            for(i = 0; i < combo.length; i++) {
              combo[i].flicker(2);
            }
          }
        }
        _comboTimer = 2;
      }
      
      FlxG.score = _score;
    }

    /**
     * A generic helper function for grouping arrays.
     * You need to write a group function that takes two arguments:
     * - The current array
     * - The new element
     * The function then has to return true if the new element
     * belongs into the current array and false if it belongs
     * in a new one.
     */
    protected function groupArray(group:Function, arr:Array):Array {
      if(arr.length == 0) {
        return [];
      }

      var groups:Array = [[arr[0]]];
      for(var j:int = 1; j < arr.length; j++){
        var el:Object = arr[j];
        var currArr:Array = groups[groups.length - 1];
        if(group(currArr, el)) {
          currArr.push(el);
        } else {
          groups.push([el]);
        }
      }
      return groups;
    }
    
    /**
     * This has to be overridden in your level to actually check any combos.
     * It should check for all possible combos and return them in an array
     * of arrays.
     */
    protected function checkCombos(arr:Array):Array {
      return [];
    }

    protected function spawnFood():void {
      reallySpawnFood(3);
    }
    
    protected function reallySpawnFood(n:int):void {
      var egg:Egg = new Egg(Math.floor(Math.random() * n));
      spawnEgg(egg);
      _food.add(egg);
    }

    protected function spawnEgg(egg:Egg):void {
      var wTiles:int = FlxG.width / 15;
      var hTiles:int = FlxG.height / 15;
      wTiles -= 2; // Left and right;
      hTiles -= 7; // 6 top, 1 bottom;
      do {
        egg.x = int(1 + (Math.random() * wTiles)) * 15;
        egg.y = int(6 + (Math.random() * hTiles)) * 15;
      } while(egg.overlaps(_unspawnable));

    }
    
    override public function destroy():void {
      super.destroy();
    }
  }
}

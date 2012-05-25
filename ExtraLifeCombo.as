package  
{
	/**
     * ...
     * @author 
     */
    public class ExtraLifeCombo extends Combo 
    {
        
        public function ExtraLifeCombo() 
        {
            super();
		        repeat = false;
            trigger = [EggTypes.EGGC, EggTypes.EGGA, EggTypes.EGGA, EggTypes.EGGB];
        }
        
        override public function effect(state:LevelState):void {
          state.snake.lives += 1;
          state.showMessage("Bonus Life!");
        }
        
    }

}
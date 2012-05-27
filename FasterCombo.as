package {
  public class FasterCombo extends Combo {
    public function FasterCombo() {
      super();
      repeat = true;
      trigger = [EggTypes.EGGA, EggTypes.EGGA, EggTypes.EGGA];
    }
    
    override public function effect(state:LevelState):void {
      state.snake.faster();
      state.showMessage("Faster!");
    }
  }
}
package {
  public class ExtraTimeCombo extends Combo {
    public function ExtraTimeCombo() {
      super();
      repeat = true;
      trigger = [EggTypes.EGGB, EggTypes.EGGB, EggTypes.EGGB];
    }
    
    override public function effect(state:LevelState):void {
      state.timeLeft += 3;
      state.showMessage("Bonus Time!");
    }
  }
}
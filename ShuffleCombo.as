package {
  public class ShuffleCombo extends Combo {
    public function ShuffleCombo() {
      super();
      repeat = false;
      trigger = [EggTypes.EGGC, EggTypes.EGGB, EggTypes.EGGC, EggTypes.EGGB, EggTypes.EGGA];
    }
    
    override public function effect(state:LevelState):void {
      state.spawnEgg(new Egg(EggTypes.SHUFFLE));
      state.showMessage("Shuffle!");
    }
  }
}
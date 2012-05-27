package {
  public class GoldenCombo extends Combo {
    public function GoldenCombo() {
      super();
      repeat = false;
      trigger = [EggTypes.EGGB, EggTypes.EGGA, EggTypes.EGGC, EggTypes.EGGA, EggTypes.EGGC];
    }
    
    override public function effect(state:LevelState):void {
      state.spawnEgg(new Egg(EggTypes.GOLDEN));
      state.showMessage("Golden Egg!");
    }
  }
}
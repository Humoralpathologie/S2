package tests {
    import asunit.framework.TestCase;
    import org.axgl.Ax;
    import org.axgl.AxSprite;
    import org.axgl.*;
    import Egg;
    
  public class ComboTests extends TestCase {
    
    public function ComboTests(testMethod:String) {
      super(testMethod);
    }
        
    public function TestAAACombo():void {   
      var noCombos:Array = [new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGC)];
      var oneCombo:Array = [new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGB)];
      var longCombo:Array = [new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGA)];
      var twoCombos:Array = [new MockEgg(EggTypes.EGGA),
      new MockEgg(EggTypes.EGGA),
      new MockEgg(EggTypes.EGGA),
      new MockEgg(EggTypes.EGGB),
      new MockEgg(EggTypes.EGGA),
      new MockEgg(EggTypes.EGGA),
      new MockEgg(EggTypes.EGGA),
      new MockEgg(EggTypes.EGGA)]
      
      var combo:Combo = new FasterCombo();
      var comboSet:ComboSet = new ComboSet();
      comboSet.addCombo(combo);
      
      var results:Array;
      
      results = comboSet.checkCombos(twoCombos);
      assertEquals(2, results.length);
      
      results = comboSet.checkCombos(oneCombo);
      assertEquals(1, results.length);
      
      results = comboSet.checkCombos(longCombo);
      assertEquals(1, results.length);
      assertEquals(5, results[0].eggs.length);
      
      results = comboSet.checkCombos(noCombos);
      assertEquals(0, results.length);
    }
    
    public function TestCBCBACombo():void {
      var oneCombo = [new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGA)];
      var partialThenCombo = [new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGA)];
      var differentCombos = [new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGA)];
      var overlappingCombos = [new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGC), new MockEgg(EggTypes.EGGB), new MockEgg(EggTypes.EGGA),new MockEgg(EggTypes.EGGA), new MockEgg(EggTypes.EGGA)];

      var combo:Combo = new ShuffleCombo();
      var aaacombo:Combo = new FasterCombo();
      var comboSet:ComboSet = new ComboSet();
      comboSet.addCombo(combo);
      comboSet.addCombo(aaacombo);
      
      var results:Array;
      results = comboSet.checkCombos(oneCombo);
      assertEquals(1, results.length);
      assertEquals(EggTypes.EGGC, results[0].eggs[0].type);
      
      results = comboSet.checkCombos(partialThenCombo);
      assertEquals(1, results.length);
      
      results = comboSet.checkCombos(differentCombos);
      assertEquals(2, results.length);
      
      // If two combos overlap, the one further to the end gets used.
      results = comboSet.checkCombos(overlappingCombos);
      assertEquals(1, results.length)
      assertEquals(3, results[0].eggs.length);
      
    }
  }
}
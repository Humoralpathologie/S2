package {
  public class ComboSet {
    
    private var _combos:Array;
    
    public function ComboSet() {
      _combos = [];
    }
    
    public function addCombo(combo:Combo):void {
      _combos.push(combo);
    }
    
    private function eggSort(a:Object, b:Object):int {
      if (a.eggs[1] > b.eggs[1]) {
          return -1;
        } else if (a.eggs[1] < b.eggs[1]) {
          return 1;
        } else {
          return 0;
        }
    }
    
    public function checkCombos(eggs:Array):Array {
      var results:Array = [];
      var validCombos:Array = [];
      var comboEggs:Array = [];
      
      // Get the possible combos and save a reference to the combo class.
      for each(var combo:Combo in _combos) {
        for each(var oneCombo:Array in combo.check(eggs)){
          results.push( { eggs: oneCombo, combo: combo } );
        }
      }
     
      // Sort so that combos from the end appear first.
      results.sort(eggSort);
      
      // Accept only combos that don't overlap.
      for each(var result:Object in results) {
        if (validCombos.length == 0 || (validCombos[validCombos.length - 1].eggs[0] >= result.eggs[1])) {
          validCombos.push(result); 
        }
      }
      
      // Return the combos as actual egg objects with a reference to the combo class.
      for each(var validCombo:Object in validCombos) {
        comboEggs.push({eggs: eggs.slice(validCombo.eggs[0], validCombo.eggs[1]), combo: validCombo.combo}); 
      }
      
      return comboEggs;
    }
  }
}
package tests 
{
    import org.axgl.AxState;
	/**
     * ...
     * @author 
     */
    public class TestState extends AxState
    {
      public var noCombos:Array;
      public var oneCombo:Array;
      override public function create():void {
        super.create();
        noCombos = [new Egg(Egg.EGGA), new Egg(Egg.EGGB), new Egg(Egg.EGGC)];
        oneCombo = [new Egg(Egg.EGGA), new Egg(Egg.EGGA), new Egg(Egg.EGGA)];
      }
    }

}
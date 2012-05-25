package  
{
	/**
     * ...
     * @author 
     */
  import asunit.textui.TestRunner;
  import flash.display.Sprite;
  import tests.AllTests;
  
  public class Tests extends Sprite
  {
        
    public function Tests() 
    {
      var unittests:TestRunner = new TestRunner();
      stage.addChild(unittests);
      unittests.start(tests.AllTests, null, TestRunner.SHOW_TRACE);
    }       
  }

}
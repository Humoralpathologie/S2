package tests
{
  import asunit.framework.TestCase;
    
  public class SomeTest extends TestCase {

    public function SomeTest(testMethod:String)
    {
      super(testMethod);
    }

    public function TestIntegerMath() : void
    {
      var i:int = 5;
      assertEquals(5, i);
      i += 4;
      assertEquals(9, i);
    }

    public function TestFloatMath() : void
    {
      var i:Number = 5;
      assertEqualsFloat(5, i, 0.001);
      i += 4;
      assertEqualsFloat(8, i, 0.001);
    }
  }
}
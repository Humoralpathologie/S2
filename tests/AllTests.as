package tests 
{
    import asunit.framework.TestSuite;
    public class AllTests extends TestSuite
    {
        
        public function AllTests() 
        {
            super();
            addTest(new ComboTests("TestAAACombo"));
            addTest(new ComboTests("TestCBCBACombo"));
        }
        
    }

}
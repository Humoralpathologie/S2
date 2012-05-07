package {
  import org.axgl.*;

  [SWF(width='640', height='480', backgroundColor='#aa0000')]
  //[Frame(factoryClass="Preloader")]
  public class Main extends Ax {
    public function Main() {
      SaveGame.load();
      super(MenuState, 640, 480);
    }
    override public function create():void {
			Ax.debuggerEnabled = true;
      Ax.debugger.active = true;
    }
  }
}

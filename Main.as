package {
  import org.axgl.*;

  [SWF(width='960', height='640', backgroundColor='#000000')]
  [Frame(factoryClass="Preloader")]
  public class Main extends Ax {
    public function Main() {
      SaveGame.load();
      super(MenuState);//, 640, 480);
    }
    override public function create():void {
			Ax.debuggerEnabled = true;
    }
  }
}

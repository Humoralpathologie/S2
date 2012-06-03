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
      if (Ax.width != 960 || Ax.height != 640) {
        Ax.zoom = Math.min(Ax.width / 960, Ax.height / 640);
      }
			Ax.debuggerEnabled = true;
      Ax.debugger.active = true;
    }
  }
}

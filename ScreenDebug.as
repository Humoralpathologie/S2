package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;

  [SWF(width='960', height='640', backgroundColor='#aa0000')]
  public class ScreenDebug extends Ax {
    public function ScreenDebug() {
      SaveGame.load();
      super(DebugState);
    }
    override public function create():void {
			Ax.debuggerEnabled = true;
      Ax.debugger.active = true;
      Ax.background = new AxColor(0,0,0);
    }
  }
}

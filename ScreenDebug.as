package {
  import org.axgl.*;
  import org.axgl.text.*;
  import org.axgl.render.*;

  [SWF(width='640', height='480', backgroundColor='#aa0000')]
  public class ScreenDebug extends Ax {
    public function ScreenDebug() {
      SaveGame.load();
      super(DebugState,640, 480);
    }
    override public function create():void {
			Ax.debuggerEnabled = true;
      Ax.debugger.active = true;
      Ax.background = new AxColor(0,0,0);
    }
  }
}

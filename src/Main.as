package 
{
import net.flashpunk.Engine;
import net.flashpunk.FP;

	public class Main extends Engine
	{
		public function Main()
		{
			super(320, 240, 60, false);
			FP.screen.scale = 2;
			//FP.console.enable();
		}
		
		override public function init():void
		{
			trace("FlashPunk has started successfully!");

			FP.world = new ServerWorld();
			super.init();
		}
	}	
}
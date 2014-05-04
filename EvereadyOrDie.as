package
{
	import org.flixel.*; 
	[SWF(width="640", height="150", backgroundColor="#000000")] 
	//[Frame(factoryClass="Preloader")]
	
	public class EvereadyOrDie extends FlxGame
	{
		public function EvereadyOrDie()
		{
			super(320,150,MenuState,2);
	
			forceDebugger = true;
		}
	}
}


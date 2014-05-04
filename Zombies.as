package
{
	import org.flixel.*;
	
	public class Zombies extends FlxGroup
	{
		protected var Blood:FlxEmitter;
		
		public function Zombies(blood:FlxEmitter=null)
		{
			super();
			Blood = blood;
		}
		
		//Specify x and y co-ordinates 
		public function addZombie(x:int, y:int):void
		{
			var tempZombie:Zombie = new Zombie(x,y,Blood);
			
			add(tempZombie);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
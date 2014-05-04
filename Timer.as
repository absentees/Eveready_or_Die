package
{
	import org.flixel.*;

	
	public class Timer extends FlxSprite
	{
		public var timeRemaining:Number;
		public var timerText:FlxText;
		
		//Create timer for game
		// X and Y Position, Seconds to countdown
		public function Timer(X:Number=0, Y:Number=0, TimeToCountdown:Number=0):void
		{
			super(X,Y);
			timeRemaining = TimeToCountdown;
			timerText = new FlxText(X,Y,320);
			timerText.alignment = "center";
			timerText.color = 0xffffffff;
			timerText.scrollFactor.x = 0;
			timerText.scrollFactor.y = 0;
			timerText.text = FlxU.formatTime(timeRemaining);

			FlxG.log("text constructor");
		}
		
		override public function update():void
		{
			super.update();
			
			timeRemaining -= FlxG.elapsed;
			// if timer gets to 0 do something here
			FlxG.log("updatetimer");
			timerText.text = FlxU.formatTime(timeRemaining);
			
		}
	}
}
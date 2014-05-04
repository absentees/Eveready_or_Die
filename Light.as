package
{
	import org.flixel.*;
	
	public class Light extends FlxSprite
	{
		[Embed(source="/../assets/glow-light-ver3.png")] private var LightImageClass:Class;
		private var darkness:FlxSprite;

		
		public function Light(X:Number, Y:Number,  darkness:FlxSprite)
		{
	//		super(x, y, LightImageClass);
			super(x,y);
			
			loadGraphic(LightImageClass,false,true,256,256,false);

			this.darkness = darkness;
			this.blend = "screen"
			
		}
		
		override public function draw():void {
	
			var screenXY:FlxPoint = getScreenXY();
			darkness.stamp(this, screenXY.x - this.width/2, screenXY.y - this.height/2);
	
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
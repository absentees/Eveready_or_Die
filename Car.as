package
{
	import org.flixel.*;
	
	public class Car extends FlxSprite
	{
		// Load up sprite
		[Embed(source = '../assets/car_sprite_sheet.png')] private var carSprite:Class;
		
		
		public function Car(X:Number=0,Y:Number=0)
		{
			super(X,Y);
			
			loadGraphic(carSprite,true,false,53,16,true);
			width = 53;
			height = 16;
			
			addAnimation("walk", [0,1,2,3],20,true);
			play("walk");
			
			//velocity.x = 100;
			acceleration.x = 20;
			acceleration.y = 400;
		}
		
		override public function update():void
		{
			super.update();	
		}
		
	
		
	}
}
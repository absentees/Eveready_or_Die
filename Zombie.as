package
{
	import org.flixel.*;
	
	
	public class Zombie extends FlxSprite
	{
		// Load up zombie sprite
		[Embed(source = '../assets/zombie_sheet.png')] private var zombieSprite:Class;
		protected var _facing_sign:Number;
		public var stayOnPlatform:Boolean = true;
		protected var blood:FlxEmitter;

		
		public function Zombie(X:Number=0, Y:Number=0, Blood:FlxEmitter=null)
		{
			super(X, Y);
			
			blood = Blood;
			
			loadGraphic(zombieSprite,true,true,20,20,true);
			width = 14;
			height = 20;
			
			facing = FlxObject.RIGHT;
			
			// offset for cropping sprite
			offset.x =3;
			//offset.y = 5;
			
			addAnimation("walk", [0,1,2,3,4,5,6,7], 10, true);
			play("walk");
			
			velocity.x = 5;
			acceleration.y = 400;
		}
		
		override public function kill():void
		{
			FlxG.log("before dead");
			if(!alive)
				return;
			FlxG.log("dead");
			super.kill();
			solid = false;
			exists = true;
			visible = false;
			flicker(0); 
			velocity.make();
			acceleration.make();
			FlxG.camera.shake(0.005,0.35);
			blood.at(this);
			blood.start(true,5,0,50);
		}
		
		override public function update():void
		{
			super.update();
			
			if (justTouched(LEFT)) {
				setFacing(RIGHT);
			} else if (justTouched(RIGHT)) {
				setFacing(LEFT);
			} else if (stayOnPlatform) {
				if (overlapsAt(x + _facing_sign * width, y + 1, Registry.map)) {
					// we'll still be on the floor in one width's time; keep walking
				} else {
					// we'll fall off in a width's time; turn around
					setFacing(facing == LEFT ? RIGHT : LEFT);
				}
			}
		}
		public function setFacing(newFacing:Number):void 
		{
			facing = newFacing;
			_facing_sign = (facing == LEFT ? -1 : 1);
			velocity.x = 10 * _facing_sign;
		}
//			var tilex:int = int(x / 10);
//			var tiley:int = int(y / 10);
//			FlxG.watch(this,"x","X");
//			FlxG.log(tiley);
//
//						
//			if (facing == FlxObject.LEFT)
//			{
//				if (Registry.map.getTile(tilex - 1, tiley) >= 1)
//				{
//					turnAround();
//					return;
//				}
//			}
//			else
//			{
//				if (Registry.map.getTile(tilex + 1, tiley) >= 1)
//				{
//					turnAround();
//					return;
//				}
//			}
//						
//			if (isTouching(FlxObject.FLOOR) == false)
//			{
//				turnAround();
//			}
//			
//			super.update();
//
//		}
//		
//		private function turnAround():void
//		{
//			if (facing == FlxObject.RIGHT)
//			{
//				facing = FlxObject.LEFT;
//				
//				velocity.x = -10;
//			}
//			else
//			{
//				facing = FlxObject.RIGHT;
//				
//				velocity.x = 10;
//			}
//		}
		
	}
}
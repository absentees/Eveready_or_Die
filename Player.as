package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source = '../assets/hero_sprite.png')] private var heroSprite:Class;
	//	[Embed(source="../assets/runFX.mp3")] protected var footstepSFX:Class;
		[Embed(source="../assets/jumpFX.mp3")] protected var jumpSFX:Class;
		[Embed(source="../assets/dieFX.mp3")] protected var dieSFX:Class;

		
		//protected var runFX:FlxSound;
		protected var jumpFX:FlxSound;
		protected var dieFX:FlxSound;

		protected var blood:FlxEmitter;
		
		public function Player(X:Number, Y:Number, Blood:FlxEmitter=null)
		{
			super(X, Y);
			
			//Load up sounds
			//runFX = new FlxSound();
			//runFX.loadEmbedded(footstepSFX);
			jumpFX = new FlxSound();
			jumpFX.loadEmbedded(jumpSFX);
			//dieFX = new FlxSound();
		//	dieFX.loadEmbedded(dieSFX);
			
			//Player starts out not-dead.
			blood = Blood;
			
			loadGraphic(heroSprite,true,true,25,25,true);
			width = 10;
			height = 20;
			
			// offset for cropping sprite
			offset.x = 7;
			offset.y = 5;
			
			// Different animations for the hero
			addAnimation("idle", [0,1,2,3,4,5,6], 10, false);
			addAnimation("walk", [7,8,9,10,11,12,13,14,15,16], 15, true);
			addAnimation("jump", [16], 0, false);			
			
			// Adding Flixel Controls plug-ins 
			if(FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
			
			// Sets up controls for hero
			FlxControl.create(this, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			FlxControl.player1.setCursorControl(false, false, true, true);
			
			// Set up how the 'jump' button will function
			FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 170, FlxObject.FLOOR, 250, 200);
			
			// Set player bounds within the game			
			FlxControl.player1.setBounds(20,0,1950,150);
			
			// Set physical boundaries
			FlxControl.player1.setMovementSpeed(400, 0, 150, 200, 400, 0);
			FlxControl.player1.setGravity(0, 400);
			facing = FlxObject.RIGHT;
			
			//Setup sounds for player
			FlxControl.player1.setSounds(jumpFX,null,null,null);
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (touching == FlxObject.FLOOR)
			{
				if (velocity.x != 0)
				{
					play("walk");
				}
				else
				{
					play("idle");
				}
			}
			else if (velocity.y < 0)
			{
				play("jump");
			}
		}
		
		override public function kill():void{
			if(!alive)
				return;
			FlxG.play(dieSFX);
			
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
	}
}
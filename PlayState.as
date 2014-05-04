package
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	public class PlayState extends FlxState
	{
		//TODO
		// Add objects to a meta group to speed up collisions
		// Add Zombies group to Registry
		// Move out level code into it's own class
		// Create HUD so timer isn't effected by darkness - DONE
		// Instructions pre-game - DONE
		// Make a goal to win - DONE
		// Win State - DONE
		// High score - DONE
		// Save out high score to PNG - OUT
		// EXTRA: Drive away at final win screen? - DONE 
		// EXTRA: Car runs over zombies - DONE
		
		[Embed(source = "../assets/mapCSV_Group1_MapPlatforms.csv", mimeType = "application/octet-stream")] public var mapCSV:Class;
		[Embed(source = "../assets/platform_tileset.png")] public var mapTilesPNG:Class;
		[Embed(source = "../assets/level_sky.png")] public var imgSkyBackdrop:Class;
		[Embed(source = "../assets/level_buildings.png")] public var imgBuildingsBackdrop:Class;
		[Embed(source = "../assets/blood.png")] public var blood:Class;
		[Embed(source = "../assets/game_music.mp3")] public var musicFX:Class;
		[Embed(source = "../assets/car.png")] public var carImageClass:Class;
		[Embed(source = "../assets/menu_select.mp3")] protected var menuSelectFX:Class;

		//Level specific variable
		public var level:FlxTilemap;
		public var player:Player;
		public var zombies:Zombies;
		public var skyBackdrop:Backdrop;
		public var buildingsBackdrop:Backdrop;
		protected var car:FlxSprite;
		protected var bloodBits:FlxEmitter;

		// HUD and scores
		public var timeRemaining:Number;
		public var timerText:FlxText;
		protected var hud:FlxGroup;
		
		
		//Lighting
		private var darkness:FlxSprite;
		private var background:FlxSprite;
		private var light:Light;
		private var lightOn:Boolean = false;
		
		private var madeCar:Boolean;
	
		override public function create():void
		{
			// This is dumb but it's the only way i could get a sound to play while it switched states
			FlxG.play(menuSelectFX);
			
			//Create HUD
			hud = new FlxGroup();
			
			//Car and finish point
			car = new FlxSprite(50,124);
			//car = new FlxSprite(1918,124);
			car.loadGraphic(carImageClass,false,false,53,16,false);
			car.immovable = true;
			 
			//Set volume
			//FlxG.volume = 0.3;
			FlxG.playMusic(musicFX,1);
			
			//Blood Emitter
			bloodBits = new FlxEmitter();
			bloodBits.setXSpeed(-150,150);
			bloodBits.setYSpeed(-200,0);
			bloodBits.setRotation(-720,-720);
			bloodBits.gravity = 400;
			bloodBits.bounce = 0;
			bloodBits.makeParticles(blood,100,10,true,0.5);
			
			//Dynamic lighting
			darkness = new FlxSprite(0,0);
			darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
			darkness.blend = "multiply";
			
			//Level Setup	
			FlxG.bgColor = 0xffaaaaaa;
			level = new FlxTilemap;
			level.loadMap(new mapCSV, mapTilesPNG, 10, 10, 0, 0, 1, 1);
			skyBackdrop = new Backdrop(0,1,imgSkyBackdrop,0.2);
			buildingsBackdrop = new Backdrop(0,1,imgBuildingsBackdrop,0.8);
			Registry.map = level;
			
			add(skyBackdrop);
			add(buildingsBackdrop);
			add(level);
			add(car);
			
			//Highscores setup, 2x 
			Registry.score = 30;
			if(Registry.score < Registry.highScore)
				Registry.highScore = Registry.score;
			
			//Timer Setup
			timeRemaining = 30;			
			timerText = new FlxText(0,0,320);
			timerText.setFormat(null,10,0xffffffff,"right",timerText.shadow);
			timerText.alignment = "center";
			timerText.text = "TIME LEFT: " + FlxU.formatTime(timeRemaining, true);
			hud.add(timerText);
			
			//Player Setup
			player = new Player(32,120,bloodBits);
			madeCar = false;
			add(player);
			
			FlxG.watch(player,"x","X Pos")
			FlxG.watch(player,"y","Y Pos")
				
			//Zombie Setup
			addZombies();
			add(zombies);
			
			//Camera Setup
			//Fix these values to sit inside a Level class
			FlxG.worldBounds = new FlxRect(0, 0, 2000, 150);
			FlxG.camera.setBounds(0, 0, 2000, 150);
			FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			
			//Dynamic lighting
			light = new Light(FlxG.width , FlxG.height, darkness);
			add(light);
			add(darkness);
			add(bloodBits);
			
			//Add HUD after lighting so it will be layered on top
			add(hud);
			hud.setAll("scrollFactor",new FlxPoint(0,0));

		}
		
		private function addZombies():void
		{
			zombies = new Zombies;
			
			// 10 zombies
			zombies.addZombie(362,100);
			zombies.addZombie(480,100);
			zombies.addZombie(575,100);
			zombies.addZombie(624,80);
			zombies.addZombie(873,100);
			zombies.addZombie(1125,80);
			zombies.addZombie(1259,100);
			zombies.addZombie(1535,100);
			zombies.addZombie(1719,120);
			zombies.addZombie(1750,120);
		}
		
		private function updateTimer():void{
			timeRemaining -= FlxG.elapsed;
			// if timer gets to 0 do something here
			
			if(timeRemaining <= 0)
			{
				playerDie();
			}
			else
			{
				timerText.text = "TIME LEFT: " + FlxU.formatTime(timeRemaining,true);
			}
		}
		
		// Player Die function is called when the player runs out of time or hits a zombie
		// Slows down time, kills the player, and fades out to the end level
		private function playerDie():void
		{
			FlxG.timeScale = 0.45;
			player.kill();
			FlxG.fade(0xff000000, 1, endLevel);
		}
		
		private function playerWin():void
		{
			//FlxG.timeScale = 0.45;
			//FlxG.play(menuSelectFX,1,false,true);
			FlxG.fade(0xff000000, 0.25,endLevel);
		}
		
		// End level function, call level end state with time remaining.
		private function endLevel():void
		{
			FlxG.log("endgame");
			
			FlxG.music.fadeOut(1);
			if(player.alive == false)
				FlxG.switchState(new LevelEndState(timeRemaining));		
			else
				FlxG.switchState(new LevelWinState(timeRemaining));		
			
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(level,player);
			FlxG.collide(level,car);
			//FlxG.collide(player,car);
			FlxG.collide(level,zombies);
			FlxG.collide(level,bloodBits);
			
			FlxG.overlap(player,zombies,hitZombie);
			FlxG.overlap(player,car,hitCar);
		
			// Keeps timer going until the player is dead or has made it to the car
			if(player.alive && madeCar == false)
				updateTimer();	
			
			//Check to turn the light on and off
			if(FlxG.keys.justPressed("T"))
			{
				if(lightOn == true) //turn light off
				{
					light.alpha = 0;
					lightOn = false;
				}
				else //turn light on
				{
					light.alpha = 1;
					lightOn = true;	
				}
			}
			if (FlxG.keys.R)
			{
				playerDie();
			}
		}
		
		private function hitZombie(player:Player,zombie:Zombie):void
		{
			//Player do something
			FlxG.log("player hit zombie");
			playerDie();
		}
		
		private function hitCar(player:Player,car:FlxSprite):void{
			//FlxG.log("player hit car");
			madeCar = true;
			Registry.score = timeRemaining;
			playerWin();
		}
		
		//dynamic lighting
		override public function draw():void{
			// fills with the darkness
			darkness.fill(0xff000000);
			
			// light position
			light.x = player.x + 15;
			light.y = player.y;
			light.draw();
						
			super.draw();		
		}
	}
}
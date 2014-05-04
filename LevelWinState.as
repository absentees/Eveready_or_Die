package
{
	import org.flixel.*;
	
	public class LevelWinState extends FlxState
	{
		[Embed(source = "../assets/end_level.csv", mimeType = "application/octet-stream")] public var mapCSV:Class;
		[Embed(source = "../assets/platform_tileset.png")] public var mapTilesPNG:Class;
		[Embed(source = "../assets/level_sky.png")] public var imgSkyBackdrop:Class;
		[Embed(source = "../assets/level_buildings.png")] public var imgBuildingsBackdrop:Class;
		[Embed(source = "../assets/intro_music.mp3")] public var introMusicClass:Class;
		[Embed(source = "../assets/car_sound_sm.mp3")] public var carSoundClass:Class;
		[Embed(source = "../assets/ingame_text_win.png")] public var winTextImage:Class;
		[Embed(source = "../assets/blood.png")] public var blood:Class; 

		public var level:FlxTilemap;
		public var skyBackdrop:Backdrop;
		public var buildingsBackdrop:Backdrop;
		public var scoreText:FlxText;
		protected var highscoreText:FlxText;
		protected var playerScore:String;
		protected var winTextGraphic:FlxSprite;
		
		protected var onScreenText:FlxGroup;
		
		public var bloodBits:FlxEmitter;
		public var zombie:Zombie;		
		public var zombies:Zombies;
		
		protected var car:Car;

		
		public function LevelWinState(timeRemaining:Number=0)
		{
			timeRemaining = 30 - timeRemaining;
			
			playerScore = FlxU.formatTime(timeRemaining,true);
			
			FlxG.log("timeR" + timeRemaining);
			FlxG.log(Registry.highScore);
			
			if(timeRemaining < Registry.highScore){
				FlxG.log("HERE");
				Registry.highScore = timeRemaining;
			}
				
			
			

		}
		
		override public function create():void
		{
			
			//Reset timeScale
			FlxG.timeScale = 1;
						
			FlxG.play(carSoundClass);
			FlxG.log("WIN State reached");
			
			winTextGraphic = new FlxSprite(0,0);
			winTextGraphic.loadGraphic(winTextImage,false);
						
			FlxG.bgColor = 0xffaaaaaa;
			level = new FlxTilemap;
			level.loadMap(new mapCSV, mapTilesPNG, 10, 10, 0, 0, 1, 1);
			skyBackdrop = new Backdrop(0,1,imgSkyBackdrop,0.2);
			buildingsBackdrop = new Backdrop(0,1,imgBuildingsBackdrop,0.8);
			Registry.map = level;

			
			//Blood for zombies
			//Blood Emitter
			bloodBits = new FlxEmitter();
			bloodBits.setXSpeed(-150,150);
			bloodBits.setYSpeed(-200,0);
			bloodBits.setRotation(-720,-720);
			bloodBits.gravity = 400;
			bloodBits.bounce = 0;
			bloodBits.makeParticles(blood,100,10,true,0.5);
			
			car = new Car(30,124);
		 
			addZombies();
			
			add(skyBackdrop);
			add(buildingsBackdrop);
			add(level);
			add(car);
			add(zombies);
			add(bloodBits); 
			
			FlxG.worldBounds = new FlxRect(0, 0, 2000, 150);
			FlxG.camera.setBounds(0, 0, 2000, 150);
			FlxG.camera.follow(car, FlxCamera.STYLE_PLATFORMER);
			
			scoreText = new FlxText(147,54,320, playerScore);
			highscoreText = new FlxText(147,66,320, FlxU.formatTime(Registry.highScore,true));
			
			FlxG.playMusic(introMusicClass);
			
			onScreenText = new FlxGroup();
			onScreenText.add(scoreText);
			onScreenText.add(highscoreText);
			onScreenText.add(winTextGraphic);
			
			add(onScreenText);
			//Sets all objects within the flxgroup to have no scroll factor
			onScreenText.setAll("scrollFactor",new FlxPoint(0,0));

			
//			add(scoreText);
//			add(highscoreText);
//			add(winTextGraphic);
			
			FlxG.log("FUCK SAKE");
		}
		
		private function addZombies():void
		{
			zombies = new Zombies(bloodBits);
			
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
		
		private function hitZombie(car:Car,zombie:Zombie):void
		{
			FlxG.log("zombiekillfunc");
			zombie.kill();
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(level,car);
			
			FlxG.collide(level,zombies);
			FlxG.collide(level,bloodBits);
			FlxG.overlap(car,zombies,hitZombie);
			
			
			if (FlxG.keys.R)
			{
				FlxG.switchState(new PlayState);
			}
			
		}
	}
}
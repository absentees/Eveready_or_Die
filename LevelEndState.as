package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	public class LevelEndState extends FlxState
	{
		[Embed(source = "../assets/mapCSV_Group1_MapPlatforms.csv", mimeType = "application/octet-stream")] public var mapCSV:Class;
		[Embed(source = "../assets/platform_tileset.png")] public var mapTilesPNG:Class;
		[Embed(source = "../assets/level_sky.png")] public var imgSkyBackdrop:Class;
		[Embed(source = "../assets/level_buildings.png")] public var imgBuildingsBackdrop:Class;
		[Embed(source = "../assets/intro_music.mp3")] public var introMusicClass:Class;
		[Embed(source = "../assets/ingame_text_lose.png")] public var loseTextImage:Class;

		
		public var level:FlxTilemap;
		public var skyBackdrop:Backdrop;
		public var buildingsBackdrop:Backdrop;
		protected var scoreText:FlxText;
		protected var highscoreText:FlxText;
		public var playerScore:String;
		protected var loseTextGraphic:FlxSprite;
		
		public function LevelEndState(timeRemaining:Number=0)
		{
			playerScore = "";
		}
		
		override public function create():void
		{
			//Reset timeScale
			FlxG.timeScale = 1;
			
			loseTextGraphic = new FlxSprite(0,0);
			loseTextGraphic.loadGraphic(loseTextImage,false);
			
			FlxG.bgColor = 0xffaaaaaa;
			level = new FlxTilemap;
			level.loadMap(new mapCSV, mapTilesPNG, 10, 10, 0, 0, 1, 1);
			skyBackdrop = new Backdrop(0,1,imgSkyBackdrop,0.2);
			buildingsBackdrop = new Backdrop(0,1,imgBuildingsBackdrop,0.8);
			
			add(skyBackdrop);
			add(buildingsBackdrop);
			add(level);
			
			scoreText = new FlxText(0,50,320,"YOU LOSE, YOU GET NOTHING");
			scoreText.alignment = "center";
			scoreText.scrollFactor.x = 0;
			scoreText.scrollFactor.y = 0;
						
			scoreText = new FlxText(147,54,320, playerScore);
			highscoreText = new FlxText(147,66,320, FlxU.formatTime(Registry.highScore,true));
			add(scoreText);
			add(highscoreText);
			add(loseTextGraphic);
			
			FlxG.playMusic(introMusicClass);

		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.R)
			{
				FlxG.switchState(new PlayState);
			}
		}
	}
}
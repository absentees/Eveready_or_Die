package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.GlitchFX;

	public class MenuState extends FlxState
	{
		[Embed(source = "../assets/mapCSV_Group1_MapPlatforms.csv", mimeType = "application/octet-stream")] public var mapCSV:Class;
		[Embed(source = "../assets/platform_tileset.png")] public var mapTilesPNG:Class;
		[Embed(source = "../assets/level_sky.png")] public var imgSkyBackdrop:Class;
		[Embed(source = "../assets/level_buildings.png")] public var imgBuildingsBackdrop:Class;
		[Embed(source = "../assets/eveready_logo_big.png")] public var logoImageClass:Class;
		[Embed(source = "../assets/intro_music_sm.mp3")] public var introMusicClass:Class;

		public var level:FlxTilemap;
		public var skyBackdrop:Backdrop;
		public var buildingsBackdrop:Backdrop;
		public var player:Player;
		protected var specialEffect:GlitchFX;
		protected var logo:FlxSprite;
		protected var glitchLogo:FlxSprite;
		protected var subText:FlxText;
		
		public function MenuState()
		{
		}
		
		override public function create():void
		{
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX); 
			}
			
			player = new Player(32,120);
			
			//Reset timeScale
			FlxG.timeScale = 1;
			
			FlxG.bgColor = 0xffaaaaaa;
			level = new FlxTilemap;
			level.loadMap(new mapCSV, mapTilesPNG, 10, 10, 0, 0, 1, 1);
			skyBackdrop = new Backdrop(0,1,imgSkyBackdrop,0.2);
			buildingsBackdrop = new Backdrop(0,1,imgBuildingsBackdrop,0.8);
			
			//logo
			logo = new FlxSprite(0,0);
			logo.loadGraphic(logoImageClass,false,false,320,200,true);
			specialEffect = FlxSpecialFX.glitch();
			glitchLogo = specialEffect.createFromFlxSprite(logo,2,4,true,0);
			glitchLogo.offset.x = -10;
			glitchLogo.offset.y = 52;

			specialEffect.start(1);
			
			//Text under logo
			subText = new FlxText(0,120,320,"Press ANY KEY to start");
			subText.alignment = "center";
			subText.scrollFactor.x = 0;
			subText.scrollFactor.y = 0;
			
			//Play background music
			FlxG.playMusic(introMusicClass,0.8);
			

			//Add all the things to the main flxgroup	
			add(skyBackdrop);
			add(buildingsBackdrop);
			add(level);
			add(player);
			add(glitchLogo);
			add(subText);
		}
		
		override public function update():void
		{
			super.update();
					
			FlxG.collide(level,player);
			
			if (FlxG.keys.any())
			{
				specialEffect.stop()
				FlxG.switchState(new PreGameState);
			}
		}
	}
}
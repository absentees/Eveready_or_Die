package
{
	import org.flixel.*;
	
	public class PreGameState extends FlxState
	{
		[Embed(source = "../assets/mapCSV_Group1_MapPlatforms.csv", mimeType = "application/octet-stream")] public var mapCSV:Class;
		[Embed(source = "../assets/platform_tileset.png")] public var mapTilesPNG:Class;
		[Embed(source = "../assets/level_sky.png")] public var imgSkyBackdrop:Class;
		[Embed(source = "../assets/level_buildings.png")] public var imgBuildingsBackdrop:Class;
		[Embed(source = "../assets/instructions_text.png")] public var instructionTextImage:Class;
		[Embed(source = "../assets/menu_select.mp3")] public var menuSelectFX:Class;

		
		public var level:FlxTilemap;
		public var skyBackdrop:Backdrop;
		public var buildingsBackdrop:Backdrop;
		public var player:Player;
		protected var instructionsGraphic:FlxSprite;
		
		public function PreGameState()
		{
			super();
		}
		
		override public function create():void
		{
			FlxG.play(menuSelectFX);
			
			player = new Player(32,100);
			
			//Reset timeScale
			FlxG.timeScale = 1;
			
			FlxG.bgColor = 0xffaaaaaa;
			level = new FlxTilemap;
			level.loadMap(new mapCSV, mapTilesPNG, 10, 10, 0, 0, 1, 1);
			skyBackdrop = new Backdrop(0,1,imgSkyBackdrop,0.2);
			buildingsBackdrop = new Backdrop(0,1,imgBuildingsBackdrop,0.8);

			instructionsGraphic = new FlxSprite(0,0);
			instructionsGraphic.loadGraphic(instructionTextImage,false);

			Registry.highScore = 30;
//			
//			
//			headerGraphic = new FlxSprite(110,10);
//			headerGraphic.loadGraphic(buttonImageClass,false,false,100,25,true);
//			headerGraphic.scale.x = 1.4;
//
			
			//Text under logo
//			instructionTitle = new FlxText(0,10,320);
//			instructionTitle.setFormat(null,8,0x0,"center",instructionTitle.shadow);
//			instructionTitle.text = "HOW TO PLAY"
//
//			
//			instructionText = new FlxText(0,30,320);
//			instructionText.setFormat(null,10,0xffffffff,"center",instructionText.shadow);
//			instructionText.text = "Using your EVEREADY DOLPHIN Torch \n reach the end before the timer runs out. \n\n" +
//									"Use the DIRECTIONAL buttons to MOVE\n" + 
//									"SPACE to JUMP\n\n" +
//									"Oh and watch out for the zombies.\n\n" +
//									"PRESS -> to start the clock!";
				

			
			//Add all the things to the main flxgroup	
			add(skyBackdrop);
			add(buildingsBackdrop);
			add(level);
			add(player);
			add(instructionsGraphic);
			
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(level,player);
			
			if (FlxG.keys.any())
			{
				FlxG.music.fadeOut(3);
				FlxG.switchState(new PlayState);
			}
		}
	}
}
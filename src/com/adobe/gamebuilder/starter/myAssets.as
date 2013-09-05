package com.adobe.gamebuilder.starter
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	
	public class myAssets
	{
		[Embed(source="../../../../resource/assets/welcome_designButton.png")]
		public static var design:Class;
		
		[Embed(source="../../../../resource/assets/welcome_playButton.png")]
		public static var play:Class;
		
		[Embed(source="../../../../resource/assets/share.png")]
		public static var share:Class;
		
		[Embed(source="../../../../resource/assets/Level1.png")]
		public static var level1:Class;
		
		[Embed(source="../../../../resource/assets/Level2.png")]
		public static var level2:Class;
		
		[Embed(source="../../../../resource/assets/Level3.png")]
		public static var level3:Class;
		
		[Embed(source="../../../../resource/assets/Level4.png")]
		public static var level4:Class;
		
		[Embed(source="../../../../resource/assets/temp.png")]
		public static var temp:Class;
		
		public static var gameTextures:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture
		{
			if(gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new myAssets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}
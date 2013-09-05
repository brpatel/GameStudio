package com.adobe.gamebuilder.editor.view.bars
{
	import com.adobe.gamebuilder.editor.assets.Assets;
	import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
	import com.adobe.gamebuilder.starter.myAssets;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	import org.josht.starling.display.Image;
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.display.Sprite;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.ScrollContainer;
	import org.josht.starling.textures.Scale3Textures;
	import org.josht.starling.textures.Scale9Textures;
	
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class CreativeCloudPopUp extends Sprite
	{
		private var imagesList:ArrayCollection;
		
		public function CreativeCloudPopUp()
		{
			imagesList = new ArrayCollection;
			var _local1:Scale9Textures = new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("default_btn_bg_black_down"), new Rectangle(2, 2, 30, 30));
			var bg1:Scale9Image = new Scale9Image(_local1);
			bg1.width = 1260;
			bg1.height = 700;
			addChild(bg1);
			
			var closeIcon:ImageButton = new ImageButton("overlay_close_icon_down", 0, 0);
			closeIcon.x = this.x + this.width - closeIcon.width - 10;;
			closeIcon.y = this.y + 5;
			closeIcon.onRelease.add(removePopUp);
			addChild(closeIcon);
			
			getImageRecursivesList("resource/creativeCloud");
			
			for (var i:int = 0; i < imagesList.length; i++) 
			{
				var imgButton:Button = new Button;
				imgButton.width = 150;
				imgButton.height = 100;
				imgButton.name = File(imagesList[i]).name.toString();
				
				if( i < 6)
				{
					imgButton.x = (this.x + 50)*(i+1) + i*150;
					imgButton.y = this.y + 50;
				}
				else if(i>=6 && i< 12)
				{
					imgButton.x = (this.x + 50)*(i-5) + (i-6)*150;
					imgButton.y = this.y + 50 + 150;
				}
				else if(i>=12 && i<18)
				{
					imgButton.x = (this.x + 50)*(i-11) + (i-12)*150;
					imgButton.y = this.y + 50 + 300
				}
				else if(i>=18 && i<24)
				{
					imgButton.x = (this.x + 50)*(i-17) + (i-18)*150;
					imgButton.y = this.y + 50 + 450
				}
				var imgText:TextField = new TextField(150,40,File(imagesList[i]).name.substr(0,File(imagesList[i]).name.indexOf('.')),"Verdana",14,Color.WHITE);
				imgText.y = imgButton.y + imgButton.height;
				imgText.x = imgButton.x;
				
				imgButton.onRelease.add(addToEditor);
				this.addChild(imgButton);
				this.addChild(imgText);
				
				var last:int = File(imagesList[i]).url.indexOf('.');
				var begin:int = File(imagesList[i]).url.lastIndexOf('/');
				var imageName:String = File(imagesList[i]).url.substr(begin+1, last-begin-1);
				
				var iconTexture:Scale9Textures = new Scale9Textures(Assets.getTextureAtlas("creativeCloud").getTexture(imageName), new Rectangle(2, 2, 150, 100));
				
				var iconImg:Image = new Image(iconTexture.texture);
				iconImg.width = 150;
				iconImg.height = 100;
				imgButton.defaultIcon = iconImg;
			}
		}
		
		private function removePopUp(_arg1:ImageButton):void
		{
			this.parent.removeChild(this);			
		}
		
		private function addToEditor():void
		{
			// Do something here to add it to the editor. May be reflect the path from here in properties
		}
		
		private function addButtonIcon(_arg1:Button):void
		{
			trace("listener here");
		}
		
		public function getImageRecursivesList(imgFolder:String):void
		{
			if(imagesList != null)
				imagesList.removeAll();
			var count:int = 0;
			
			var folder:File = File.applicationDirectory.resolvePath(imgFolder);
			var tempObj:Array = folder.getDirectoryListing();
			
			for (var i:int = 0; i < tempObj.length; i++) 
			{
				if (File(tempObj[i]).isDirectory) {
					getImageRecursivesList(File(tempObj[i]).nativePath);
				} 
				else
				{
					var extension:String = File(tempObj[i]).extension.toString();
					if(extension == "png" || extension == "jpg" || extension == "jpeg" && !imagesList.contains(tempObj[i]))
						imagesList.addItemAt(tempObj[i], count++);
				}
			}			
		}
	}
}
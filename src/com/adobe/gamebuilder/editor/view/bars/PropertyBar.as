package com.adobe.gamebuilder.editor.view.bars
{
	import com.adobe.gamebuilder.editor.assets.Assets;
	import com.adobe.gamebuilder.editor.core.Constants;
	import com.adobe.gamebuilder.editor.view.comps.InputField;
	import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.Screen;
	import org.josht.starling.textures.Scale9Textures;
	import org.osflash.signals.Signal;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class PropertyBar extends Screen 
	{
		private var _btnRelease:Signal;
//		private var _open:Boolean = false;
//		private var _sidebarWidth:Number = 325;
		private var _contents:Dictionary;
		private var _tabs:Dictionary;
		private var _currTab:String;
		
//		private var _reset:Boolean = true;
		private var btnProperties:ImageButton;
		
		private var _bg1:Scale9Image;
		private var _bg2:Scale9Image;
		private var _bg3:Scale9Image;
		
		
		public static const FIELD_WIDTH:int = 142;
		private var _inputA:InputField;
		private var _inputB:InputField;
		private var _inputC:InputField;
		private var _inputD:InputField;
		private var _btnAssume:Button;
		private var _btnReset:Button;
		private var _valueA:int;
		private var _valueB:int;
		private var _valueC:int;
		private var _valueD:int;
		private var _initialComplete:Signal;
		private var _measureRequest:Signal;
		private var _sideMeasureInputChange:Signal;
		private var _sidesUpdate:Signal;
		private var _roomChange:Signal;
		private var _roomReflection:Signal;
		private var _selectedRoom:int = 1;
		private var contentSprte:Screen;
		    
		
		public function PropertyBar()
		{
			this._btnRelease = new Signal(String);
			super();
			addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		public function get btnRelease():Signal
		{
			return (this._btnRelease);
		}
		
		private function init():void
		{
			dispatchEvent(new Event("added"));
			//	this.map = map;
		}
		
		public function get visibleContent():Sprite
		{
			if (!(this._currTab))
			{
				return (null);
			};
			return (this._contents[this._currTab]);
		}
		
		override protected function initialize():void
		{
			
			
			contentSprte = new Screen;
			addChild(contentSprte);
			
			
		}
		
		public function setContent(content:Screen, tab:String):void
		{
			
			var _local1:Scale9Textures = new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("mode_bg"), new Rectangle(2, 2, 53, 52));
			this._bg1 = new Scale9Image(_local1);
			this._bg1.width = Constants.PROPERTYBAR_WIDTH;
			this._bg1.height = stage.stageHeight - 200;
			addChild(this._bg1);
			
			this._bg2 = new Scale9Image(_local1);
			this._bg2.width = Constants.PROPERTYBAR_WIDTH;
			this._bg2.height = 35;
			addChild(this._bg2);
			
			this.btnProperties = new ImageButton("list_info_icon_down", 0, 0);
			this.btnProperties.x = 5;
			this.btnProperties.y = 5;
			this.btnProperties.name = "propertiesBtn";
			addChild(btnProperties);
			
			this._bg3 = new Scale9Image(_local1);
			this._bg3.width = Constants.PROPERTYBAR_WIDTH;
			this._bg3.height = 35;
			this._bg3.y = _bg1.height - 35;
			addChild(this._bg3);
			
			this.initialize();
			contentSprte.addChild(content);
			content.visible = true;
			
			

		}
		private function handleTabClick(e:MouseEvent):void
		{
			this.showTab(e.target.name);
		}
		
		public function showTab(tab:String):void
		{
			if ((((this._currTab == tab)) || (!(this._contents[tab]))))
			{
				return;
			};
			if (this.visibleContent)
			{
				this._tabs[this._currTab].alpha = 0.45;
				this.visibleContent.visible = false;
			};
			this._currTab = tab;
			this.visibleContent.visible = true;
			this._tabs[this._currTab].alpha = 1;
		}
	}
}
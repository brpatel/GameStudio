package com.adobe.gamebuilder.editor.view.bars
{
	import com.adobe.gamebuilder.editor.core.Constants;
	import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class PropertyTab extends DisplayObjectContainer 
	{
		
		///[Embed(source="../assets/arrow.png")]
		private var _btnCloseClass:Class;
		
	//	[Embed(source="../assets/properties.png")]
		private var _titleModelsClass:Class;
		
		public static const WIDTH:uint = 30;
		
		public var titleSprite:Sprite;
		
		public var toggleButton:uint = 83;
		public var openCloseButton:Sprite;
		public var createTabButton:Sprite;
		public var propertiesTabButton:Sprite;
		
		private var _actionSignal:Signal;
		
		private var _reset:Boolean = true;
		
		private var btnProperties:ImageButton;
		private var btnCloseProperties:ImageButton;

		private var propertyBar:PropertyBar;
		
		public function PropertyTab()
		{
			super();
			this._actionSignal = new Signal(String);
			addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		public function get actionSignal():Signal
		{
			return (this._actionSignal);
		}
		
		private function init():void
		{
			this.btnProperties = new ImageButton("list_back_btn_icon_down", 0, 0);
			this.btnProperties.x =0;
			this.btnProperties.y = 0;
			this.btnProperties.name = "propertiesBtn";
			this.btnProperties.onRelease.add(this.btnPropertiesOnRelease);
			addChild(this.btnProperties);
			
			if(propertyBar == null)
			{
				propertyBar = new PropertyBar;
				propertyBar.x = stage.stageWidth;
				propertyBar.y = Constants.TOPBAR_HEIGHT + 50;
				this.parent.addChild(propertyBar);
				
				this.btnCloseProperties = new ImageButton("list_back_btn_icon_down", 0, 0);
				this.btnCloseProperties.x = stage.stageWidth+50;
				this.btnCloseProperties.y = stage.stageHeight - 138;
				btnCloseProperties.scaleX=-1;
				this.btnCloseProperties.name = "propertiesCloseBtn";
				this.parent.addChild(btnCloseProperties);
				this.btnCloseProperties.onRelease.add(this.btnClosePropertiesOnRelease);
			}
		}		
		
		private function btnPropertiesOnRelease(_arg1:ImageButton):void
		{
			if(propertyBar == null)
			{
				propertyBar = new PropertyBar;
				propertyBar.x = stage.stageWidth;
				propertyBar.y = Constants.TOPBAR_HEIGHT + 50;
				this.parent.addChild(propertyBar);
				
				this.btnCloseProperties = new ImageButton("icon_save", 0, 0);
				this.btnCloseProperties.x = stage.stageWidth;
				this.btnCloseProperties.y = stage.stageHeight - 145;
				this.btnCloseProperties.name = "propertiesCloseBtn";
				this.parent.addChild(btnCloseProperties);
				this.btnCloseProperties.onRelease.add(this.btnClosePropertiesOnRelease);
			}
			
			var _local1:Tween = new Tween(propertyBar, 0.3, Transitions.EASE_OUT);
			_local1.animate("x", stage.stageWidth - Constants.PROPERTYBAR_WIDTH);
			Starling.juggler.add(_local1);
			
			var _local2:Tween = new Tween(btnCloseProperties, 0.3, Transitions.EASE_OUT);
			_local2.animate("x", stage.stageWidth +30 - Constants.PROPERTYBAR_WIDTH + 5);
			Starling.juggler.add(_local2);
			
			this.btnProperties.visible = false;
			this.btnCloseProperties.visible = true;
		}
		
		private function btnClosePropertiesOnRelease(_arg1:ImageButton):void
		{
			var _local1:Tween = new Tween(propertyBar, 0.3, Transitions.EASE_OUT);
			_local1.animate("x", stage.stageWidth);
			Starling.juggler.add(_local1);
			
			var _local2:Tween = new Tween(btnCloseProperties, 0.3, Transitions.EASE_OUT);
			_local2.animate("x", stage.stageWidth+ 50);
			Starling.juggler.add(_local2);
			
			this.btnProperties.visible = true;
		}
	}
}//package components

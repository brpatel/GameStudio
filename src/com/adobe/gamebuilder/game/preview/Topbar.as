package com.adobe.gamebuilder.game.preview
{
    import com.greensock.TweenMax;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    
    import fl.controls.Slider;
    import fl.events.SliderEvent;
    
    
  
    public class Topbar extends Sprite 
    {

		/*[Embed(source="../assets/LevelArc_b4_5.png")]
        private var _btnCloseClass:Class;
		*/
		
		
		
			
        public var toggleButton:uint = 83;
 //       public var openCloseButton:Sprite;
		 public var createTabButton:Sprite;
        public var propertiesTabButton:Sprite;
        private var _open:Boolean = true;
        private var _topBarHeight:Number = 50;
        private var _contents:Dictionary;
        private var _tabs:Dictionary;
        private var _currTab:String;
		
		[Embed(source="../../../../../resource/play.png")]
		private var _btnPlayClass:Class;
		public var playButton:Sprite;
		
		[Embed(source="../../../../../resource/pause.png")]
		private var _btnPauseClass:Class;
		public var pauseButton:Sprite;
		
		[Embed(source="../../../../../resource/exit.png")]
		private var _btnExitClass:Class;
		public var exitButton:Sprite;
		
	/*	[Embed(source="../assets/delete.png")]
		private var _btnDeleteClass:Class;
		public var deleteButton:Sprite;
		
		[Embed(source="../assets/share.png")]
		private var _btnShareClass:Class;
		public var shareButton:Sprite;
		
		[Embed(source="../assets/settings.png")]
		private var _btnSettingsClass:Class;
		public var settingsButton:Sprite;
		
		[Embed(source="../assets/Minus.png")]
		private var _btnMinusClass:Class;
		public var minusButton:Sprite;
		
		[Embed(source="../assets/Plus.png")]
		private var _btnPlusClass:Class;
		public var plusButton:Sprite;
	*/	
		[Embed(source="../../../../../resource/timeline_show.png")]
		private var _btnShowTimelineClass:Class;
		[Embed(source="../../../../../resource/timeline_hide.png")]
		private var _btnHideTimelineClass:Class;
		public var timelineButton:Sprite;
		
		/*[Embed(source="../assets/Slider.swf")]
		private var _sliderClass:Class;
		*/public var sliderButton:Slider;
		
		
		private var isMouseDown:Boolean;
		public var	showTimeline:Boolean=false;
		private var previousSliderValue:int =0;

		private var app:GameBuilderApp;
		
		

        public function Topbar(app:GameBuilderApp)
        {
			this.app = app;
      //      this._btnCloseClass = Sidebar__btnCloseClass;
            this._contents = new Dictionary();
            this._tabs = new Dictionary();
            super();
            addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
     /*       var closeBitmap:Bitmap = new this._btnCloseClass();
            this.openCloseButton = new Sprite();
            addChild(this.openCloseButton);
            this.openCloseButton.buttonMode = true;
            this.openCloseButton.addChild(closeBitmap);
            this.openCloseButton.addEventListener(MouseEvent.CLICK, this.handleOpenCloseButtonClick);*/
			
			
			
			
/*			// Top bar buttons
			// Minus button
			this.minusButton = new Sprite();
			var minusBitmap:Bitmap = new this._btnMinusClass();			
//			addChild(this.minusButton);
			this.minusButton.buttonMode = true;
			this.minusButton.addChild(minusBitmap);
			this.minusButton.addEventListener(MouseEvent.CLICK, this.handleMinusButtonClick);
			
			// Plus button
			this.plusButton = new Sprite();
			var plusBitmap:Bitmap = new this._btnPlusClass();			
//			addChild(this.plusButton);
			this.plusButton.buttonMode = true;
			this.plusButton.addChild(plusBitmap);
			this.plusButton.addEventListener(MouseEvent.CLICK, this.handlePlusButtonClick);*/
			
			
			
			// Play button
			this.playButton = new Sprite();
			var playBitmap:Bitmap = new this._btnPlayClass();			
			addChild(this.playButton);
			this.playButton.buttonMode = true;
			this.playButton.addChild(playBitmap);
			this.playButton.addEventListener(MouseEvent.CLICK, this.handlePlayButtonClick);
			this.playButton.visible = false;
			
			// Pause Button
			this.pauseButton = new Sprite();
			var pauseBitmap:Bitmap = new this._btnPauseClass();			
			addChild(this.pauseButton);
			this.pauseButton.buttonMode = true;
			this.pauseButton.addChild(pauseBitmap);
			this.pauseButton.addEventListener(MouseEvent.CLICK, this.handlePauseButtonClick);
			this.pauseButton.visible = !this.playButton.visible;
			
			
			
			// Exit button
			this.exitButton = new Sprite();
			var exitBitmap:Bitmap = new this._btnExitClass();			
			addChild(this.exitButton);
			this.exitButton.buttonMode = true;
			this.exitButton.addChild(exitBitmap);
			this.exitButton.addEventListener(MouseEvent.CLICK, this.handleExitButtonClick);
/*			
			// Delete button
			this.deleteButton = new Sprite();
			var deleteBitmap:Bitmap = new this._btnDeleteClass();			
			addChild(this.deleteButton);
			this.deleteButton.buttonMode = true;
			this.deleteButton.addChild(deleteBitmap);
			this.deleteButton.addEventListener(MouseEvent.CLICK, this.handleDeleteButtonClick);
			
			// Settings button
			this.settingsButton = new Sprite();
			var settingsBitmap:Bitmap = new this._btnSettingsClass();			
			addChild(this.settingsButton);
			this.settingsButton.buttonMode = true;
			this.settingsButton.addChild(settingsBitmap);
			this.settingsButton.addEventListener(MouseEvent.CLICK, this.handleSettingsButtonClick);
			
			// Share button
			
			this.shareButton = new Sprite();
			var shareBitmap:Bitmap = new this._btnShareClass();			
			addChild(this.shareButton);
			this.shareButton.buttonMode = true;
			this.shareButton.addChild(shareBitmap);
			this.shareButton.addEventListener(MouseEvent.CLICK, this.handleShareButtonClick);*/
			
			// slider
					
			this.sliderButton = new Slider();
			sliderButton.width = 500;
			sliderButton.height = 50;
			sliderButton.tickInterval =5;
			sliderButton.liveDragging=true;
			sliderButton.addEventListener(MouseEvent.CLICK,onSliderClick);
			sliderButton.addEventListener(SliderEvent.THUMB_DRAG,onSliderChange);
			addChild(sliderButton);
			sliderButton.visible = false;
			sliderButton.getChildAt(1).width = 30;
			sliderButton.getChildAt(1).height = 40;
			
			// Timeline button
			
			this.timelineButton = new Sprite();
			var timelineBitmap:Bitmap = new this._btnShowTimelineClass();			
			addChild(this.timelineButton);
			this.timelineButton.buttonMode = true;
			this.timelineButton.addChild(timelineBitmap);
			this.timelineButton.addEventListener(MouseEvent.CLICK, this.handleTimelineButtonClick);
			timelineButton.visible = false;
        }
		
		protected function onSliderClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}		
		
			
			
				
		
        public function get visibleContent():Sprite
        {
            if (!(this._currTab))
            {
                return (null);
            };
            return (this._contents[this._currTab]);
        }

        public function open():void
        {
            if (this._open)
            {
                return;
            };
			if(stage!= null){
	            TweenMax.to(this, 0.4, {x:0});
	            this._open = true;
	     //       removeEventListener(MouseEvent.CLICK, this.openViaClick);
/*	            this.openCloseButton.scaleX = 1;
	            this.openCloseButton.x = 10;
				this.openCloseButton.y = 10;*/
	            buttonMode = false;
			}
        }

        public function close():void
        {
            if (!(this._open))
            {
                return;
            };
            TweenMax.to(this, 0.4, {x:(stage.stageWidth - 50)});
            this._open = false;
   //         addEventListener(MouseEvent.CLICK, this.openViaClick);
         /*   this.openCloseButton.scaleX = -1;
            this.openCloseButton.x = this.openCloseButton.width + 10;
			this.openCloseButton.y = 10;*/
            buttonMode = true;
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

        private function handleAddedToStage(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
            stage.addEventListener(Event.RESIZE, this.handleStageResize);
            this.draw();
			
			
			
        }

        private function handleKeyDown(e:KeyboardEvent):void
        {
            if (e.keyCode == this.toggleButton)
            {
                if (this._open)
                {
                    this.close();
                }
                else
                {
                    this.open();
                };
            };
        }

        private function handleStageResize(e:Event):void
        {
            this.draw();
        }

        private function openViaClick(e:MouseEvent):void
        {
            this.open();
        }

        private function handleOpenCloseButtonClick(e:MouseEvent):void
        {
            if (this._open)
            {
                this.close();
            }
            else
            {
                this.open();
            };
            e.stopPropagation();
        }

        private function draw():void
        {
			if(stage!=null){
	            var bgWidth:Number = 50;
				
	            if (this.visibleContent)
	            {
	                bgWidth = (bgWidth + this.visibleContent.width);
	            };
	            if (this._open)
	            {
					x=0;
	                y = 0;//this._topBarHeight;
	            }
	            else
	            {
					x= stage.stageWidth - 50;
	                y = 0;//(stage.stageHeight - 50);
	            };
	            graphics.clear();
				graphics.beginFill(0x000000, 0.5);
	            graphics.drawRect(0, 0, (stage.stageWidth - x), this._topBarHeight);
	            graphics.endFill();
				
					
					
					
				
					// Open Close button
				 	
					/*this.openCloseButton.x = 10;
					this.openCloseButton.y = 10;*/
					
					
					
				/*	this.minusButton.x = this.openCloseButton.x + this.openCloseButton.width + 50;
					this.minusButton.y = 5;
					
					this.plusButton.x = this.minusButton.x + this.minusButton.width + 50;
					this.plusButton.y = 5;*/
					
					// Timeline button
					this.timelineButton.x = 100;// this.openCloseButton.x + this.openCloseButton.width + 50;
					this.timelineButton.y = 5;
					
					// slider
					
					this.sliderButton.x = this.timelineButton.x + this.timelineButton.width + 50;
					this.sliderButton.y = 25;
				
					// Exit button
					this.exitButton.x = this.stage.stageWidth - this.exitButton.width - 50;
					this.exitButton.y = 2;
					
			/*		// Settings button
					this.settingsButton.x = this.exitButton.x  - this.settingsButton.width - 50;
					this.settingsButton.y = 5;
					
					// Delete button
					this.deleteButton.x =  this.settingsButton.x - this.deleteButton.width - 50;
					this.deleteButton.y = 5;
					
					// Share button
					this.shareButton.x =  this.deleteButton.x - this.shareButton.width - 50;
					this.shareButton.y = 5;
				*/	
					// Play button
					this.playButton.x = this.exitButton.x - this.playButton.width - 50;//this.shareButton.x - this.playButton.width - 50;
					this.playButton.y = 5;
					
					// Pause button
					this.pauseButton.x = playButton.x;
					this.pauseButton.y = playButton.y;
				
					
					
					
				
			}
        }

        private function handleTabClick(e:MouseEvent):void
        {
            this.showTab(e.target.name);
        }
		
		protected function handlePlayButtonClick(event:MouseEvent):void
		{
			playButton.visible = false;
			pauseButton.visible = true;
		//	playButton.dispatchEvent(new Event(Event.SELECT));
			hideTimelineControls();
			app.resumeGame();
						
		}
		
		protected function handlePauseButtonClick(event:MouseEvent):void
		{
			playButton.visible = true;
			pauseButton.visible = false;
		//	pauseButton.dispatchEvent(new Event(Event.SELECT));
			app.pauseGame();
		}	
		
		protected function handleExitButtonClick(event:MouseEvent):void
		{
			//	exitButton.dispatchEvent(new Event(Event.SELECT));
					hideTimelineControls();
					app.removeGameElements();
					this.parent.removeChild(this);
			
		}	
		
/*		protected function handleSettingsButtonClick(event:MouseEvent):void
		{
			settingsButton.dispatchEvent(new Event(Event.SELECT));
		}
		
		protected function handleDeleteButtonClick(event:MouseEvent):void
		{
			deleteButton.dispatchEvent(new Event(Event.SELECT));
			
		}	
		
		protected function handleShareButtonClick(event:MouseEvent):void
		{
			shareButton.dispatchEvent(new Event(Event.SELECT));
		}	

		protected function handleMinusButtonClick(event:MouseEvent):void
		{
			minusButton.dispatchEvent(new Event(Event.SELECT));
			
		}
		
		protected function handlePlusButtonClick(event:MouseEvent):void
		{
			plusButton.dispatchEvent(new Event(Event.SELECT));
			
		}*/
		
		protected function onSliderChange(event:SliderEvent):void
		{
			app.getFrame(sliderButton.value);
			//sliderButton.dispatchEvent(new Event(Event.SELECT));
			/*if(previousSliderValue < event.value){
				plusButton.dispatchEvent(new Event(Event.SELECT));
		//		trace("+ Slider: "+event.value);
			}else if(previousSliderValue > event.value){
				minusButton.dispatchEvent(new Event(Event.SELECT));
		//		trace("- Slider: "+event.value);
			}
			previousSliderValue = event.value;*/
			
		}	
		
		protected function handleTimelineButtonClick(event:MouseEvent):void
		{
			var timelineBitmap:Bitmap;
			showTimeline = !showTimeline;
			if(showTimeline){
				this.timelineButton.removeChildAt(this.timelineButton.numChildren-1);
				timelineBitmap = new this._btnHideTimelineClass();			
				this.timelineButton.addChild(timelineBitmap);
				
				app.redrawGhost();
			}else{
				this.timelineButton.removeChildAt(this.timelineButton.numChildren-1);
				timelineBitmap = new this._btnShowTimelineClass();			
				this.timelineButton.addChild(timelineBitmap);
				
				app.hideGhost();
			}
			
			timelineButton.dispatchEvent(new Event(Event.SELECT));		
		}
		
		public function showTimelineControls():void{
			this.timelineButton.visible = true;
			this.sliderButton.visible = true;
		}
		
		public function hideTimelineControls():void{
			this.timelineButton.visible = false;
			this.sliderButton.visible = false;
		}

    }
}//package components

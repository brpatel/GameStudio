package com.adobe.gamebuilder.editor.view
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.view.comps.TabButton;
    import com.adobe.gamebuilder.editor.view.screens.GameSetupScreen;
    import com.adobe.gamebuilder.editor.view.screens.ModelScreen;
    import com.gskinner.motion.easing.Cubic;
    
    import org.josht.starling.display.TiledImage;
    import org.josht.starling.foxhole.controls.ScreenNavigator;
    import org.josht.starling.foxhole.controls.ScreenNavigatorItem;
    import org.josht.starling.foxhole.transitions.ScreenSlidingStackTransitionManager;
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;

    public class LeftPanel extends DisplayObjectContainer 
    {

        public static const TAB_WIDTH:int = 46;

        private var _screenChange:Signal;
        private var _navigator:ScreenNavigator;
        private var _transitionManager:ScreenSlidingStackTransitionManager;
        private var _roomScreen:ScreenNavigatorItem;
        public var btnStep1:TabButton;
        public var btnStep2:TabButton;
        public var btnStep3:TabButton;
        public var btnStep4:TabButton;

        public function LeftPanel()
        {
            this._screenChange = new Signal(String);
        }

		public function get navigator():ScreenNavigator
		{
			return _navigator;
		}

		public function set navigator(value:ScreenNavigator):void
		{
			_navigator = value;
		}

        public function get screenChange():Signal
        {
            return (this._screenChange);
        }

        public function init(_arg1:int):void
        {
            var _local2:TiledImage = new TiledImage(Assets.getTextureAtlas("Interface").getTexture("left_panel_bg"));
            _local2.width = 0;//(TAB_WIDTH);
            _local2.height = (stage.stageHeight - Constants.TOPBAR_HEIGHT);
            addChild(_local2);
			
			var _local3:TiledImage = new TiledImage(Assets.getTextureAtlas("Interface").getTexture("left_panel_bg"));
			//  var _local3:TiledImage = new TiledImage(Assets.getTextureAtlas("Interface").getTexture("left_panel_screen_bg"));
            _local3.x = 0;(Constants.PANEL_WIDTH - 268);
            _local3.width = 195;
            _local3.height = (stage.stageHeight - Constants.TOPBAR_HEIGHT);
            addChild(_local3);
            var _local4:Image = new Image(Assets.getTextureAtlas("Interface").getTexture("left_panel_screen_bg_corner"));
            _local4.x = TAB_WIDTH;
  /*          addChild(_local4);
            this.btnStep4 = new TabButton(4, Constants.STEP_FINALIZE);
            this.btnStep4.x = 0;
            this.btnStep4.y = 346;
            this.btnStep4.onRelease.add(this.stepButton_onRelease);
            addChild(this.btnStep4);
            this.btnStep3 = new TabButton(3, Constants.STEP_PRODUCTS);
            this.btnStep3.x = 0;
            this.btnStep3.y = 233;
            this.btnStep3.onRelease.add(this.stepButton_onRelease);
            addChild(this.btnStep3);
     */       this.btnStep2 = new TabButton(2, Constants.STEP_OPENINGS);
            this.btnStep2.x = 0;
            this.btnStep2.y = 120;
            this.btnStep2.onRelease.add(this.stepButton_onRelease);
//            addChild(this.btnStep2);
            this.btnStep1 = new TabButton(1, Constants.STEP_ROOM);
            this.btnStep1.x = 0;
            this.btnStep1.y = 7;
            this.btnStep1.onRelease.add(this.stepButton_onRelease);
//            addChild(this.btnStep1);
            this._navigator = new ScreenNavigator();
            addChildAt(this._navigator, 2);
            this._navigator.defaultScreenID = (Common.appStep = Constants.STEP_ROOM);
            this._navigator.width = 261;
			
            this._navigator.height = (stage.stageHeight - Constants.TOPBAR_HEIGHT);
            this._navigator.x = 0; //TAB_WIDTH;
            this._navigator.y = 0;
            this._navigator.clipContent = true;
//            this._roomScreen = new ScreenNavigatorItem(RoomScreen, {}, {selectedRoom:_arg1});
			this._roomScreen = new ScreenNavigatorItem(GameSetupScreen, {}, {selectedRoom:_arg1});
            this._navigator.addScreen(Constants.STEP_ROOM, this._roomScreen);
          /*  this._navigator.addScreen(Constants.STEP_OPENINGS, new ScreenNavigatorItem(OpeningsScreen));*/
			this._navigator.addScreen(Constants.STEP_OPENINGS, new ScreenNavigatorItem(ModelScreen));
  //          this._navigator.addScreen(Constants.STEP_PRODUCTS, new ScreenNavigatorItem(ProductScreen));
  //          this._navigator.addScreen(Constants.STEP_FINALIZE, new ScreenNavigatorItem(FinalizeScreen));
            this._navigator.onChange.add(this.screenChangeHandler);
            this._navigator.showScreen(Constants.STEP_OPENINGS);
		    this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
            this._transitionManager.duration = 0.4;
            this._transitionManager.ease = Cubic.easeOut;
        }

        private function stepButton_onRelease(_arg1:String):void
        {
            this._navigator.showScreen(_arg1);
        }

        private function screenChangeHandler(_arg1:ScreenNavigator):void
        {
           /* if ((_arg1.activeScreen is RoomScreen))
            {
                (_arg1.activeScreen as RoomScreen).roomChange.add(this.roomChangeHandler);
            };*/
			if ((_arg1.activeScreen is GameSetupScreen))
			{
				(_arg1.activeScreen as GameSetupScreen).roomChange.add(this.roomChangeHandler);
			};
			
            Common.appStep = _arg1.activeScreenID;
            this._screenChange.dispatch(_arg1.activeScreenID);
//            this.setButtons(_arg1.activeScreenID);
        }

        private function setButtons(_arg1:String):void
        {
            this.btnStep1.isSelected = (_arg1 == Constants.STEP_ROOM);
            this.btnStep1.touchable = !((_arg1 == Constants.STEP_ROOM));
            if (_arg1 == Constants.STEP_ROOM)
            {
     //           setChildIndex(this.btnStep4, (numChildren - 1));
     //           setChildIndex(this.btnStep3, (numChildren - 1));
                setChildIndex(this.btnStep2, (numChildren - 1));
                setChildIndex(this.btnStep1, (numChildren - 1));
            };
            this.btnStep2.isSelected = (_arg1 == Constants.STEP_OPENINGS);
            this.btnStep2.touchable = !((_arg1 == Constants.STEP_OPENINGS));
            if (_arg1 == Constants.STEP_OPENINGS)
            {
   //             setChildIndex(this.btnStep3, (numChildren - 1));
                setChildIndex(this.btnStep2, (numChildren - 1));
            };
  //          this.btnStep3.isSelected = (_arg1 == Constants.STEP_PRODUCTS);
 //           this.btnStep3.touchable = !((_arg1 == Constants.STEP_PRODUCTS));
            if (_arg1 == Constants.STEP_PRODUCTS)
            {
                setChildIndex(this.btnStep2, (numChildren - 1));
  //              setChildIndex(this.btnStep3, (numChildren - 1));
            };
  //          this.btnStep4.isSelected = (_arg1 == Constants.STEP_FINALIZE);
  //          this.btnStep4.touchable = !((_arg1 == Constants.STEP_FINALIZE));
            if (_arg1 == Constants.STEP_FINALIZE)
            {
                setChildIndex(this.btnStep1, (numChildren - 1));
                setChildIndex(this.btnStep2, (numChildren - 1));
   //             setChildIndex(this.btnStep3, (numChildren - 1));
   //             setChildIndex(this.btnStep4, (numChildren - 1));
            };
        }

        public function switchScreen(_arg1:String):void
        {
            if (Common.appStep != _arg1)
            {
                this.stepButton_onRelease(_arg1);
            };
        }

        private function roomChangeHandler(_arg1:uint):void
        {
            this._roomScreen.initializer.selectedRoom = _arg1;
        }


    }
}//package at.polypex.badplaner.view

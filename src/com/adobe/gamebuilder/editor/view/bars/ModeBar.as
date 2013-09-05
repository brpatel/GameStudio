package com.adobe.gamebuilder.editor.view.bars
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageToggle;
    import com.adobe.gamebuilder.editor.view.states.ViewMode;
    
    import flash.geom.Rectangle;
    
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.textures.Scale9Textures;
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class ModeBar extends DisplayObjectContainer 
    {

        public static const WIDTH:uint = 56;
        public static const BUTTON_HEIGHT:uint = 52;

        private var _btnRelease:Signal;
        private var _bg1:Scale9Image;
        private var _bg2:Scale9Image;
        private var _btnGridSnap:ImageToggle;
        private var _btnAngleSnap:ImageToggle;

        public function ModeBar()
        {
            this._btnRelease = new Signal(String);
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get btnRelease():Signal
        {
            return (this._btnRelease);
        }

		protected function init():void
		{
			var _local1:Scale9Textures = new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("mode_bg"), new Rectangle(2, 2, 53, 52));
			this._bg1 = new Scale9Image(_local1);
			this._bg1.width = 2 * WIDTH;
			this._bg1.height = BUTTON_HEIGHT;
			//this._bg1.width = WIDTH;
			//this._bg1.height = (2 * BUTTON_HEIGHT);
			addChild(this._bg1);
			this._bg2 = new Scale9Image(_local1);
			this._bg2.x = 107;
			//this._bg2.y = 107;
			this._bg2.width = WIDTH;
			this._bg2.height = BUTTON_HEIGHT;
			addChild(this._bg2);
			this._btnGridSnap = new ImageToggle("mode_gridsnap_icon");
			this._btnGridSnap.x = 2;
			this._btnGridSnap.y = 0;
			this._btnGridSnap.isSelected = false;
			this._btnGridSnap.onRelease.add(this.btnGridSnapOnRelease);
			addChild(this._btnGridSnap);
			this._btnAngleSnap = new ImageToggle("mode_anglesnap_icon");
			this._btnAngleSnap.x = 53;
			this._btnAngleSnap.y = 2;
			// this._btnAngleSnap.x = 2;
			// this._btnAngleSnap.y = 52;
			this._btnAngleSnap.isSelected = false;
			this._btnAngleSnap.onRelease.add(this.btnAngleSnapOnRelease);
			addChild(this._btnAngleSnap);
			var _local2:ImageToggle = new ImageToggle("mode_presentation_icon");
			_local2.x = 107;
			_local2.y = 2;
			// _local2.x = 2;
			// _local2.y = 107;
			_local2.onRelease.add(this.btnPresOnRelease);
			addChild(_local2);
		}


        public function switchViewMode(_arg1:String):void
        {
            this.visible = (((_arg1)==ViewMode.SCREENSHOT) ? false : true);
            this._bg1.visible = (_arg1 == ViewMode.NORMAL);
            this._btnGridSnap.visible = (_arg1 == ViewMode.NORMAL);
            this._btnAngleSnap.visible = (_arg1 == ViewMode.NORMAL);
        }

        private function btnPresOnRelease(_arg1:ImageToggle):void
        {
            this._btnRelease.dispatch("presentationMode");
        }

        private function btnGridSnapOnRelease(_arg1:ImageToggle):void
        {
            this._btnRelease.dispatch("gridSnap");
        }

        private function btnAngleSnapOnRelease(_arg1:ImageToggle):void
        {
            this._btnRelease.dispatch("angleSnap");
        }


    }
}//package at.polypex.badplaner.view.bars

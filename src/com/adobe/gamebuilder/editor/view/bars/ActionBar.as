package com.adobe.gamebuilder.editor.view.bars
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.view.ActionBarContainer;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    
    import org.josht.starling.display.TiledImage;
    import org.osflash.signals.Signal;
    
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class ActionBar extends DisplayObjectContainer 
    {

        public static const HEIGHT:int = 62;
        public static const BG_HEIGHT:int = 79;

        protected var _hideComplete:Signal;
        protected var _closeButton:ImageButton;
        private var _reset:Boolean = true;

        public function ActionBar()
        {
            this._hideComplete = new Signal(Boolean);
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get hideComplete():Signal
        {
            return (this._hideComplete);
        }

        protected function init():void
        {
            var _local1:TiledImage = new TiledImage(Assets.getTextureAtlas("Interface").getTexture("sub_menu_bg"));
            _local1.width = stage.stageWidth;
            _local1.y = -8;
            addChild(_local1);
            this._closeButton = new ImageButton("close_icon_white", 52, 52);
            this._closeButton.onRelease.add(this.closeButtonOnRelease);
            this._closeButton.x = 4;
            this._closeButton.y = int(((HEIGHT - 52) >> 1));
            addChild(this._closeButton);
        }

        private function closeButtonOnRelease(_arg1:ImageButton):void
        {
            (parent as ActionBarContainer).hide();
        }

        public function show():void
        {
            var _local1:Tween = new Tween(this, 0.3, Transitions.EASE_OUT);
            _local1.animate("y", 0);
            Starling.juggler.add(_local1);
        }

        public function hide(_arg1:Boolean=true):void
        {
            this._reset = _arg1;
            var _local2:Tween = new Tween(this, 0.3, Transitions.EASE_OUT);
            _local2.animate("y", -(BG_HEIGHT));
            _local2.onComplete = this.hideTweenCompleteHandler;
            Starling.juggler.add(_local2);
        }

        public function hideImmediate():void
        {
            this.y = -(BG_HEIGHT);
        }

        private function hideTweenCompleteHandler():void
        {
            this._hideComplete.dispatch(this._reset);
        }


    }
}//package at.polypex.badplaner.view.bars

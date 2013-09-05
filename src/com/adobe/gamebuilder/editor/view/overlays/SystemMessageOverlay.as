package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.utils.Timer;
    
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.textures.Scale9Textures;
    
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.TextureSmoothing;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class SystemMessageOverlay extends DisplayObjectContainer 
    {

        public static const WIDTH:uint = 310;
        public static const MARGIN:uint = 15;
        public static const PADDING:uint = 18;
        public static const PADDING_VERTICAL:uint = 10;

        private var _bg:Scale9Image;
        private var _textField:TextField;
        private var _timer:Timer;
        private var _icon:Image;

        public function SystemMessageOverlay()
        {
            this.init();
        }

        private function init():void
        {
            var _local1:Scale9Textures = new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("bg_alert"), new Rectangle(5, 5, 26, 26));
            this._bg = new Scale9Image(_local1);
            this._bg.smoothing = TextureSmoothing.NONE;
            this._bg.width = WIDTH;
            this._bg.height = 50;
            addChild(this._bg);
            this._icon = new Image(Assets.getTextureAtlas("Interface").getTexture("alert_hakerl"));
            this._icon.x = 15;
            this._icon.y = 9;
            addChild(this._icon);
            this._textField = new TextField((WIDTH - (2 * PADDING)), 200, "", Constants.WHITE_SHADOW_FONT, 14, 0xFFFFFF);
            this._textField.hAlign = HAlign.LEFT;
            this._textField.vAlign = VAlign.TOP;
            this._textField.x = ((this._icon.x + this._icon.width) + PADDING);
            this._textField.width = ((WIDTH - this._textField.x) - PADDING);
            this._textField.y = PADDING_VERTICAL;
            addChild(this._textField);
            this._timer = new Timer(SystemMessage.DEFAULT_DELAY, 1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.hideTimerCompleteHandler);
        }

        protected function hideTimerCompleteHandler(_arg1:TimerEvent):void
        {
            this.hide();
        }

        public function show(_arg1:SystemMessage):void
        {
            this._timer.stop();
            this.x = stage.stageWidth;
            this.alpha = 1;
            this.visible = true;
            parent.setChildIndex(this, (parent.numChildren - 1));
            this._icon.texture = Assets.getTextureAtlas("Interface").getTexture((((_arg1.type)==SystemMessage.TYPE_CONFIRM) ? "alert_hakerl" : "alert_rufzeichen"));
            this._textField.text = _arg1.text;
            this._bg.height = ((this._textField.textBounds.height + (2 * PADDING_VERTICAL)) + 5);
            this.slideIntoView();
            this._timer.delay = _arg1.delay;
            this._timer.start();
            stage.addEventListener(Event.ENTER_FRAME, this.addListenerLater);
        }

        private function addListenerLater():void
        {
            stage.removeEventListener(Event.ENTER_FRAME, this.addListenerLater);
            stage.addEventListener(TouchEvent.TOUCH, this.onStageTouch);
        }

        private function onStageTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage);
            if (_local2.phase != TouchPhase.HOVER)
            {
                if (stage)
                {
                    stage.removeEventListener(TouchEvent.TOUCH, this.onStageTouch);
                };
                this.hideImmediate();
            };
        }

        private function slideIntoView():void
        {
            var _local1:Tween = new Tween(this, 0.3, Transitions.EASE_OUT);
            _local1.animate("x", ((stage.stageWidth - WIDTH) - MARGIN));
            Starling.juggler.add(_local1);
        }

        public function hide():void
        {
            if (stage)
            {
                stage.removeEventListener(TouchEvent.TOUCH, this.onStageTouch);
            };
            this._timer.stop();
            var _local1:Tween = new Tween(this, 0.3, Transitions.EASE_OUT);
            _local1.animate("alpha", 0);
            _local1.onComplete = this.hideComplete;
            Starling.juggler.add(_local1);
        }

        private function hideComplete():void
        {
            this.alpha = 1;
            this.visible = false;
        }

        public function hideImmediate():void
        {
            if (stage)
            {
                stage.removeEventListener(TouchEvent.TOUCH, this.onStageTouch);
            };
            this._timer.stop();
            this.hideComplete();
        }


    }
}//package at.polypex.badplaner.view.overlays

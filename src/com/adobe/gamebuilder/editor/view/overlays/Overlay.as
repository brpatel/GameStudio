package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.view.comps.InputField;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    
    import __AS3__.vec.Vector;
    
    import org.josht.starling.foxhole.controls.ScrollContainer;
    import org.josht.starling.foxhole.controls.Scroller;
    import org.josht.starling.foxhole.core.PopUpManager;
    import org.osflash.signals.Signal;
    
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.TextureSmoothing;

    public class Overlay extends DisplayObjectContainer 
    {

        protected var _onClose:Signal;
        protected var _errorSignal:Signal;
        protected var _mediateFormFields:Signal;
        protected var _config:OverlayConfig;
        protected var _bg:DisplayObject;
        protected var _inputFields:Vector.<InputField>;

        public function Overlay(_arg1:OverlayConfig)
        {
            this._config = _arg1;
            this._onClose = new Signal(Object);
            this._errorSignal = new Signal(SystemMessage);
            this._mediateFormFields = new Signal(Vector.<InputField>);
            this._inputFields = new Vector.<InputField>();
            addEventListener(Event.ADDED_TO_STAGE, this.overlayAddedToStagehandler);
            addEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
        }

        public static function scrollContainer(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):ScrollContainer
        {
            var _local5:ScrollContainer = new ScrollContainer();
            _local5.scrollerProperties = {hasElasticEdges:true};
            _local5.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            _local5.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
            _local5.width = _arg3;
            _local5.height = _arg4;
            _local5.x = _arg1;
            _local5.y = _arg2;
            return (_local5);
        }

        public static function iconBtnCancel():ImageButton
        {
            var _local1:ImageButton = new ImageButton("close_icon_black", 52, 52, true);
            _local1.x = 4;
            _local1.y = 5;
            return (_local1);
        }


        public function get errorSignal():Signal
        {
            return (this._errorSignal);
        }

        public function get mediateFormFields():Signal
        {
            return (this._mediateFormFields);
        }

        private function overlayAddedToStagehandler():void
        {
            if (this.config.closeOnTouchOutside)
            {
                this.addEventListener(TouchEvent.TOUCH, this.menuTouchListener);
                stage.addEventListener(TouchEvent.TOUCH, this.stageTouchListener);
            };
            this.init();
        }

        private function menuTouchListener(_arg1:TouchEvent):void
        {
            _arg1.stopImmediatePropagation();
        }

        private function stageTouchListener(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage, TouchPhase.BEGAN);
            if (_local2 != null)
            {
                this.hide();
            };
        }

        public function get config():OverlayConfig
        {
            return (this._config);
        }

        protected function removeHandler(_arg1:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
            this.dispose();
        }

        override public function dispose():void
        {
            if (!this.config.reuse)
            {
                this.removeEventListener(TouchEvent.TOUCH, this.menuTouchListener);
                if (this.stage != null)
                {
                    stage.removeEventListener(TouchEvent.TOUCH, this.stageTouchListener);
                };
                this._onClose.removeAll();
                super.dispose();
            };
        }

        protected function init():void
        {
            this.removeChildren();
            if (this.config.bgAlpha > 0)
            {
                this._bg = new Image(Assets.getTextureAtlas("Interface").getTexture("bg_window"));
                this._bg.width = this._config.width;
                this._bg.height = this._config.height;
                (this._bg as Image).smoothing = TextureSmoothing.NONE;
                this._bg.touchable = true;
                this._bg.alpha = this.config.bgAlpha;
                addChild(this._bg);
            };
        }

        public function show(_arg1:Boolean=false, _arg2:Boolean=true, _arg3:Boolean=true):void
        {
            if (_arg3)
            {
                PopUpManager.addPopUp(this, _arg2, _arg1);
            }
            else
            {
                (Starling.current.root as DisplayObjectContainer).addChild(this);
            };
        }

        public function prepareForExit():void
        {
            this.removeEventListener(TouchEvent.TOUCH, this.menuTouchListener);
            if (this.stage != null)
            {
                stage.removeEventListener(TouchEvent.TOUCH, this.stageTouchListener);
            };
            this.addEventListener(Event.ENTER_FRAME, this.exit);
        }

        protected function exit():void
        {
            this.removeEventListener(Event.ENTER_FRAME, this.exit);
            this._onClose.dispatch(null);
            if (this._config.hideOnRemove)
            {
                this.hide();
            };
        }

        public function hide():void
        {
            if (PopUpManager.isPopUp(this))
            {
                PopUpManager.removePopUp(this);
            }
            else
            {
                if (this.parent != null)
                {
                    this.parent.removeChild(this);
                };
            };
        }

        public function get onClose():Signal
        {
            return (this._onClose);
        }


    }
}//package at.polypex.badplaner.view.overlays

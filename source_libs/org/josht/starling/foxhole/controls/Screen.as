//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import starling.events.Event;
    import flash.system.Capabilities;
    import flash.display.LoaderInfo;
    import flash.display.DisplayObjectContainer;
    import starling.core.Starling;
    import org.josht.utils.display.calculateScaleRatioToFit;
    import starling.events.ResizeEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    public class Screen extends FoxholeControl 
    {

        private var _originalWidth:Number = NaN;
        private var _originalHeight:Number = NaN;
        private var _originalDPI:int = 0;
        private var _pixelScale:Number = 1;
        private var _dpiScale:Number = 1;
        protected var backButtonHandler:Function;
        protected var menuButtonHandler:Function;
        protected var searchButtonHandler:Function;

        public function Screen()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
            super();
            this.originalDPI = 168;
        }

        public function get originalWidth():Number
        {
            return (this._originalWidth);
        }

        public function set originalWidth(_arg1:Number):void
        {
            if (this._originalWidth == _arg1)
            {
                return;
            };
            this._originalWidth = _arg1;
            if (this.stage)
            {
                this.refreshPixelScale();
            };
        }

        public function get originalHeight():Number
        {
            return (this._originalHeight);
        }

        public function set originalHeight(_arg1:Number):void
        {
            if (this._originalHeight == _arg1)
            {
                return;
            };
            this._originalHeight = _arg1;
            if (this.stage)
            {
                this.refreshPixelScale();
            };
        }

        public function get originalDPI():int
        {
            return (this._originalDPI);
        }

        public function set originalDPI(_arg1:int):void
        {
            if (this._originalDPI == _arg1)
            {
                return;
            };
            this._originalDPI = _arg1;
            this._dpiScale = (Capabilities.screenDPI / this._originalDPI);
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }

        protected function get pixelScale():Number
        {
            return (this._pixelScale);
        }

        protected function get dpiScale():Number
        {
            return (this._dpiScale);
        }

        private function refreshPixelScale():void
        {
            var loaderInfo:LoaderInfo = DisplayObjectContainer(Starling.current.nativeStage.root).getChildAt(0).loaderInfo;
            if (isNaN(this._originalWidth))
            {
                try
                {
                    this._originalWidth = loaderInfo.width;
                }
                catch(error:Error)
                {
                    this._originalWidth = this.stage.stageWidth;
                };
            };
            if (isNaN(this._originalHeight))
            {
                try
                {
                    this._originalHeight = loaderInfo.height;
                }
                catch(error:Error)
                {
                    this._originalHeight = this.stage.stageHeight;
                };
            };
            this._pixelScale = calculateScaleRatioToFit(this.originalWidth, this.originalHeight, this.stage.stageWidth, this.stage.stageHeight);
        }

        private function addedToStageHandler(_arg1:Event):void
        {
            if (_arg1.target != this)
            {
                return;
            };
            this.refreshPixelScale();
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
            this.stage.addEventListener(ResizeEvent.RESIZE, this.stage_resizeHandler);
            Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler, false, 0, true);
        }

        private function removedFromStageHandler(_arg1:Event):void
        {
            if (_arg1.target != this)
            {
                return;
            };
            this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
            this.stage.removeEventListener(ResizeEvent.RESIZE, this.stage_resizeHandler);
            Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
        }

        private function stage_resizeHandler(_arg1:ResizeEvent):void
        {
            this.refreshPixelScale();
        }

        private function stage_keyDownHandler(_arg1:KeyboardEvent):void
        {
            if (((((!((this.backButtonHandler == null))) && (Object(Keyboard).hasOwnProperty("BACK")))) && ((_arg1.keyCode == Keyboard["BACK"]))))
            {
                _arg1.stopImmediatePropagation();
                _arg1.preventDefault();
                this.backButtonHandler();
            };
            if (((((!((this.menuButtonHandler == null))) && (Object(Keyboard).hasOwnProperty("MENU")))) && ((_arg1.keyCode == Keyboard["MENU"]))))
            {
                _arg1.preventDefault();
                this.menuButtonHandler();
            };
            if (((((!((this.searchButtonHandler == null))) && (Object(Keyboard).hasOwnProperty("SEARCH")))) && ((_arg1.keyCode == Keyboard["SEARCH"]))))
            {
                _arg1.preventDefault();
                this.searchButtonHandler();
            };
        }


    }
}//package org.josht.starling.foxhole.controls

//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.popups
{
    import starling.display.DisplayObject;
    import org.osflash.signals.Signal;
    import org.osflash.signals.ISignal;
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.errors.IllegalOperationError;
    import org.josht.starling.foxhole.core.PopUpManager;
    import starling.core.Starling;
    import starling.events.TouchEvent;
    import starling.events.ResizeEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import starling.events.Touch;
    import __AS3__.vec.Vector;
    import starling.events.TouchPhase;

    public class VerticalCenteredPopUpContentManager implements IPopUpContentManager 
    {

        public var marginTop:Number = 0;
        public var marginRight:Number = 0;
        public var marginBottom:Number = 0;
        public var marginLeft:Number = 0;
        protected var content:DisplayObject;
        protected var touchPointID:int = -1;
        private var _onClose:Signal;

        public function VerticalCenteredPopUpContentManager()
        {
            this._onClose = new Signal(VerticalCenteredPopUpContentManager);
            super();
        }

        public function get onClose():ISignal
        {
            return (this._onClose);
        }

        public function open(_arg1:DisplayObject, _arg2:DisplayObject):void
        {
            var _local3:FoxholeControl;
            if (this.content)
            {
                throw (new IllegalOperationError("Pop-up content is already defined."));
            };
            this.content = _arg1;
            PopUpManager.addPopUp(this.content, true, false);
            if ((this.content is FoxholeControl))
            {
                _local3 = FoxholeControl(this.content);
                FoxholeControl(this.content).onResize.add(this.content_resizeHandler);
            };
            this.layout();
            Starling.current.stage.addEventListener(TouchEvent.TOUCH, this.stage_touchHandler);
            Starling.current.stage.addEventListener(ResizeEvent.RESIZE, this.stage_resizeHandler);
            Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler, false, int.MAX_VALUE, true);
        }

        public function close():void
        {
            if (!this.content)
            {
                return;
            };
            Starling.current.stage.removeEventListener(TouchEvent.TOUCH, this.stage_touchHandler);
            Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, this.stage_resizeHandler);
            Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, this.stage_keyDownHandler);
            if ((this.content is FoxholeControl))
            {
                FoxholeControl(this.content).onResize.remove(this.content_resizeHandler);
            };
            PopUpManager.removePopUp(this.content);
            this.content = null;
            this._onClose.dispatch(this);
        }

        public function dispose():void
        {
            this.close();
            this._onClose.removeAll();
        }

        protected function layout():void
        {
            var _local3:FoxholeControl;
            var _local1:Number = ((Math.min(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight) - this.marginLeft) - this.marginRight);
            var _local2:Number = ((Starling.current.stage.stageHeight - this.marginTop) - this.marginBottom);
            if ((this.content is FoxholeControl))
            {
                _local3 = FoxholeControl(this.content);
                _local3.minWidth = (_local3.maxWidth = _local1);
                _local3.maxHeight = _local2;
                _local3.validate();
            };
            if (this.content.width > _local1)
            {
                this.content.width = _local1;
            };
            if (this.content.height > _local2)
            {
                this.content.height = _local2;
            };
            this.content.x = ((Starling.current.stage.stageWidth - this.content.width) / 2);
            this.content.y = ((Starling.current.stage.stageHeight - this.content.height) / 2);
        }

        protected function content_resizeHandler(_arg1:FoxholeControl):void
        {
            this.layout();
        }

        protected function stage_keyDownHandler(_arg1:KeyboardEvent):void
        {
            if (((!((_arg1.keyCode == Keyboard.BACK))) && (!((_arg1.keyCode == Keyboard.ESCAPE)))))
            {
                return;
            };
            _arg1.preventDefault();
            _arg1.stopImmediatePropagation();
            this.close();
        }

        protected function stage_resizeHandler(_arg1:ResizeEvent):void
        {
            this.layout();
        }

        protected function stage_touchHandler(_arg1:TouchEvent):void
        {
            var _local3:Touch;
            var _local4:Touch;
            if (_arg1.interactsWith(this.content))
            {
                return;
            };
            var _local2:Vector.<Touch> = _arg1.getTouches(Starling.current.stage);
            if (_local2.length == 0)
            {
                return;
            };
            if (this.touchPointID >= 0)
            {
                for each (_local4 in _local2)
                {
                    if (_local4.id == this.touchPointID)
                    {
                        _local3 = _local4;
                        break;
                    };
                };
                if (!_local3)
                {
                    return;
                };
                if (_local3.phase == TouchPhase.ENDED)
                {
                    this.touchPointID = -1;
                    this.close();
                    return;
                };
            }
            else
            {
                for each (_local3 in _local2)
                {
                    if (_local3.phase == TouchPhase.BEGAN)
                    {
                        this.touchPointID = _local3.id;
                        return;
                    };
                };
            };
        }


    }
}//package org.josht.starling.foxhole.controls.popups

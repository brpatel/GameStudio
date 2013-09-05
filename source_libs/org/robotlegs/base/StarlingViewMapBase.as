//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.base
{
    import starling.display.DisplayObjectContainer;
    import org.robotlegs.core.IInjector;
    import starling.events.Event;

    public class StarlingViewMapBase 
    {

        protected var _enabled:Boolean = true;
        protected var _contextView:DisplayObjectContainer;
        protected var injector:IInjector;
        protected var useCapture:Boolean;
        protected var viewListenerCount:uint;

        public function StarlingViewMapBase(_arg1:DisplayObjectContainer, _arg2:IInjector)
        {
            this.injector = _arg2;
            this.useCapture = true;
            this.contextView = _arg1;
        }

        public function get contextView():DisplayObjectContainer
        {
            return (this._contextView);
        }

        public function set contextView(_arg1:DisplayObjectContainer):void
        {
            if (_arg1 != this._contextView)
            {
                this.removeListeners();
                this._contextView = _arg1;
                if (this.viewListenerCount > 0)
                {
                    this.addListeners();
                };
            };
        }

        public function get enabled():Boolean
        {
            return (this._enabled);
        }

        public function set enabled(_arg1:Boolean):void
        {
            if (_arg1 != this._enabled)
            {
                this.removeListeners();
                this._enabled = _arg1;
                if (this.viewListenerCount > 0)
                {
                    this.addListeners();
                };
            };
        }

        protected function addListeners():void
        {
        }

        protected function removeListeners():void
        {
        }

        protected function onViewAdded(_arg1:Event):void
        {
        }


    }
}//package org.robotlegs.base

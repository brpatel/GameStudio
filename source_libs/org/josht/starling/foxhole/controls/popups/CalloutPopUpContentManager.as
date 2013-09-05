//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.popups
{
    import starling.display.DisplayObject;
    import org.josht.starling.foxhole.controls.Callout;
    import org.osflash.signals.Signal;
    import org.osflash.signals.ISignal;
    import flash.errors.IllegalOperationError;

    public class CalloutPopUpContentManager implements IPopUpContentManager 
    {

        protected var content:DisplayObject;
        protected var callout:Callout;
        private var _onClose:Signal;

        public function CalloutPopUpContentManager()
        {
            this._onClose = new Signal(CalloutPopUpContentManager);
            super();
        }

        public function get onClose():ISignal
        {
            return (this._onClose);
        }

        public function open(_arg1:DisplayObject, _arg2:DisplayObject):void
        {
            if (this.content)
            {
                throw (new IllegalOperationError("Pop-up content is already defined."));
            };
            this.content = _arg1;
            this.callout = Callout.show(_arg1, _arg2);
            this.callout.onClose.add(this.callout_onClose);
        }

        public function close():void
        {
            if (!this.callout)
            {
                return;
            };
            this.callout.close();
        }

        public function dispose():void
        {
            this.close();
            this._onClose.removeAll();
        }

        protected function cleanup():void
        {
            this.content = null;
            this.callout.content = null;
            this.callout.onClose.remove(this.callout_onClose);
            this.callout = null;
        }

        protected function callout_onClose(_arg1:Callout):void
        {
            this.cleanup();
            this._onClose.dispatch(this);
        }


    }
}//package org.josht.starling.foxhole.controls.popups

package com.adobe.gamebuilder.editor.core.manager
{
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    import com.adobe.gamebuilder.editor.view.overlays.DefaultAlertWindow;
    
    import flash.utils.getQualifiedClassName;

    public class AlertManager implements IAlertManager 
    {

        public static const YES:uint = 1;
        public static const NO:uint = 2;
        public static const OK:uint = 4;
        public static const CANCEL:uint = 8;

        private static var _instance:AlertManager = null;

        private var _isOpen:Boolean;
        private var _alertWindow:DefaultAlertWindow;
        private var _closeFunction:Function;
        private var _internalToken:Object;
        private var _yesLabel:String;
        private var _noLabel:String;
        private var _okLabel:String;
        private var _cancelLabel:String;

        public function AlertManager(_arg1:SingletonEnforcer)
        {
            if (getQualifiedClassName(this) != "at.polypex.badplaner.core.manager::AlertManager")
            {
                throw (new Error("This is a Singleton Class you dont must initialize it. Just use AlertManager.instance;"));
            };
        }

        public static function get instance():IAlertManager
        {
            if (_instance == null)
            {
                _instance = new AlertManager(new SingletonEnforcer());
            };
            return (_instance);
        }


        public function get isOpen():Boolean
        {
            return (this._isOpen);
        }

        public function show(_arg1:String, _arg2:String, _arg3:uint, _arg4:Function=null, _arg5:Object=null):void
        {
            this._closeFunction = _arg4;
            this._internalToken = _arg5;
            this._alertWindow = new DefaultAlertWindow(new OverlayConfig(500, 330, 0xFFFFFF, 0, false));
            this._alertWindow.btnRelease.add(this.closeHandler);
            if (this._yesLabel != null)
            {
                this._alertWindow.btnYesLabel = this._yesLabel;
            };
            if (this._noLabel != null)
            {
                this._alertWindow.btnNoLabel = this._noLabel;
            };
            if (this._okLabel != null)
            {
                this._alertWindow.btnOkLabel = this._okLabel;
            };
            if (this._cancelLabel != null)
            {
                this._alertWindow.btnCancelLabel = this._cancelLabel;
            };
            if ((((((((_arg3 & OK)) || ((_arg3 & CANCEL)))) || ((_arg3 & YES)))) || ((_arg3 & NO))))
            {
                this._alertWindow.buttonFlags = _arg3;
            };
            this._alertWindow.header = _arg2;
            this._alertWindow.message = _arg1;
            if (!this._isOpen)
            {
                this._alertWindow.show(true, true);
                this._isOpen = true;
            };
        }

        public function closeAlert():void
        {
            if (this._alertWindow != null)
            {
                this._alertWindow.prepareForExit();
                this._isOpen = false;
            };
        }

        private function closeHandler(_arg1:Object):void
        {
            this._alertWindow.prepareForExit();
            this._isOpen = false;
            if (this._closeFunction != null)
            {
                if (this._internalToken != null)
                {
                    this._closeFunction(_arg1, this._internalToken);
                    this._internalToken = null;
                }
                else
                {
                    this._closeFunction(_arg1);
                };
            };
            this._yesLabel = "";
            this._noLabel = "";
            this._okLabel = "";
            this._cancelLabel = "";
        }

        public function set yesLabel(_arg1:String):void
        {
            this._yesLabel = _arg1;
        }

        public function set noLabel(_arg1:String):void
        {
            this._noLabel = _arg1;
        }

        public function set okLabel(_arg1:String):void
        {
            this._okLabel = _arg1;
        }

        public function set cancelLabel(_arg1:String):void
        {
            this._cancelLabel = _arg1;
        }


    }
}//package at.polypex.badplaner.core.manager

class SingletonEnforcer 
{


}

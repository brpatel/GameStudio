package com.adobe.gamebuilder.editor.view.pages
{
    import com.adobe.gamebuilder.editor.view.comps.InputField;
    
    import __AS3__.vec.Vector;
    
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class Page extends DisplayObjectContainer 
    {

        protected var _cancelSignal:Signal;
        protected var _errorSignal:Signal;
        protected var _successSignal:Signal;
        protected var _completeSignal:Signal;
        protected var _inputFields:Vector.<InputField>;

        public function Page()
        {
            this._errorSignal = new Signal(String);
            this._successSignal = new Signal(Object);
            this._completeSignal = new Signal(Page);
            this._cancelSignal = new Signal();
            this._inputFields = new Vector.<InputField>();
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get cancelSignal():Signal
        {
            return (this._cancelSignal);
        }

        public function get completeSignal():Signal
        {
            return (this._completeSignal);
        }

        public function get inputFields():Vector.<InputField>
        {
            return (this._inputFields);
        }

        public function get successSignal():Signal
        {
            return (this._successSignal);
        }

        public function get errorSignal():Signal
        {
            return (this._errorSignal);
        }

        protected function init():void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function checkForm():void
        {
        }

        override public function dispose():void
        {
            this._errorSignal.removeAll();
            this._successSignal.removeAll();
            super.dispose();
        }


    }
}//package at.polypex.badplaner.view.pages

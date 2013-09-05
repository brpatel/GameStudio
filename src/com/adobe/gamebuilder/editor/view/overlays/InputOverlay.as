package com.adobe.gamebuilder.editor.view.overlays
{
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.SoftKeyboardEvent;
    import flash.text.StageText;
    
    import flashx.textLayout.formats.TextAlign;
    
    import org.josht.starling.foxhole.controls.TextInput;
    import org.osflash.signals.Signal;
    
    import starling.events.Event;
    
   

    public class InputOverlay extends TextInput 
    {

        private var _onKeyDown:Signal;
        private var _onFocusOut:Signal;
        private var _onFocusIn:Signal;
        private var _onSoftkeyboardDeactivate:Signal;
        private var _fieldWidth:int;
        private var _restrict:String;
        private var _maxChars:uint;

        public function InputOverlay()
        {
            this._onKeyDown = new Signal(TextInput, KeyboardEvent);
            this._onFocusOut = new Signal(TextInput);
            this._onFocusIn = new Signal(TextInput);
            this._onSoftkeyboardDeactivate = new Signal(TextInput);
            super();
            this.addEventListener(starling.events.Event.ADDED_TO_STAGE, this.init);
        }

        public function get maxChars():uint
        {
            return (this._maxChars);
        }

        public function set maxChars(_arg1:uint):void
        {
            this._maxChars = _arg1;
        }

        public function get onFocusIn():Signal
        {
            return (this._onFocusIn);
        }

        public function get restrict():String
        {
            return (this._restrict);
        }

        public function set restrict(_arg1:String):void
        {
            this._restrict = _arg1;
        }

        public function get onSoftkeyboardDeactivate():Signal
        {
            return (this._onSoftkeyboardDeactivate);
        }

        public function get onFocusOut():Signal
        {
            return (this._onFocusOut);
        }

        public function get onKeyDown():Signal
        {
            return (this._onKeyDown);
        }

        override public function set width(_arg1:Number):void
        {
            super.width = _arg1;
            this._fieldWidth = _arg1;
        }

        private function init():void
        {
            this.stageTextProperties.fontSize = 16;
            this.stageTextProperties.textAlign = TextAlign.LEFT;
            if (this._restrict != "")
            {
                this.stageTextProperties.restrict = this._restrict;
            };
            this.stageTextProperties.maxChars = this._maxChars;
            this.width = this._fieldWidth;
        }

        override protected function stageText_keyDownHandler(_arg1:KeyboardEvent):void
        {
            super.stageText_keyDownHandler(_arg1);
            this._onKeyDown.dispatch(this, _arg1);
        }

        override protected function stageText_focusOutHandler(_arg1:FocusEvent):void
        {
            super.stageText_focusOutHandler(_arg1);
            this._onFocusOut.dispatch(this);
        }

        override protected function stageText_focusInHandler(_arg1:FocusEvent):void
        {
            super.stageText_focusInHandler(_arg1);
            this._onFocusIn.dispatch(this);
        }

        public function get stageTextHasFocus():Boolean
        {
            return (_stageTextHasFocus);
        }

        public function setSelectionToEnd():void
        {
            if ((this.stageText is StageText))
            {
                (this.stageText as StageText).selectRange(this.text.length, this.text.length);
            };
        }

        override protected function addedToStageHandler(_arg1:starling.events.Event):void
        {
            super.addedToStageHandler(_arg1);
            if ((this.stageText is StageText))
            {
                (this.stageText as StageText).addEventListener(flash.events.Event.ACTIVATE, this.stageTextActivateHandler);
                (this.stageText as StageText).addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, this.softkeyboard_activateHandler);
                (this.stageText as StageText).addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, this.softkeyboard_activatingHandler);
                (this.stageText as StageText).addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, this.softkeyboard_deactivateHandler);
            };
        }

        override protected function removedFromStageHandler(_arg1:starling.events.Event):void
        {
            if ((this.stageText is StageText))
            {
                (this.stageText as StageText).removeEventListener(flash.events.Event.ACTIVATE, this.stageTextActivateHandler);
                (this.stageText as StageText).removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, this.softkeyboard_activateHandler);
                (this.stageText as StageText).removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, this.softkeyboard_activatingHandler);
                (this.stageText as StageText).removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, this.softkeyboard_deactivateHandler);
            };
            super.removedFromStageHandler(_arg1);
        }

        protected function stageTextActivateHandler(_arg1:flash.events.Event):void
        {
        }

        protected function softkeyboard_activateHandler(_arg1:SoftKeyboardEvent):void
        {
            (this.stageText as StageText).selectRange((this.text.length - 1), (this.text.length - 1));
            this._measureTextField.setSelection((this.text.length - 1), (this.text.length - 1));
        }

        protected function softkeyboard_activatingHandler(_arg1:SoftKeyboardEvent):void
        {
        }

        protected function softkeyboard_deactivateHandler(_arg1:SoftKeyboardEvent):void
        {
            this._onSoftkeyboardDeactivate.dispatch(this);
        }


    }
}//package at.polypex.badplaner.view.overlays

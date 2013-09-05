package com.adobe.gamebuilder.editor.core.manager
{
    import com.adobe.gamebuilder.editor.view.comps.InputField;
    import com.adobe.gamebuilder.editor.view.overlays.InputOverlay;
    
    import flash.events.KeyboardEvent;
    import flash.utils.getQualifiedClassName;
    
    import org.josht.starling.foxhole.controls.TextInput;
    
    import starling.events.Event;

    public class InputFieldManager 
    {

        private static var _instance:InputFieldManager = null;

        private var _inputField:InputField;
        private var _inputOverlay:InputOverlay;

        public function InputFieldManager(_arg1:SingletonEnforcer)
        {
            if (getQualifiedClassName(this) != "com.adobe.gamebuilder.editor.core.manager::InputFieldManager")
            {
                throw (new Error("This is a Singleton Class, you must not initialize it. Just use InputFieldManager.instance"));
            };
        }

        public static function get instance():InputFieldManager
        {
            if (_instance == null)
            {
                _instance = new InputFieldManager(new SingletonEnforcer());
            };
            return (_instance);
        }


        public function showInput(_arg1:InputField):void
        {
            this._inputField = _arg1;
            if (this._inputOverlay == null)
            {
                this._inputOverlay = new InputOverlay();
                this._inputOverlay.addEventListener(Event.ADDED_TO_STAGE, this.overlayAddedHandler);
                this._inputOverlay.onChange.add(this.inputChangeHandler);
                this._inputOverlay.onEnter.add(this.inputEnterHandler);
                this._inputOverlay.onFocusOut.add(this.inputFocusOutHandler);
                this._inputOverlay.onFocusIn.add(this.inputFocusInHandler);
                this._inputOverlay.onKeyDown.add(this.inputKeyDownHandler);
                this._inputOverlay.onSoftkeyboardDeactivate.add(this.inputSoftkeyboardDeactivateHandler);
            };
            this._inputOverlay.restrict = _arg1.restrict;
            this._inputOverlay.maxChars = _arg1.maxChars;
            this._inputOverlay.text = _arg1.text;
            if (_arg1.name)
            {
                this._inputOverlay.name = _arg1.name;
            };
            this._inputOverlay.width = _arg1.width;
            this._inputOverlay.height = _arg1.height;
            this._inputOverlay.x = _arg1.x;
            this._inputOverlay.y = (_arg1.y - 1);
            this._inputOverlay.setFocus();
            _arg1.parent.addChild(this._inputOverlay);
        }

        private function overlayAddedHandler():void
        {
            if (!this._inputOverlay.stageTextHasFocus)
            {
                this._inputOverlay.setFocus();
            };
        }

        private function inputFocusOutHandler(_arg1:TextInput):void
        {
            this._inputField.active = false;
            this.removeInput();
        }

        private function inputFocusInHandler(_arg1:TextInput):void
        {
            this._inputOverlay.setSelectionToEnd();
        }

        private function inputEnterHandler(_arg1:TextInput):void
        {
            this.removeInput();
        }

        private function inputSoftkeyboardDeactivateHandler(_arg1:TextInput):void
        {
            this._inputField.addEventListener(Event.ENTER_FRAME, this.removeMeasureInputLater);
        }

        private function inputKeyDownHandler(_arg1:TextInput, _arg2:KeyboardEvent):void
        {
            if (_arg2.keyCode == 9)
            {
            };
        }

        private function inputChangeHandler(_arg1:TextInput):void
        {
            this._inputField.text = _arg1.text;
        }

        private function removeMeasureInputLater(_arg1:Event):void
        {
            this._inputField.removeEventListener(Event.ENTER_FRAME, this.removeMeasureInputLater);
            this.removeInput();
        }

        private function removeInput():void
        {
            if (this._inputField.parent.contains(this._inputOverlay))
            {
                this._inputField.parent.removeChild(this._inputOverlay);
                this._inputOverlay = null;
                this._inputField = null;
            };
        }


    }
}//package at.polypex.badplaner.core.manager

class SingletonEnforcer 
{


}

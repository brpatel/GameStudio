package com.adobe.gamebuilder.editor.view
{
    import com.adobe.gamebuilder.editor.view.bars.ActionBar;
    import com.adobe.gamebuilder.editor.view.bars.SaveBar;
    import com.adobe.gamebuilder.editor.view.bars.TopBar;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObject;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class ActionBarContainer extends Sprite 
    {

        public static const TYPE_SAVE:String = "save";
        public static const TYPE_INFO:String = "info";
        public static const TYPE_HELP:String = "help";

        private var _saveBar:SaveBar;
        private var _reset:Signal;
        private var _currentBar:ActionBar;

        public function ActionBarContainer()
        {
            this._reset = new Signal();
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get reset():Signal
        {
            return (this._reset);
        }

        private function init(_arg1:Event):void
        {
            this._saveBar = new SaveBar();
            this._saveBar.y = -(ActionBar.BG_HEIGHT);
            this._saveBar.hideComplete.add(this.barHideCompleteHandler);
            addChild(this._saveBar);
        }

        public function show(_arg1:String):void
        {
            if (this._currentBar != null)
            {
                this._currentBar.hideImmediate();
                this._currentBar = null;
            };
            if (_arg1 == TYPE_SAVE)
            {
                this._currentBar = this._saveBar;
            };
            this._currentBar.show();
            this.addHideListener();
        }

        private function barHideCompleteHandler(_arg1:Boolean):void
        {
            if (_arg1)
            {
                this._reset.dispatch();
            };
        }

        public function hide(_arg1:Boolean=true):void
        {
            if (this._currentBar != null)
            {
                this.removeHideListener();
                this._currentBar.hide(_arg1);
            };
        }

        private function removeHideListener():void
        {
            this.removeEventListener(TouchEvent.TOUCH, this.barOnTouch);
            this.stage.removeEventListener(TouchEvent.TOUCH, this.stageOnTouch);
        }

        private function addHideListener():void
        {
            this.addEventListener(TouchEvent.TOUCH, this.barOnTouch);
            this.stage.addEventListener(TouchEvent.TOUCH, this.stageOnTouch);
        }

        private function barOnTouch(_arg1:TouchEvent):void
        {
            _arg1.stopImmediatePropagation();
        }

        private function stageOnTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage, TouchPhase.BEGAN);
            if (_local2 != null)
            {
                if (!(((((_arg1.target is Quad)) && (((_arg1.target as DisplayObject).parent is ImageButton)))) && ((((_arg1.target as DisplayObject).parent as ImageButton).parent is TopBar))))
                {
                    this.hide();
                };
            };
        }


    }
}//package at.polypex.badplaner.view

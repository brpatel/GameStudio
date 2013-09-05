package com.adobe.gamebuilder.editor.view.pages
{
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class HelpPage extends DisplayObjectContainer 
    {

        public static const WIDTH:int = 720;

        public var mainStep:int;
        public var totalPage:int;
        public var nextMainStep:int;
        public var nextSubStep:int;
        public var previousMainStep:int;
        public var previousSubStep:int;

        public function HelpPage()
        {
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        protected function init():void
        {
        }


    }
}//package at.polypex.badplaner.view.pages

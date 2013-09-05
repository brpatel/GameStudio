package com.adobe.gamebuilder.editor.view.comps
{
    import org.josht.starling.foxhole.controls.popups.CalloutPopUpContentManager;
    import flash.errors.IllegalOperationError;
    import org.josht.starling.foxhole.controls.Callout;
    import starling.display.DisplayObject;

    public class CustomCalloutPopUpContentManager extends CalloutPopUpContentManager 
    {


        override public function open(_arg1:DisplayObject, _arg2:DisplayObject):void
        {
            if (this.content)
            {
                throw (new IllegalOperationError("Pop-up content is already defined."));
            };
            this.content = _arg1;
            this.callout = Callout.show(_arg1, _arg2, Callout.DIRECTION_DOWN);
            this.callout.onClose.add(callout_onClose);
        }


    }
}//package at.polypex.badplaner.view.comps

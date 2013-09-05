package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Settings;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.view.bars.ModeBar;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class ModeBarMediator extends StarlingMediator 
    {

        [Inject]
        public var view:ModeBar;


        override public function onRegister():void
        {
            this.view.btnRelease.add(this.btnReleaseHandler);
        }

        private function btnReleaseHandler(_arg1:String):void
        {
            if (_arg1 == "angleSnap")
            {
                Settings.angleSnap = !(Settings.angleSnap);
            }
            else
            {
                if (_arg1 == "gridSnap")
                {
                    Settings.gridSnap = !(Settings.gridSnap);
                }
                else
                {
                    if (_arg1 == "presentationMode")
                    {
                        Common.presentationMode = (((Common.presentationMode)=="on") ? "off" : "on");
                        dispatch(new ContextEvent(ContextEvent.SWITCH_PRESENTATION_MODE));
                    };
                };
            };
        }

        override public function onRemove():void
        {
            this.view.btnRelease.remove(this.btnReleaseHandler);
        }


    }
}//package at.polypex.badplaner.view.mediator

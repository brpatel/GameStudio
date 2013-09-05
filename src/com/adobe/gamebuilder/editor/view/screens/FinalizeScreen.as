package com.adobe.gamebuilder.editor.view.screens
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlueButton;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.foxhole.controls.Screen;
    import org.osflash.signals.Signal;
    
    import starling.text.TextField;

    public class FinalizeScreen extends Screen 
    {

        private var _btnRelease:Signal;
        private var _btnEmail:Button;
        private var _btnAngebot:Button;

        public function FinalizeScreen()
        {
            this._btnRelease = new Signal(String);
        }

        public function get btnRelease():Signal
        {
            return (this._btnRelease);
        }

        override protected function initialize():void
        {
            super.initialize();
            var _local1:TextField = Common.labelField(200, 620, Common.getResourceString("help4_1_2_text"), 16);
            _local1.x = 30;
            _local1.y = 50;
            addChild(_local1);
            this._btnEmail = new BlueButton();
            this._btnEmail.label = Common.getResourceString("btnSendViaEmail");
            this._btnEmail.width = 200;
            this._btnEmail.x = 30;
            this._btnEmail.y = 260;
            this._btnEmail.onRelease.add(this.btnEmailOnRelease);
            addChild(this._btnEmail);
            this._btnAngebot = new BlueButton();
            this._btnAngebot.label = Common.getResourceString("btnAngebot");
            this._btnAngebot.width = 200;
            this._btnAngebot.x = 30;
            this._btnAngebot.y = 320;
            this._btnAngebot.onRelease.add(this.btnAngebotOnRelease);
            addChild(this._btnAngebot);
        }

        private function btnEmailOnRelease(_arg1:Button):void
        {
            this._btnRelease.dispatch("email");
        }

        private function btnAngebotOnRelease(_arg1:Button):void
        {
            this._btnRelease.dispatch("angebot");
        }


    }
}//package at.polypex.badplaner.view.screens

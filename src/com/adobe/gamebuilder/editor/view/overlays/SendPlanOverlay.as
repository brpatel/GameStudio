package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.data.MailFormVO;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.view.comps.InputField;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlackButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlueButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    
    import mx.events.ValidationResultEvent;
    import mx.validators.EmailValidator;
    import mx.validators.StringValidator;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.foxhole.controls.ScrollContainer;
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.text.TextField;
    import starling.utils.VAlign;

    public class SendPlanOverlay extends Overlay 
    {

        private var _btnSend:Button;
        private var _btnCancel:Button;
        private var _sendSignal:Signal;
        private var _inFromEmail:InputField;
        private var _inFromName:InputField;
        private var _inToName:InputField;
        private var _inToEmail:InputField;
        private var _inMessage:InputField;
        private var _sendFlag:Boolean = false;
        private var _iconBtnCancel:ImageButton;

        public function SendPlanOverlay(_arg1:OverlayConfig)
        {
            super(_arg1);
            this._sendSignal = new Signal(MailFormVO);
        }

        public function get sendSignal():Signal
        {
            return (this._sendSignal);
        }

        override protected function init():void
        {
            super.init();
            var _local1:TextField = Common.labelField(stage.stageWidth, 30, Common.getResourceString("sendPlan_header"), 18, "center", "top", false, Constants.BOLD_FONT);
            _local1.x = 0;
            _local1.y = 30;
            addChild(_local1);
            var _local2:TextField = Common.labelField(720, 120, Common.getResourceString("sendPlan_info"), 16, "left", "top", true);
            _local2.x = int(((stage.stageWidth - 720) >> 1));
            _local2.y = 100;
            addChild(_local2);
            var _local3:Image = Common.separator(_local2.x, 75, 720);
            addChild(_local3);
            var _local4:ScrollContainer = Overlay.scrollContainer(_local2.x, 155, 740, 395);
            addChild(_local4);
            _local1 = Common.labelField(140, 30, (Common.getResourceString("sendPlan_fromName") + ":"));
            _local1.x = 45;
            _local1.y = 17;
            _local4.addChild(_local1);
            this._inFromName = new InputField(460);
            this._inFromName.text = "";
            this._inFromName.x = 195;
            this._inFromName.y = 10;
            _local4.addChild(this._inFromName);
            _local1 = Common.labelField(140, 30, (Common.getResourceString("sendPlan_fromEmail") + ":"));
            _local1.x = 45;
            _local1.y = 60;
            _local4.addChild(_local1);
            this._inFromEmail = new InputField(460);
            this._inFromEmail.text = "";
            this._inFromEmail.x = 195;
            this._inFromEmail.y = 60;
            _local4.addChild(this._inFromEmail);
            _local1 = Common.labelField(140, 30, (Common.getResourceString("sendPlan_toName") + ":"));
            _local1.x = 45;
            _local1.y = 110;
            _local4.addChild(_local1);
            this._inToName = new InputField(460);
            this._inToName.text = "";
            this._inToName.x = 195;
            this._inToName.y = 110;
            _local4.addChild(this._inToName);
            _local1 = Common.labelField(140, 30, (Common.getResourceString("sendPlan_toEmail") + ":"));
            _local1.x = 45;
            _local1.y = 160;
            _local4.addChild(_local1);
            this._inToEmail = new InputField(460);
            this._inToEmail.text = "";
            this._inToEmail.x = 195;
            this._inToEmail.y = 160;
            _local4.addChild(this._inToEmail);
            _local1 = Common.labelField(140, 30, (Common.getResourceString("sendPlan_message") + ":"));
            _local1.x = 45;
            _local1.y = 210;
            _local4.addChild(_local1);
            this._inMessage = new InputField(460, "", "", 500, 160);
            this._inMessage.x = 195;
            this._inMessage.y = 210;
            this._inMessage.vAlign = VAlign.TOP;
            _local4.addChild(this._inMessage);
            this._btnSend = new BlueButton();
            this._btnSend.label = Common.getResourceString("btnSendLabel");
            this._btnSend.width = Constants.DEFAULT_BUTTON_WIDTH;
            this._btnSend.x = (((_local2.x + 720) - 55) - 180);
            this._btnSend.y = ((_local4.y + _local4.height) + 15);
            this._btnSend.onRelease.add(this.btnSendReleaseHandler);
            this.addChild(this._btnSend);
            this._btnCancel = new BlackButton();
            this._btnCancel.label = Common.getResourceString("btnCancelLabel");
            this._btnCancel.width = Constants.DEFAULT_BUTTON_WIDTH;
            this._btnCancel.x = (((_local2.x + 720) - 55) - 360);
            this._btnCancel.y = ((_local4.y + _local4.height) + 15);
            this._btnCancel.onRelease.add(this.btnCancelReleaseHandler);
            this.addChild(this._btnCancel);
            if ((this._btnSend.y + this._btnSend.height) > _config.height)
            {
                this._btnSend.y = ((_config.height - this._btnSend.height) - 10);
                this._btnCancel.y = this._btnSend.y;
                _local4.height = ((this._btnCancel.y - _local4.y) - 10);
            };
            this._sendFlag = false;
            this._iconBtnCancel = Overlay.iconBtnCancel();
            this._iconBtnCancel.onRelease.add(this.iconBtnCancelReleaseHandler);
            this.addChild(this._iconBtnCancel);
        }

        private function iconBtnCancelReleaseHandler(_arg1:ImageButton):void
        {
            prepareForExit();
        }

        private function btnSendReleaseHandler(_arg1:Button):void
        {
            this.checkForm();
        }

        private function checkForm():void
        {
            var _local5:String;
            var _local6:int;
            var _local1:Array = [];
            var _local2:EmailValidator = new EmailValidator();
            _local2.required = true;
            var _local3:ValidationResultEvent = _local2.validate(this._inFromEmail.text);
            if (((_local3.results) && ((_local3.results.length > 0))))
            {
                _local1.push(Common.getResourceString("error_fromEmail_invalid"));
                this._inFromEmail.alert = true;
            };
            _local3 = _local2.validate(this._inToEmail.text);
            if (((_local3.results) && ((_local3.results.length > 0))))
            {
                _local1.push(Common.getResourceString("error_toEmail_invalid"));
                this._inToEmail.alert = true;
            };
            var _local4:StringValidator = new StringValidator();
            _local4.required = true;
            _local3 = _local4.validate(this._inFromName.text);
            if (((_local3.results) && ((_local3.results.length > 0))))
            {
                _local1.push(Common.getResourceString("error_fromName_required"));
                this._inFromName.alert = true;
            };
            _local3 = _local4.validate(this._inToName.text);
            if (((_local3.results) && ((_local3.results.length > 0))))
            {
                _local1.push(Common.getResourceString("error_toName_required"));
                this._inToName.alert = true;
            };
            if (_local1.length == 0)
            {
                this.sendPlan();
            }
            else
            {
                _local5 = "";
                _local6 = 0;
                while (_local6 < _local1.length)
                {
                    _local5 = (_local5 + (_local1[_local6] + "\n"));
                    _local6++;
                };
                _errorSignal.dispatch(new SystemMessage(_local5, SystemMessage.TYPE_ALERT, SystemMessage.LONG_DELAY));
            };
        }

        private function sendPlan():void
        {
            this._sendFlag = true;
            prepareForExit();
        }

        override protected function exit():void
        {
            var _local1:MailFormVO;
            if (this._sendFlag)
            {
                _local1 = new MailFormVO();
                _local1.name_from = this._inFromName.text;
                _local1.mail_from = this._inFromEmail.text;
                _local1.name_to = this._inToName.text;
                _local1.mail_to = this._inToEmail.text;
                _local1.message = this._inMessage.text;
                this._sendSignal.dispatch(_local1);
            };
            super.exit();
        }

        private function btnCancelReleaseHandler(_arg1:Button):void
        {
            prepareForExit();
        }


    }
}//package at.polypex.badplaner.view.overlays

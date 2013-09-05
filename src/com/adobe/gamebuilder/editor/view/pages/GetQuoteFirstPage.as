package com.adobe.gamebuilder.editor.view.pages
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.data.ContactFormVO;
    import com.adobe.gamebuilder.editor.view.comps.InputField;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlackButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlueButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.overlays.GetQuoteOverlay;
    
    import mx.events.ValidationResultEvent;
    import mx.validators.EmailValidator;
    import mx.validators.StringValidator;
    
    import __AS3__.vec.Vector;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.foxhole.controls.ScrollContainer;
    
    import starling.display.Image;
    import starling.text.TextField;
    import starling.utils.VAlign;

    public class GetQuoteFirstPage extends Page 
    {

        private var _inFirstName:InputField;
        private var _inLastName:InputField;
        private var _inEmail:InputField;
        private var _inStart:InputField;
        private var _inStreet:InputField;
        private var _requiredFields:Vector.<InputField>;
        private var _inZip:InputField;
        private var _inCity:InputField;
        private var _inPhone:InputField;
        private var _inNote:InputField;
        private var _btnResume:Button;
        private var _btnCancel:BlackButton;
        private var _iconBtnNext:ImageButton;


        override protected function init():void
        {
            var _local1:TextField;
            super.init();
            this._requiredFields = new Vector.<InputField>();
            _local1 = Common.labelField(stage.stageWidth, 30, Common.getResourceString("getQuote_header", "iLabels", ["1"]), 18, "center", "top", false, Constants.BOLD_FONT);
            _local1.x = 0;
            _local1.y = 30;
            addChild(_local1);
            var _local2:TextField = Common.labelField(720, 120, Common.getResourceString("getQuote_intro"), 16, "left", "top", true);
            _local2.x = int(((stage.stageWidth - 720) >> 1));
            _local2.y = 100;
            addChild(_local2);
            var _local3:Image = Common.separator(_local2.x, 75, 720);
            addChild(_local3);
            var _local4:ScrollContainer = new ScrollContainer();
            _local4.scrollerProperties = {hasElasticEdges:true};
            _local4.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            _local4.x = _local2.x;
            _local4.y = 210;
            _local4.width = 740;
            _local4.height = (((parent as GetQuoteOverlay).config.height - _local4.y) - 95);
            addChild(_local4);
            _local1 = Common.labelField(90, 30, Common.getResourceString("form_firstname"));
            _local1.x = 0;
            _local1.y = 5;
            _local4.addChild(_local1);
            this._inFirstName = new InputField(195, "form_firstname");
            if (Constants.DEV_TEST)
            {
                this._inFirstName.text = "Tester";
            };
            this._inFirstName.x = 90;
            this._inFirstName.y = 0;
            _local4.addChild(this._inFirstName);
            _inputFields.push(this._inFirstName);
            this._requiredFields.push(this._inFirstName);
            _local1 = Common.labelField(90, 30, Common.getResourceString("form_lastname"));
            _local1.x = 305;
            _local1.y = 5;
            _local4.addChild(_local1);
            this._inLastName = new InputField(325, "form_lastname");
            if (Constants.DEV_TEST)
            {
                this._inLastName.text = "Testmann";
            };
            this._inLastName.x = 395;
            this._inLastName.y = 0;
            _local4.addChild(this._inLastName);
            _inputFields.push(this._inLastName);
            this._requiredFields.push(this._inLastName);
            _local1 = Common.labelField(90, 30, Common.getResourceString("form_street"));
            _local1.x = 0;
            _local1.y = 60;
            _local4.addChild(_local1);
            this._inStreet = new InputField(630, "form_street");
            if (Constants.DEV_TEST)
            {
                this._inStreet.text = "Teststrasse";
            };
            this._inStreet.x = 90;
            this._inStreet.y = 55;
            _local4.addChild(this._inStreet);
            this._requiredFields.push(this._inStreet);
            _local1 = Common.labelField(90, 30, Common.getResourceString("form_zip"));
            _local1.x = 0;
            _local1.y = 115;
            _local4.addChild(_local1);
            this._inZip = new InputField(110, "form_zip", "", 6);
            if (Constants.DEV_TEST)
            {
                this._inZip.text = "7090";
            };
            this._inZip.x = 90;
            this._inZip.y = 110;
            _local4.addChild(this._inZip);
            this._requiredFields.push(this._inZip);
            _local1 = Common.labelField(70, 30, Common.getResourceString("form_city"));
            _local1.x = 220;
            _local1.y = 115;
            _local4.addChild(_local1);
            this._inCity = new InputField(430, "form_city");
            if (Constants.DEV_TEST)
            {
                this._inCity.text = "Testort";
            };
            this._inCity.x = 290;
            this._inCity.y = 110;
            _local4.addChild(this._inCity);
            _local1 = Common.labelField(90, 30, Common.getResourceString("form_phone"));
            _local1.x = 0;
            _local1.y = 170;
            _local4.addChild(_local1);
            this._inPhone = new InputField(307, "form_phone");
            if (Constants.DEV_TEST)
            {
                this._inPhone.text = "01-98638273";
            };
            this._inPhone.x = 90;
            this._inPhone.y = 165;
            _local4.addChild(this._inPhone);
            _local1 = Common.labelField(90, 30, Common.getResourceString("form_email"));
            _local1.x = 0;
            _local1.y = 225;
            _local4.addChild(_local1);
            this._inEmail = new InputField(410, "form_email");
            if (Constants.DEV_TEST)
            {
                this._inEmail.text = "til.s@arcor.de";
            };
            this._inEmail.x = 90;
            this._inEmail.y = 220;
            _local4.addChild(this._inEmail);
            this._requiredFields.push(this._inEmail);
            _local1 = Common.labelField(90, 30, Common.getResourceString("getQuote_start"));
            _local1.x = 520;
            _local1.y = 225;
            _local4.addChild(_local1);
            this._inStart = new InputField(110);
            this._inStart.x = 610;
            this._inStart.y = 220;
            _local4.addChild(this._inStart);
            _local1 = Common.labelField(90, 30, Common.getResourceString("getQuote_note"));
            _local1.x = 0;
            _local1.y = 280;
            _local4.addChild(_local1);
            this._inNote = new InputField(630, "", "", 500, 110);
            this._inNote.vAlign = VAlign.TOP;
            this._inNote.x = 90;
            this._inNote.y = 275;
            _local4.addChild(this._inNote);
            this._btnResume = new BlueButton();
            this._btnResume.label = Common.getResourceString("btnResumeLabel");
            this._btnResume.width = Constants.DEFAULT_BUTTON_WIDTH;
            this._btnResume.x = ((_local2.x + 720) - 180);
            this._btnResume.y = ((parent as GetQuoteOverlay).config.height - 65);
            this._btnResume.onRelease.add(this.btnResumeReleaseHandler);
            this.addChild(this._btnResume);
            this._btnCancel = new BlackButton();
            this._btnCancel.label = Common.getResourceString("btnCancelLabel");
            this._btnCancel.width = Constants.DEFAULT_BUTTON_WIDTH;
            this._btnCancel.x = ((_local2.x + 720) - 360);
            this._btnCancel.y = ((parent as GetQuoteOverlay).config.height - 65);
            this._btnCancel.onRelease.add(this.btnCancelReleaseHandler);
            this.addChild(this._btnCancel);
            this._iconBtnNext = new ImageButton("overlay_next_icon", 0, 0, false);
            this._iconBtnNext.x = ((stage.stageWidth - 21) - this._iconBtnNext.width);
            this._iconBtnNext.y = int((((parent as GetQuoteOverlay).config.height - this._iconBtnNext.height) >> 1));
            this._iconBtnNext.onRelease.add(this.btnNextReleaseHandler);
            this.addChild(this._iconBtnNext);
            _completeSignal.dispatch(this);
        }

        private function btnNextReleaseHandler(_arg1:ImageButton):void
        {
            this.checkForm();
        }

        private function btnCancelReleaseHandler(_arg1:Button):void
        {
            _cancelSignal.dispatch();
        }

        private function btnResumeReleaseHandler(_arg1:Button):void
        {
            this.checkForm();
        }

        override public function checkForm():void
        {
            var _local5:int;
            var _local6:String;
            var _local1:Array = [];
            var _local2:EmailValidator = new EmailValidator();
            _local2.required = true;
            var _local3:ValidationResultEvent = _local2.validate(this._inEmail.text);
            if (((_local3.results) && ((_local3.results.length > 0))))
            {
                _local1.push(Common.getResourceString("error_invalidEmail"));
                this._inEmail.alert = true;
            };
            var _local4:StringValidator = new StringValidator();
            _local4.required = true;
            _local5 = 0;
            while (_local5 < this._requiredFields.length)
            {
                _local3 = _local4.validate(this._requiredFields[_local5].text);
                if (((_local3.results) && ((_local3.results.length > 0))))
                {
                    _local1.push(Common.getResourceString("error_requiredField", "iLabels", [Common.getResourceString(this._requiredFields[_local5].labelKey)]));
                    this._requiredFields[_local5].alert = true;
                };
                _local5++;
            };
            if (_local1.length == 0)
            {
                this.sendForm();
            }
            else
            {
                _local6 = "";
                _local5 = 0;
                while (_local5 < _local1.length)
                {
                    _local6 = (_local6 + (_local1[_local5] + "\n"));
                    _local5++;
                };
                _errorSignal.dispatch(_local6);
            };
        }

        private function sendForm():void
        {
            var _local1:ContactFormVO = new ContactFormVO();
            _local1.firstname = this._inFirstName.text;
            _local1.lastname = this._inLastName.text;
            _local1.street = this._inStreet.text;
            _local1.zip = this._inZip.text;
            _local1.city = this._inCity.text;
            _local1.phone = this._inPhone.text;
            _local1.email = this._inEmail.text;
            _local1.start = this._inStart.text;
            _successSignal.dispatch({contactForm:_local1});
        }


    }
}//package at.polypex.badplaner.view.pages

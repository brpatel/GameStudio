package com.adobe.gamebuilder.editor.view.pages
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.Locale;
    import com.adobe.gamebuilder.editor.core.data.PartnerVO;
    import com.adobe.gamebuilder.editor.service.PartnerService;
    import com.adobe.gamebuilder.editor.view.comps.CustomCalloutPopUpContentManager;
    import com.adobe.gamebuilder.editor.view.comps.InputField;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlackButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlueButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.overlays.GetQuoteOverlay;
    
    import flash.globalization.NumberFormatter;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.CallResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.foxhole.controls.Check;
    import org.josht.starling.foxhole.controls.List;
    import org.josht.starling.foxhole.controls.PickerList;
    import org.josht.starling.foxhole.controls.ScrollContainer;
    import org.josht.starling.foxhole.controls.Scroller;
    import org.josht.starling.foxhole.data.ListCollection;
    
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;

    public class GetQuoteSecondPage extends Page 
    {

        private var _cbConfirm:Check;
        private var _partnerList:PickerList;
        private var _inZip:InputField;
        private var _inCountry:PickerList;
        private var _inRadius:PickerList;
        private var _partnerService:PartnerService;
        private var _responder:CallResponder;
        private var _btnSend:Button;
        private var _btnCancel:Button;
        private var _searchItem1:PartnerVO;
        private var _searchItem2:PartnerVO;
        private var _inHaendler:InputField;
        private var _inZip2:InputField;
        private var _inCity2:InputField;
        private var _iconBtnPrevious:ImageButton;
        private var _nF:NumberFormatter;
        private var partnersLoaded:Boolean = false;


        override protected function init():void
        {
            var _local1:TextField;
            super.init();
            this._nF = new NumberFormatter(Locale.currentLang);
            this._nF.decimalSeparator = Common.getResourceString("decimalSeparator");
            this._nF.fractionalDigits = 2;
            this._searchItem1 = new PartnerVO();
            this._searchItem1.name = (Common.getResourceString("getQuote_reseller_load") + "...");
            this._searchItem1.distance = -1;
            this._searchItem1.id = -1;
            this._searchItem2 = new PartnerVO();
            this._searchItem2.name = (Common.getResourceString("getQuote_reseller_load") + "...");
            this._searchItem2.distance = -1;
            this._searchItem2.id = -1;
            _local1 = Common.labelField(stage.stageWidth, 30, Common.getResourceString("getQuote_header", "iLabels", ["2"]), 18, "center", "top", false, Constants.BOLD_FONT);
            _local1.x = 0;
            _local1.y = 30;
            addChild(_local1);
            var _local2:TextField = Common.labelField(720, 120, Common.getResourceString("getQuote_radiusSearch"), 16, "left", "top", true);
            _local2.x = int(((stage.stageWidth - 720) >> 1));
            _local2.y = 100;
            addChild(_local2);
            var _local3:Image = Common.separator(_local2.x, 75, 720);
            addChild(_local3);
            var _local4:ScrollContainer = new ScrollContainer();
            _local4.scrollerProperties = {hasElasticEdges:true};
            _local4.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            _local4.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
            _local4.width = 740;
            _local4.height = (stage.stageHeight - 450);
            _local4.x = _local2.x;
            _local4.y = 177;
            addChild(_local4);
            _local1 = Common.labelField(75, 30, (Common.getResourceString("form_country") + ":"));
            _local1.x = 0;
            _local1.y = 7;
            _local4.addChild(_local1);
            var _local5:Array = [];
            _local5.push({
                label:Common.getResourceString("country_at"),
                code:"AT"
            });
            _local5.push({
                label:Common.getResourceString("country_de"),
                code:"DE"
            });
            this._inCountry = new PickerList();
            this._inCountry.dataProvider = new ListCollection(_local5);
            this._inCountry.selectedIndex = 0;
            this._inCountry.labelField = "label";
            this._inCountry.listProperties.@itemRendererProperties.labelField = "label";
            this._inCountry.listProperties.@scrollerProperties.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            this._inCountry.listProperties.@scrollerProperties.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            this._inCountry.width = 235;
            this._inCountry.x = 75;
            this._inCountry.y = 0;
            _local4.addChild(this._inCountry);
            _local1 = Common.labelField(50, 30, (Common.getResourceString("form_zip") + ":"));
            _local1.x = 325;
            _local1.y = 7;
            _local4.addChild(_local1);
            this._inZip = new InputField(115, "", "", 6);
            this._inZip.x = 395;
            this._inZip.y = 0;
            _local4.addChild(this._inZip);
            _local1 = Common.labelField(80, 30, (Common.getResourceString("getQuote_radius") + ":"));
            _local1.x = 530;
            _local1.y = 7;
            _local4.addChild(_local1);
            var _local6:Array = [];
            _local6.push({
                label:"10 km",
                value:10
            });
            _local6.push({
                label:"25 km",
                value:25
            });
            _local6.push({
                label:"50 km",
                value:50
            });
            this._inRadius = new PickerList();
            this._inRadius.dataProvider = new ListCollection(_local6);
            this._inRadius.selectedIndex = 0;
            this._inRadius.labelField = "label";
            this._inRadius.listProperties.@itemRendererProperties.labelField = "label";
            this._inRadius.listProperties.@scrollerProperties.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            this._inRadius.listProperties.@scrollerProperties.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            this._inRadius.width = 110;
            this._inRadius.x = 610;
            this._inRadius.y = 0;
            _local4.addChild(this._inRadius);
            _local1 = Common.labelField(110, 30, (Common.getResourceString("getQuote_reseller_list") + ":"));
            _local1.x = 0;
            _local1.y = 117;
            _local4.addChild(_local1);
            this._partnerList = new PickerList();
            var _local7:PartnerVO = new PartnerVO();
            _local7.name = "Partner-Händler";
            _local7.distance = 0;
            this._partnerList.typicalItem = _local7;
            this._partnerList.x = 110;
            this._partnerList.y = 110;
            this._partnerList.width = 610;
            this._partnerList.labelField = "labelDisplay";
            this._partnerList.listProperties.@itemRendererProperties.labelField = "labelDisplay";
            this._partnerList.listProperties.@itemRendererProperties.labelFunction = this.partnerDisplay;
            this._partnerList.listProperties.@itemRendererProperties.minWidth = 610;
            this._partnerList.listProperties.@itemRendererProperties.width = 720;
            this._partnerList.listProperties.@scrollerProperties.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            this._partnerList.addEventListener(Event.ADDED_TO_STAGE, this.partnerListAdded);
            _local4.addChild(this._partnerList);
            var _local8:BlueButton = new BlueButton();
            _local8.label = Common.getResourceString("btnSearchLabel");
            _local8.width = 720;
            _local8.x = 0;
            _local8.y = 53;
            _local8.onRelease.add(this.btnSearchOnRelease);
            _local4.addChild(_local8);
            _local3 = Common.separator(0, 170, 720);
            _local4.addChild(_local3);
            _local1 = Common.labelField(500, 30, Common.getResourceString("getQuote_customReseller_header"), 18);
            _local1.x = 0;
            _local1.y = 190;
            _local4.addChild(_local1);
            _local1 = Common.labelField(500, 30, Common.getResourceString("getQuote_customReseller_message"));
            _local1.x = 0;
            _local1.y = 215;
            _local4.addChild(_local1);
            _local1 = Common.labelField(90, 30, (Common.getResourceString("getQuote_reseller") + ":"), 15);
            _local1.x = 0;
            _local1.y = 267;
            _local4.addChild(_local1);
            this._inHaendler = new InputField(630);
            this._inHaendler.x = 90;
            this._inHaendler.y = 260;
            _local4.addChild(this._inHaendler);
            _local1 = Common.labelField(90, 30, Common.getResourceString("form_zip"), 15);
            _local1.x = 0;
            _local1.y = 322;
            _local4.addChild(_local1);
            this._inZip2 = new InputField(110, "", "", 6);
            this._inZip2.text = "";
            this._inZip2.x = 90;
            this._inZip2.y = 315;
            _local4.addChild(this._inZip2);
            _local1 = Common.labelField(70, 30, Common.getResourceString("form_city"), 15);
            _local1.x = 220;
            _local1.y = 322;
            _local4.addChild(_local1);
            this._inCity2 = new InputField(430, "", "", 128);
            this._inCity2.text = "";
            this._inCity2.x = 290;
            this._inCity2.y = 315;
            _local4.addChild(this._inCity2);
            _local3 = Common.separator(_local2.x, ((parent as GetQuoteOverlay).config.height - 160), 720);
            addChild(_local3);
            _local4.height = (((stage.stageHeight - Constants.TOPBAR_HEIGHT) - ((stage.stageHeight - Constants.TOPBAR_HEIGHT) - _local3.y)) - _local4.y);
            this._cbConfirm = new Check();
            this._cbConfirm.x = _local2.x;
            this._cbConfirm.y = ((parent as GetQuoteOverlay).config.height - 140);
            addChild(this._cbConfirm);
            _local1 = Common.labelField(670, 70, Common.getResourceString("getQuote_confirm_info"));
            _local1.x = (_local2.x + 48);
            _local1.y = ((parent as GetQuoteOverlay).config.height - 140);
            _local1.addEventListener(TouchEvent.TOUCH, this.confirmTouchHandler);
            addChild(_local1);
            this._btnSend = new BlueButton();
            this._btnSend.label = Common.getResourceString("btnSendLabel");
            this._btnSend.width = Constants.DEFAULT_BUTTON_WIDTH;
            this._btnSend.x = ((_local2.x + 720) - 180);
            this._btnSend.y = ((parent as GetQuoteOverlay).config.height - 65);
            this._btnSend.onRelease.add(this.btnSendReleaseHandler);
            this.addChild(this._btnSend);
            this._btnCancel = new BlackButton();
            this._btnCancel.label = Common.getResourceString("btnCancelLabel");
            this._btnCancel.width = Constants.DEFAULT_BUTTON_WIDTH;
            this._btnCancel.x = ((_local2.x + 720) - 360);
            this._btnCancel.y = ((parent as GetQuoteOverlay).config.height - 65);
            this._btnCancel.onRelease.add(this.btnCancelReleaseHandler);
            this.addChild(this._btnCancel);
            this._iconBtnPrevious = new ImageButton("overlay_previous_icon", 0, 0, false);
            this._iconBtnPrevious.x = 21;
            this._iconBtnPrevious.y = int((((parent as GetQuoteOverlay).config.height - this._iconBtnPrevious.height) >> 1));
            this._iconBtnPrevious.onRelease.add(this.iconBtnPreviousReleaseHandler);
            this.addChild(this._iconBtnPrevious);
        }

        private function partnerListAdded():void
        {
            this._partnerList.popUpContentManager = new CustomCalloutPopUpContentManager();
        }

        private function confirmTouchHandler(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch((_arg1.currentTarget as DisplayObject), TouchPhase.ENDED);
            if (_local2 != null)
            {
                this._cbConfirm.isSelected = !(this._cbConfirm.isSelected);
            };
        }

        private function showSearchMessage(_arg1:String):void
        {
            var _local2:uint = (((this._partnerList.selectedIndex)==0) ? 1 : 0);
            this._searchItem1.name = _arg1;
            this._searchItem2.name = _arg1;
            this._partnerList.dataProvider = new ListCollection([this._searchItem1, this._searchItem2]);
            this._partnerList.selectedIndex = _local2;
            this._partnerList.isEnabled = false;
        }

        private function iconBtnPreviousReleaseHandler(_arg1:ImageButton):void
        {
            (parent as GetQuoteOverlay).switchToPage("first");
        }

        private function btnCancelReleaseHandler(_arg1:Button):void
        {
            _cancelSignal.dispatch();
        }

        private function btnSendReleaseHandler(_arg1:Button):void
        {
            this.checkForm();
        }

        private function partnerDisplay(_arg1:Object):String
        {
            return (((((PartnerVO(_arg1).distance)>=0) ? (("(" + this._nF.formatNumber(PartnerVO(_arg1).distance)) + " km) ") : "") + PartnerVO(_arg1).labelDisplay));
        }

        private function btnSearchOnRelease(_arg1:Button):void
        {
            this.showSearchMessage((Common.getResourceString("getQuote_reseller_load") + "..."));
            var _local2:String = this._inCountry.selectedItem.code;
            var _local3:String = this._inZip.text;
            var _local4:uint = this._inRadius.selectedItem.value;
            this.loadPartners(_local2, _local3, _local4);
        }

        public function initialLod():void
        {
            if (!this.partnersLoaded)
            {
                this.partnersLoaded = true;
                this.showSearchMessage((Common.getResourceString("getQuote_reseller_load") + "..."));
                this.loadPartners("AT", "", 0);
            };
        }

        private function loadPartners(_arg1:String, _arg2:String, _arg3:uint):void
        {
            if (this._partnerService == null)
            {
                this._partnerService = new PartnerService();
                this._responder = new CallResponder();
                this._responder.addEventListener(FaultEvent.FAULT, this.serviceFaultListener, false, 0, true);
                this._responder.addEventListener(ResultEvent.RESULT, this.serviceResultListener, false, 0, true);
            };
            this._responder.token = this._partnerService.partnerRadiusSearch(_arg1, _arg2, _arg3);
        }

        protected function serviceResultListener(_arg1:ResultEvent):void
        {
            if ((_arg1.result is ArrayCollection))
            {
                this._partnerList.dataProvider = new ListCollection(ArrayCollection(_arg1.result).source);
                this._partnerList.isEnabled = true;
                this.addEventListener(Event.ENTER_FRAME, this.selectFirst);
            }
            else
            {
                Common.log(("Fehler bei Partnersuche:" + _arg1.message));
            };
        }

        private function selectFirst(_arg1:Event):void
        {
            this.removeEventListener(Event.ENTER_FRAME, this.selectFirst);
            if (this._partnerList)
            {
                this._partnerList.selectedIndex = (this._partnerList.dataProvider.length - 1);
                this._partnerList.selectedIndex = 0;
            };
        }

        protected function serviceFaultListener(_arg1:FaultEvent):void
        {
            Common.log(("Fehler bei Partnersuche:" + _arg1.fault));
            if (_arg1.fault.faultCode == "700")
            {
                _errorSignal.dispatch(Common.getResourceString("getQuote_reseller_load_error700"));
                this.showSearchMessage(Common.getResourceString("getQuote_reseller_load_error700"));
            }
            else
            {
                if (_arg1.fault.faultCode == "701")
                {
                    _errorSignal.dispatch(Common.getResourceString("getQuote_reseller_load_error701"));
                    this.showSearchMessage(Common.getResourceString("getQuote_reseller_load_error701_short"));
                }
                else
                {
                    _errorSignal.dispatch(Common.getResourceString("getQuote_reseller_load_error702"));
                    this.showSearchMessage(Common.getResourceString("getQuote_reseller_load_error702_short"));
                };
            };
        }

        private function partnerListTouchHandler(_arg1:List, _arg2:PartnerVO, _arg3:int, _arg4:TouchEvent):void
        {
            var _local5:Touch;
            if (_arg4.touches.length > 0)
            {
                _local5 = _arg4.touches[0];
                if (_local5.phase == TouchPhase.ENDED)
                {
                    this.selectPartner(_arg2);
                };
            };
        }

        private function selectPartner(_arg1:PartnerVO):void
        {
        }

        override public function checkForm():void
        {
            var _local2:String;
            var _local3:int;
            var _local1:Array = [];
            if (!this._cbConfirm.isSelected)
            {
                _local1.push(Common.getResourceString("error_confirmRequired"));
            };
            if ((((this._inHaendler.text == "")) && ((((this._partnerList.selectedItem == null)) || (((this._partnerList.selectedItem as PartnerVO).id == -1))))))
            {
                _local1.push(Common.getResourceString("error_resellerRequired"));
            };
            if (_local1.length == 0)
            {
                this.sendForm();
            }
            else
            {
                _local2 = "";
                _local3 = 0;
                while (_local3 < _local1.length)
                {
                    _local2 = (_local2 + (_local1[_local3] + "\n"));
                    _local3++;
                };
                _errorSignal.dispatch(_local2);
            };
        }

        private function sendForm():void
        {
            var _local1:PartnerVO = (this._partnerList.selectedItem as PartnerVO);
            var _local2:PartnerVO = new PartnerVO();
            _local2.name = this._inHaendler.text;
            _local2.city = this._inCity2.text;
            _local2.zip = this._inZip2.text;
            _successSignal.dispatch({
                partnerInfo:_local1,
                partnerInfo2:_local2
            });
        }


    }
}//package at.polypex.badplaner.view.pages

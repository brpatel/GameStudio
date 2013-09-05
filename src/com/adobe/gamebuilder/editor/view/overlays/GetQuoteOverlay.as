package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.core.data.ContactFormVO;
    import com.adobe.gamebuilder.editor.core.data.PartnerVO;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    import com.adobe.gamebuilder.editor.view.pages.GetQuoteFirstPage;
    import com.adobe.gamebuilder.editor.view.pages.GetQuoteSecondPage;
    import com.adobe.gamebuilder.editor.view.pages.Page;
    
    import org.osflash.signals.Signal;
    
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;

    public class GetQuoteOverlay extends Overlay 
    {

        private var _firstPage:Page;
        private var _secondPage:Page;
        private var _oldPage:Page;
        private var _currentPage:Page;
        private var _sendSignal:Signal;
        private var _contactForm:ContactFormVO;
        private var _partnerInfo:PartnerVO;
        private var _partnerInfo2:PartnerVO;
        private var _iconBtnCancel:ImageButton;
        private var _sendFlag:Boolean = false;

        public function GetQuoteOverlay(_arg1:OverlayConfig)
        {
            super(_arg1);
            this._sendSignal = new Signal(Object);
        }

        public function get sendSignal():Signal
        {
            return (this._sendSignal);
        }

        override protected function init():void
        {
            super.init();
            this._firstPage = new GetQuoteFirstPage();
            this._firstPage.errorSignal.add(this.pageErrorHandler);
            this._firstPage.successSignal.add(this.firstPageSuccessHandler);
            this._firstPage.completeSignal.add(this.pageCompleteHandler);
            this._firstPage.cancelSignal.add(this.pageCancelHandler);
            this._firstPage.width = width;
            addChild(this._firstPage);
            this._currentPage = this._firstPage;
            this._secondPage = new GetQuoteSecondPage();
            this._secondPage.errorSignal.add(this.pageErrorHandler);
            this._secondPage.successSignal.add(this.secondPageSuccessHandler);
            this._secondPage.cancelSignal.add(this.pageCancelHandler);
            this._secondPage.visible = false;
            addChild(this._secondPage);
            this._iconBtnCancel = Overlay.iconBtnCancel();
            this._iconBtnCancel.onRelease.add(this.iconBtnCancelReleaseHandler);
            this.addChild(this._iconBtnCancel);
        }

        private function iconBtnCancelReleaseHandler(_arg1:ImageButton):void
        {
            prepareForExit();
        }

        private function pageCompleteHandler(_arg1:Page):void
        {
        }

        private function firstPageSuccessHandler(_arg1:Object):void
        {
            this._contactForm = _arg1.contactForm;
            this.switchToPage("second");
        }

        private function secondPageSuccessHandler(_arg1:Object):void
        {
            this._partnerInfo = _arg1.partnerInfo;
            this._partnerInfo2 = _arg1.partnerInfo2;
            this.sendForm();
        }

        public function switchToPage(_arg1:String):void
        {
            if (_arg1 == "first")
            {
                this._currentPage = this._firstPage;
                this._oldPage = this._secondPage;
            }
            else
            {
                if (_arg1 == "second")
                {
                    this._currentPage = this._secondPage;
                    this._oldPage = this._firstPage;
                    this._secondPage.visible = true;
                    (this._secondPage as GetQuoteSecondPage).initialLod();
                };
            };
            this._currentPage.x = (((this._oldPage is GetQuoteFirstPage)) ? stage.stageWidth : -(stage.stageWidth));
            var _local2:Tween = new Tween(this._currentPage, 0.3, Transitions.EASE_OUT);
            _local2.animate("x", 0);
            Starling.juggler.add(_local2);
            _local2 = new Tween(this._oldPage, 0.3, Transitions.EASE_OUT);
            _local2.animate("x", (((this._oldPage is GetQuoteFirstPage)) ? -(stage.stageWidth) : stage.stageWidth));
            Starling.juggler.add(_local2);
        }

        private function pageErrorHandler(_arg1:String):void
        {
            _errorSignal.dispatch(new SystemMessage(_arg1, SystemMessage.TYPE_ALERT, SystemMessage.LONG_DELAY));
        }

        private function sendForm():void
        {
            this._sendFlag = true;
            prepareForExit();
        }

        override protected function exit():void
        {
            if (this._sendFlag)
            {
                this._sendSignal.dispatch({
                    contactForm:this._contactForm,
                    partnerInfo:this._partnerInfo,
                    partnerInfo2:this._partnerInfo2
                });
            };
            super.exit();
        }

        private function pageCancelHandler():void
        {
            prepareForExit();
        }


    }
}//package at.polypex.badplaner.view.overlays

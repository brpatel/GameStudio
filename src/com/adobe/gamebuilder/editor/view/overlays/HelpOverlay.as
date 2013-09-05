package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage0_1;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage1_1;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage1_2;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage1_3;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage1_4;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage2_1;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage3_1;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage3_2;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage4_1;
    import com.adobe.gamebuilder.editor.view.pages.HelpPage4_2;
    import com.adobe.gamebuilder.editor.view.pages.PageDisplay;
    
    import flash.utils.getDefinitionByName;
    
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class HelpOverlay extends Overlay 
    {

        private const MIN_PAGE:int = 0;
        private const MAX_PAGE:int = 4;

        private var _nextPage:HelpPage;
        private var _currentPage:HelpPage;
        private var _iconBtnCancel:ImageButton;
        private var _iconBtnNext:ImageButton;
        private var _iconBtnPrevious:ImageButton;
        private var _pageDisplay:PageDisplay;
        private var _footerField:TextField;
        private var hp1_1:HelpPage1_1;
        private var hp1_2:HelpPage1_2;
        private var hp1_3:HelpPage1_3;
        private var hp1_4:HelpPage1_4;
        private var hp2_1:HelpPage2_1;
        private var hp3_1:HelpPage3_1;
        private var hp3_2:HelpPage3_2;
        private var hp4_1:HelpPage4_1;
        private var hp4_2:HelpPage4_2;
        private var _complete1:Boolean = false;
        private var _complete2:Boolean = false;

        public function HelpOverlay(_arg1:OverlayConfig)
        {
            super(_arg1);
        }

        override protected function init():void
        {
            var _local1:Image;
            super.init();
            this._iconBtnNext = new ImageButton("overlay_next_icon", 0, 0, false);
            this._iconBtnNext.x = ((stage.stageWidth - 21) - this._iconBtnNext.width);
            this._iconBtnNext.y = int(((config.height - this._iconBtnNext.height) >> 1));
            this._iconBtnNext.onRelease.add(this.btnNextReleaseHandler);
            this.addChild(this._iconBtnNext);
            this._iconBtnPrevious = new ImageButton("overlay_previous_icon", 0, 0, false);
            this._iconBtnPrevious.x = 21;
            this._iconBtnPrevious.visible = false;
            this._iconBtnPrevious.y = int(((config.height - this._iconBtnPrevious.height) >> 1));
            this._iconBtnPrevious.onRelease.add(this.btnPreviousReleaseHandler);
            this.addChild(this._iconBtnPrevious);
            this._iconBtnCancel = Overlay.iconBtnCancel();
            this._iconBtnCancel.onRelease.add(this.btnCancelReleaseHandler);
            this.addChild(this._iconBtnCancel);
            this._currentPage = new HelpPage0_1();
            addChild(this._currentPage);
            _local1 = Common.separator(int(((config.width - HelpPage.WIDTH) >> 1)), (_config.height - 57), HelpPage.WIDTH);
            addChild(_local1);
            this._pageDisplay = new PageDisplay();
            this._pageDisplay.x = int(((config.width - this._pageDisplay.width) >> 1));
            this._pageDisplay.y = (_config.height - 37);
            addChild(this._pageDisplay);
            this._footerField = Common.labelField(400, 25, "", 16);
            this._footerField.vAlign = VAlign.TOP;
            this._footerField.hAlign = HAlign.RIGHT;
            this._footerField.x = ((_local1.x + _local1.width) - this._footerField.width);
            this._footerField.y = (_config.height - 80);
            addChild(this._footerField);
            this.showFooter(0, 1);
        }

        private function btnPreviousReleaseHandler(_arg1:ImageButton):void
        {
            this._iconBtnNext.enabled = (this._iconBtnPrevious.enabled = false);
            this.switchBack();
        }

        private function btnNextReleaseHandler(_arg1:ImageButton):void
        {
            this._iconBtnNext.enabled = (this._iconBtnPrevious.enabled = false);
            this.switchForward();
        }

        private function btnCancelReleaseHandler(_arg1:ImageButton):void
        {
            prepareForExit();
        }

        private function showFooter(_arg1:int, _arg2:int):void
        {
            if (((!((Common.getResourceString((("help" + _arg1) + "_footer")) == null))) && (!((_arg2 == _arg1)))))
            {
                this._footerField.text = Common.getResourceString((("help" + _arg1) + "_footer"));
            }
            else
            {
                this._footerField.text = "";
            };
        }

        private function showPageDisplay(_arg1:int):void
        {
            this._pageDisplay.setStep(_arg1);
        }

        private function switchBack():void
        {
            var _local1:Class;
            if (this._currentPage.previousMainStep >= this.MIN_PAGE)
            {
                _local1 = (getDefinitionByName(((("at.polypex.badplaner.view.pages.HelpPage" + this._currentPage.previousMainStep) + "_") + this._currentPage.previousSubStep)) as Class);
                this._nextPage = new (_local1)();
                addChild(this._nextPage);
                this.buttonsToFront();
                this.slideToNext("left");
            };
        }

        private function switchForward():void
        {
            var _local1:Class;
            if (this._currentPage.nextMainStep <= this.MAX_PAGE)
            {
                _local1 = (getDefinitionByName(((("at.polypex.badplaner.view.pages.HelpPage" + this._currentPage.nextMainStep) + "_") + this._currentPage.nextSubStep)) as Class);
                this._nextPage = new (_local1)();
                addChild(this._nextPage);
                this.buttonsToFront();
                this.slideToNext("right");
            };
        }

        private function buttonsToFront():void
        {
            setChildIndex(this._iconBtnNext, (numChildren - 1));
            setChildIndex(this._iconBtnPrevious, (numChildren - 1));
            setChildIndex(this._iconBtnCancel, (numChildren - 1));
        }

        private function showButtons(_arg1:int, _arg2:int):void
        {
            this._iconBtnNext.visible = (_arg1 <= this.MAX_PAGE);
            this._iconBtnPrevious.visible = (_arg2 >= this.MIN_PAGE);
            this.buttonsToFront();
        }

        public function slideToNext(_arg1:String):void
        {
            this._complete1 = (this._complete2 = false);
            this._nextPage.x = (((_arg1)=="right") ? stage.stageWidth : -(stage.stageWidth));
            var _local2:Tween = new Tween(this._nextPage, 0.3, Transitions.EASE_OUT);
            _local2.animate("x", 0);
            _local2.onComplete = this.slideInComplete;
            Starling.juggler.add(_local2);
            _local2 = new Tween(this._currentPage, 0.3, Transitions.EASE_OUT);
            _local2.animate("x", (((_arg1)=="right") ? -(stage.stageWidth) : stage.stageWidth));
            _local2.onComplete = this.slideOutComplete;
            Starling.juggler.add(_local2);
        }

        private function slideInComplete():void
        {
            this._complete1 = true;
            if ((((this._complete1 == true)) && ((this._complete2 == true))))
            {
                this.finishSlide();
            };
        }

        private function slideOutComplete():void
        {
            this._complete2 = true;
            if ((((this._complete1 == true)) && ((this._complete2 == true))))
            {
                this.finishSlide();
            };
        }

        private function finishSlide():void
        {
            removeChild(this._currentPage);
            this._currentPage = this._nextPage;
            this.showButtons(this._currentPage.nextMainStep, this._currentPage.previousMainStep);
            this.showPageDisplay(this._currentPage.totalPage);
            this.showFooter(this._currentPage.mainStep, this._currentPage.nextMainStep);
            this._iconBtnNext.enabled = (this._iconBtnPrevious.enabled = true);
        }


    }
}//package at.polypex.badplaner.view.overlays

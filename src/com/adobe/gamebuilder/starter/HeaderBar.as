﻿package com.adobe.gamebuilder.starter
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.IGameEditor;
    import com.adobe.gamebuilder.editor.core.Locale;
    import com.adobe.gamebuilder.editor.view.ActionBarContainer;
    import com.adobe.gamebuilder.editor.view.LeftPanel;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    
    import flash.globalization.NumberFormatter;
    
    import org.josht.starling.display.TiledImage;
    import org.osflash.signals.Signal;
    
    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.TextureSmoothing;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class HeaderBar extends DisplayObjectContainer 
    {

        private var _stepField:TextField;
        private var _nameField:TextField;
        private var _percentField:TextField;
        private var _actionSignal:Signal;
        private var _btnHighlight:Image;
        private var btnSave:Image;//ImageButton;
        private var btnHelp:ImageButton;
        private var _areaField:TextField;
        private var _nF:NumberFormatter;
        private var btnInfo:ImageButton;

        public function HeaderBar()
        {
            this._actionSignal = new Signal(String);
            this._nF = new NumberFormatter(Locale.currentLang);
		//	this._nF = new NumberFormatter("en");
            this._nF.decimalSeparator = Common.getResourceString("decimalSeparator");
            this._nF.fractionalDigits = 2;
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get actionSignal():Signal
        {
            return (this._actionSignal);
        }

        private function init(_arg1:Event):void
        {
            var _local3:Image;
            var _local2:TiledImage = new TiledImage(Assets.getTextureAtlas("Interface").getTexture("top_bar_bg"));
            _local2.width = stage.stageWidth;
            _local2.height = Constants.TOPBAR_HEIGHT;
            addChild(_local2);
            this._stepField = new TextField(350, 20, Common.getResourceString("appLabel"), Constants.WHITE_SHADOW_FONT, 14, 0xFFFFFF, true);
            this._stepField.touchable = false;
            this._stepField.hAlign = HAlign.LEFT;
            this._stepField.vAlign = VAlign.CENTER;
            this._stepField.x = (LeftPanel.TAB_WIDTH);
            this._stepField.y = Math.ceil(((Constants.TOPBAR_HEIGHT - this._stepField.height) >> 1));
            addChild(this._stepField);
           
           
           
            
            this._btnHighlight = new Image(Assets.getTextureAtlas("Interface").getTexture("top_bar_btn_highlight"));
            this._btnHighlight.touchable = false;
            this._btnHighlight.y = 1;
            this._btnHighlight.visible = false;
            this._btnHighlight.addEventListener(TouchEvent.TOUCH, this.btnHighlightOnTouch);
            addChild(this._btnHighlight);
            this.btnSave = new Image(myAssets.getTexture("share")); // ImageButton("icon_save", this._btnHighlight.width, this._btnHighlight.height);
            this.btnSave.x = (stage.stageWidth - (3 * this._btnHighlight.width));
            this.btnSave.y = 5;
            this.btnSave.name = "topBarBtnSave";
     //       this.btnSave.onRelease.add(this.btnSaveOnRelease);
            addChild(this.btnSave);
            this.btnHelp = new ImageButton("icon_help", this._btnHighlight.width, this._btnHighlight.height);
            this.btnHelp.x = (stage.stageWidth - (2 * this._btnHighlight.width));
            this.btnHelp.y = 0;
            this.btnHelp.name = "topBarBtnHelp";
            this.btnHelp.onRelease.add(this.btnHelpOnRelease);
            addChild(this.btnHelp);
            this.btnInfo = new ImageButton("icon_info", this._btnHighlight.width, this._btnHighlight.height);
            this.btnInfo.x = (stage.stageWidth - this._btnHighlight.width);
            this.btnInfo.y = 0;
            this.btnInfo.name = "topBarBtnInfo";
            this.btnInfo.onRelease.add(this.btnInfoOnRelease);
            addChild(this.btnInfo);
 //           this.separator((this.btnSave.x - 1));
 //           this.separator((this.btnHelp.x - 1));
 //           this.separator((this.btnInfo.x - 1));
        }

        private function separator(_arg1:uint, _arg2:uint=0):void
        {
            var _local3:Image = new Image(Assets.getTextureAtlas("Interface").getTexture("top_bar_division_line"));
            _local3.touchable = false;
            _local3.smoothing = TextureSmoothing.NONE;
            _local3.x = _arg1;
            _local3.y = _arg2;
            _local3.height = Constants.TOPBAR_HEIGHT;
            addChild(_local3);
        }

        private function percentFieldOnTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage, TouchPhase.ENDED);
            if (_local2 != null)
            {
                this._percentField.text = "100%";
                (Starling.current.root as IGameEditor).container.resetZoom();
            };
        }

        private function btnHighlightOnTouch(_arg1:TouchEvent):void
        {
            _arg1.stopImmediatePropagation();
        }

        public function setPlanName(_arg1:String):void
        {
            this._nameField.text = _arg1;
        }

        public function setStepName(_arg1:String):void
        {
            this._stepField.text = _arg1;
        }

        public function reset():void
        {
            this.btnSave.touchable = true;
            this.btnHelp.touchable = true;
            this.btnInfo.touchable = true;
            this._btnHighlight.visible = false;
        }

        private function btnInfoOnRelease(_arg1:ImageButton):void
        {
            this._actionSignal.dispatch(ActionBarContainer.TYPE_INFO);
            this._btnHighlight.x = (stage.stageWidth - this._btnHighlight.width);
            this._btnHighlight.visible = true;
            this.btnSave.touchable = true;
            this.btnHelp.touchable = true;
            this.btnInfo.touchable = false;
        }

        private function btnHelpOnRelease(_arg1:ImageButton):void
        {
            this._actionSignal.dispatch(ActionBarContainer.TYPE_HELP);
            this._btnHighlight.x = (stage.stageWidth - (2 * this._btnHighlight.width));
            this._btnHighlight.visible = true;
            this.btnSave.touchable = true;
            this.btnHelp.touchable = false;
            this.btnInfo.touchable = true;
        }

        private function btnSaveOnRelease(_arg1:ImageButton):void
        {
            this._actionSignal.dispatch(ActionBarContainer.TYPE_SAVE);
            this._btnHighlight.x = (stage.stageWidth - (3 * this._btnHighlight.width));
            this._btnHighlight.visible = true;
            this.btnSave.touchable = false;
            this.btnHelp.touchable = true;
            this.btnInfo.touchable = true;
        }

        private function areaChangeHandler(_arg1:Number):void
        {
            this._areaField.text = (this._nF.formatNumber(_arg1) + " m²");
        }

        private function zoomChangeHandler(_arg1:Number):void
        {
            this._percentField.text = (_arg1.toFixed(0) + "%");
        }


    }
}//package at.polypex.badplaner.view.bars

package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.manager.AlertManager;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlackButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlueButton;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    
    import flash.geom.Rectangle;
    
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.textures.Scale9Textures;
    import org.osflash.signals.Signal;
    
    import starling.text.TextField;
    import starling.textures.TextureSmoothing;

    public class DefaultAlertWindow extends Overlay 
    {

        private const BUTTON_WIDTH:uint = 80;
        private const BUTTON_BIG_WIDTH:uint = 125;
        private const BUTTON_PADDING:uint = 10;

        public var btnYesLabel:String = "";
        public var btnNoLabel:String = "";
        public var btnOkLabel:String = "";
        public var btnCancelLabel:String = "";
        private var _buttonFlags:uint = 4;
        private var btnYes:Button;
        private var btnNo:Button;
        private var btnOk:Button;
        private var btnCancel:Button;
        private var _header:String;
        private var _message:String;
        private var _btnRelease:Signal;
        private var _messageField:TextField;
        private var _headerField:TextField;

        public function DefaultAlertWindow(_arg1:OverlayConfig)
        {
            super(_arg1);
            this._btnRelease = new Signal(uint);
        }

        public function set message(_arg1:String):void
        {
            this._message = _arg1;
            if (this._messageField)
            {
                this._messageField.text = this._message;
                _bg.height = Math.max(100, ((this._messageField.y + this._messageField.textBounds.height) + 65));
            };
        }

        public function set header(_arg1:String):void
        {
            this._header = _arg1;
            if (this._headerField)
            {
                this._headerField.text = this._header;
            };
        }

        public function get btnRelease():Signal
        {
            return (this._btnRelease);
        }

        public function get message():String
        {
            return (this._message);
        }

        public function get header():String
        {
            return (this._header);
        }

        private function layoutButtons():void
        {
        }

        override protected function init():void
        {
            this.removeChildren();
            var _local1:Scale9Textures = new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("bg_alert"), new Rectangle(5, 5, 26, 26));
            _bg = new Scale9Image(_local1);
            (_bg as Scale9Image).smoothing = TextureSmoothing.NONE;
            _bg.width = config.width;
            _bg.height = 200;
            addChild(_bg);
            this._headerField = new TextField((width - 40), 35, "", Constants.WHITE_SHADOW_FONT, Constants.WHITE_SHADOW_FONT_SIZE, 16724787);
            this._headerField.x = 20;
            this._headerField.y = 5;
            this._headerField.hAlign = "left";
            this._headerField.autoScale = false;
            this._headerField.text = this._header;
            this._headerField.touchable = false;
            addChild(this._headerField);
            this._messageField = new TextField((width - 40), (_bg.height - 110), "", Constants.WHITE_SHADOW_FONT, Constants.WHITE_SHADOW_FONT_SIZE, 0xFFFFFF);
            this._messageField.x = 20;
            this._messageField.y = 45;
            this._messageField.hAlign = "left";
            this._messageField.vAlign = "top";
            this._messageField.text = this._message;
            this._messageField.touchable = false;
            addChild(this._messageField);
            _bg.height = Math.max(100, ((this._messageField.y + this._messageField.textBounds.height) + 65));
            this.btnYes = new BlueButton();
            this.btnYes.x = 5;
            this.btnYes.y = (_bg.height - 50);
            this.btnYes.width = this.BUTTON_WIDTH;
            this.btnYes.label = this.btnYesLabel;
            this.btnYes.onRelease.add(this.btnYesHandler);
            addChild(this.btnYes);
            this.btnNo = new BlackButton();
            this.btnNo.x = 50;
            this.btnNo.y = (_bg.height - 50);
            this.btnNo.width = this.BUTTON_WIDTH;
            this.btnNo.label = this.btnYesLabel;
            this.btnNo.onRelease.add(this.btnNoHandler);
            addChild(this.btnNo);
            this.btnOk = new BlueButton();
            this.btnOk.x = 105;
            this.btnOk.y = (_bg.height - 50);
            this.btnOk.width = this.BUTTON_WIDTH;
            this.btnOk.label = this.btnYesLabel;
            this.btnOk.onRelease.add(this.btnOkHandler);
            addChild(this.btnOk);
            this.btnCancel = new BlackButton();
            this.btnCancel.x = 155;
            this.btnCancel.y = (_bg.height - 50);
            this.btnCancel.width = this.BUTTON_BIG_WIDTH;
            this.btnCancel.label = this.btnYesLabel;
            this.btnCancel.onRelease.add(this.btnCancelHandler);
            addChild(this.btnCancel);
            this.setButtons();
        }

        protected function btnYesHandler(_arg1:Button):void
        {
            this._btnRelease.dispatch(AlertManager.YES);
        }

        protected function btnNoHandler(_arg1:Button):void
        {
            this._btnRelease.dispatch(AlertManager.NO);
        }

        protected function btnOkHandler(_arg1:Button):void
        {
            this._btnRelease.dispatch(AlertManager.OK);
        }

        protected function btnCancelHandler(_arg1:Button):void
        {
            this._btnRelease.dispatch(AlertManager.CANCEL);
        }

        public function set buttonFlags(_arg1:uint):void
        {
            this._buttonFlags = _arg1;
            this.setButtons();
        }

        private function setButtons():void
        {
            var _local1:uint;
            var _local2:uint;
            if (this.btnCancel)
            {
                _local1 = 0;
                this.btnYes.visible = this.buttonVisibility(AlertManager.YES);
                if (this.btnYes.visible)
                {
                    _local1 = (_local1 + this.btnYes.width);
                };
                this.btnYes.label = (this.btnYesLabel = (((this.btnYesLabel)!="") ? this.btnYesLabel : Common.getResourceString("btnYesLabel")));
                this.btnNo.visible = this.buttonVisibility(AlertManager.NO);
                if (this.btnNo.visible)
                {
                    _local1 = (_local1 + (this.btnNo.width + (((_local1)>0) ? this.BUTTON_PADDING : 0)));
                };
                this.btnNo.label = (this.btnNoLabel = (((this.btnNoLabel)!="") ? this.btnNoLabel : Common.getResourceString("btnNoLabel")));
                this.btnOk.visible = this.buttonVisibility(AlertManager.OK);
                if (this.btnOk.visible)
                {
                    _local1 = (_local1 + (this.btnOk.width + (((_local1)>0) ? this.BUTTON_PADDING : 0)));
                };
                this.btnOk.label = (this.btnOkLabel = (((this.btnOkLabel)!="") ? this.btnOkLabel : Common.getResourceString("btnOkLabel")));
                this.btnCancel.visible = this.buttonVisibility(AlertManager.CANCEL);
                if (this.btnCancel.visible)
                {
                    _local1 = (_local1 + (this.btnCancel.width + (((_local1)>0) ? this.BUTTON_PADDING : 0)));
                };
                this.btnCancel.label = (this.btnCancelLabel = (((this.btnCancelLabel)!="") ? this.btnCancelLabel : Common.getResourceString("btnCancelLabel")));
                _local2 = ((width - _local1) >> 1);
                if (this.btnYes.visible)
                {
                    this.btnYes.x = _local2;
                    _local2 = (_local2 + (this.btnYes.width + this.BUTTON_PADDING));
                };
                if (this.btnNo.visible)
                {
                    this.btnNo.x = _local2;
                    _local2 = (_local2 + (this.btnNo.width + this.BUTTON_PADDING));
                };
                if (this.btnOk.visible)
                {
                    this.btnOk.x = _local2;
                    _local2 = (_local2 + (this.btnOk.width + this.BUTTON_PADDING));
                };
                if (this.btnCancel.visible)
                {
                    this.btnCancel.x = _local2;
                };
            };
        }

        private function buttonVisibility(_arg1:uint):Boolean
        {
            return (((_arg1 & this._buttonFlags) == _arg1));
        }


    }
}//package at.polypex.badplaner.view.overlays

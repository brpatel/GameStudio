package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.storage.StoredThumbnail;
    import com.adobe.gamebuilder.editor.view.comps.InputField;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlackButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlueButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    
    import flash.display.BitmapData;
    
    import mx.events.ValidationResultEvent;
    import mx.validators.StringValidator;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class SavePlanOverlay extends Overlay 
    {

        private var _btnSave:Button;
        private var _btnCancel:Button;
        private var _savePlan:Signal;
        private var _saveFlag:Boolean = false;
        private var _inputPlanName:InputField;
        private var _iconBtnCancel:ImageButton;
        private var _screenshot:StoredThumbnail;
        private var _img:Image;
        private var _introField:TextField;

        public function SavePlanOverlay(_arg1:OverlayConfig)
        {
            super(_arg1);
            this._savePlan = new Signal(String);
        }

        public function get screenshot():StoredThumbnail
        {
            return (this._screenshot);
        }

        public function set screenshot(_arg1:StoredThumbnail):void
        {
            this._screenshot = _arg1;
            this.showThumb(_arg1);
        }

        public function get savePlan():Signal
        {
            return (this._savePlan);
        }

        private function showThumb(_arg1:StoredThumbnail):void
        {
            var _local2:uint = 200;
            var _local3:uint = 200;
            _arg1.data.position = 0;
            var _local4:BitmapData = new BitmapData(_arg1.rect.width, _arg1.rect.height, false);
            _local4.setPixels(_arg1.rect, _arg1.data);
            this._img = new Image(Texture.fromBitmapData(_local4));
            _local4.dispose();
            var _local5:Number = Math.min((_local2 / this._img.width), (_local3 / this._img.height));
            this._img.scaleX = _local5;
            this._img.scaleY = _local5;
            if (this._introField != null)
            {
                this.positionThumb();
            };
        }

        private function positionThumb():void
        {
            this._img.x = (this._introField.x + 30);
            this._img.y = 184;
            addChild(this._img);
        }

        override protected function init():void
        {
            var _local1:TextField;
            super.init();
            this._saveFlag = false;
            _local1 = Common.labelField(stage.stageWidth, 30, Common.getResourceString("savePlan_header"), 18, "center", "top", false, Constants.BOLD_FONT);
            _local1.x = 0;
            _local1.y = 30;
            addChild(_local1);
            this._introField = Common.labelField(720, 120, Common.getResourceString("savePlan_info"), 16, "left", "top", true);
            this._introField.x = int(((stage.stageWidth - 720) >> 1));
            this._introField.y = 100;
            addChild(this._introField);
            if (this._img != null)
            {
                this.positionThumb();
            };
            var _local2:Image = Common.separator(this._introField.x, 75, 720);
            addChild(_local2);
            _local1 = Common.labelField(115, 30, (Common.getResourceString("planName") + ":"));
            _local1.x = (this._introField.x + 280);
            _local1.y = 217;
            addChild(_local1);
            this._inputPlanName = new InputField(190, "", "", 50);
            this._inputPlanName.x = (_local1.x + 115);
            this._inputPlanName.y = 210;
            addChild(this._inputPlanName);
            this._btnSave = new BlueButton();
            this._btnSave.label = Common.getResourceString("btnSaveLabel");
            this._btnSave.width = Constants.DEFAULT_BUTTON_WIDTH;
            this._btnSave.x = (((this._introField.x + 720) - 180) - 100);
            this._btnSave.y = 330;
            this._btnSave.onRelease.add(this.btnSaveReleaseHandler);
            this.addChild(this._btnSave);
            this._btnCancel = new BlackButton();
            this._btnCancel.label = Common.getResourceString("btnCancelLabel");
            this._btnCancel.width = Constants.DEFAULT_BUTTON_WIDTH;
            this._btnCancel.x = (((this._introField.x + 720) - 360) - 100);
            this._btnCancel.y = 330;
            this._btnCancel.onRelease.add(this.btnCancelReleaseHandler);
            this.addChild(this._btnCancel);
            this._iconBtnCancel = Overlay.iconBtnCancel();
            this._iconBtnCancel.onRelease.add(this.iconBtnCancelReleaseHandler);
            this.addChild(this._iconBtnCancel);
        }

        private function iconBtnCancelReleaseHandler(_arg1:ImageButton):void
        {
            prepareForExit();
        }

        private function checkForm():void
        {
            var _local4:String;
            var _local5:int;
            var _local1:Array = [];
            var _local2:StringValidator = new StringValidator();
            _local2.required = true;
            var _local3:ValidationResultEvent = _local2.validate(this._inputPlanName.text);
            if (((_local3.results) && ((_local3.results.length > 0))))
            {
                _local1.push(Common.getResourceString("error_requiredField", "iLabels", [Common.getResourceString("planName")]));
                this._inputPlanName.alert = true;
            };
            if (_local1.length == 0)
            {
                this.sendForm();
            }
            else
            {
                _local4 = "";
                _local5 = 0;
                while (_local5 < _local1.length)
                {
                    _local4 = (_local4 + (_local1[_local5] + "\n"));
                    _local5++;
                };
                _errorSignal.dispatch(new SystemMessage(_local4, SystemMessage.TYPE_ALERT, SystemMessage.LONG_DELAY));
            };
        }

        private function sendForm():void
        {
            this._saveFlag = true;
            prepareForExit();
        }

        private function btnSaveReleaseHandler(_arg1:Button):void
        {
            this.checkForm();
        }

        override protected function exit():void
        {
            if (this._saveFlag)
            {
                this._savePlan.dispatch(this._inputPlanName.text);
            };
            super.exit();
        }

        private function btnCancelReleaseHandler(_arg1:Button):void
        {
            prepareForExit();
        }


    }
}//package at.polypex.badplaner.view.overlays

package com.adobe.gamebuilder.editor.view.comps.buttons
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;

    public class ImageToggle extends Image 
    {

        private var _onRelease:Signal;
        private var _isSelected:Boolean = false;
        private var _isEnabled:Boolean = true;
        private var _isBarButton:Boolean = false;
        private var _iconTexture:Texture;
        private var _selectedIconTexture:Texture;

        public function ImageToggle(_arg1:String, _arg2:Boolean=false)
        {
            this._isBarButton = _arg2;
            this._onRelease = new Signal(ImageToggle);
            this.addEventListener(TouchEvent.TOUCH, this.onTouch);
            this._iconTexture = Assets.getTextureAtlas("Interface").getTexture((_arg1 + "_up"));
            this._selectedIconTexture = Assets.getTextureAtlas("Interface").getTexture((_arg1 + "_down"));
            super(((this._isSelected) ? this._selectedIconTexture : this._iconTexture));
        }

        public function get isEnabled():Boolean
        {
            return (this._isEnabled);
        }

        public function set isEnabled(_arg1:Boolean):void
        {
            this._isEnabled = _arg1;
        }

        public function get isSelected():Boolean
        {
            return (this._isSelected);
        }

        public function set isSelected(_arg1:Boolean):void
        {
            this._isSelected = _arg1;
            if (this._isBarButton)
            {
                this._isEnabled = !(this._isSelected);
            };
            this.texture = ((this._isSelected) ? this._selectedIconTexture : this._iconTexture);
            this.readjustSize();
        }

        public function get onRelease():Signal
        {
            return (this._onRelease);
        }

        private function onTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage);
            if (_local2 != null)
            {
                if ((((_local2.phase == TouchPhase.ENDED)) && (this._isEnabled)))
                {
                    this.isSelected = !(this.isSelected);
                    this._onRelease.dispatch(this);
                };
            };
        }


    }
}//package at.polypex.badplaner.view.comps.buttons

package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageToggle;
    
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;

    public class TabButton extends DisplayObjectContainer 
    {

        private var _btnTab:ImageToggle;
        private var _step:String;
        private var _onRelease:Signal;
        private var _icon:Image;
        private var _nr:uint;

        public function TabButton(_arg1:uint, _arg2:String)
        {
            this._nr = _arg1;
            this._step = _arg2;
            this._onRelease = new Signal(String);
            this.init();
        }

        public function get onRelease():Signal
        {
            return (this._onRelease);
        }

        public function set isSelected(_arg1:Boolean):void
        {
            if (this._btnTab)
            {
                this._btnTab.isSelected = _arg1;
            };
            this.setIconTexture();
        }

        public function get isSelected():Boolean
        {
            return (this._btnTab.isSelected);
        }

        private function init():void
        {
            this._btnTab = new ImageToggle("tab_bg");
            this._btnTab.onRelease.add(this.btnTabOnRelease);
            addChild(this._btnTab);
            this._icon = new Image(Assets.getTextureAtlas("Interface").getTexture((("tab" + this._nr) + "_inactive")));
            this._icon.touchable = false;
            this._icon.x = (int(((this._btnTab.width - this._icon.width) >> 1)) + 3);
            this._icon.y = int(((this._btnTab.height - this._icon.height) >> 1));
            addChild(this._icon);
        }

        private function btnTabOnRelease(_arg1:ImageToggle):void
        {
            this._onRelease.dispatch(this._step);
            this.setIconTexture();
        }

        private function setIconTexture():void
        {
            if (this._icon)
            {
                this._icon.texture = ((this._btnTab.isSelected) ? Assets.getTextureAtlas("Interface").getTexture((("tab" + this._nr) + "_active")) : Assets.getTextureAtlas("Interface").getTexture((("tab" + this._nr) + "_inactive")));
            };
        }


    }
}//package at.polypex.badplaner.view.comps

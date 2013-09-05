package com.adobe.gamebuilder.editor.view.pages
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;

    public class PageDisplay extends DisplayObjectContainer 
    {

        private var _circle:Image;

        public function PageDisplay()
        {
            this.init();
        }

        private function init():void
        {
            var _local1:Image = new Image(Assets.getTextureAtlas("Interface").getTexture("page_display_bg"));
            addChild(_local1);
            this._circle = new Image(Assets.getTextureAtlas("Interface").getTexture("page_display_circle"));
            this._circle.x = 0;
            this._circle.y = 0;
            addChild(this._circle);
        }

        public function setStep(_arg1:uint):void
        {
            this._circle.x = ((_arg1 - 1) * 10);
        }


    }
}//package at.polypex.badplaner.view.pages

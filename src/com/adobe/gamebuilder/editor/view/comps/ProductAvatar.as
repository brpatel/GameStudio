package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class ProductAvatar extends Sprite 
    {

        private var _img:Image;
        private var _icon:Image;

        public function ProductAvatar(_arg1:Texture)
        {
            this._img = new Image(_arg1);
            addChild(this._img);
        }

        public function showIcon():void
        {
            if (this._icon == null)
            {
                this._icon = new Image(Assets.getTextureAtlas("Interface").getTexture("icon_plus"));
                this._icon.x = (-(this._icon.width) >> 1);
                this._icon.y = (-(this._icon.height) >> 1);
                addChild(this._icon);
            };
            this._icon.visible = true;
        }

        public function hideIcon():void
        {
            if (this._icon != null)
            {
                this._icon.visible = false;
            };
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package at.polypex.badplaner.view.comps

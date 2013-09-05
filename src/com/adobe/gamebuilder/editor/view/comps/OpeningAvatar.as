package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.view.parts.DragDoor;
    import com.adobe.gamebuilder.editor.view.parts.DragWindow;
    
    import starling.display.Image;
    import starling.display.Sprite;

    public class OpeningAvatar extends Sprite 
    {

        private var _img:Image;
        private var _icon:Image;

        public function OpeningAvatar(_arg1:String)
        {
            this._img = (((_arg1)==Opening.DOOR) ? new DragDoor() : new DragWindow());
            addChild(this._img);
        }

        public function showIcon():void
        {
            if (this._icon == null)
            {
                this._icon = new Image(Assets.getTextureAtlas("Interface").getTexture("icon_plus"));
                this._icon.x = 45;
                this._icon.y = -14;
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

package com.adobe.gamebuilder.editor.view.comps.lists
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    
    import org.josht.starling.foxhole.controls.renderers.DefaultListItemRenderer;
    
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;

    public class ProductListRenderer extends DefaultListItemRenderer 
    {

        public static const RENDERER_HEIGHT:uint = 150;

        public function ProductListRenderer()
        {
            this.addEventListener(Event.ADDED, this.addedHandler);
            this.addEventListener(Event.REMOVED, this.removedHandler);
        }

        override protected function refreshIconTexture(_arg1:Texture):void
        {
            super.refreshIconTexture(_arg1);
            if (iconImage)
            {
                iconImage.name = "iconImage";
                if (iconImage.height > (RENDERER_HEIGHT - 30))
                {
                    iconImage.scaleX = (iconImage.scaleY = ((RENDERER_HEIGHT - 30) / iconImage.height));
                }
                else
                {
                    iconImage.scaleX = (iconImage.scaleY = 1);
                };
            };
        }

        override protected function layoutContent():void
        {
            super.layoutContent();
            if (this.accessory)
            {
                this.accessory.x = 211;
                this.accessory.y = 13;
            };
            if (((accessoryImage) && (!((data == null)))))
            {
                accessoryImage.visible = (data as MobileProductVO).info;
                accessoryImage.name = "infoIcon";
            };
        }

        override public function set data(_arg1:Object):void
        {
            super.data = _arg1;
            if (accessoryImage)
            {
                accessoryImage.visible = (_arg1 as MobileProductVO).info;
            };
        }

        private function addedHandler():void
        {
            if (iconImage)
            {
                iconImage.addEventListener(TouchEvent.TOUCH, this.iconOnTouch);
            };
            if (accessoryImage)
            {
                accessoryImage.addEventListener(TouchEvent.TOUCH, this.infoOnTouch);
            };
        }

        private function removedHandler():void
        {
            if (accessoryImage)
            {
                accessoryImage.removeEventListener(TouchEvent.TOUCH, this.infoOnTouch);
            };
        }

        private function infoOnTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage);
            if (((!((_local2 == null))) && ((_local2.phase == TouchPhase.ENDED))))
            {
                (owner.parent as ProductList).onInfoTouchHandler(this, (data as MobileProductVO));
                accessoryImage.texture = Assets.getTextureAtlas("Interface").getTexture("list_info_icon_down");
            };
        }

        private function iconOnTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(iconImage);
            if (((((!((_local2 == null))) && ((_local2.tapCount == 2)))) && ((_local2.phase == TouchPhase.ENDED))))
            {
                (owner.parent as ProductList).onIconDoubleTouchHandler(this, (data as MobileProductVO));
            };
        }

        public function resetInfo():void
        {
            accessoryImage.texture = Assets.getTextureAtlas("Interface").getTexture("list_info_icon_up");
        }


    }
}//package at.polypex.badplaner.view.comps.lists

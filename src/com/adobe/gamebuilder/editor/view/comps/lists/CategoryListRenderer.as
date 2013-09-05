package com.adobe.gamebuilder.editor.view.comps.lists
{
    import org.josht.starling.foxhole.controls.renderers.DefaultListItemRenderer;
    import starling.events.Event;
    import starling.textures.Texture;

    public class CategoryListRenderer extends DefaultListItemRenderer 
    {

        public static const RENDERER_HEIGHT:uint = 50;

        public function CategoryListRenderer()
        {
            this.addEventListener(Event.ADDED, this.addedHandler);
            this.addEventListener(Event.REMOVED, this.removedHandler);
        }

        override protected function refreshIconTexture(_arg1:Texture):void
        {
            super.refreshIconTexture(_arg1);
        }

        override protected function positionLabelAndIcon():void
        {
            super.positionLabelAndIcon();
		
            if (this.currentIcon)
            {
                this.currentIcon.x = 218;
                this.currentIcon.y = 20;
			
            };
        }

        override public function set data(_arg1:Object):void
        {
            super.data = _arg1;
        }

        private function addedHandler():void
        {
        }

        private function removedHandler():void
        {
        }


    }
}//package at.polypex.badplaner.view.comps.lists

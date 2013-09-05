package com.adobe.gamebuilder.editor.view.comps.lists
{
    import com.adobe.gamebuilder.editor.core.Constants;
    
    import org.josht.starling.foxhole.controls.renderers.DefaultListItemRenderer;
    import org.josht.starling.foxhole.text.BitmapFontTextFormat;
    import org.josht.starling.foxhole.themes.GameEditorTheme;
    
    import starling.events.Event;
    import starling.textures.Texture;

    public class DefaultPickerListRenderer extends DefaultListItemRenderer 
    {

        public static const RENDERER_HEIGHT:uint = 36;

        public function DefaultPickerListRenderer()
        {
            this.addEventListener(Event.ADDED, this.addedHandler);
            this.addEventListener(Event.REMOVED, this.removedHandler);
            defaultLabelProperties.textFormat = new BitmapFontTextFormat(GameEditorTheme.BITMAP_FONT, 16, Constants.DEFAULT_FONT_COLOR);
        }

        override protected function refreshIconTexture(_arg1:Texture):void
        {
            super.refreshIconTexture(_arg1);
        }

        override protected function layoutContent():void
        {
            super.layoutContent();
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

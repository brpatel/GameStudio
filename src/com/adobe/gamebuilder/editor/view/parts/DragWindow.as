package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.view.comps.DragOpening;

    public class DragWindow extends DragOpening 
    {

        public function DragWindow()
        {
            super(Assets.getTextureAtlas("Interface").getTexture("window_icon_sidebar"));
            pivotX = (width >> 1);
            pivotY = (height >> 1);
        }

    }
}//package at.polypex.badplaner.view.parts

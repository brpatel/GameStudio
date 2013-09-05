package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.view.comps.DragOpening;

    public class DragDoor extends DragOpening 
    {

        public function DragDoor()
        {
            super(Assets.getTextureAtlas("Interface").getTexture("icon_door_sidebar"));
            pivotX = (width >> 1);
            pivotY = (height - RoomMeasure.WALL_SIZE_HALF);
        }

    }
}//package at.polypex.badplaner.view.parts

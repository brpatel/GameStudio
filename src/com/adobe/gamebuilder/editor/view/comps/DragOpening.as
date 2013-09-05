package com.adobe.gamebuilder.editor.view.comps
{
    import starling.display.Image;
    import org.osflash.signals.Signal;
    import org.josht.starling.foxhole.dragDrop.IDragSource;
    import org.josht.starling.foxhole.dragDrop.DragData;
    import starling.textures.Texture;
    import org.osflash.signals.ISignal;
    import org.josht.starling.foxhole.dragDrop.*;

    public class DragOpening extends Image implements IDragSource 
    {

        public static const DOOR:String = "door";
        public static const WINDOW:String = "window";

        private var _onDragStart:Signal;
        private var _onDragComplete:Signal;

        public function DragOpening(_arg1:Texture)
        {
            super(_arg1);
            this._onDragStart = new Signal(IDragSource, DragData);
            this._onDragComplete = new Signal(IDragSource, DragData, Boolean);
        }

        public function get onDragStart():ISignal
        {
            return (this._onDragStart);
        }

        public function get onDragComplete():ISignal
        {
            return (this._onDragComplete);
        }


    }
}//package at.polypex.badplaner.view.comps

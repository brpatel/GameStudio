package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    import com.adobe.gamebuilder.editor.view.parts.RoomPoint;
    
    import org.osflash.signals.Signal;

    public class RoomPointMenu extends Overlay 
    {

        private var _point:RoomPoint;
        private var _btnDelete:ImageButton;
        private var _removePoint:Signal;

        public function RoomPointMenu(_arg1:OverlayConfig)
        {
            super(_arg1);
            this._removePoint = new Signal(RoomPoint);
        }

        public function get removePoint():Signal
        {
            return (this._removePoint);
        }

        public function get point():RoomPoint
        {
            return (this._point);
        }

        public function set point(_arg1:RoomPoint):void
        {
            this._point = _arg1;
            if (this._btnDelete != null)
            {
                this._btnDelete.visible = this.point.removeable;
            };
        }

        override protected function init():void
        {
            super.init();
            this._btnDelete = new ImageButton("icon_delete");
            this._btnDelete.onRelease.add(this.btnDeleteReleaseHandler);
            this._btnDelete.x = 3;
            this._btnDelete.y = -2;
            this.addChild(this._btnDelete);
        }

        private function btnDeleteReleaseHandler(_arg1:ImageButton):void
        {
            prepareForExit();
            this._removePoint.dispatch(this.point);
        }


    }
}//package at.polypex.badplaner.view.overlays

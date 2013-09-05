package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;

    public class HorizontalDistanceLine extends DistanceLine 
    {

        private var _leftMarker:MeasureLine;
        private var _rightMarker:MeasureLine;


        override public function init():void
        {
            super.init();
            _line.y = (-(Constants.DISTANCE_LINE_SIZE) >> 1);
            _field.y = (_line.y - 30);
            this._leftMarker = new MeasureLine(Constants.DISTANCE_LINE_SIZE, 12);
            this._leftMarker.pivotX = 0;
            this._leftMarker.pivotY = 6;
            addChild(this._leftMarker);
            this._rightMarker = new MeasureLine(Constants.DISTANCE_LINE_SIZE, 12);
            this._rightMarker.pivotX = Constants.DISTANCE_LINE_SIZE;
            this._rightMarker.pivotY = 6;
            addChild(this._rightMarker);
        }

        override public function set width(_arg1:Number):void
        {
            super.width = _arg1;
            _field.text = RoomMeasure.px2cm(_line.width, false).toFixed(0);
            _field.x = (_line.x + ((_line.width - _field.width) >> 1));
            this._leftMarker.x = _line.x;
            this._rightMarker.x = (_line.x + _line.width);
            if ((((RoomMeasure.px2cm(_line.width, false) < 1)) || ((RoomMeasure.px2cm(_line.width, false) > 50))))
            {
                hide();
            }
            else
            {
                show();
            };
        }


    }
}//package at.polypex.badplaner.view.comps

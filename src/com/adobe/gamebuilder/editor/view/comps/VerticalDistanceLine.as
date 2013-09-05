package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;

    public class VerticalDistanceLine extends DistanceLine 
    {

        private var _topMarker:MeasureLine;
        private var _botMarker:MeasureLine;


        override public function init():void
        {
            super.init();
            _line.x = (-(Constants.DISTANCE_LINE_SIZE) >> 1);
            _field.x = (_line.x + 5);
            this._topMarker = new MeasureLine(12, Constants.DISTANCE_LINE_SIZE);
            this._topMarker.pivotX = 6;
            this._topMarker.pivotY = 0;
            addChild(this._topMarker);
            this._botMarker = new MeasureLine(12, Constants.DISTANCE_LINE_SIZE);
            this._botMarker.pivotX = 6;
            this._botMarker.pivotY = Constants.DISTANCE_LINE_SIZE;
            addChild(this._botMarker);
        }

        override public function set height(_arg1:Number):void
        {
            super.height = _arg1;
            _field.text = RoomMeasure.px2cm(_line.height, false).toFixed(0);
            _field.y = (_line.y + ((_line.height - _field.height) >> 1));
            this._topMarker.y = _line.y;
            this._botMarker.y = (_line.y + _line.height);
            if ((((RoomMeasure.px2cm(_line.height, false) < 1)) || ((RoomMeasure.px2cm(_line.height, false) > 50))))
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

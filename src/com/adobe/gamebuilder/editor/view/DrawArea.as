package com.adobe.gamebuilder.editor.view
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.model.data.Extrema;
    import com.adobe.gamebuilder.editor.view.comps.MarkerOrganizer;
    import com.adobe.gamebuilder.editor.view.comps.MeasureField;
    import com.adobe.gamebuilder.editor.view.comps.MeasureFieldDispenser;
    import com.adobe.gamebuilder.editor.view.comps.MeasureLine;
    import com.adobe.gamebuilder.editor.view.comps.MeasureLineDispenser;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    import com.adobe.gamebuilder.editor.view.layout.PointAlign;
    import com.adobe.gamebuilder.editor.view.parts.RoomPoint;
    
    import flash.geom.Point;
    
    import __AS3__.vec.Vector;
    
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;
    import starling.utils.deg2rad;
    import starling.utils.rad2deg;

    public class DrawArea extends DisplayObjectContainer 
    {

        private const MEASURE_MARGIN:int = 40;
        private const FIELD_VERTICAL_MARGIN:int = 5;
        private const FIELD_HORIZONTAL_MARGIN:int = 10;

        private var _measureFieldDispenser:MeasureFieldDispenser;
        private var _lineDispenser:MeasureLineDispenser;
        private var _markerDispenser:MeasureLineDispenser;
        private var _markerOrganizer:MarkerOrganizer;
        private var _mainDrawed:Boolean;

        public function DrawArea()
        {
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        private function init(_arg1:Event):void
        {
            this._measureFieldDispenser = new MeasureFieldDispenser(this);
            this._markerDispenser = new MeasureLineDispenser(this, 24, 12, 1);
            this._lineDispenser = new MeasureLineDispenser(this, 0x0400, 0, 1);
            this._markerOrganizer = new MarkerOrganizer();
        }

        public function reset():void
        {
        }

        public function drawMeasure(_arg1:Room):void
        {
            this._markerDispenser.reset();
            this._markerDispenser.hideAll();
            if (Common.appStep == Constants.STEP_FINALIZE)
            {
                this._lineDispenser.hideAll();
                this._measureFieldDispenser.hideAll();
            }
            else
            {
                this._lineDispenser.showAll();
                if (Common.appStep == Constants.STEP_ROOM)
                {
                    this._markerOrganizer.resetMarkers("all");
                    this.drawRoomMeasure(_arg1);
                    this._mainDrawed = false;
                }
                else
                {
                    if (!this._mainDrawed)
                    {
                        this._markerOrganizer.resetMarkers("all");
                        this.drawRoomMeasure(_arg1);
                        this._mainDrawed = true;
                    }
                    else
                    {
                        this._markerOrganizer.showMarkers("main");
                        this._markerOrganizer.showMarkers("inter");
                        this._markerOrganizer.resetMarkers("opening");
                        this._markerDispenser.reset(this._markerOrganizer.getLength("main", "inter"));
                    };
                };
                if ((((Common.appStep == Constants.STEP_OPENINGS)) || ((Common.appStep == Constants.STEP_PRODUCTS))))
                {
                    this.drawOpeningMeasure(_arg1);
                };
                this.positionMeasureFields();
            };
        }

        private function drawRoomMeasure(_arg1:Room):void
        {
            var _local3:RoomPoint;
            var _local2:Extrema = _arg1.pointManager.getExtrema();
            this._lineDispenser.getItemAt(0).width = ((_local2.horMax - _local2.horMin) - RoomMeasure.WALL_SIZE);
            this._lineDispenser.getItemAt(0).rotation = 0;
            this._lineDispenser.getItemAt(0).setPosition((_local2.horMin + (RoomMeasure.WALL_SIZE >> 1)), (_local2.verMin - this.MEASURE_MARGIN));
            this.setMarker(this._lineDispenser.getItemAt(0).x, this._lineDispenser.getItemAt(0).y, deg2rad(90), "top");
            this.setMarker((this._lineDispenser.getItemAt(0).x + this._lineDispenser.getItemAt(0).width), this._lineDispenser.getItemAt(0).y, deg2rad(90), "top");
            this._lineDispenser.getItemAt(1).width = ((_local2.horMax - _local2.horMin) - RoomMeasure.WALL_SIZE);
            this._lineDispenser.getItemAt(1).rotation = 0;
            this._lineDispenser.getItemAt(1).setPosition((_local2.horMin + (RoomMeasure.WALL_SIZE >> 1)), (_local2.verMax + this.MEASURE_MARGIN));
            this.setMarker(this._lineDispenser.getItemAt(1).x, this._lineDispenser.getItemAt(1).y, deg2rad(90), "bottom");
            this.setMarker((this._lineDispenser.getItemAt(1).x + this._lineDispenser.getItemAt(1).width), this._lineDispenser.getItemAt(1).y, deg2rad(90), "bottom");
            this._lineDispenser.getItemAt(2).width = ((_local2.verMax - _local2.verMin) - RoomMeasure.WALL_SIZE);
            this._lineDispenser.getItemAt(2).rotation = deg2rad(90);
            this._lineDispenser.getItemAt(2).setPosition((_local2.horMin - this.MEASURE_MARGIN), (_local2.verMin + (RoomMeasure.WALL_SIZE >> 1)));
            this.setMarker(this._lineDispenser.getItemAt(2).x, this._lineDispenser.getItemAt(2).y, 0, "left");
            this.setMarker(this._lineDispenser.getItemAt(2).x, (this._lineDispenser.getItemAt(2).y + this._lineDispenser.getItemAt(2).height), 0, "left");
            this._lineDispenser.getItemAt(3).width = ((_local2.verMax - _local2.verMin) - RoomMeasure.WALL_SIZE);
            this._lineDispenser.getItemAt(3).rotation = deg2rad(90);
            this._lineDispenser.getItemAt(3).setPosition((_local2.horMax + this.MEASURE_MARGIN), (_local2.verMin + (RoomMeasure.WALL_SIZE >> 1)));
            this.setMarker(this._lineDispenser.getItemAt(3).x, this._lineDispenser.getItemAt(3).y, 0, "right");
            this.setMarker(this._lineDispenser.getItemAt(3).x, (this._lineDispenser.getItemAt(3).y + this._lineDispenser.getItemAt(3).height), 0, "right");
            _arg1.pointManager.sortPoints();
            _local3 = _arg1.pointManager.leftPoints[0].successor;
            while (_local3.x < _local2.horMax)
            {
                this.setMarker((_local3.x + (((_local3.hAlign)==PointAlign.LEFT) ? RoomMeasure.WALL_SIZE_HALF : -(RoomMeasure.WALL_SIZE_HALF))), this._lineDispenser.getItemAt(0).y, deg2rad(90), "top");
                _local3 = _local3.successor;
            };
            _local3 = _arg1.pointManager.topPoints[(_arg1.pointManager.topPoints.length - 1)].successor;
            while (_local3.y < _local2.verMax)
            {
                this.setMarker(this._lineDispenser.getItemAt(3).x, (_local3.y + (((_local3.vAlign)==PointAlign.TOP) ? RoomMeasure.WALL_SIZE_HALF : -(RoomMeasure.WALL_SIZE_HALF))), 0, "right");
                _local3 = _local3.successor;
            };
            _local3 = _arg1.pointManager.rightPoints[(_arg1.pointManager.rightPoints.length - 1)].successor;
            while (_local3.x > _local2.horMin)
            {
                this.setMarker((_local3.x + (((_local3.hAlign)==PointAlign.LEFT) ? RoomMeasure.WALL_SIZE_HALF : -(RoomMeasure.WALL_SIZE_HALF))), this._lineDispenser.getItemAt(1).y, deg2rad(90), "bottom");
                _local3 = _local3.successor;
            };
            _local3 = _arg1.pointManager.botPoints[0].successor;
            while (_local3.y > _local2.verMin)
            {
                this.setMarker(this._lineDispenser.getItemAt(2).x, (_local3.y + (((_local3.vAlign)==PointAlign.TOP) ? RoomMeasure.WALL_SIZE_HALF : -(RoomMeasure.WALL_SIZE_HALF))), 0, "left");
                _local3 = _local3.successor;
            };
        }

        private function drawOpeningMeasure(_arg1:Room):void
        {
            var _local3:Number;
            var _local4:String;
            var _local5:String;
            var _local6:Point;
            var _local7:Point;
            var _local8:Opening;
            var _local2:Extrema = _arg1.pointManager.getExtrema();
            var _local9:int;
            while (_local9 < _arg1.openingManager.length)
            {
                _local8 = _arg1.openingManager.getItemAt(_local9);
                _local3 = rad2deg(_local8.point.roomLine.rotation);
                _local6 = _arg1.globalToLocal(_local8.point.roomLine.localToGlobal(new Point(_local8.x, _local8.y)));
                _local7 = _arg1.globalToLocal(_local8.point.roomLine.localToGlobal(new Point((_local8.x + _local8.width), _local8.y)));
                if ((((((((-45 < _local3)) && ((_local3 < 45)))) || ((((135 < _local3)) && ((_local3 < 225)))))) || ((((-225 < _local3)) && ((_local3 < -135))))))
                {
                    _local4 = "hor";
                    if (((_local6.y + _local7.y) >> 1) < (_local2.verMin + ((_local2.verMax - _local2.verMin) / 2)))
                    {
                        _local5 = "top";
                    }
                    else
                    {
                        _local5 = "bottom";
                    };
                }
                else
                {
                    _local4 = "ver";
                    if (((_local6.x + _local7.x) >> 1) < (_local2.horMin + ((_local2.horMax - _local2.horMin) / 2)))
                    {
                        _local5 = "left";
                    }
                    else
                    {
                        _local5 = "right";
                    };
                };
                if (_local4 == "hor")
                {
                    this.setMarker(_local6.x, (((_local5)=="top") ? this._lineDispenser.getItemAt(0).y : this._lineDispenser.getItemAt(1).y), deg2rad(90), _local5, "opening");
                    this.setMarker(_local7.x, (((_local5)=="top") ? this._lineDispenser.getItemAt(0).y : this._lineDispenser.getItemAt(1).y), deg2rad(90), _local5, "opening");
                }
                else
                {
                    this.setMarker((((_local5)=="left") ? this._lineDispenser.getItemAt(2).x : this._lineDispenser.getItemAt(3).x), _local6.y, 0, _local5, "opening");
                    this.setMarker((((_local5)=="left") ? this._lineDispenser.getItemAt(2).x : this._lineDispenser.getItemAt(3).x), _local7.y, 0, _local5, "opening");
                };
                _local9++;
            };
        }

        private function positionMeasureFields():void
        {
            var _local1:int;
            var _local2:MeasureField;
            var _local3:Vector.<MeasureLine>;
            this._measureFieldDispenser.reset();
            this._measureFieldDispenser.hideAll();
            _local3 = this._markerOrganizer.getMarkersAtPosition("top");
            _local1 = 1;
            while (_local1 < _local3.length)
            {
                _local2 = this._measureFieldDispenser.getNextItem();
                _local2.text = RoomMeasure.measureDisplay(Math.abs((_local3[_local1].x - _local3[(_local1 - 1)].x)));
                _local2.setPosition((((_local3[_local1].x + _local3[(_local1 - 1)].x) - _local2.width) >> 1), ((_local3[_local1].y - _local2.height) - this.FIELD_VERTICAL_MARGIN));
                _local1++;
            };
            _local3 = this._markerOrganizer.getMarkersAtPosition("bottom");
            _local1 = 1;
            while (_local1 < _local3.length)
            {
                _local2 = this._measureFieldDispenser.getNextItem();
                _local2.text = RoomMeasure.measureDisplay(Math.abs((_local3[_local1].x - _local3[(_local1 - 1)].x)));
                _local2.setPosition((((_local3[_local1].x + _local3[(_local1 - 1)].x) - _local2.width) >> 1), (_local3[_local1].y + this.FIELD_VERTICAL_MARGIN));
                _local1++;
            };
            _local3 = this._markerOrganizer.getMarkersAtPosition("left");
            _local1 = 1;
            while (_local1 < _local3.length)
            {
                _local2 = this._measureFieldDispenser.getNextItem();
                _local2.text = RoomMeasure.measureDisplay(Math.abs((_local3[_local1].y - _local3[(_local1 - 1)].y)));
                _local2.setPosition(((_local3[_local1].x - _local2.width) - this.FIELD_HORIZONTAL_MARGIN), (((_local3[_local1].y + _local3[(_local1 - 1)].y) - _local2.height) >> 1));
                _local1++;
            };
            _local3 = this._markerOrganizer.getMarkersAtPosition("right");
            _local1 = 1;
            while (_local1 < _local3.length)
            {
                _local2 = this._measureFieldDispenser.getNextItem();
                _local2.text = RoomMeasure.measureDisplay(Math.abs((_local3[_local1].y - _local3[(_local1 - 1)].y)));
                _local2.setPosition((_local3[_local1].x + this.FIELD_HORIZONTAL_MARGIN), (((_local3[_local1].y + _local3[(_local1 - 1)].y) - _local2.height) >> 1));
                _local1++;
            };
        }

        private function setMarker(_arg1:int, _arg2:int, _arg3:Number, _arg4:String, _arg5:String="main"):void
        {
            var _local6:MeasureLine = this._markerDispenser.getNextItem();
            _local6.setPosition(_arg1, _arg2);
            _local6.rotation = _arg3;
            this._markerOrganizer.addMarker(_local6, _arg4, _arg5);
        }


    }
}//package at.polypex.badplaner.view

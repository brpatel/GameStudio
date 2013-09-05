package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.view.comps.HorizontalDistanceLine;
    import com.adobe.gamebuilder.editor.view.comps.VerticalDistanceLine;
    import com.adobe.gamebuilder.editor.view.manager.PointManager;
    import com.adobe.gamebuilder.util.Utils;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class DistanceCross extends DisplayObjectContainer 
    {

        private var _leftLine:HorizontalDistanceLine;
        private var _rightLine:HorizontalDistanceLine;
        private var _topLine:VerticalDistanceLine;
        private var _botLine:VerticalDistanceLine;
        private var _productBounds:Rectangle;

        public function DistanceCross()
        {
            this.touchable = false;
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get productBounds():Rectangle
        {
            return (this._productBounds);
        }

        public function set productBounds(_arg1:Rectangle):void
        {
            this._productBounds = _arg1;
        }

        private function init(_arg1:Event):void
        {
            this._leftLine = new HorizontalDistanceLine();
            addChild(this._leftLine);
            this._rightLine = new HorizontalDistanceLine();
            addChild(this._rightLine);
            this._topLine = new VerticalDistanceLine();
            addChild(this._topLine);
            this._botLine = new VerticalDistanceLine();
            addChild(this._botLine);
        }

        public function setTopLine(_arg1:Number):void
        {
            this._topLine.height = ((this.y - (this.productBounds.height >> 1)) - _arg1);
            this._topLine.y = (-((this.productBounds.height >> 1)) - this._topLine.height);
        }

        public function setBotLine(_arg1:Number):void
        {
            this._botLine.height = (_arg1 - (this.y + (this.productBounds.height >> 1)));
            this._botLine.y = (this.productBounds.height >> 1);
        }

        public function setLeftLine(_arg1:Number):void
        {
            this._leftLine.width = ((this.x - (this.productBounds.width >> 1)) - _arg1);
            this._leftLine.x = (-((this.productBounds.width >> 1)) - this._leftLine.width);
        }

        public function setRightLine(_arg1:Number):void
        {
            this._rightLine.width = (_arg1 - (this.x + (this.productBounds.width >> 1)));
            this._rightLine.x = (this.productBounds.width >> 1);
        }

        public function showDistances(_arg1:Product, _arg2:PointManager):void
        {
            var _local3:int;
            var _local6:RoomPoint;
            var _local7:Point;
            var _local4:Array = [];
            var _local5:Array = [];
            _local3 = 0;
            while (_local3 < _arg2.length)
            {
                _local6 = _arg2.getItemAt(_local3);
                if ((((((_local6.x < x)) && ((_local6.successor.x > x)))) || ((((_local6.x > x)) && ((_local6.successor.x < x))))))
                {
                    _local4.push(_local6);
                };
                if ((((((_local6.y < y)) && ((_local6.successor.y > y)))) || ((((_local6.y > y)) && ((_local6.successor.y < y))))))
                {
                    _local5.push(_local6);
                };
                _local3++;
            };
            var _local8:Array = [];
            var _local9:Array = [];
            var _local10:Array = [];
            var _local11:Array = [];
            _local3 = 0;
            while (_local3 < _local4.length)
            {
                _local6 = _local4[_local3];
                _local7 = Utils.lineIntersectLine(new Point(_local6.x, (_local6.y + RoomMeasure.WALL_SIZE_HALF)), new Point(_local6.successor.x, (_local6.successor.y + RoomMeasure.WALL_SIZE_HALF)), new Point(x, (y - (this.productBounds.height >> 1))), new Point(x, (y - 1000)));
                if (_local7 != null)
                {
                    _local8.push(_local7);
                };
                _local7 = Utils.lineIntersectLine(new Point(_local6.x, (_local6.y - RoomMeasure.WALL_SIZE_HALF)), new Point(_local6.successor.x, (_local6.successor.y - RoomMeasure.WALL_SIZE_HALF)), new Point(x, (y + (this.productBounds.height >> 1))), new Point(x, (y + 1000)));
                if (_local7 != null)
                {
                    _local9.push(_local7);
                };
                _local3++;
            };
            _local3 = 0;
            while (_local3 < _local5.length)
            {
                _local6 = _local5[_local3];
                _local7 = Utils.lineIntersectLine(new Point((_local6.x + RoomMeasure.WALL_SIZE_HALF), _local6.y), new Point((_local6.successor.x + RoomMeasure.WALL_SIZE_HALF), _local6.successor.y), new Point((x - (this.productBounds.width >> 1)), y), new Point((x - 1000), y));
                if (_local7 != null)
                {
                    _local10.push(_local7);
                };
                _local7 = Utils.lineIntersectLine(new Point((_local6.x - RoomMeasure.WALL_SIZE_HALF), _local6.y), new Point((_local6.successor.x - RoomMeasure.WALL_SIZE_HALF), _local6.successor.y), new Point((x + (this.productBounds.width >> 1)), y), new Point((x + 1000), y));
                if (_local7 != null)
                {
                    _local11.push(_local7);
                };
                _local3++;
            };
            if (_local8.length > 0)
            {
                if (_local8.length > 1)
                {
                    _local8.sortOn("y", (Array.DESCENDING | Array.NUMERIC));
                };
                this.setTopLine((_local8[0] as Point).y);
            }
            else
            {
                this._topLine.hide();
            };
            if (_local9.length > 0)
            {
                if (_local9.length > 1)
                {
                    _local9.sortOn("y", Array.NUMERIC);
                };
                this.setBotLine((_local9[0] as Point).y);
            }
            else
            {
                this._botLine.hide();
            };
            if (_local10.length > 0)
            {
                if (_local10.length > 1)
                {
                    _local10.sortOn("x", (Array.DESCENDING | Array.NUMERIC));
                };
                this.setLeftLine((_local10[0] as Point).x);
            }
            else
            {
                this._leftLine.hide();
            };
            if (_local11.length > 0)
            {
                if (_local11.length > 1)
                {
                    _local11.sortOn("x", Array.NUMERIC);
                };
                this.setRightLine((_local11[0] as Point).x);
            }
            else
            {
                this._rightLine.hide();
            };
        }


    }
}//package at.polypex.badplaner.view.parts

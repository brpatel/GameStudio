//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.display
{
    import starling.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import starling.utils.MatrixUtil;
    import starling.display.DisplayObject;
    import starling.core.Starling;
    import starling.core.RenderSupport;

    public class Sprite extends starling.display.Sprite implements IDisplayObjectWithScrollRect 
    {

        private static var helperPoint:Point = new Point();
        private static var helperMatrix:Matrix = new Matrix();
        private static var helperRect:Rectangle = new Rectangle();

        private var _scrollRect:Rectangle;
        private var _scaledScrollRectXY:Point;
        private var _scissorRect:Rectangle;


        public function get scrollRect():Rectangle
        {
            return (this._scrollRect);
        }

        public function set scrollRect(_arg1:Rectangle):void
        {
            this._scrollRect = _arg1;
            if (this._scrollRect)
            {
                if (!this._scaledScrollRectXY)
                {
                    this._scaledScrollRectXY = new Point();
                };
                if (!this._scissorRect)
                {
                    this._scissorRect = new Rectangle();
                };
            }
            else
            {
                this._scaledScrollRectXY = null;
                this._scissorRect = null;
            };
        }

        override public function getBounds(_arg1:DisplayObject, _arg2:Rectangle=null):Rectangle
        {
            if (this._scrollRect)
            {
                if (!_arg2)
                {
                    _arg2 = new Rectangle();
                };
                if (_arg1 == this)
                {
                    _arg2.x = 0;
                    _arg2.y = 0;
                    _arg2.width = this._scrollRect.width;
                    _arg2.height = this._scrollRect.height;
                }
                else
                {
                    this.getTransformationMatrix(_arg1, helperMatrix);
                    MatrixUtil.transformCoords(helperMatrix, 0, 0, helperPoint);
                    _arg2.x = helperPoint.x;
                    _arg2.y = helperPoint.y;
                    _arg2.width = ((helperMatrix.a * this._scrollRect.width) + (helperMatrix.c * this._scrollRect.height));
                    _arg2.height = ((helperMatrix.d * this._scrollRect.height) + (helperMatrix.b * this._scrollRect.width));
                };
                return (_arg2);
            };
            return (super.getBounds(_arg1, _arg2));
        }

        override public function render(_arg1:RenderSupport, _arg2:Number):void
        {
            var _local4:Number;
            var _local5:Rectangle;
            var _local3:Boolean = true;
            if (this._scrollRect)
            {
                _arg1.finishQuadBatch();
                _local4 = Starling.contentScaleFactor;
                this.getBounds(this.stage, this._scissorRect);
                this._scissorRect.x = (this._scissorRect.x * _local4);
                this._scissorRect.y = (this._scissorRect.y * _local4);
                this._scissorRect.width = (this._scissorRect.width * _local4);
                this._scissorRect.height = (this._scissorRect.height * _local4);
                this.getTransformationMatrix(this.stage, helperMatrix);
                this._scaledScrollRectXY.x = (this._scrollRect.x * helperMatrix.a);
                this._scaledScrollRectXY.y = (this._scrollRect.y * helperMatrix.d);
                _local5 = ScrollRectManager.currentScissorRect;
                if (_local5)
                {
                    this._scissorRect.x = (this._scissorRect.x + (ScrollRectManager.scrollRectOffsetX * _local4));
                    this._scissorRect.y = (this._scissorRect.y + (ScrollRectManager.scrollRectOffsetY * _local4));
                    this._scissorRect = this._scissorRect.intersection(_local5);
                };
                if ((((this._scissorRect.width < 1)) || ((this._scissorRect.height < 1))))
                {
                    _local3 = false;
                };
                Starling.context.setScissorRectangle(this._scissorRect);
                ScrollRectManager.currentScissorRect = this._scissorRect;
                ScrollRectManager.scrollRectOffsetX = (ScrollRectManager.scrollRectOffsetX - this._scaledScrollRectXY.x);
                ScrollRectManager.scrollRectOffsetY = (ScrollRectManager.scrollRectOffsetY - this._scaledScrollRectXY.y);
                _arg1.translateMatrix(-(this._scrollRect.x), -(this._scrollRect.y));
            };
            if (_local3)
            {
                super.render(_arg1, _arg2);
            };
            if (this._scrollRect)
            {
                _arg1.finishQuadBatch();
                _arg1.translateMatrix(this._scrollRect.x, this._scrollRect.y);
                ScrollRectManager.scrollRectOffsetX = (ScrollRectManager.scrollRectOffsetX + this._scaledScrollRectXY.x);
                ScrollRectManager.scrollRectOffsetY = (ScrollRectManager.scrollRectOffsetY + this._scaledScrollRectXY.y);
                ScrollRectManager.currentScissorRect = _local5;
                Starling.context.setScissorRectangle(_local5);
            };
        }

        override public function hitTest(_arg1:Point, _arg2:Boolean=false):DisplayObject
        {
            var _local3:DisplayObject;
            if (this._scrollRect)
            {
                if (this.getBounds(this, helperRect).containsPoint(_arg1))
                {
                    _arg1.x = (_arg1.x + this._scrollRect.x);
                    _arg1.y = (_arg1.y + this._scrollRect.y);
                    _local3 = super.hitTest(_arg1, _arg2);
                    _arg1.x = (_arg1.x - this._scrollRect.x);
                    _arg1.y = (_arg1.y - this._scrollRect.y);
                    return (_local3);
                };
                return (null);
            };
            return (super.hitTest(_arg1, _arg2));
        }


    }
}//package org.josht.starling.display

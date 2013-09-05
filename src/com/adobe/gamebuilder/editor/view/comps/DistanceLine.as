package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.core.Constants;
    
    import starling.display.Quad;
    import starling.display.Sprite;

    public class DistanceLine extends Sprite 
    {

        protected var _line:Quad;
        protected var _field:MeasureField;

        public function DistanceLine()
        {
            this.touchable = false;
            this.init();
        }

        public function init():void
        {
            this._line = new Quad(Constants.DISTANCE_LINE_SIZE, Constants.DISTANCE_LINE_SIZE, 0xCC0000, true);
            addChild(this._line);
            this._field = new MeasureField();
            addChild(this._field);
        }

        override public function set width(_arg1:Number):void
        {
            this._line.width = _arg1;
        }

        override public function get width():Number
        {
            return (this._line.width);
        }

        override public function set height(_arg1:Number):void
        {
            this._line.height = _arg1;
        }

        override public function get height():Number
        {
            return (this._line.height);
        }

        public function hide():void
        {
            this.visible = false;
        }

        public function show():void
        {
            this.visible = true;
        }


    }
}//package at.polypex.badplaner.view.comps

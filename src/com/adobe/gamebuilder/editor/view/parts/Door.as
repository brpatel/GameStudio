package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    import com.adobe.gamebuilder.editor.view.layout.ReflectionAxis;
    
    import org.josht.starling.display.Scale3Image;
    import org.josht.starling.textures.Scale3Textures;
    
    import starling.display.Image;
    import starling.textures.TextureSmoothing;

    public class Door extends Opening 
    {

        private var _img1:Image;
        private var _img2:Scale3Image;
        private var wi:int;

        public function Door(_arg1:RoomPoint=null)
        {
            super(_arg1);
            this._img1 = new Image(Assets.getTextureAtlas("Interface").getTexture("door_part"));
            this._img1.width = RoomMeasure.cm2px(Opening.DEFAULT_SIZE);
            this._img1.height = RoomMeasure.cm2px(Opening.DEFAULT_SIZE);
            this.wi = this._img1.width;
            this._img1.y = -(this._img1.height);
            addChild(this._img1);
            this._img2 = new Scale3Image(new Scale3Textures(Assets.getTextureAtlas("Interface").getTexture("window"), 2, 8));
            this._img2.smoothing = TextureSmoothing.NONE;
            this._img2.width = RoomMeasure.cm2px(Opening.DEFAULT_SIZE);
            addChild(this._img2);
            pivotX = 0;
            pivotY = RoomMeasure.WALL_SIZE_HALF;
        }

        override public function setSize(_arg1:Number, _arg2:Number):void
        {
            this.wi = _arg1;
            this._img1.width = (horizontalReflectionState * this.wi);
            this._img1.height = (verticalReflectionState * this.wi);
            this._img1.x = (((horizontalReflectionState)==1) ? 0 : this.wi);
            this._img1.y = (((verticalReflectionState)==1) ? -(this._img1.height) : (this._img2.height + this._img1.height));
            this._img2.width = _arg1;
        }

        override public function set width(_arg1:Number):void
        {
            this.setSize(_arg1, _arg1);
        }

        override public function set horizontalReflectionState(_arg1:int):void
        {
            _horizontalReflectionState = _arg1;
        }

        override public function set verticalReflectionState(_arg1:int):void
        {
            _verticalReflectionState = _arg1;
        }

        override public function reflect(_arg1:String):void
        {
            if (_arg1 == ReflectionAxis.HORIZONTAL)
            {
                _horizontalReflectionState = -(_horizontalReflectionState);
                this.setSize(this.wi, this.wi);
            }
            else
            {
                if (_arg1 == ReflectionAxis.VERTICAL)
                {
                    _verticalReflectionState = -(_verticalReflectionState);
                    this.setSize(this.wi, this.wi);
                };
            };
        }


    }
}//package at.polypex.badplaner.view.parts

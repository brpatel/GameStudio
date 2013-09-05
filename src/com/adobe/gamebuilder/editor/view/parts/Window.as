package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    
    import org.josht.starling.display.Scale3Image;
    import org.josht.starling.textures.Scale3Textures;
    
    import starling.display.Quad;
    import starling.textures.TextureSmoothing;

    public class Window extends Opening 
    {

        private var _img:Scale3Image;
        private var _sensor:Quad;

        public function Window(_arg1:RoomPoint=null)
        {
            super(_arg1);
            this._img = new Scale3Image(new Scale3Textures(Assets.getTextureAtlas("Interface").getTexture("window"), 2, 8));
            this._img.width = RoomMeasure.cm2px(Opening.DEFAULT_SIZE);
            this._img.smoothing = TextureSmoothing.NONE;
            addChild(this._img);
            this._sensor = new Quad(this._img.width, (RoomMeasure.WALL_SIZE * 2), 0xFF0000);
            this._sensor.y = int((-((this._sensor.height - this._img.height)) >> 1));
            this._sensor.alpha = 0;
            addChild(this._sensor);
            pivotX = 0;
            pivotY = RoomMeasure.WALL_SIZE_HALF;
        }

        override public function setSize(_arg1:Number, _arg2:Number):void
        {
            this._img.width = _arg1;
            this._sensor.width = _arg1;
        }

        override public function set width(_arg1:Number):void
        {
            this.setSize(_arg1, _arg1);
        }


    }
}//package at.polypex.badplaner.view.parts

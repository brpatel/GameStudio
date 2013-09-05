package com.adobe.gamebuilder.editor.view.comps.buttons
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.starter.myAssets;
    
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;

    public class DesignImageButton extends Sprite 
    {

        private var _bg:Quad;
        private var _img:Image;
        private var _onRelease:Signal;
        private var _iconTexture:Texture;
        private var _iconDownTexture:Texture;
        private var _enabled:Boolean = true;

        public function DesignImageButton(_arg1:String, _arg2:int=0, _arg3:int=0, _arg4:Boolean=true)
        {
		   if (_arg4)
            {
				if(_arg1 == "play")
					this._iconTexture = (this._iconDownTexture = myAssets.getTexture("play"));
				else if(_arg1 == "design")
					this._iconTexture = (this._iconDownTexture = myAssets.getTexture("design"));
            }
            else
            {
                this._iconTexture = Assets.getTextureAtlas("Interface").getTexture((_arg1 + "_up"));
                this._iconDownTexture = Assets.getTextureAtlas("Interface").getTexture((_arg1 + "_down"));
            };
			this._onRelease = new Signal(DesignImageButton);
            this._img = new Image(this._iconTexture);
            this._img.touchable = false;
            addChild(this._img);
            this._bg = new Quad((((_arg2)>0) ? _arg2 : this._img.width), (((_arg3)>0) ? _arg3 : this._img.height), 0);
            this._bg.touchable = true;
            this._bg.alpha = 0;
            addChildAt(this._bg, 0);
            if (_arg2 > 0)
            {
                this._img.x = int(((_arg2 - this._img.width) >> 1));
            };
            if (_arg3 > 0)
            {
                this._img.y = int(((_arg3 - this._img.height) >> 1));
            };
            this._bg.addEventListener(TouchEvent.TOUCH, this.onTouch);
        }
		
		

      
        override public function get width():Number
        {
            return (this._img.width);
        }

        override public function get height():Number
        {
            return (this._img.height);
        }

        public function get onRelease():Signal
        {
            return (this._onRelease);
        }

        private function onTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(this);
            if (((!((_local2 == null))) && (this._enabled)))
            {
                if (_local2.phase == TouchPhase.BEGAN)
                {
                    this._img.texture = this._iconDownTexture;
                }
                else
                {
                    if (_local2.phase == TouchPhase.ENDED)
                    {
                        this._onRelease.dispatch(this);
                        this._img.texture = this._iconTexture;
                    };
                };
            };
        }


    }
}//package at.polypex.badplaner.view.comps.buttons

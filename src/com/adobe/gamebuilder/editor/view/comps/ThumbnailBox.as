package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlackButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    
    import flash.display.BitmapData;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    import starling.utils.HAlign;

    public class ThumbnailBox extends Sprite 
    {

        public static const WIDTH:uint = 179;
        public static const HEIGHT:uint = 133;
        public static const IMAGE_PADDING:uint = 5;
        public static const BOX_HOR_MARGIN:uint = 42;
        public static const BOX_VER_MARGIN:uint = 77;

        private var _onRelease:Signal;
        private var _storedPlan:Object;
        private var _fileName:String;
        private var _label:TextField;
        private var _bg:Image;
        private var _btnDelete:ImageButton;
        private var _onDelete:Signal;
        private var _btnFinalDelete:BlackButton;

        public function ThumbnailBox(_arg1:String)
        {
            this._fileName = _arg1;
            this._onRelease = new Signal(ThumbnailBox);
            this._onDelete = new Signal(ThumbnailBox);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemove);
            this._label = new TextField((WIDTH - 10), 35, "", Constants.DEFAULT_FONT, 13, Constants.DEFAULT_FONT_COLOR);
            this._label.hAlign = HAlign.CENTER;
            this._label.x = 5;
            this._label.y = 147;
            this._label.autoScale = true;
            addChild(this._label);
            this._bg = new Image(Assets.getTextureAtlas("Interface").getTexture("thumbnail_bg_up"));
            this._bg.smoothing = TextureSmoothing.NONE;
            this._bg.x = -20;
            this._bg.y = -19;
            addChild(this._bg);
            this._btnDelete = new ImageButton("delete_thumb");
            this._btnDelete.onRelease.add(this.btnDeleteOnRelease);
            this._btnDelete.x = (int((WIDTH - (this._btnDelete.width / 2))) - 1);
            this._btnDelete.y = (-(int((this._btnDelete.height / 2))) + 5);
            addChild(this._btnDelete);
            this._btnFinalDelete = new BlackButton();
            this._btnFinalDelete.onRelease.add(this.btnFinalDeleteOnRelease);
            this._btnFinalDelete.label = Common.getResourceString("btnDeleteLabel");
            this._btnFinalDelete.width = 115;
            this._btnFinalDelete.x = int(((WIDTH - this._btnFinalDelete.width) / 2));
            this._btnFinalDelete.y = int(((HEIGHT - this._btnFinalDelete.height) / 2));
            this._btnFinalDelete.visible = false;
            addChild(this._btnFinalDelete);
            this.loadPlan(_arg1);
        }

        private function onRemove():void
        {
            stage.removeEventListener(TouchEvent.TOUCH, this.onStageTouch);
            this.removeEventListener(TouchEvent.TOUCH, this.onTouch);
            this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemove);
        }

        public function get fileName():String
        {
            return (this._fileName);
        }

        public function get onRelease():Signal
        {
            return (this._onRelease);
        }

        public function get onDelete():Signal
        {
            return (this._onDelete);
        }

        public function get storedPlan():Object
        {
            return (this._storedPlan);
        }

        private function loadPlan(_arg1:String):void
        {
            var fileName:String = _arg1;
            var fs:FileStream = new FileStream();
            var file:File = File.documentsDirectory.resolvePath(fileName);
            var byteArray:ByteArray = new ByteArray();
            try
            {
                fs.open(file, FileMode.READ);
                fs.readBytes(byteArray);
                byteArray.uncompress();
                this._storedPlan = byteArray.readObject();
                fs.close();
                byteArray.clear();
                byteArray = null;
                this._bg.addEventListener(TouchEvent.TOUCH, this.onTouch);
                this._label.addEventListener(TouchEvent.TOUCH, this.onTouch);
            }
            catch(e:Error)
            {
                Common.log(((("ThumbnailBox.loadPlan(" + fileName) + "):") + e.message), "ERROR");
                _label.text = "LOAD ERROR\ncorrupted data";
            };
            if (this._storedPlan != null)
            {
                if (this._storedPlan.thumbnail != null)
                {
                    this.showThumb(this._storedPlan.thumbnail);
                };
                if (((!((this._storedPlan.name == null))) && (!((this._storedPlan.name == "")))))
                {
                    this._label.text = this._storedPlan.name;
                }
                else
                {
                    this._label.text = fileName;
                };
            };
        }

        private function showThumb(_arg1:Object):void
        {
            var bmd:BitmapData;
            var img:Image;
            var scale:Number;
            var thumbnail:Object = _arg1;
            try
            {
                bmd = new BitmapData(thumbnail.rect.width, thumbnail.rect.height, false);
                (thumbnail.data as ByteArray).position = 0;
                bmd.setPixels(new Rectangle(thumbnail.rect.x, thumbnail.rect.y, thumbnail.rect.width, thumbnail.rect.height), thumbnail.data);
                img = new Image(Texture.fromBitmapData(bmd));
                img.touchable = false;
                addChild(img);
                bmd.dispose();
                scale = Math.min(((WIDTH - (2 * IMAGE_PADDING)) / img.width), ((HEIGHT - (2 * IMAGE_PADDING)) / img.height));
                img.scaleX = scale;
                img.scaleY = scale;
                img.x = ((WIDTH - img.width) >> 1);
                img.y = ((HEIGHT - img.height) >> 1);
                this.setChildIndex(this._btnDelete, (numChildren - 1));
                this.setChildIndex(this._btnFinalDelete, (numChildren - 1));
            }
            catch(e:Error)
            {
                Common.log(("ThumbnailBox.showThumb:" + e.message), "ERROR");
            };
        }

        private function btnDeleteOnRelease(_arg1:ImageButton):void
        {
            this.showFinalDelete();
        }

        private function showFinalDelete():void
        {
            this._btnFinalDelete.visible = true;
            stage.addEventListener(TouchEvent.TOUCH, this.onStageTouch);
        }

        private function onStageTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage);
            if (((!((_local2 == null))) && ((_local2.phase == TouchPhase.BEGAN))))
            {
                if (_arg1.target != this._btnFinalDelete)
                {
                    this._btnFinalDelete.visible = false;
                    stage.removeEventListener(TouchEvent.TOUCH, this.onStageTouch);
                };
            };
        }

        private function btnFinalDeleteOnRelease(_arg1:Button):void
        {
            this._onDelete.dispatch(this);
        }

        private function onTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage);
            if (_local2 != null)
            {
                if (_local2.phase == TouchPhase.BEGAN)
                {
                    this._bg.texture = Assets.getTextureAtlas("Interface").getTexture("thumbnail_bg_selected");
                    this._btnFinalDelete.visible = false;
                }
                else
                {
                    if (_local2.phase == TouchPhase.ENDED)
                    {
                        this._bg.texture = Assets.getTextureAtlas("Interface").getTexture("thumbnail_bg_up");
                        if (this.getBounds(stage).contains(_local2.globalX, _local2.globalY))
                        {
                            this._onRelease.dispatch(this);
                        };
                    };
                };
            };
        }


    }
}//package at.polypex.badplaner.view.comps

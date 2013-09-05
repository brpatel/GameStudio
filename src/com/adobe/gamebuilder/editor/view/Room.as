package com.adobe.gamebuilder.editor.view
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.IGameEditor;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.model.data.BaseRoom;
    import com.adobe.gamebuilder.editor.storage.StoredRoom;
    import com.adobe.gamebuilder.editor.storage.StoredThumbnail;
    import com.adobe.gamebuilder.editor.view.comps.ThumbnailBox;
    import com.adobe.gamebuilder.editor.view.layout.ReflectionAxis;
    import com.adobe.gamebuilder.editor.view.manager.LoadManager;
    import com.adobe.gamebuilder.editor.view.manager.OpeningManager;
    import com.adobe.gamebuilder.editor.view.manager.OutlineManager;
    import com.adobe.gamebuilder.editor.view.manager.PointManager;
    import com.adobe.gamebuilder.editor.view.manager.ProductManager;
    import com.adobe.gamebuilder.editor.view.manager.SideManager;
    import com.adobe.gamebuilder.editor.view.parts.OpeningOutline;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    import com.adobe.gamebuilder.editor.view.states.ViewMode;
    
    import flash.display.BitmapData;
    import flash.display.PNGEncoderOptions;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    
    import org.osflash.signals.Signal;
    
    import starling.display.Sprite;
    import starling.events.Event;

    public class Room extends Sprite 
    {

        private var _sideManager:SideManager;
        private var _pointManager:PointManager;
        private var _productManager:ProductManager;
        private var _outlineManager:OutlineManager;
        private var _openingManager:OpeningManager;
        private var _loadManager:LoadManager;
        private var _resetSignal:Signal;
        private var _drawSignal:Signal;
        private var _initialComplete:Signal;
        private var _systemMessage:Signal;
        private var _storedStep:String;
        public var verticalReflectionState:int = 1;
        public var horizontalReflectionState:int = 1;

        public function Room()
        {
            this._drawSignal = new Signal();
            this._resetSignal = new Signal();
            this._initialComplete = new Signal(int);
            this._systemMessage = new Signal(SystemMessage);
            this._sideManager = new SideManager(this);
            this._pointManager = new PointManager(this);
            this._outlineManager = new OutlineManager(this);
            this._productManager = new ProductManager(this);
            this._openingManager = new OpeningManager(this);
            this._loadManager = new LoadManager(this);
        }

        public function get systemMessage():Signal
        {
            return (this._systemMessage);
        }

        public function get resetSignal():Signal
        {
            return (this._resetSignal);
        }

        public function get loadManager():LoadManager
        {
            return (this._loadManager);
        }

        public function get openingManager():OpeningManager
        {
            return (this._openingManager);
        }

        public function get outlineManager():OutlineManager
        {
            return (this._outlineManager);
        }

        public function get openingOutline():OpeningOutline
        {
            return (this._outlineManager.openingOutline);
        }

        public function get pointManager():PointManager
        {
            return (this._pointManager);
        }

        public function get productManager():ProductManager
        {
            return (this._productManager);
        }

        public function get sideManager():SideManager
        {
            return (this._sideManager);
        }

        public function get initialComplete():Signal
        {
            return (this._initialComplete);
        }

        public function get drawSignal():Signal
        {
            return (this._drawSignal);
        }

        public function screenChangeHandler(_arg1:String):void
        {
            if (_arg1 == Constants.STEP_ROOM)
            {
                this._pointManager.enableAll();
                this._sideManager.enableAll();
            }
            else
            {
                this._pointManager.disableAll();
                this._sideManager.disableAll();
            };
            this._pointManager.updateAll();
            this._drawSignal.dispatch();
        }

        public function reflect(_arg1:String, _arg2:int):void
        {
            if (_arg1 == ReflectionAxis.HORIZONTAL)
            {
                this.horizontalReflectionState = -(this.horizontalReflectionState);
            }
            else
            {
                if (_arg1 == ReflectionAxis.VERTICAL)
                {
                    this.verticalReflectionState = -(this.verticalReflectionState);
                };
            };
            this._pointManager.reflect(_arg1, _arg2);
            this._sideManager.reflect(_arg1, _arg2);
            this._drawSignal.dispatch();
        }

        private function resetReflectionState():void
        {
            this.horizontalReflectionState = 1;
            this.verticalReflectionState = 1;
        }

        public function addProduct(_arg1:MobileProductVO, _arg2:Point, _arg3:Number, _arg4:Number):void
        {
            var _local5:Product = new Product(_arg1);
            _local5.x = RoomMeasure.productPos((_arg2.x + _arg3));
            _local5.y = RoomMeasure.productPos((_arg2.y + _arg4));
            this._productManager.add(_local5);
        }

        private function resetRoom(_arg1:Boolean):void
        {
            if (_arg1)
            {
                (this.parent as Container).setPosition("zero");
            };
            this._outlineManager.hideProductOutline();
            this._outlineManager.hideOpeningOutline();
            this.resetReflectionState();
            this._pointManager.removeAll();
            this._sideManager.removeAll();
            this._productManager.removeAll();
            this._openingManager.removeAll();
            this._resetSignal.dispatch();
        }

        public function loadStoredRoom(_arg1:Object):void
        {
            this.resetRoom(true);
            Common.log(("loadStoredRoom, is StoredRoom=" + (_arg1 is StoredRoom)));
            if ((((_arg1 is StoredRoom)) && (((_arg1 as StoredRoom).version >= 4))))
            {
                this._loadManager.restoreRoom((_arg1 as StoredRoom));
                this._initialComplete.dispatch((_arg1 as StoredRoom).baseRoomID);
            }
            else
            {
                this._loadManager.importRoom(_arg1);
                this._initialComplete.dispatch(2);
            };
            this._drawSignal.dispatch();
        }

        private function prepareForScreenshot():void
        {
            this._storedStep = Common.appStep;
            Common.appStep = Constants.STEP_FINALIZE;
            this.screenChangeHandler(Constants.STEP_FINALIZE);
            this._outlineManager.hideOpeningOutline();
            this._outlineManager.hideProductOutline();
            (this.root as IGameEditor).switchViewMode(ViewMode.SCREENSHOT);
            this.addEventListener(Event.ENTER_FRAME, this.restoreAfterScreenshot);
        }

        private function restoreAfterScreenshot():void
        {
            this.removeEventListener(Event.ENTER_FRAME, this.restoreAfterScreenshot);
            (this.root as IGameEditor).switchViewMode(ViewMode.NORMAL);
            Common.appStep = this._storedStep;
            this.screenChangeHandler(this._storedStep);
        }

        public function getThumbnail():StoredThumbnail
        {
            var bmd:BitmapData;
            this.prepareForScreenshot();
            var roomBounds:Rectangle = this.getBounds(this.root);
            try
            {
                bmd = Common.getScreenshot(this.stage, stage.stageWidth, stage.stageHeight);
            }
            catch(e:Error)
            {
                Common.log(((((("[getScreenshot: " + stage.stageWidth) + "x") + stage.stageHeight) + "] ") + e.message), "ERROR");
            };
            var scale:Number = Math.min(((ThumbnailBox.WIDTH - (2 * ThumbnailBox.IMAGE_PADDING)) / roomBounds.width), ((ThumbnailBox.HEIGHT - (2 * ThumbnailBox.IMAGE_PADDING)) / roomBounds.height));
            var drawBA:BitmapData = new BitmapData((roomBounds.width * scale), (roomBounds.height * scale), false);
            var matrix:Matrix = new Matrix(1, 0, 0, 1, -(roomBounds.x), -(roomBounds.y));
            matrix.scale(scale, scale);
            drawBA.draw(bmd, matrix, null, null, null, true);
            var thumbnail:StoredThumbnail = new StoredThumbnail();
            thumbnail.data = drawBA.getPixels(drawBA.rect);
            thumbnail.rect = drawBA.rect;
            bmd.dispose();
            return (thumbnail);
        }

        public function getPlanImage():ByteArray
        {
            var bmd:BitmapData;
            this.prepareForScreenshot();
            try
            {
                bmd = Common.getScreenshot(this.stage, stage.stageWidth, stage.stageHeight);
            }
            catch(e:Error)
            {
                Common.log(((((("[getScreenshot: " + stage.stageWidth) + "x") + stage.stageHeight) + "] ") + e.message), "ERROR");
            };
            var roomBounds:Rectangle = this.getBounds(this.root);
            var drawBA:BitmapData = new BitmapData(roomBounds.width, roomBounds.height, false);
            var matrix:Matrix = new Matrix(1, 0, 0, 1, -(roomBounds.x), -(roomBounds.y));
            drawBA.draw(bmd, matrix, null, null, null, true);
            var ba:ByteArray = bmd.encode(roomBounds, new PNGEncoderOptions());
            return (ba);
        }

        public function loadBaseRoom(_arg1:BaseRoom, _arg2:Boolean=true):void
        {
            this.resetRoom(_arg2);
            this._loadManager.loadBaseRoom(_arg1);
            this._initialComplete.dispatch(-1);
            this._drawSignal.dispatch();
        }


    }
}//package at.polypex.badplaner.view

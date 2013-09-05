package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.view.comps.ThumbnailBox;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    
    import flash.filesystem.File;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.foxhole.controls.ScrollContainer;
    import org.osflash.signals.Signal;

    public class LoadPlanOverlay extends Overlay 
    {

        private var _btnCancel:Button;
        private var _loadPlan:Signal;
        private var _iconBtnCancel:ImageButton;
        private var _scrollContainer:ScrollContainer;

        public function LoadPlanOverlay(_arg1:OverlayConfig)
        {
            super(_arg1);
            this._loadPlan = new Signal(Object, String);
        }

        public function get loadPlan():Signal
        {
            return (this._loadPlan);
        }

        override protected function init():void
        {
            super.init();
            this._scrollContainer = new ScrollContainer();
            this._scrollContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            this._scrollContainer.x = 20;
            this._scrollContainer.y = 40;
            this._scrollContainer.width = (_config.width - (2 * this._scrollContainer.x));
            this._scrollContainer.height = ((_config.height - this._scrollContainer.y) - 10);
            addChild(this._scrollContainer);
            this.showFiles();
            this._iconBtnCancel = Overlay.iconBtnCancel();
            this._iconBtnCancel.onRelease.add(this.iconBtnCancelReleaseHandler);
            this.addChild(this._iconBtnCancel);
        }

        private function showFiles():void
        {
            var _local2:ThumbnailBox;
            this._scrollContainer.removeChildren();
            var _local1:Array = File.documentsDirectory.getDirectoryListing();
            var _local3:int = -1;
            var _local4:uint = Math.floor(((width - 40) / (ThumbnailBox.WIDTH + ThumbnailBox.BOX_HOR_MARGIN)));
            var _local5:uint = (((width - (_local4 * ThumbnailBox.WIDTH)) - ((_local4 - 1) * ThumbnailBox.BOX_HOR_MARGIN)) >> 1);
            var _local6:int;
            while (_local6 < _local1.length)
            {
                if ((_local1[_local6] as File).extension == "badplan")
                {
                    _local3++;
                    _local2 = new ThumbnailBox((_local1[_local6] as File).name);
                    _local2.x = ((_local5 - 20) + ((ThumbnailBox.BOX_HOR_MARGIN + ThumbnailBox.WIDTH) * (_local3 % _local4)));
                    _local2.y = (20 + ((ThumbnailBox.BOX_VER_MARGIN + ThumbnailBox.HEIGHT) * Math.floor((_local3 / _local4))));
                    _local2.onRelease.add(this.thumbReleaseHandler);
                    _local2.onDelete.add(this.thumbDeleteHandler);
                    this._scrollContainer.addChild(_local2);
                };
                _local6++;
            };
        }

        private function iconBtnCancelReleaseHandler(_arg1:ImageButton):void
        {
            prepareForExit();
        }

        private function thumbDeleteHandler(_arg1:ThumbnailBox):void
        {
            var _local2:File = File.documentsDirectory.resolvePath(_arg1.fileName);
            if (_local2.exists)
            {
                _local2.deleteFile();
                this.showFiles();
            };
        }

        private function thumbReleaseHandler(_arg1:ThumbnailBox):void
        {
            prepareForExit();
            this._loadPlan.dispatch(_arg1.storedPlan, _arg1.fileName);
        }


    }
}//package at.polypex.badplaner.view.overlays

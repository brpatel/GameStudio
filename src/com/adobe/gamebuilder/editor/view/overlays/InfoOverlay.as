package com.adobe.gamebuilder.editor.view.overlays
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    
    import org.josht.starling.display.TiledImage;
    import org.josht.starling.foxhole.controls.ScrollContainer;
    
    import starling.display.Image;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class InfoOverlay extends Overlay 
    {

        private const COL_WIDTH:uint = 459;
        private const PADDING:uint = 10;
        private const MARGIN:uint = 20;

        private var _iconBtnCancel:ImageButton;

        public function InfoOverlay(_arg1:OverlayConfig)
        {
            super(_arg1);
        }

        override protected function init():void
        {
            var _local2:uint;
            var _local4:Image;
            var _local6:TextField;
            super.init();
            var _local1:uint = int((((stage.stageWidth - (2 * this.COL_WIDTH)) - this.MARGIN) >> 1));
            _local2 = 10;
            var _local3:ScrollContainer = new ScrollContainer();
            _local3.scrollerProperties = {hasElasticEdges:true};
            _local3.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
            _local3.x = _local1;
            _local3.y = _local2;
            _local3.width = ((2 * this.COL_WIDTH) + this.MARGIN);
            _local3.height = ((stage.stageHeight - 20) - Constants.TOPBAR_HEIGHT);
            addChild(_local3);
            _local1 = 0;
            _local2 = 20;
            _local4 = new Image(Assets.getTextureAtlas("Interface").getTexture("polypexlogo"));
            _local4.x = (_local1 + this.PADDING);
            _local4.y = _local2;
            _local3.addChild(_local4);
            _local2 = ((_local2 + _local4.height) + 15);
            _local4 = new Image(Assets.getTextureAtlas("Interface").getTexture("polypex"));
            _local4.x = _local1;
            _local4.y = _local2;
            _local3.addChild(_local4);
            _local2 = ((_local2 + _local4.height) + 15);
            var _local5:uint = _local4.y;
            _local6 = new TextField((this.COL_WIDTH - this.PADDING), 30, Common.getResourceString("info_polypex_header"), Constants.BOLD_FONT, Constants.BOLD_FONT_SIZE, Constants.DEFAULT_FONT_COLOR);
            _local6.x = (_local1 + this.PADDING);
            _local6.y = _local2;
            _local6.hAlign = HAlign.LEFT;
            _local6.vAlign = VAlign.TOP;
            _local3.addChild(_local6);
            _local2 = ((_local2 + _local6.textBounds.height) + 12);
            _local6 = new TextField((this.COL_WIDTH - this.PADDING), 130, Common.getResourceString("info_polypex_text1"), Constants.DEFAULT_FONT, Constants.DEFAULT_FONT_SIZE, 0x666666);
            _local6.hAlign = HAlign.LEFT;
            _local6.vAlign = VAlign.TOP;
            _local6.x = (_local1 + this.PADDING);
            _local6.y = _local2;
            _local3.addChild(_local6);
            _local2 = ((_local2 + _local6.textBounds.height) + 12);
            _local6 = new TextField((this.COL_WIDTH - this.PADDING), 340, Common.getResourceString("info_polypex_text2"), Constants.DEFAULT_FONT, Constants.DEFAULT_FONT_SIZE, Constants.DEFAULT_FONT_COLOR);
            _local6.hAlign = HAlign.LEFT;
            _local6.vAlign = VAlign.TOP;
            _local6.x = (_local1 + this.PADDING);
            _local6.y = _local2;
            _local3.addChild(_local6);
            var _local7:TiledImage = new TiledImage(Assets.getTextureAtlas("Interface").getTexture("trenner"));
            _local7.width = 1;
            _local7.height = (_local3.height - 10);
            _local7.x = ((_local1 + (this.MARGIN / 2)) + this.COL_WIDTH);
            _local7.y = 10;
            _local3.addChild(_local7);
            _local1 = (_local1 + (this.MARGIN + this.COL_WIDTH));
            _local2 = 20;
            _local4 = new Image(Assets.getTextureAtlas("Interface").getTexture("palmelogo"));
            _local4.x = (_local1 + this.PADDING);
            _local4.y = (_local2 + 15);
            _local3.addChild(_local4);
            _local2 = ((_local2 + _local4.height) + 15);
            _local4 = new Image(Assets.getTextureAtlas("Interface").getTexture("palme"));
            _local4.x = _local1;
            _local4.y = _local5;
            _local3.addChild(_local4);
            _local2 = ((_local5 + _local4.height) + 15);
            _local6 = new TextField((this.COL_WIDTH - this.PADDING), 30, Common.getResourceString("info_palme_header"), Constants.BOLD_FONT, Constants.BOLD_FONT_SIZE, Constants.DEFAULT_FONT_COLOR);
            _local6.x = (_local1 + this.PADDING);
            _local6.y = _local2;
            _local6.hAlign = HAlign.LEFT;
            _local6.vAlign = VAlign.TOP;
            _local3.addChild(_local6);
            _local2 = ((_local2 + _local6.textBounds.height) + 12);
            _local6 = new TextField((this.COL_WIDTH - this.PADDING), 130, Common.getResourceString("info_palme_text1"), Constants.DEFAULT_FONT, Constants.DEFAULT_FONT_SIZE, 0x666666);
            _local6.hAlign = HAlign.LEFT;
            _local6.vAlign = VAlign.TOP;
            _local6.x = (_local1 + this.PADDING);
            _local6.y = _local2;
            _local3.addChild(_local6);
            _local2 = ((_local2 + _local6.textBounds.height) + 12);
            _local6 = new TextField((this.COL_WIDTH - this.PADDING), 340, Common.getResourceString("info_palme_text2"), Constants.DEFAULT_FONT, Constants.DEFAULT_FONT_SIZE, Constants.DEFAULT_FONT_COLOR);
            _local6.hAlign = HAlign.LEFT;
            _local6.vAlign = VAlign.TOP;
            _local6.x = (_local1 + this.PADDING);
            _local6.y = _local2;
            _local3.addChild(_local6);
            this._iconBtnCancel = Overlay.iconBtnCancel();
            this._iconBtnCancel.onRelease.add(this.btnCancelReleaseHandler);
            this.addChild(this._iconBtnCancel);
        }

        private function btnCancelReleaseHandler(_arg1:ImageButton):void
        {
            prepareForExit();
        }


    }
}//package at.polypex.badplaner.view.overlays

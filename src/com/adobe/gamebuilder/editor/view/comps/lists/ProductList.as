package com.adobe.gamebuilder.editor.view.comps.lists
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.data.MobileCategoryVO;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.view.LeftPanel;
    import com.adobe.gamebuilder.editor.view.screens.ProductScreen;
    
    import flash.geom.Rectangle;
    
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.foxhole.controls.List;
    import org.josht.starling.foxhole.controls.ScrollContainer;
    import org.josht.starling.foxhole.layout.VerticalLayout;
    import org.josht.starling.textures.Scale9Textures;
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObjectContainer;
    import starling.events.TouchEvent;
    import starling.textures.TextureSmoothing;

    public class ProductList extends DisplayObjectContainer 
    {

        private var _list:List;
        private var _onInfoTouch:Signal;
        private var _onProductDoubleTouch:Signal;
        private var _onItemTouch:Signal;
        private var _border:Scale9Image;
        private var _height:Number;

        public function ProductList()
        {
            this._onItemTouch = new Signal(List, MobileProductVO, int, TouchEvent);
            this._onInfoTouch = new Signal(ProductListRenderer, MobileProductVO);
            this._onProductDoubleTouch = new Signal(MobileProductVO);
            this.init();
        }

        public function get onProductDoubleTouch():Signal
        {
            return (this._onProductDoubleTouch);
        }

        public function get onInfoTouch():Signal
        {
            return (this._onInfoTouch);
        }

        public function get onItemTouch():Signal
        {
            return (this._onItemTouch);
        }

        public function get list():List
        {
            return (this._list);
        }

        override public function set height(_arg1:Number):void
        {
            this._height = _arg1;
            if (this._list)
            {
                this._list.height = this._height;
            };
            if (this._border)
            {
                this._border.height = this._height;
            };
        }

        private function init():void
        {
            this._list = new List();
//            this._list.backgroundSkin = new Scale9Image(new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("list_bg"), new Rectangle(4, 4, 24, 24)));
//			this._list.alpha=0;
            addChild(this._list);
            var _local1:MobileCategoryVO = new MobileCategoryVO();
            _local1.name = "Badewannen";
            this._list.typicalItem = _local1;
            this._list.scrollerProperties = {
                hasElasticEdges:true,
                horizontalScrollPolicy:ScrollContainer.SCROLL_POLICY_OFF
            };
            this._list.layout = this.customLayout();
            this._list.isSelectable = false;
            this._list.paddingTop = 5;
            this._list.paddingBottom = 5;
            this._list.width = (((Constants.PANEL_WIDTH - LeftPanel.TAB_WIDTH) - (2 * ProductScreen.LIST_PADDING)) - 1);
            if (this._height > 0)
            {
                this._list.height = this._height;
            };
            this._list.itemRendererType = ProductListRenderer;
            this._list.itemRendererProperties.labelField = "name";
            this._list.itemRendererProperties.horizontalAlign = "center";
            this._list.itemRendererProperties.iconPosition = "top";
            this._list.itemRendererProperties.iconTextureField = "iconTexture";
            this._list.itemRendererProperties.height = ProductListRenderer.RENDERER_HEIGHT;
            this._list.itemRendererProperties.accessoryTextureField = "accessoryTexture";
            this._list.onItemTouch.add(this.listTouchHandler);
            this._border = new Scale9Image(new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("list_border"), new Rectangle(4, 4, 24, 24)));
            this._border.touchable = false;
            this._border.smoothing = TextureSmoothing.NONE;
            this._border.width = this._list.width;
            this._border.height = this._list.height;
            addChild(this._border);
        }

        private function customLayout():VerticalLayout
        {
            var _local1:VerticalLayout = new VerticalLayout();
            _local1.useVirtualLayout = true;
            _local1.paddingTop = (_local1.paddingRight = (_local1.paddingBottom = (_local1.paddingLeft = 0)));
            _local1.gap = -2;
            _local1.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
            _local1.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
            return (_local1);
        }

        public function onInfoTouchHandler(_arg1:ProductListRenderer, _arg2:MobileProductVO):void
        {
            this._onInfoTouch.dispatch(_arg1, _arg2);
        }

        public function onIconDoubleTouchHandler(_arg1:ProductListRenderer, _arg2:MobileProductVO):void
        {
            this._onProductDoubleTouch.dispatch(_arg2);
        }

        private function listOnProviderChange(_arg1:List):void
        {
            if (((this._list.dataProvider) && (this._border)))
            {
                this._border.height = Math.min(this._list.maxHeight, (((this._list.dataProvider.length * ProductListRenderer.RENDERER_HEIGHT) + this._list.paddingTop) + this._list.paddingBottom));
            };
        }

        private function listTouchHandler(_arg1:List, _arg2:MobileProductVO, _arg3:int, _arg4:TouchEvent):void
        {
            this._onItemTouch.dispatch(_arg1, _arg2, _arg3, _arg4);
        }


    }
}//package at.polypex.badplaner.view.comps.lists

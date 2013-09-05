package com.adobe.gamebuilder.editor.view.comps.lists
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.Locale;
    import com.adobe.gamebuilder.editor.core.data.MobileCategoryVO;
    import com.adobe.gamebuilder.editor.view.LeftPanel;
    import com.adobe.gamebuilder.editor.view.screens.ProductScreen;
    
    import flash.geom.Rectangle;
    
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.foxhole.controls.List;
    import org.josht.starling.foxhole.controls.ScrollContainer;
    import org.josht.starling.foxhole.layout.VerticalLayout;
    import org.josht.starling.textures.Scale9Textures;
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.textures.TextureSmoothing;

    public class CategoryList extends DisplayObjectContainer 
    {

        private var _list:List;
        private var _onItemSelect:Signal;
        private var _border:Scale9Image;
        private var _height:Number;

        public function CategoryList()
        {
            this._onItemSelect = new Signal(MobileCategoryVO);
            this.init();
        }

        public function get onItemSelect():Signal
        {
            return (this._onItemSelect);
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
            this._list.onChange.add(this.listOnChange);
//            this._list.backgroundSkin = new Scale9Image(new Scale9Textures(Assets.getTextureAtlas("Interface").getTexture("list_bg"), new Rectangle(4, 4, 24, 24)));
            addChild(this._list);
            var _local1:MobileCategoryVO = new MobileCategoryVO();
            _local1.name = "Badewannen";
            this._list.typicalItem = _local1;
            this._list.scrollerProperties = {
                hasElasticEdges:true,
                horizontalScrollPolicy:ScrollContainer.SCROLL_POLICY_OFF
            };
            this._list.layout = this.customLayout();
            this._list.paddingTop = 5;
            this._list.paddingBottom = 5;
            this._list.width = (((Constants.PANEL_WIDTH - LeftPanel.TAB_WIDTH) - (2 * ProductScreen.LIST_PADDING)) - 1);
            if (this._height > 0)
            {
                this._list.height = this._height;
            };
            this._list.itemRendererType = CategoryListRenderer;
			this._list.itemRendererProperties.labelField = (((Locale.currentLang)=="en") ? "name_en" : "name");
 //           this._list.itemRendererProperties.@labelProperties.maxWidth = 195;
            this._list.itemRendererProperties.horizontalAlign = "left";
            this._list.itemRendererProperties.iconPosition = "right";
            this._list.itemRendererProperties.iconFunction = this.categoryIcon;
            this._list.itemRendererProperties.height = CategoryListRenderer.RENDERER_HEIGHT;
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

        private function listOnChange(_arg1:List):void
        {
            if (_arg1.selectedItem != null)
            {
                this._onItemSelect.dispatch((_arg1.selectedItem as MobileCategoryVO));
            };
        }

        private function categoryIcon(_arg1:Object):DisplayObject
        {
            return (new Image(Assets.getTextureAtlas("Interface").getTexture("list_cell_arrow_icon")));
        }


    }
}//package at.polypex.badplaner.view.comps.lists

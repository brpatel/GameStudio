package com.adobe.gamebuilder.editor.view.screens
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.data.MobileCategoryVO;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.view.LeftPanel;
    import com.adobe.gamebuilder.editor.view.comps.ProductAvatar;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.comps.lists.CategoryList;
    import com.adobe.gamebuilder.editor.view.comps.lists.ProductList;
    import com.adobe.gamebuilder.editor.view.comps.lists.ProductListRenderer;
    import com.adobe.gamebuilder.editor.view.states.ScrollDirection;
    import com.adobe.gamebuilder.util.ArrayUtil;
    
    import flash.events.ErrorEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.media.StageWebView;
    
    import mx.collections.ArrayCollection;
    
    import __AS3__.vec.Vector;
    
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.foxhole.controls.List;
    import org.josht.starling.foxhole.controls.Screen;
    import org.josht.starling.foxhole.controls.ScrollContainer;
    import org.josht.starling.foxhole.data.ListCollection;
    import org.josht.starling.foxhole.dragDrop.DragData;
    import org.josht.starling.foxhole.dragDrop.DragDropManager;
    import org.josht.starling.foxhole.dragDrop.IDragSource;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class ProductScreen extends Screen implements IDragSource 
    {

        public static const LIST_PADDING:uint = 4;

        private const LIST_BOTTOM_MARGIN:uint = 4;
        private const LIST_PRODUCTS:String = "products";
        private const LIST_SUB_CATS:String = "sub";
        private const LIST_MAIN_CATS:String = "main";

        private var _alertSignal:Signal;
        private var _productList:ProductList;
        private var _mainCatList:CategoryList;
        private var _subCatList:CategoryList;
        private var _productCollection:ArrayCollection;
        private var _mainCategoryCollection:ArrayCollection;
        private var _subCategoryCollection:ArrayCollection;
        private var _selectedMainCategory:MobileCategoryVO;
        private var _selectedSubCategory:MobileCategoryVO;
        private var _productDragStart:Signal;
        private var _productDragComplete:Signal;
        private var _oldList:DisplayObject;
        private var _newList:DisplayObject;
        private var _moveTouches:Vector.<Touch>;
        private var _backLink:ImageButton;
        private var _delta:Point;
        private var _listStatus:String;
        private var _browser:StageWebView;
        private var _browserClose:ImageButton;
        private var _renderer:ProductListRenderer;
        private var _startTime:Number;
        private var _startX:Number;
        private var _listBorder:Scale9Image;
        private var _addProduct:Signal;

        public function ProductScreen()
        {
            this._alertSignal = new Signal(SystemMessage);
            this._addProduct = new Signal(MobileProductVO);
            super();
        }

        public function get addProduct():Signal
        {
            return (this._addProduct);
        }

        public function get alertSignal():Signal
        {
            return (this._alertSignal);
        }

        public function init(_arg1:Array, _arg2:Array, _arg3:Array):void
        {
            this._productCollection = new ArrayCollection(_arg1);
            this._mainCategoryCollection = new ArrayCollection(_arg2);
            this._subCategoryCollection = new ArrayCollection(_arg3);
            this._backLink = new ImageButton("list_back_btn_icon", 0, 0, false);
            this._backLink.onRelease.add(this.backLinkTouchHandler);
            this._backLink.x = 15;
            this._backLink.y = 18;
            this._backLink.visible = false;
            addChild(this._backLink);
            this._mainCatList = new CategoryList();
            this._mainCatList.list.dataProvider = new ListCollection(_arg2);
            this._mainCatList.x = LIST_PADDING;
            this._mainCatList.y = 70;
            this._mainCatList.height = (((stage.stageHeight - Constants.TOPBAR_HEIGHT) - 70) - this.LIST_BOTTOM_MARGIN);
            this._mainCatList.onItemSelect.add(this.mainCatListSelectHandler);
            addChild(this._mainCatList);
            this._subCatList = new CategoryList();
            this._subCatList.x = ((Constants.PANEL_WIDTH - LeftPanel.TAB_WIDTH) + LIST_PADDING);
            this._subCatList.y = 70;
            this._subCatList.visible = false;
            this._subCatList.height = (((stage.stageHeight - Constants.TOPBAR_HEIGHT) - 70) - this.LIST_BOTTOM_MARGIN);
            this._subCatList.onItemSelect.add(this.subCatListSelectHandler);
            addChild(this._subCatList);
            this._productList = new ProductList();
            this._productList.x = ((Constants.PANEL_WIDTH - LeftPanel.TAB_WIDTH) + LIST_PADDING);
            this._productList.y = 70;
            this._productList.visible = false;
            this._productList.height = (((stage.stageHeight - Constants.TOPBAR_HEIGHT) - 70) - this.LIST_BOTTOM_MARGIN);
            this._productList.onItemTouch.add(this.productListTouchHandler);
            this._productList.onInfoTouch.add(this.productOnInfoTouch);
            this._productList.onProductDoubleTouch.add(this.productDoubleTouchHandler);
            addChild(this._productList);
            this._productDragStart = new Signal(IDragSource, DragData);
            this._productDragComplete = new Signal(IDragSource, DragData, Boolean);
            this._productDragComplete.add(this.productDragCompleteHandler);
        }

        private function productDoubleTouchHandler(_arg1:MobileProductVO):void
        {
            this._addProduct.dispatch(_arg1);
        }

        public function productOnInfoTouch(_arg1:ProductListRenderer, _arg2:MobileProductVO):void
        {
            this._renderer = _arg1;
            this.loadBrowser((Constants.PRODUCT_URL + _arg2.url_title));
            this.addEventListener(Event.ENTER_FRAME, this.addListenerLater);
        }

        private function addListenerLater(_arg1:Event):void
        {
            this.removeEventListener(Event.ENTER_FRAME, this.addListenerLater);
            this.stage.addEventListener(TouchEvent.TOUCH, this.stageOnTouch);
        }

        private function browserErrorHandler(_arg1:ErrorEvent):void
        {
            this.removeBrowser();
            this._alertSignal.dispatch(new SystemMessage(Common.getResourceString("errorProductDetail"), SystemMessage.TYPE_ALERT, SystemMessage.LONG_DELAY));
        }

        private function removeBrowser():void
        {
            if (stage != null)
            {
                stage.removeEventListener(TouchEvent.TOUCH, this.stageOnTouch);
            };
            if (this._renderer != null)
            {
                this._renderer.resetInfo();
                this._renderer = null;
            };
            if (this._browser)
            {
                this._browser.dispose();
                this._browser = null;
            };
        }

        private function loadBrowser(_arg1:String):void
        {
            if (this._browser == null)
            {
                this._browser = new StageWebView();
                this._browser.addEventListener(ErrorEvent.ERROR, this.browserErrorHandler, false, 0, true);
                this._browser.stage = Starling.current.nativeStage;
                this._browser.viewPort = new Rectangle(Constants.PANEL_WIDTH, Constants.TOPBAR_HEIGHT, Constants.BROWSER_WIDTH, (stage.stageHeight - Constants.TOPBAR_HEIGHT));
            };
            this._browser.loadURL(_arg1);
        }

        private function stageOnTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage);
            if (_local2.phase == TouchPhase.BEGAN)
            {
                if (this._renderer != null)
                {
                    this._renderer.resetInfo();
                    this._renderer = null;
                };
                if (!(((_arg1.target is Image)) && (((_arg1.target as Image).name == "infoIcon"))))
                {
                    this.removeBrowser();
                };
            };
        }

        private function backLinkTouchHandler(_arg1:ImageButton):void
        {
            if (this._listStatus == this.LIST_PRODUCTS)
            {
                if (this._selectedSubCategory != null)
                {
                    this.scrollInView(this.LIST_SUB_CATS, this.LIST_PRODUCTS, ScrollDirection.RIGHT);
                }
                else
                {
                    this.scrollInView(this.LIST_MAIN_CATS, this.LIST_PRODUCTS, ScrollDirection.RIGHT);
                };
            }
            else
            {
                if (this._listStatus == this.LIST_SUB_CATS)
                {
                    this.scrollInView(this.LIST_MAIN_CATS, this.LIST_SUB_CATS, ScrollDirection.RIGHT);
                };
            };
        }

        private function subCatFilter(_arg1:MobileCategoryVO):Boolean
        {
            return ((_arg1.parent_id == this._selectedMainCategory.id));
        }

        private function productMainCatFilter(_arg1:MobileProductVO):Boolean
        {
            return ((_arg1.category == this._selectedMainCategory.id));
        }

        private function productSubCatFilter(_arg1:MobileProductVO):Boolean
        {
            var _local2:Array = _arg1.subcats.split(",");
            return (ArrayUtil.contains(_local2, this._selectedSubCategory.id));
        }

        private function productListTouchHandler(_arg1:List, _arg2:MobileProductVO, _arg3:int, _arg4:TouchEvent):void
        {
            var _local5:Number;
            var _local6:Number;
            var _local7:DisplayObject;
            var _local8:DragData;
            if (_arg4.touches[0].phase == TouchPhase.BEGAN)
            {
                this._startTime = _arg4.timestamp;
                this._startX = _arg4.touches[0].globalX;
            };
            this._moveTouches = _arg4.getTouches(this, TouchPhase.MOVED);
            if (this._moveTouches.length == 1)
            {
                this._delta = this._moveTouches[0].getMovement(this);
                if (((((((!(DragDropManager.isDragging)) && ((this._delta.x > 0)))) && ((Math.abs(this._delta.y) < 2)))) && (((_arg4.timestamp - this._startTime) > 0.1))))
                {
                    _local5 = (-(this._moveTouches[0].getLocation((_arg4.target as DisplayObject)).x) * (_arg4.target as DisplayObject).scaleX);
                    _local5 = (_local5 + (_arg4.touches[0].globalX - this._startX));
                    _local6 = -((this._productList.list.verticalScrollPosition + (this._moveTouches[0].getLocation((_arg4.target as DisplayObject)).y * (_arg4.target as DisplayObject).scaleY)));
                    _local7 = new ProductAvatar(_arg2.iconTexture);
                    _local8 = new DragData();
                    _local8.setDataForFormat("product", {
                        product:_arg2,
                        offsetX:_local5,
                        offsetY:_local6,
                        avatar:_local7
                    });
                    DragDropManager.startDrag((this as IDragSource), this._moveTouches[0], _local8, _local7, _local5, _local6);
                    this._productList.list.scrollerProperties = {
                        hasElasticEdges:false,
                        verticalScrollPolicy:ScrollContainer.SCROLL_POLICY_OFF
                    };
                };
            };
        }

        private function productDragCompleteHandler(_arg1:IDragSource, _arg2:DragData, _arg3:Boolean):void
        {
            this._productList.list.scrollerProperties = {
                hasElasticEdges:true,
                verticalScrollPolicy:ScrollContainer.SCROLL_POLICY_ON
            };
        }

        public function get onDragStart():ISignal
        {
            return (this._productDragStart);
        }

        public function get onDragComplete():ISignal
        {
            return (this._productDragComplete);
        }

        private function subCatListSelectHandler(_arg1:MobileCategoryVO):void
        {
            this.selectSubCat(_arg1);
        }

        private function mainCatListSelectHandler(_arg1:MobileCategoryVO):void
        {
            this.selectMainCat(_arg1);
        }

        private function selectSubCat(_arg1:MobileCategoryVO):void
        {
            this._selectedSubCategory = _arg1;
            this.showProductsOfSubCat();
            this.scrollInView(this.LIST_PRODUCTS, this.LIST_SUB_CATS, ScrollDirection.LEFT);
            this._subCatList.list.selectedIndex = -1;
        }

        private function selectMainCat(_arg1:MobileCategoryVO):void
        {
            this._selectedMainCategory = _arg1;
            this._subCategoryCollection.filterFunction = this.subCatFilter;
            this._subCategoryCollection.refresh();
            if (this._subCategoryCollection.length > 0)
            {
                this._subCatList.list.dataProvider = new ListCollection(this._subCategoryCollection.toArray());
                this.scrollInView(this.LIST_SUB_CATS, this.LIST_MAIN_CATS, ScrollDirection.LEFT);
            }
            else
            {
                this._selectedSubCategory = null;
                this.showProductsOfMainCat();
                this.scrollInView(this.LIST_PRODUCTS, this.LIST_MAIN_CATS, ScrollDirection.LEFT);
            };
            this._mainCatList.list.selectedIndex = -1;
        }

        private function showProductsOfSubCat():void
        {
            this._productCollection.filterFunction = this.productSubCatFilter;
            this._productCollection.refresh();
            this._productList.list.dataProvider = new ListCollection(this._productCollection.toArray());
        }

        private function showProductsOfMainCat():void
        {
            this._productCollection.filterFunction = this.productMainCatFilter;
            this._productCollection.refresh();
            this._productList.list.dataProvider = new ListCollection(this._productCollection.toArray());
        }

        private function scrollInView(_arg1:String, _arg2:String, _arg3:String):void
        {
            this._oldList = (((_arg2)==this.LIST_MAIN_CATS) ? this._mainCatList : (((_arg2)==this.LIST_SUB_CATS) ? this._subCatList : this._productList));
            this._newList = (((_arg1)==this.LIST_MAIN_CATS) ? this._mainCatList : (((_arg1)==this.LIST_SUB_CATS) ? this._subCatList : this._productList));
            this._newList.x = (((_arg3)==ScrollDirection.LEFT) ? (Constants.PANEL_WIDTH + LIST_PADDING) : -((Constants.PANEL_WIDTH - LIST_PADDING)));
            this._newList.visible = true;
            var _local4:Tween = new Tween(this._oldList, 0.3, Transitions.EASE_OUT);
            _local4.animate("x", (((_arg3)==ScrollDirection.LEFT) ? -(((Constants.PANEL_WIDTH - LeftPanel.TAB_WIDTH) - LIST_PADDING)) : ((Constants.PANEL_WIDTH - LeftPanel.TAB_WIDTH) + LIST_PADDING)));
            _local4.onComplete = this.tween1Complete;
            Starling.juggler.add(_local4);
            var _local5:Tween = new Tween(this._newList, 0.3, Transitions.EASE_OUT);
            _local5.animate("x", LIST_PADDING);
            _local5.onComplete = this.tween2Complete;
            Starling.juggler.add(_local5);
            this._listStatus = _arg1;
            this._backLink.visible = !((_arg1 == this.LIST_MAIN_CATS));
        }

        private function tween1Complete():void
        {
            this._oldList.visible = false;
        }

        private function tween2Complete():void
        {
        }

        override public function dispose():void
        {
            this.removeBrowser();
            super.dispose();
        }


    }
}//package at.polypex.badplaner.view.screens

package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.model.AppModel;
    import com.adobe.gamebuilder.editor.view.screens.ProductScreen;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class ProductScreenMediator extends StarlingMediator 
    {

        [Inject]
        public var appModel:AppModel;
        [Inject]
        public var view:ProductScreen;


        override public function onRegister():void
        {
            this.view.init(this.appModel.productList, this.appModel.mainCategoryList, this.appModel.subCategoryList);
            this.view.alertSignal.add(this.alertHandler);
            this.view.addProduct.add(this.addProductHandler);
        }

        private function addProductHandler(_arg1:MobileProductVO):void
        {
            dispatch(new ContextEvent(ContextEvent.ADD_PRODUCT, {productVO:_arg1}));
        }

        private function alertHandler(_arg1:SystemMessage):void
        {
            dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:_arg1}));
        }

        override public function onRemove():void
        {
            this.view.alertSignal.remove(this.alertHandler);
            this.view.addProduct.remove(this.addProductHandler);
        }


    }
}//package at.polypex.badplaner.view.mediator

package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.model.vo.ObjectAsset;
    import com.adobe.gamebuilder.editor.view.Container;
    import com.adobe.gamebuilder.editor.view.events.CreateObjectInstanceEvent;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    
    import flash.geom.Point;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class ContainerMediator extends StarlingMediator 
    {

        [Inject]
        public var view:Container;
		
		[Inject]
		public var gameState:GameState;


        override public function onRegister():void
        {
            this.view.touchEnded.add(this.touchEndedHandler);
			this.view.productDrop.add(this.handleCreateInstance);
            addContextListener(ContextEvent.SWITCH_PRESENTATION_MODE, this.presentationModeHandler, ContextEvent);
        }

        private function presentationModeHandler(_arg1:ContextEvent):void
        {
            this.view.setPosition((((Common.presentationMode)=="off") ? "zero" : "center"));
        }

        private function touchEndedHandler():void
        {
            dispatch(new ContextEvent(ContextEvent.CONTAINER_TOUCH));
        }
		
		private function handleCreateInstance(product:Product,placementPoint:Point):void
		{
			product._instanceID = this.gameState._lastObjectID +1;
			dispatch(new CreateObjectInstanceEvent(product.vo.objectAsset, placementPoint.x, placementPoint.y));
		}

        override public function onRemove():void
        {
            this.view.touchEnded.remove(this.touchEndedHandler);
			this.view.productDrop.remove(this.handleCreateInstance);
            addContextListener(ContextEvent.SWITCH_PRESENTATION_MODE, this.presentationModeHandler, ContextEvent);
        }


    }
}//package at.polypex.badplaner.view.mediator

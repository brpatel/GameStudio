package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.view.bars.PropertyBar;
    import com.adobe.gamebuilder.editor.view.bars.PropertyInspector;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class PropertyBarMediator extends StarlingMediator 
    {

        [Inject]
        public var view:PropertyBar;
       /* [Inject]
        public var appModel:AppModel;*/
		private var _propertyInspector:PropertyInspector;


        override public function onRegister():void
        {
			this.view.addEventListener("added", this.addedToStage);
            this.view.btnRelease.add(this.btnReleaseHandler);
			this._propertyInspector = new PropertyInspector();
			this.view.setContent(this._propertyInspector, "Properties");
        }

        private function btnReleaseHandler(_arg1:String):void
        {
           
        }
		
		private function addedToStage(event:*):void
		{
			
		}	

        override public function onRemove():void
        {
            this.view.btnRelease.remove(this.btnReleaseHandler);
        }


    }
}//package at.polypex.badplaner.view.mediator

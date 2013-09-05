package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.model.AppModel;
    import com.adobe.gamebuilder.editor.view.bars.SaveBar;
    
    import editor.model.vo.GameState;
    
    import org.robotlegs.mvcs.StarlingMediator;
    
    import starling.events.Event;
    import com.adobe.gamebuilder.editor.model.vo.GameState;

    public class SaveBarMediator extends StarlingMediator 
    {

        [Inject]
        public var view:SaveBar;
        [Inject]
        public var appModel:AppModel;
		
		[Inject]
		public var gameState:GameState;


        override public function onRegister():void
        {
            this.view.btnRelease.add(this.btnReleaseHandler);
        }

        private function btnReleaseHandler(_arg1:String):void
        {
            if (_arg1 == "new")
            {
                dispatch(new ContextEvent(ContextEvent.NEW_PLAN));
                this.view.hide(true);
            }
            else
            {
                if (_arg1 == "load")
                {
                    dispatch(new ContextEvent(ContextEvent.OPEN_OVERLAY, {type:"loadPlan"}));
                    this.view.hide(false);
                }
                else
                {
                    if (_arg1 == "saveAs")
                    {
						gameState.saveGameStateAs();
						this.view.hide(false);
                       /* dispatch(new ContextEvent(ContextEvent.OPEN_OVERLAY, {type:"savePlan"}));
                        this.view.hide(false);*/
                    }
                    else
                    {
                        if (_arg1 == "save")
                        {
							gameState.saveGameState();
							this.view.hide(false);
                            /*if (this.appModel.currentPlan.isNew)
                            {
                                dispatch(new ContextEvent(ContextEvent.OPEN_OVERLAY, {type:"savePlan"}));
                                this.view.hide(false);
                            }
                            else
                            {
                                this.view.addEventListener(Event.ENTER_FRAME, this.savePlanLater);
                            };*/
                        };
                    };
                };
            };
        }

        private function savePlanLater(_arg1:Event):void
        {
            this.view.hide(true);
            this.view.removeEventListener(Event.ENTER_FRAME, this.savePlanLater);
            dispatch(new ContextEvent(ContextEvent.SAVE_PLAN_REQUEST, {
                planName:this.appModel.currentPlan.name,
                overwrite:true
            }));
        }

        override public function onRemove():void
        {
            this.view.btnRelease.remove(this.btnReleaseHandler);
        }


    }
}//package at.polypex.badplaner.view.mediator

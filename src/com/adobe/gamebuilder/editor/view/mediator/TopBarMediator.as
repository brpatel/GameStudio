package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.GameEditor;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.view.ActionBarContainer;
    import com.adobe.gamebuilder.editor.view.bars.TopBar;
    import com.adobe.gamebuilder.game.preview.Game;
    import com.adobe.gamebuilder.game.preview.Topbar;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class TopBarMediator extends StarlingMediator 
    {

        [Inject]
        public var view:TopBar;
		
		[Inject]
		public var gameState:GameState;


        override public function onRegister():void
        {
            this.view.actionSignal.add(this.viewActionHandler);
            addContextListener(ContextEvent.RESET_TOPBAR, this.resetHandler, ContextEvent);
            addContextListener(ContextEvent.SET_PLAN_NAME, this.setNameHandler, ContextEvent);
            addContextListener(ContextEvent.SCREEN_CHANGED, this.screenChangeHandler, ContextEvent);
        }

        private function screenChangeHandler(_arg1:ContextEvent):void
        {
            if (_arg1.data == Constants.STEP_ROOM)
            {
                this.view.setStepName(Common.getResourceString("label_step1"));
            }
            else
            {
                if (_arg1.data == Constants.STEP_OPENINGS)
                {
                    this.view.setStepName(Common.getResourceString("label_step2"));
                }
                else
                {
                    if (_arg1.data == Constants.STEP_PRODUCTS)
                    {
                        this.view.setStepName(Common.getResourceString("label_step3"));
                    }
                    else
                    {
                        if (_arg1.data == Constants.STEP_FINALIZE)
                        {
                            this.view.setStepName(Common.getResourceString("label_step4"));
                        };
                    };
                };
            };
        }

        private function setNameHandler(_arg1:ContextEvent):void
        {
            this.view.setPlanName(_arg1.data.planName);
        }

        private function resetHandler(_arg1:ContextEvent):void
        {
            this.view.reset();
        }

        private function viewActionHandler(_arg1:String):void
        {
            if (_arg1 == ActionBarContainer.TYPE_HELP)
            {
                dispatch(new ContextEvent(ContextEvent.HIDE_ACTION_BAR));
                dispatch(new ContextEvent(ContextEvent.OPEN_OVERLAY, {type:_arg1}));
            }
            else
            {
                if (_arg1 == ActionBarContainer.TYPE_INFO)
                {
                   /* dispatch(new ContextEvent(ContextEvent.HIDE_ACTION_BAR));
                    dispatch(new ContextEvent(ContextEvent.OPEN_OVERLAY, {type:_arg1}));*/
					this.gameState.saveGameState();
					GameBuilderApp.game = new Game(this.gameState.gameStateFile.name);
					GameBuilderApp.game.x = 0;
					GameBuilderApp.game.y = 0;
					GameBuilderApp(Game.parentSprite).addChild(GameBuilderApp.game);
					GameBuilderApp.topBar = new Topbar(GameBuilderApp(Game.parentSprite));
					GameBuilderApp(Game.parentSprite).addChild(GameBuilderApp.topBar);
					
					// Disable editor
					GameEditor(this.view.parent).touchable=false;
					GameEditor(this.view.parent)._topBar.visible = false;
					GameEditor(this.view.parent)._actionBar.visible = false;
					
                }
                else
                {
                    dispatch(new ContextEvent(ContextEvent.SHOW_ACTION_BAR, {type:_arg1}));
                };
            };
        }

        override public function onRemove():void
        {
            this.view.actionSignal.remove(this.viewActionHandler);
            removeContextListener(ContextEvent.RESET_TOPBAR, this.resetHandler, ContextEvent);
            removeContextListener(ContextEvent.SET_PLAN_NAME, this.setNameHandler, ContextEvent);
        }


    }
}//package at.polypex.badplaner.view.mediator

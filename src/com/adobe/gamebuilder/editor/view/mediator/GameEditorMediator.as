
package com.adobe.gamebuilder.editor.view.mediator
{
   
    import com.adobe.gamebuilder.editor.GameEditor;
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.Locale;
    import com.adobe.gamebuilder.editor.core.data.ContactFormVO;
    import com.adobe.gamebuilder.editor.core.data.MailFormVO;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.core.events.CommandEvent;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.model.AppModel;
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.storage.StoreUtils;
    import com.adobe.gamebuilder.editor.storage.StoredRoom;
    import com.adobe.gamebuilder.editor.view.ActionBarContainer;
    import com.adobe.gamebuilder.editor.view.layout.OverlayConfig;
    import com.adobe.gamebuilder.editor.view.overlays.GetQuoteOverlay;
    import com.adobe.gamebuilder.editor.view.overlays.HelpOverlay;
    import com.adobe.gamebuilder.editor.view.overlays.InfoOverlay;
    import com.adobe.gamebuilder.editor.view.overlays.LoadPlanOverlay;
    import com.adobe.gamebuilder.editor.view.overlays.Overlay;
    import com.adobe.gamebuilder.editor.view.overlays.SavePlanOverlay;
    import com.adobe.gamebuilder.editor.view.overlays.SendPlanOverlay;
    import com.adobe.gamebuilder.editor.view.states.ViewMode;
    
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.system.Capabilities;
    
    import mx.resources.ResourceManager;
    
    import org.josht.starling.foxhole.core.PopUpManager;
    import org.robotlegs.mvcs.StarlingMediator;
    
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;
    import starling.textures.TextureSmoothing;
    import starling.utils.getNextPowerOfTwo;

    public class GameEditorMediator extends StarlingMediator 
    {

        [Inject]
        public var view:GameEditor;
        [Inject]
        public var appModel:AppModel;
		
		[Inject]
		public var gameState:GameState;
		
        private var _planName:String;
        private var _overlay:Overlay;
        private var _getQuoteData:Object;
        private var _form:MailFormVO;


        override public function onRegister():void
        {
            ResourceManager.getInstance().addEventListener(flash.events.Event.CHANGE, this.language_changeHandler);
			Locale.setLanguage(Capabilities.language);
            PopUpManager.overlayFactory = this.modalFactory;
            addContextListener(ContextEvent.SWITCH_PRESENTATION_MODE, this.presentationModeSwitch, ContextEvent);
            addContextListener(ContextEvent.OPEN_OVERLAY, this.openOverlay, ContextEvent);
            addContextListener(ContextEvent.SYSTEM_MESSAGE, this.showSystemMessage, ContextEvent);
            addContextListener(ContextEvent.SAVE_PLAN_COMPLETE, this.savePlanCompleteHandler, ContextEvent);
            addContextListener(ContextEvent.SAVE_PLAN_REQUEST, this.savePlanRequestHandler, ContextEvent);
			view.onImport.add(this.onGameLevelImport);
            dispatch(new CommandEvent(CommandEvent.LOAD_PRODUCTS));
        }
		
		private function onGameLevelImport(levelName:String):void
		{
			// Open SampleLevel.lev file 
			if(levelName!=null){
				var dir:File = File.applicationStorageDirectory; 
				dir = dir.resolvePath(levelName); 
				this.gameState.openGameState(dir);
			}
		}
		
        private function showSystemMessage(_arg1:ContextEvent):void
        {
            this.view.systemMessage.show(_arg1.data.message);
        }

        private function openOverlay(_arg1:ContextEvent):void
        {
            if (this._overlay != null)
            {
                this._overlay.hide();
            };
            var _local2:OverlayConfig = new OverlayConfig(this.view.stage.stageWidth, (this.view.stage.stageHeight - Constants.TOPBAR_HEIGHT), 0xE8E8E8, 1, false, false, false);
            if (_arg1.data.type == "email")
            {
                this._overlay = new SendPlanOverlay(_local2);
                (this._overlay as SendPlanOverlay).sendSignal.add(this.sendPlanHandler);
                (this._overlay as SendPlanOverlay).errorSignal.add(this.overlayErrorHandler);
            }
            else
            {
                if (_arg1.data.type == "angebot")
                {
                    this._overlay = new GetQuoteOverlay(_local2);
                    (this._overlay as GetQuoteOverlay).sendSignal.add(this.getQuoteSendHandler);
                    (this._overlay as GetQuoteOverlay).errorSignal.add(this.overlayErrorHandler);
                }
                else
                {
                    if (_arg1.data.type == "savePlan")
                    {
                        this._overlay = new SavePlanOverlay(_local2);
                        (this._overlay as SavePlanOverlay).savePlan.add(this.savePlanHandler);
                        (this._overlay as SavePlanOverlay).errorSignal.add(this.overlayErrorHandler);
                        (this._overlay as SavePlanOverlay).screenshot = this.view.container.room.getThumbnail();
                    }
                    else
                    {
                        if (_arg1.data.type == "loadPlan")
                        {
                            this._overlay = new LoadPlanOverlay(_local2);
                            (this._overlay as LoadPlanOverlay).loadPlan.add(this.loadPlanHandler);
                        }
                        else
                        {
                            if (_arg1.data.type == ActionBarContainer.TYPE_HELP)
                            {
                                this._overlay = new HelpOverlay(_local2);
                            }
                            else
                            {
                                if (_arg1.data.type == ActionBarContainer.TYPE_INFO)
                                {
                                    this._overlay = new InfoOverlay(_local2);
                                };
                            };
                        };
                    };
                };
            };
            if (this._overlay != null)
            {
                this._overlay.onClose.add(this.overlayOnClose);
                this._overlay.x = 0;
                this._overlay.y = this.view.stage.stageHeight;
                this.view.addChild(this._overlay);
                this.view.barsToFront();
                this.slideIntoView(this._overlay);
            };
        }

        private function overlayOnClose(_arg1:Object):void
        {
            if ((((this._overlay is HelpOverlay)) || ((this._overlay is InfoOverlay))))
            {
                dispatch(new ContextEvent(ContextEvent.RESET_TOPBAR));
            };
            this.slideOutOfView(this._overlay);
        }

        private function loadPlanHandler(_arg1:Object, _arg2:String):void
        {
            dispatch(new ContextEvent(ContextEvent.LOAD_PLAN, {
                storedPlan:_arg1,
                fileName:_arg2
            }));
        }

        private function savePlanHandler(_arg1:String):void
        {
            if (this._overlay)
            {
                this._overlay.visible = false;
            };
            this._planName = _arg1;
            dispatch(new CommandEvent(CommandEvent.SAVE_PLAN, {
                room:this.view.container.room,
                baseRoomID:this.appModel.currentPlan.baseRoom,
                planName:_arg1,
                overwrite:false
            }));
        }

        private function savePlanRequestHandler(_arg1:ContextEvent):void
        {
            if (this._overlay)
            {
                this._overlay.visible = false;
            };
            dispatch(new CommandEvent(CommandEvent.SAVE_PLAN, {
                room:this.view.container.room,
                baseRoomID:this.appModel.currentPlan.baseRoom,
                planName:_arg1.data.planName,
                overwrite:_arg1.data.overwrite
            }));
        }

        private function savePlanCompleteHandler(_arg1:ContextEvent):void
        {
            if (this._overlay)
            {
                this._overlay.visible = true;
            };
            this.appModel.currentPlan.isNew = false;
            this.appModel.currentPlan.name = _arg1.data.planName;
            dispatch(new ContextEvent(ContextEvent.SET_PLAN_NAME, {planName:_arg1.data.planName}));
            if (_arg1.data.success)
            {
                dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:new SystemMessage(Common.getResourceString("system_save_successful"), SystemMessage.TYPE_CONFIRM)}));
            }
            else
            {
                dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:new SystemMessage(Common.getResourceString("savePlan_errorMessage"), SystemMessage.TYPE_ALERT, SystemMessage.LONG_DELAY)}));
            };
        }

        private function savePlanLater(_arg1:starling.events.Event):void
        {
            this.view.removeEventListener(starling.events.Event.ENTER_FRAME, this.savePlanLater);
            dispatch(new ContextEvent(ContextEvent.SAVE_PLAN_REQUEST, {
                planName:this._planName,
                overwrite:false
            }));
        }

        private function slideOutOfView(_arg1:Overlay):void
        {
            var _local2:Tween = new Tween(_arg1, 0.3, Transitions.EASE_OUT);
            _local2.animate("y", this.view.stage.stageHeight);
            _local2.onComplete = this.slideOutOfViewComplete;
            Starling.juggler.add(_local2);
        }

        private function slideOutOfViewComplete():void
        {
            this._overlay.parent.removeChild(this._overlay);
            this._overlay = null;
        }

        private function slideIntoView(_arg1:Overlay):void
        {
            var _local2:Tween = new Tween(_arg1, 0.3, Transitions.EASE_OUT);
            _local2.animate("y", Constants.TOPBAR_HEIGHT);
            Starling.juggler.add(_local2);
        }

        private function overlayErrorHandler(_arg1:SystemMessage):void
        {
            this.view.systemMessage.show(_arg1);
        }

        private function getQuoteSendHandler(_arg1:Object):void
        {
            this._getQuoteData = _arg1;
            this.view.addEventListener(starling.events.Event.ENTER_FRAME, this.getQuoteSendLater);
        }

        private function getQuoteSendLater(_arg1:starling.events.Event):void
        {
            this.view.removeEventListener(starling.events.Event.ENTER_FRAME, this.getQuoteSendLater);
            if (this._overlay)
            {
                this._overlay.visible = false;
            };
            this._getQuoteData.png = this.view.container.room.getPlanImage();
            if (this._overlay)
            {
                this._overlay.visible = true;
            };
            var _local2:StoredRoom = StoreUtils.roomToStoredRoom(this.view.container.room);
            _local2.version = Constants.PLAN_VERSION;
            _local2.baseRoomID = this.appModel.currentPlan.baseRoom;
            _local2.name = this.appModel.currentPlan.name;
            _local2.thumbnail = this.view.container.room.getThumbnail();
            (this._getQuoteData.contactForm as ContactFormVO).file = StoreUtils.compressPlan(_local2);
            dispatch(new CommandEvent(CommandEvent.GET_QUOTE, this._getQuoteData));
        }

        private function sendPlanHandler(_arg1:MailFormVO):void
        {
            this._form = _arg1;
            this.view.addEventListener(starling.events.Event.ENTER_FRAME, this.sendPlanLater);
        }

        private function sendPlanLater(_arg1:starling.events.Event):void
        {
            this.view.removeEventListener(starling.events.Event.ENTER_FRAME, this.sendPlanLater);
            if (this._overlay)
            {
                this._overlay.visible = false;
            };
            this._form.planImage = this.view.container.room.getPlanImage();
            if (this._overlay)
            {
                this._overlay.visible = false;
            };
            dispatch(new CommandEvent(CommandEvent.SEND_PLAN, this._form));
        }

        private function presentationModeSwitch(_arg1:ContextEvent):void
        {
            this.view.switchViewMode((((Common.presentationMode)=="on") ? ViewMode.PRESENTATION : ViewMode.NORMAL));
        }

        protected function language_changeHandler(_arg1:flash.events.Event):void
        {
            ResourceManager.getInstance().removeEventListener(flash.events.Event.CHANGE, this.language_changeHandler);
            Locale.setLanguage(Capabilities.language);
        }

        private function modalFactory():DisplayObject
        {
            var _local1:Image = new Image(Assets.getTextureAtlas("Interface").getTexture("bg_modal"));
			if(this.view.stage!=null){
            _local1.width = getNextPowerOfTwo(this.view.stage.stageWidth);
            _local1.height = getNextPowerOfTwo(this.view.stage.stageHeight);
			}else{
				_local1.width = 300;
				_local1.height = 200;
			}
            _local1.smoothing = TextureSmoothing.NONE;
            return (_local1);
        }

        override public function onRemove():void
        {
            removeContextListener(ContextEvent.SWITCH_PRESENTATION_MODE, this.presentationModeSwitch, ContextEvent);
            removeContextListener(ContextEvent.OPEN_OVERLAY, this.openOverlay, ContextEvent);
            removeContextListener(ContextEvent.SYSTEM_MESSAGE, this.showSystemMessage, ContextEvent);
        }


    }
}//package at.polypex.badplaner.view.mediator

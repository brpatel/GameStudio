//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.mvcs
{
    import flash.events.IEventDispatcher;
    import flash.system.ApplicationDomain;
    
    import editor.org.robotlegs.adapters.SwiftSuspendersReflector;
    import editor.org.robotlegs.base.CommandMap;
    import editor.org.robotlegs.base.MediatorMap;
    import editor.org.robotlegs.base.ViewMap;
    
    import org.robotlegs.adapters.SwiftSuspendersInjector;
    import org.robotlegs.adapters.SwiftSuspendersReflector;
    import org.robotlegs.base.CommandMap;
    import org.robotlegs.base.ContextBase;
    import org.robotlegs.base.ContextError;
    import org.robotlegs.base.ContextEvent;
    import org.robotlegs.base.EventMap;
    import org.robotlegs.base.StarlingMediatorMap;
    import org.robotlegs.base.StarlingViewMap;
    import org.robotlegs.core.ICommandMap;
    import org.robotlegs.core.IContext;
    import org.robotlegs.core.IEventMap;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.IReflector;
    import org.robotlegs.core.IStarlingMediatorMap;
    import org.robotlegs.core.IStarlingViewMap;
    
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class StarlingContext extends ContextBase implements IContext 
    {

        protected var _injector:IInjector;
        protected var _reflector:IReflector;
        protected var _autoStartup:Boolean;
        protected var _contextView:DisplayObjectContainer;
        protected var _commandMap:ICommandMap;
        protected var _mediatorMap:IStarlingMediatorMap;
        protected var _viewMap:IStarlingViewMap;

        public function StarlingContext(_arg1:DisplayObjectContainer=null, _arg2:Boolean=true)
        {
            this._contextView = _arg1;
            this._autoStartup = _arg2;
            if (this._contextView)
            {
                this.mapInjections();
                this.checkAutoStartup();
            };
        }

        public function startup():void
        {
            dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
        }

        public function shutdown():void
        {
            dispatchEvent(new ContextEvent(ContextEvent.SHUTDOWN_COMPLETE));
        }

        public function get contextView():DisplayObjectContainer
        {
            return (this._contextView);
        }

        public function set contextView(_arg1:DisplayObjectContainer):void
        {
            if (this._contextView)
            {
                throw (new ContextError(ContextError.E_CONTEXT_VIEW_OVR));
            };
            if (_arg1)
            {
                this._contextView = _arg1;
                this.mapInjections();
                this.checkAutoStartup();
            };
        }

        protected function get injector():IInjector
        {
            return ((this._injector = ((this._injector) || (this.createInjector()))));
        }

        protected function set injector(_arg1:IInjector):void
        {
            this._injector = _arg1;
        }

        protected function get reflector():IReflector
        {
			if(this._reflector !=null)
				return this._reflector;
			else
				this._reflector = new SwiftSuspendersReflector();
			
			return this._reflector;
            //return ((this._reflector = ((this._reflector) || (new SwiftSuspendersReflector()))));
        }

        protected function set reflector(_arg1:IReflector):void
        {
            this._reflector = _arg1;
        }

        protected function get commandMap():ICommandMap
        {
			if(this._commandMap !=null)
				return this._commandMap;
			else
				this._commandMap = new CommandMap(eventDispatcher, this.createChildInjector(), this.reflector);
			
			return this._commandMap;
           // return ((this._commandMap = ((this._commandMap) || (new CommandMap(eventDispatcher, this.createChildInjector(), this.reflector)))));
        }

        protected function set commandMap(_arg1:ICommandMap):void
        {
            this._commandMap = _arg1;
        }

        protected function get mediatorMap():IStarlingMediatorMap
        {
			if(this._mediatorMap !=null)
				return this._mediatorMap;
			else
				this._mediatorMap = new StarlingMediatorMap(this.contextView, this.createChildInjector(), this.reflector);
			
			return this._mediatorMap;
          //  return ((this._mediatorMap = ((this._mediatorMap) || (new StarlingMediatorMap(this.contextView, this.createChildInjector(), this.reflector)))));
        }

        protected function set mediatorMap(_arg1:IStarlingMediatorMap):void
        {
            this._mediatorMap = _arg1;
        }

        protected function get viewMap():IStarlingViewMap
        {
			if(this._viewMap !=null)
				return this._viewMap;
			else
				this._viewMap = new StarlingViewMap(this.contextView, this.injector);
			
			return this._viewMap;
			
         //   return ((this._viewMap = ((this._viewMap) || (new StarlingViewMap(this.contextView, this.injector)))));
        }

        protected function set viewMap(_arg1:IStarlingViewMap):void
        {
            this._viewMap = _arg1;
        }

        protected function mapInjections():void
        {
            this.injector.mapValue(IReflector, this.reflector);
            this.injector.mapValue(IInjector, this.injector);
            this.injector.mapValue(IEventDispatcher, eventDispatcher);
            this.injector.mapValue(DisplayObjectContainer, this.contextView);
            this.injector.mapValue(ICommandMap, this.commandMap);
            this.injector.mapValue(IStarlingMediatorMap, this.mediatorMap);
            this.injector.mapValue(IStarlingViewMap, this.viewMap);
            this.injector.mapClass(IEventMap, EventMap);
        }

        protected function checkAutoStartup():void
        {
            if (((this._autoStartup) && (this.contextView)))
            {
                if (this.contextView.stage)
                {
                    this.startup();
                }
                else
                {
                    this.contextView.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
                };
            };
        }

        protected function onAddedToStage(_arg1:Event):void
        {
            this.contextView.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.startup();
        }

        protected function createInjector():IInjector
        {
            var _local1:IInjector = new SwiftSuspendersInjector();
            _local1.applicationDomain = this.getApplicationDomainFromContextView();
            return (_local1);
        }

        protected function createChildInjector():IInjector
        {
            return (this.injector.createChild(this.getApplicationDomainFromContextView()));
        }

        protected function getApplicationDomainFromContextView():ApplicationDomain
        {
            return (ApplicationDomain.currentDomain);
        }


    }
}//package org.robotlegs.mvcs

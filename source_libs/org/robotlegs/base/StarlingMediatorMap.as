//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.base
{
    import starling.display.Sprite;
    import flash.utils.Dictionary;
    import org.robotlegs.core.IReflector;
    import starling.display.DisplayObjectContainer;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.IMediator;
    import flash.utils.getQualifiedClassName;
    import starling.events.Event;
    import flash.utils.setTimeout;
    import starling.display.DisplayObject;
    import org.robotlegs.core.*;

    public class StarlingMediatorMap extends StarlingViewMapBase implements IStarlingMediatorMap 
    {

        protected static const enterFrameDispatcher:Sprite = new Sprite();

        protected var mediatorByView:Dictionary;
        protected var mappingConfigByView:Dictionary;
        protected var mappingConfigByViewClassName:Dictionary;
        protected var mediatorsMarkedForRemoval:Dictionary;
        protected var hasMediatorsMarkedForRemoval:Boolean;
        protected var reflector:IReflector;

        public function StarlingMediatorMap(_arg1:DisplayObjectContainer, _arg2:IInjector, _arg3:IReflector)
        {
            super(_arg1, _arg2);
            this.reflector = _arg3;
            this.mediatorByView = new Dictionary(true);
            this.mappingConfigByView = new Dictionary(true);
            this.mappingConfigByViewClassName = new Dictionary(false);
            this.mediatorsMarkedForRemoval = new Dictionary(false);
        }

        public function mapView(_arg1, _arg2:Class, _arg3=null, _arg4:Boolean=true, _arg5:Boolean=true):void
        {
            var _local6:String = this.reflector.getFQCN(_arg1);
            if (this.mappingConfigByViewClassName[_local6] != null)
            {
                throw (new ContextError(((ContextError.E_MEDIATORMAP_OVR + " - ") + _arg2)));
            };
            if (this.reflector.classExtendsOrImplements(_arg2, IMediator) == false)
            {
                throw (new ContextError(((ContextError.E_MEDIATORMAP_NOIMPL + " - ") + _arg2)));
            };
            var _local7:MappingConfig = new MappingConfig();
            _local7.mediatorClass = _arg2;
            _local7.autoCreate = _arg4;
            _local7.autoRemove = _arg5;
            if (_arg3)
            {
                if ((_arg3 is Array))
                {
                    _local7.typedViewClasses = (_arg3 as Array).concat();
                }
                else
                {
                    if ((_arg3 is Class))
                    {
                        _local7.typedViewClasses = [_arg3];
                    };
                };
            }
            else
            {
                if ((_arg1 is Class))
                {
                    _local7.typedViewClasses = [_arg1];
                };
            };
            this.mappingConfigByViewClassName[_local6] = _local7;
            if (((_arg4) || (_arg5)))
            {
                viewListenerCount++;
                if (viewListenerCount == 1)
                {
                    this.addListeners();
                };
            };
            if (((((_arg4) && (contextView))) && ((_local6 == getQualifiedClassName(contextView)))))
            {
                this.createMediatorUsing(contextView, _local6, _local7);
            };
        }

        public function unmapView(_arg1):void
        {
            var _local2:String = this.reflector.getFQCN(_arg1);
            var _local3:MappingConfig = this.mappingConfigByViewClassName[_local2];
            if (((_local3) && (((_local3.autoCreate) || (_local3.autoRemove)))))
            {
                viewListenerCount--;
                if (viewListenerCount == 0)
                {
                    this.removeListeners();
                };
            };
            delete this.mappingConfigByViewClassName[_local2];
        }

        public function createMediator(_arg1:Object):IMediator
        {
            return (this.createMediatorUsing(_arg1));
        }

        public function registerMediator(_arg1:Object, _arg2:IMediator):void
        {
            injector.mapValue(this.reflector.getClass(_arg2), _arg2);
            this.mediatorByView[_arg1] = _arg2;
            this.mappingConfigByView[_arg1] = this.mappingConfigByViewClassName[getQualifiedClassName(_arg1)];
            _arg2.setViewComponent(_arg1);
            _arg2.preRegister();
        }

        public function removeMediator(_arg1:IMediator):IMediator
        {
            var _local2:Object;
            if (_arg1)
            {
                _local2 = _arg1.getViewComponent();
                delete this.mediatorByView[_local2];
                delete this.mappingConfigByView[_local2];
                _arg1.preRemove();
                _arg1.setViewComponent(null);
                injector.unmap(this.reflector.getClass(_arg1));
            };
            return (_arg1);
        }

        public function removeMediatorByView(_arg1:Object):IMediator
        {
            return (this.removeMediator(this.retrieveMediator(_arg1)));
        }

        public function retrieveMediator(_arg1:Object):IMediator
        {
            return (this.mediatorByView[_arg1]);
        }

        public function hasMapping(_arg1):Boolean
        {
            var _local2:String = this.reflector.getFQCN(_arg1);
            return (!((this.mappingConfigByViewClassName[_local2] == null)));
        }

        public function hasMediatorForView(_arg1:Object):Boolean
        {
            return (!((this.mediatorByView[_arg1] == null)));
        }

        public function hasMediator(_arg1:IMediator):Boolean
        {
            var _local2:IMediator;
            for each (_local2 in this.mediatorByView)
            {
                if (_local2 == _arg1)
                {
                    return (true);
                };
            };
            return (false);
        }

        override protected function addListeners():void
        {
            if (((contextView) && (enabled)))
            {
                contextView.addEventListener(Event.ADDED, this.onViewAdded);
                contextView.addEventListener(Event.REMOVED, this.onViewRemoved);
                contextView.addEventListener(Event.ADDED_TO_STAGE, this.onViewAdded);
                contextView.addEventListener(Event.REMOVED_FROM_STAGE, this.onViewRemoved);
            };
        }

        override protected function removeListeners():void
        {
            if (contextView)
            {
                contextView.removeEventListener(Event.ADDED, this.onViewAdded);
                contextView.removeEventListener(Event.REMOVED, this.onViewRemoved);
                contextView.removeEventListener(Event.ADDED_TO_STAGE, this.onViewAdded);
                contextView.removeEventListener(Event.REMOVED_FROM_STAGE, this.onViewRemoved);
            };
        }

        override protected function onViewAdded(_arg1:Event):void
        {
            if (this.mediatorsMarkedForRemoval[_arg1.target])
            {
                delete this.mediatorsMarkedForRemoval[_arg1.target];
                return;
            };
            var _local2:String = getQualifiedClassName(_arg1.target);
            var _local3:MappingConfig = this.mappingConfigByViewClassName[_local2];
            if (((_local3) && (_local3.autoCreate)))
            {
                this.createMediatorUsing(_arg1.target, _local2, _local3);
            };
        }

        protected function createMediatorUsing(_arg1:Object, _arg2:String="", _arg3:MappingConfig=null):IMediator
        {
            var _local5:Class;
            var _local6:Class;
            var _local4:IMediator = this.mediatorByView[_arg1];
            if (_local4 == null)
            {
                _arg2 = ((_arg2) || (getQualifiedClassName(_arg1)));
                _arg3 = ((_arg3) || (this.mappingConfigByViewClassName[_arg2]));
                if (_arg3)
                {
                    for each (_local5 in _arg3.typedViewClasses)
                    {
                        injector.mapValue(_local5, _arg1);
                    };
                    _local4 = injector.instantiate(_arg3.mediatorClass);
                    for each (_local6 in _arg3.typedViewClasses)
                    {
                        injector.unmap(_local6);
                    };
                    this.registerMediator(_arg1, _local4);
                };
            };
            return (_local4);
        }

        protected function onViewRemoved(_arg1:Event):void
        {
            var _local2:MappingConfig = this.mappingConfigByView[_arg1.target];
            if (((_local2) && (_local2.autoRemove)))
            {
                this.mediatorsMarkedForRemoval[_arg1.target] = _arg1.target;
                if (!this.hasMediatorsMarkedForRemoval)
                {
                    this.hasMediatorsMarkedForRemoval = true;
                    setTimeout(this.removeMediatorLater, 500, null);
                };
            };
        }

        protected function removeMediatorLater(_arg1:Event):void
        {
            var _local2:DisplayObject;
            for each (_local2 in this.mediatorsMarkedForRemoval)
            {
                if (!_local2.stage)
                {
                    this.removeMediatorByView(_local2);
                };
                delete this.mediatorsMarkedForRemoval[_local2];
            };
            this.hasMediatorsMarkedForRemoval = false;
        }


    }
}//package org.robotlegs.base

class MappingConfig 
{

    public var mediatorClass:Class;
    public var typedViewClasses:Array;
    public var autoCreate:Boolean;
    public var autoRemove:Boolean;


}

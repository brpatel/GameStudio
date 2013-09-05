//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.base
{
    import flash.events.IEventDispatcher;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.IReflector;
    import flash.utils.Dictionary;
    import flash.events.Event;
    import flash.utils.describeType;
    import org.robotlegs.core.*;

    public class CommandMap implements ICommandMap 
    {

        protected var eventDispatcher:IEventDispatcher;
        protected var injector:IInjector;
        protected var reflector:IReflector;
        protected var eventTypeMap:Dictionary;
        protected var verifiedCommandClasses:Dictionary;
        protected var detainedCommands:Dictionary;

        public function CommandMap(_arg1:IEventDispatcher, _arg2:IInjector, _arg3:IReflector)
        {
            this.eventDispatcher = _arg1;
            this.injector = _arg2;
            this.reflector = _arg3;
            this.eventTypeMap = new Dictionary(false);
            this.verifiedCommandClasses = new Dictionary(false);
            this.detainedCommands = new Dictionary(false);
        }

        public function mapEvent(_arg1:String, _arg2:Class, _arg3:Class=null, _arg4:Boolean=false):void
        {
            var eventType:String = _arg1;
            var commandClass:Class = _arg2;
            var eventClass = _arg3;
            var oneshot:Boolean = _arg4;
            this.verifyCommandClass(commandClass);
            eventClass = ((eventClass) || (Event));
            var eventClassMap:Dictionary = (this.eventTypeMap[eventType] = ((this.eventTypeMap[eventType]) || (new Dictionary(false))));
            var callbacksByCommandClass:Dictionary = (eventClassMap[eventClass] = ((eventClassMap[eventClass]) || (new Dictionary(false))));
            if (callbacksByCommandClass[commandClass] != null)
            {
                throw (new ContextError((((((ContextError.E_COMMANDMAP_OVR + " - eventType (") + eventType) + ") and Command (") + commandClass) + ")")));
            };
            var callback:Function = function (_arg1:Event):void
            {
                routeEventToCommand(_arg1, commandClass, oneshot, eventClass);
            };
            this.eventDispatcher.addEventListener(eventType, callback, false, 0, true);
            callbacksByCommandClass[commandClass] = callback;
        }

        public function unmapEvent(_arg1:String, _arg2:Class, _arg3:Class=null):void
        {
            var _local4:Dictionary = this.eventTypeMap[_arg1];
            if (_local4 == null)
            {
                return;
            };
            var _local5:Dictionary = _local4[((_arg3) || (Event))];
            if (_local5 == null)
            {
                return;
            };
            var _local6:Function = _local5[_arg2];
            if (_local6 == null)
            {
                return;
            };
            this.eventDispatcher.removeEventListener(_arg1, _local6, false);
            delete _local5[_arg2];
        }

        public function unmapEvents():void
        {
            var _local1:String;
            var _local2:Dictionary;
            var _local3:Dictionary;
            var _local4:Function;
            for (_local1 in this.eventTypeMap)
            {
                _local2 = this.eventTypeMap[_local1];
                for each (_local3 in _local2)
                {
                    for each (_local4 in _local3)
                    {
                        this.eventDispatcher.removeEventListener(_local1, _local4, false);
                    };
                };
            };
            this.eventTypeMap = new Dictionary(false);
        }

        public function hasEventCommand(_arg1:String, _arg2:Class, _arg3:Class=null):Boolean
        {
            var _local4:Dictionary = this.eventTypeMap[_arg1];
            if (_local4 == null)
            {
                return (false);
            };
            var _local5:Dictionary = _local4[((_arg3) || (Event))];
            if (_local5 == null)
            {
                return (false);
            };
            return (!((_local5[_arg2] == null)));
        }

        public function execute(_arg1:Class, _arg2:Object=null, _arg3:Class=null, _arg4:String=""):void
        {
            this.verifyCommandClass(_arg1);
            if (((!((_arg2 == null))) || (!((_arg3 == null)))))
            {
                _arg3 = ((_arg3) || (this.reflector.getClass(_arg2)));
                if ((((_arg2 is Event)) && (!((_arg3 == Event)))))
                {
                    this.injector.mapValue(Event, _arg2);
                };
                this.injector.mapValue(_arg3, _arg2, _arg4);
            };
            var _local5:Object = this.injector.instantiate(_arg1);
            if (((!((_arg2 === null))) || (!((_arg3 == null)))))
            {
                if ((((_arg2 is Event)) && (!((_arg3 == Event)))))
                {
                    this.injector.unmap(Event);
                };
                this.injector.unmap(_arg3, _arg4);
            };
            _local5.execute();
        }

        public function detain(_arg1:Object):void
        {
            this.detainedCommands[_arg1] = true;
        }

        public function release(_arg1:Object):void
        {
            if (this.detainedCommands[_arg1])
            {
                delete this.detainedCommands[_arg1];
            };
        }

        protected function verifyCommandClass(_arg1:Class):void
        {
            var commandClass:Class = _arg1;
            if (!this.verifiedCommandClasses[commandClass])
            {
                this.verifiedCommandClasses[commandClass] = describeType(commandClass).factory.method.(@name == "execute").length();
                if (!this.verifiedCommandClasses[commandClass])
                {
                    throw (new ContextError(((ContextError.E_COMMANDMAP_NOIMPL + " - ") + commandClass)));
                };
            };
        }

        protected function routeEventToCommand(_arg1:Event, _arg2:Class, _arg3:Boolean, _arg4:Class):Boolean
        {
            if (!(_arg1 is _arg4))
            {
                return (false);
            };
            this.execute(_arg2, _arg1);
            if (_arg3)
            {
                this.unmapEvent(_arg1.type, _arg2, _arg4);
            };
            return (true);
        }


    }
}//package org.robotlegs.base

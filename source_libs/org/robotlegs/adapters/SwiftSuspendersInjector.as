//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.adapters
{
    import org.swiftsuspenders.Injector;
    import flash.system.ApplicationDomain;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.*;

    public class SwiftSuspendersInjector extends Injector implements IInjector 
    {

        protected static const XML_CONFIG:XML = <types>
				<type name='org.robotlegs.mvcs::Actor'>
					<field name='eventDispatcher'/>
				</type>
				<type name='org.robotlegs.mvcs::Command'>
					<field name='contextView'/>
					<field name='mediatorMap'/>
					<field name='eventDispatcher'/>
					<field name='injector'/>
					<field name='commandMap'/>
				</type>
				<type name='org.robotlegs.mvcs::Mediator'>
					<field name='contextView'/>
					<field name='mediatorMap'/>
					<field name='eventDispatcher'/>
				</type>
			</types>
        ;

        public function SwiftSuspendersInjector(_arg1:XML=null)
        {
            var _local2:XML;
            if (_arg1)
            {
                for each (_local2 in XML_CONFIG.children())
                {
                    _arg1.appendChild(_local2);
                };
            };
            super(_arg1);
        }

        public function createChild(_arg1:ApplicationDomain=null):IInjector
        {
            var _local2:SwiftSuspendersInjector = new SwiftSuspendersInjector();
            _local2.setApplicationDomain(_arg1);
            _local2.setParentInjector(this);
            return (_local2);
        }

        public function get applicationDomain():ApplicationDomain
        {
            return (getApplicationDomain());
        }

        public function set applicationDomain(_arg1:ApplicationDomain):void
        {
            setApplicationDomain(_arg1);
        }


    }
}//package org.robotlegs.adapters

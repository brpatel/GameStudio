//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core
{
    import mx.resources.IResourceManager;
    import flash.system.ApplicationDomain;
    import flash.events.IEventDispatcher;
    import mx.events.ResourceEvent;
    import flash.events.IOErrorEvent;

    public class ResourceModuleRSLItem extends RSLItem 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        public static var resourceManager:IResourceManager;

        private var appDomain:ApplicationDomain;

        public function ResourceModuleRSLItem(_arg1:String, _arg2:ApplicationDomain)
        {
            super(_arg1);
            this.appDomain = _arg2;
        }

        override public function load(_arg1:Function, _arg2:Function, _arg3:Function, _arg4:Function, _arg5:Function):void
        {
            var _local7:Class;
            chainedProgressHandler = _arg1;
            chainedCompleteHandler = _arg2;
            chainedIOErrorHandler = _arg3;
            chainedSecurityErrorHandler = _arg4;
            chainedRSLErrorHandler = _arg5;
            if (!resourceManager)
            {
                if (this.appDomain.hasDefinition("mx.resources::ResourceManager"))
                {
                    _local7 = Class(this.appDomain.getDefinition("mx.resources::ResourceManager"));
                    resourceManager = IResourceManager(_local7["getInstance"]());
                }
                else
                {
                    return;
                };
            };
            var _local6:IEventDispatcher = resourceManager.loadResourceModule(url);
            _local6.addEventListener(ResourceEvent.PROGRESS, itemProgressHandler);
            _local6.addEventListener(ResourceEvent.COMPLETE, itemCompleteHandler);
            _local6.addEventListener(ResourceEvent.ERROR, this.resourceErrorHandler);
        }

        private function resourceErrorHandler(_arg1:ResourceEvent):void
        {
            var _local2:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
            _local2.text = _arg1.errorText;
            super.itemErrorHandler(_local2);
        }


    }
}//package mx.core

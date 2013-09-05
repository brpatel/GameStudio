//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core
{
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.system.LoaderContext;
    import mx.utils.LoaderUtil;
    import flash.events.ProgressEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.system.ApplicationDomain;
    import mx.events.RSLEvent;
    import flash.events.ErrorEvent;

    public class RSLItem 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        public var urlRequest:URLRequest;
        public var total:uint = 0;
        public var loaded:uint = 0;
        public var rootURL:String;
        protected var chainedProgressHandler:Function;
        protected var chainedCompleteHandler:Function;
        protected var chainedIOErrorHandler:Function;
        protected var chainedSecurityErrorHandler:Function;
        protected var chainedRSLErrorHandler:Function;
        private var completed:Boolean = false;
        private var errorText:String;
        protected var moduleFactory:IFlexModuleFactory;
        protected var url:String;

        public function RSLItem(_arg1:String, _arg2:String=null, _arg3:IFlexModuleFactory=null)
        {
            this.url = _arg1;
            this.rootURL = _arg2;
            this.moduleFactory = _arg3;
        }

        public function load(_arg1:Function, _arg2:Function, _arg3:Function, _arg4:Function, _arg5:Function):void
        {
            this.chainedProgressHandler = _arg1;
            this.chainedCompleteHandler = _arg2;
            this.chainedIOErrorHandler = _arg3;
            this.chainedSecurityErrorHandler = _arg4;
            this.chainedRSLErrorHandler = _arg5;
            var _local6:Loader = new Loader();
            var _local7:LoaderContext = new LoaderContext();
            this.urlRequest = new URLRequest(LoaderUtil.createAbsoluteURL(this.rootURL, this.url));
            _local6.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.itemProgressHandler);
            _local6.contentLoaderInfo.addEventListener(Event.COMPLETE, this.itemCompleteHandler);
            _local6.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.itemErrorHandler);
            _local6.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.itemErrorHandler);
            if (this.moduleFactory != null)
            {
                _local7.applicationDomain = this.moduleFactory.info()["currentDomain"];
            }
            else
            {
                _local7.applicationDomain = ApplicationDomain.currentDomain;
            };
            _local6.load(this.urlRequest, _local7);
        }

        public function itemProgressHandler(_arg1:ProgressEvent):void
        {
            this.loaded = _arg1.bytesLoaded;
            this.total = _arg1.bytesTotal;
            if (this.chainedProgressHandler != null)
            {
                this.chainedProgressHandler(_arg1);
            };
        }

        public function itemCompleteHandler(_arg1:Event):void
        {
            this.completed = true;
            if (this.chainedCompleteHandler != null)
            {
                this.chainedCompleteHandler(_arg1);
            };
        }

        public function itemErrorHandler(_arg1:ErrorEvent):void
        {
            this.errorText = decodeURI(_arg1.text);
            this.completed = true;
            this.loaded = 0;
            this.total = 0;
            trace(this.errorText);
            if ((((_arg1.type == IOErrorEvent.IO_ERROR)) && (!((this.chainedIOErrorHandler == null)))))
            {
                this.chainedIOErrorHandler(_arg1);
            }
            else
            {
                if ((((_arg1.type == SecurityErrorEvent.SECURITY_ERROR)) && (!((this.chainedSecurityErrorHandler == null)))))
                {
                    this.chainedSecurityErrorHandler(_arg1);
                }
                else
                {
                    if ((((_arg1.type == RSLEvent.RSL_ERROR)) && (!((this.chainedRSLErrorHandler == null)))))
                    {
                        this.chainedRSLErrorHandler(_arg1);
                    };
                };
            };
        }


    }
}//package mx.core

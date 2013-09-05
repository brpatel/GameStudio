//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core
{
    import flash.events.Event;

    public class RSLListLoader 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var currentIndex:int = 0;
        private var rslList:Array;
        private var chainedProgressHandler:Function;
        private var chainedCompleteHandler:Function;
        private var chainedIOErrorHandler:Function;
        private var chainedSecurityErrorHandler:Function;
        private var chainedRSLErrorHandler:Function;

        public function RSLListLoader(_arg1:Array)
        {
            this.rslList = [];
            super();
            this.rslList = _arg1;
        }

        public function load(_arg1:Function, _arg2:Function, _arg3:Function, _arg4:Function, _arg5:Function):void
        {
            this.chainedProgressHandler = _arg1;
            this.chainedCompleteHandler = _arg2;
            this.chainedIOErrorHandler = _arg3;
            this.chainedSecurityErrorHandler = _arg4;
            this.chainedRSLErrorHandler = _arg5;
            this.currentIndex = -1;
            this.loadNext();
        }

        private function loadNext():void
        {
            if (!this.isDone())
            {
                this.currentIndex++;
                if (this.currentIndex < this.rslList.length)
                {
                    this.rslList[this.currentIndex].load(this.chainedProgressHandler, this.listCompleteHandler, this.listIOErrorHandler, this.listSecurityErrorHandler, this.chainedRSLErrorHandler);
                };
            };
        }

        public function getItem(_arg1:int):RSLItem
        {
            if ((((_arg1 < 0)) || ((_arg1 >= this.rslList.length))))
            {
                return (null);
            };
            return (this.rslList[_arg1]);
        }

        public function getIndex():int
        {
            return (this.currentIndex);
        }

        public function getItemCount():int
        {
            return (this.rslList.length);
        }

        public function isDone():Boolean
        {
            return ((this.currentIndex >= this.rslList.length));
        }

        private function listCompleteHandler(_arg1:Event):void
        {
            if (this.chainedCompleteHandler != null)
            {
                this.chainedCompleteHandler(_arg1);
            };
            this.loadNext();
        }

        private function listIOErrorHandler(_arg1:Event):void
        {
            if (this.chainedIOErrorHandler != null)
            {
                this.chainedIOErrorHandler(_arg1);
            };
        }

        private function listSecurityErrorHandler(_arg1:Event):void
        {
            if (this.chainedSecurityErrorHandler != null)
            {
                this.chainedSecurityErrorHandler(_arg1);
            };
        }


    }
}//package mx.core

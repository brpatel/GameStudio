//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.rpc
{
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class AsyncDispatcher 
    {

        private var _method:Function;
        private var _args:Array;
        private var _timer:Timer;

        public function AsyncDispatcher(_arg1:Function, _arg2:Array, _arg3:Number)
        {
            this._method = _arg1;
            this._args = _arg2;
            this._timer = new Timer(_arg3);
            this._timer.addEventListener(TimerEvent.TIMER, this.timerEventHandler);
            this._timer.start();
        }

        private function timerEventHandler(_arg1:TimerEvent):void
        {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER, this.timerEventHandler);
            this._method.apply(null, this._args);
        }


    }
}//package mx.rpc

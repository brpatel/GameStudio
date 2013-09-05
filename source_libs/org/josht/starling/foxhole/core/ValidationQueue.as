//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.core
{
    import __AS3__.vec.Vector;
    import starling.core.Starling;
    import __AS3__.vec.*;
    import starling.animation.*;

    public class ValidationQueue implements IAnimatable 
    {

        private var _isValidating:Boolean = false;
        private var _delayedQueue:Vector.<FoxholeControl>;
        private var _queue:Vector.<FoxholeControl>;

        public function ValidationQueue()
        {
            this._delayedQueue = new <FoxholeControl>[];
            this._queue = new <FoxholeControl>[];
            super();
        }

        public function addControl(_arg1:FoxholeControl, _arg2:Boolean):void
        {
            var _local6:FoxholeControl;
            var _local3:Vector.<FoxholeControl> = ((((this._isValidating) && (_arg2))) ? this._delayedQueue : this._queue);
            var _local4:int = _local3.length;
            var _local5:int;
            while (_local5 < _local4)
            {
                _local6 = _local3[_local5];
                if (_arg1.contains(_local6)) break;
                _local5++;
            };
            _local3.splice(_local5, 0, _arg1);
            if (((((!(this._isValidating)) && ((_local3 == this._queue)))) && ((this._queue.length == 1))))
            {
                Starling.juggler.add(this);
            };
        }

        public function advanceTime(_arg1:Number):void
        {
            var _local3:FoxholeControl;
            this._isValidating = true;
            while (this._queue.length > 0)
            {
                _local3 = this._queue.shift();
                _local3.validate();
            };
            var _local2:Vector.<FoxholeControl> = this._queue;
            this._queue = this._delayedQueue;
            this._delayedQueue = _local2;
            if (this._queue.length == 0)
            {
                Starling.juggler.remove(this);
            };
            this._isValidating = false;
        }


    }
}//package org.josht.starling.foxhole.core

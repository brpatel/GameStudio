//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.motion
{
    import com.gskinner.motion.GTween;
    import starling.animation.Juggler;
    import starling.core.Starling;
    import starling.animation.*;

    public class GTween extends com.gskinner.motion.GTween implements IAnimatable 
    {

        private var _juggler:Juggler;

        public function GTween(_arg1:Object=null, _arg2:Number=1, _arg3:Object=null, _arg4:Object=null, _arg5:Object=null)
        {
            if (!_arg4.hasOwnProperty("juggler"))
            {
                _arg4.juggler = Starling.juggler;
            };
            super(_arg1, _arg2, _arg3, _arg4, _arg5);
        }

        public function get juggler():Juggler
        {
            return (this._juggler);
        }

        public function set juggler(_arg1:Juggler):void
        {
            if (((this._juggler) && (!(this._paused))))
            {
                this.paused = true;
            };
            this._juggler = _arg1;
        }

        override public function set paused(_arg1:Boolean):void
        {
            if (this._paused == _arg1)
            {
                return;
            };
            this._paused = _arg1;
            if (this._paused)
            {
                this._juggler.remove(this);
            }
            else
            {
                if (((isNaN(_position)) || (((!((repeatCount == 0))) && ((_position >= (repeatCount * duration)))))))
                {
                    _inited = false;
                    calculatedPosition = (calculatedPositionOld = (ratio = (ratioOld = (positionOld = 0))));
                    _position = -(delay);
                };
                this._juggler.add(this);
            };
        }

        public function advanceTime(_arg1:Number):void
        {
            this.position = (this._position + (((this.useFrames) ? timeScaleAll : _arg1) * this.timeScale));
        }


    }
}//package org.josht.starling.motion

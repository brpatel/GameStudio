//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import flash.errors.IllegalOperationError;

    public class Check extends Button 
    {

        public function Check()
        {
            super.isToggle = true;
        }

        override public function set isToggle(_arg1:Boolean):void
        {
            throw (IllegalOperationError("CheckBox isToggle must always be true."));
        }


    }
}//package org.josht.starling.foxhole.controls

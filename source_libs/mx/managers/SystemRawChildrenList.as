//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.managers
{
    import mx.core.mx_internal;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import mx.core.*;

    use namespace mx_internal;

    public class SystemRawChildrenList implements IChildList 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var owner:SystemManager;

        public function SystemRawChildrenList(_arg1:SystemManager)
        {
            this.owner = _arg1;
        }

        public function get numChildren():int
        {
            return (this.owner.$numChildren);
        }

        public function getChildAt(_arg1:int):DisplayObject
        {
            return (this.owner.rawChildren_getChildAt(_arg1));
        }

        public function addChild(_arg1:DisplayObject):DisplayObject
        {
            return (this.owner.rawChildren_addChild(_arg1));
        }

        public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject
        {
            return (this.owner.rawChildren_addChildAt(_arg1, _arg2));
        }

        public function removeChild(_arg1:DisplayObject):DisplayObject
        {
            return (this.owner.rawChildren_removeChild(_arg1));
        }

        public function removeChildAt(_arg1:int):DisplayObject
        {
            return (this.owner.rawChildren_removeChildAt(_arg1));
        }

        public function getChildByName(_arg1:String):DisplayObject
        {
            return (this.owner.rawChildren_getChildByName(_arg1));
        }

        public function getChildIndex(_arg1:DisplayObject):int
        {
            return (this.owner.rawChildren_getChildIndex(_arg1));
        }

        public function setChildIndex(_arg1:DisplayObject, _arg2:int):void
        {
            this.owner.rawChildren_setChildIndex(_arg1, _arg2);
        }

        public function getObjectsUnderPoint(_arg1:Point):Array
        {
            return (this.owner.rawChildren_getObjectsUnderPoint(_arg1));
        }

        public function contains(_arg1:DisplayObject):Boolean
        {
            return (this.owner.rawChildren_contains(_arg1));
        }


    }
}//package mx.managers

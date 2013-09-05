//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.managers
{
    import mx.core.mx_internal;
    import mx.core.Singleton;

    use namespace mx_internal;

    public class CursorManager 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const NO_CURSOR:int = 0;

        private static var implClassDependency:CursorManagerImpl;
        private static var _impl:ICursorManager;


        private static function get impl():ICursorManager
        {
            if (!_impl)
            {
                _impl = ICursorManager(Singleton.getInstance("mx.managers::ICursorManager"));
            };
            return (_impl);
        }

        public static function getInstance():ICursorManager
        {
            return (impl);
        }

        public static function get currentCursorID():int
        {
            return (impl.currentCursorID);
        }

        public static function set currentCursorID(_arg1:int):void
        {
            impl.currentCursorID = _arg1;
        }

        public static function get currentCursorXOffset():Number
        {
            return (impl.currentCursorXOffset);
        }

        public static function set currentCursorXOffset(_arg1:Number):void
        {
            impl.currentCursorXOffset = _arg1;
        }

        public static function get currentCursorYOffset():Number
        {
            return (impl.currentCursorYOffset);
        }

        public static function set currentCursorYOffset(_arg1:Number):void
        {
            impl.currentCursorYOffset = _arg1;
        }

        public static function showCursor():void
        {
            impl.showCursor();
        }

        public static function hideCursor():void
        {
            impl.hideCursor();
        }

        public static function setCursor(_arg1:Class, _arg2:int=2, _arg3:Number=0, _arg4:Number=0):int
        {
            return (impl.setCursor(_arg1, _arg2, _arg3, _arg4));
        }

        public static function removeCursor(_arg1:int):void
        {
            impl.removeCursor(_arg1);
        }

        public static function removeAllCursors():void
        {
            impl.removeAllCursors();
        }

        public static function setBusyCursor():void
        {
            impl.setBusyCursor();
        }

        public static function removeBusyCursor():void
        {
            impl.removeBusyCursor();
        }

        mx_internal static function registerToUseBusyCursor(_arg1:Object):void
        {
            impl.registerToUseBusyCursor(_arg1);
        }

        mx_internal static function unRegisterToUseBusyCursor(_arg1:Object):void
        {
            impl.unRegisterToUseBusyCursor(_arg1);
        }


    }
}//package mx.managers

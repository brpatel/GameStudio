//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.utils
{
    import mx.core.Singleton;
    import mx.core.RuntimeDPIProvider;
    import mx.core.DPIClassification;

    public class DensityUtil 
    {

        private static var runtimeDPI:Number;


        public static function getRuntimeDPI():Number
        {
            if (!isNaN(runtimeDPI))
            {
                return (runtimeDPI);
            };
            var _local1:Class = Singleton.getClass("mx.core::RuntimeDPIProvider");
            if (!_local1)
            {
                _local1 = RuntimeDPIProvider;
            };
            var _local2:RuntimeDPIProvider = RuntimeDPIProvider(new (_local1)());
            runtimeDPI = _local2.runtimeDPI;
            return (runtimeDPI);
        }

        public static function getDPIScale(_arg1:Number, _arg2:Number):Number
        {
            if (((((((!((_arg1 == DPIClassification.DPI_160))) && (!((_arg1 == DPIClassification.DPI_240))))) && (!((_arg1 == DPIClassification.DPI_320))))) || (((((!((_arg2 == DPIClassification.DPI_160))) && (!((_arg2 == DPIClassification.DPI_240))))) && (!((_arg2 == DPIClassification.DPI_320)))))))
            {
                return (NaN);
            };
            return ((_arg2 / _arg1));
        }


    }
}//package mx.utils

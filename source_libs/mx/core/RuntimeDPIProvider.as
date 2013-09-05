//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.core
{
    import flash.system.Capabilities;

    public class RuntimeDPIProvider 
    {


        mx_internal static function classifyDPI(_arg1:Number):Number
        {
            if (_arg1 < 200)
            {
                return (DPIClassification.DPI_160);
            };
            if (_arg1 <= 280)
            {
                return (DPIClassification.DPI_240);
            };
            return (DPIClassification.DPI_320);
        }


        public function get runtimeDPI():Number
        {
			if (Capabilities.screenDPI < 200)
			{
				return (DPIClassification.DPI_160);
			};
			if (Capabilities.screenDPI <= 280)
			{
				return (DPIClassification.DPI_240);
			};
			return (DPIClassification.DPI_320);
			
         //   return (classifyDPI(Capabilities.screenDPI));
        }


    }
}//package mx.core

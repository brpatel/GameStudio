//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    import mx.core.mx_internal;
    import flash.utils.IExternalizable;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.*;

    use namespace mx_internal;

    public class ArrayCollection extends ListCollectionView implements IExternalizable 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        public function ArrayCollection(_arg1:Array=null)
        {
            this.source = _arg1;
        }

        [Bindable("listChanged")]
        public function get source():Array
        {
            if (((list) && ((list is ArrayList))))
            {
                return (ArrayList(list).source);
            };
            return (null);
        }

        public function set source(_arg1:Array):void
        {
            list = new ArrayList(_arg1);
        }

        public function readExternal(_arg1:IDataInput):void
        {
            if ((list is IExternalizable))
            {
                IExternalizable(list).readExternal(_arg1);
            }
            else
            {
                this.source = (_arg1.readObject() as Array);
            };
        }

        public function writeExternal(_arg1:IDataOutput):void
        {
            if ((list is IExternalizable))
            {
                IExternalizable(list).writeExternal(_arg1);
            }
            else
            {
                _arg1.writeObject(this.source);
            };
        }


    }
}//package mx.collections

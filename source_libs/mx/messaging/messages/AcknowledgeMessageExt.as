//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.messages
{
    import flash.utils.IDataOutput;
    import flash.utils.*;

    public class AcknowledgeMessageExt extends AcknowledgeMessage implements IExternalizable 
    {

        private var _message:AcknowledgeMessage;

        public function AcknowledgeMessageExt(_arg1:AcknowledgeMessage=null)
        {
            this._message = _arg1;
        }

        override public function writeExternal(_arg1:IDataOutput):void
        {
            if (this._message != null)
            {
                this._message.writeExternal(_arg1);
            }
            else
            {
                super.writeExternal(_arg1);
            };
        }

        override public function get messageId():String
        {
            if (this._message != null)
            {
                return (this._message.messageId);
            };
            return (super.messageId);
        }


    }
}//package mx.messaging.messages

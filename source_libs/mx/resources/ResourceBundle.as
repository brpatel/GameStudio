//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.resources
{
    import mx.core.mx_internal;
    import flash.system.ApplicationDomain;

    use namespace mx_internal;

    public class ResourceBundle implements IResourceBundle 
    {

        mx_internal static const VERSION:String = "4.6.0.0";

        mx_internal static var locale:String;
        mx_internal static var backupApplicationDomain:ApplicationDomain;

        mx_internal var _bundleName:String;
        private var _content:Object;
        mx_internal var _locale:String;

        public function ResourceBundle(_arg1:String=null, _arg2:String=null)
        {
            this._content = {};
            super();
            this._locale = _arg1;
            this._bundleName = _arg2;
            this._content = this.getContent();
        }

        private static function getClassByName(_arg1:String, _arg2:ApplicationDomain):Class
        {
            var _local3:Class;
            if (_arg2.hasDefinition(_arg1))
            {
                _local3 = (_arg2.getDefinition(_arg1) as Class);
            };
            return (_local3);
        }


        public function get bundleName():String
        {
            return (this._bundleName);
        }

        public function get content():Object
        {
            return (this._content);
        }

        public function get locale():String
        {
            return (this._locale);
        }

        protected function getContent():Object
        {
            return ({});
        }

        private function _getObject(_arg1:String):Object
        {
            var _local2:Object = this.content[_arg1];
            if (!_local2)
            {
                throw (new Error(((("Key " + _arg1) + " was not found in resource bundle ") + this.bundleName)));
            };
            return (_local2);
        }


    }
}//package mx.resources

package com.adobe.gamebuilder.editor.core.manager
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    
    import flash.data.SQLConnection;
    import flash.data.SQLMode;
    import flash.events.SQLErrorEvent;
    import flash.events.SQLEvent;
    import flash.filesystem.File;

    public class DBManager 
    {

        private static var _callback:Function;
        private static var _productDBConnection:SQLConnection;


        public static function init(_arg1:Function):void
        {
            var productDB:File;
            var callback:Function = _arg1;
            _callback = callback;
            try
            {
                productDB = File.applicationStorageDirectory.resolvePath(Constants.PRODUCT_DB);
                if (productDB.exists)
                {
                    productDBcopy();
                }
                else
                {
                    productDBcopy();
                };
            }
            catch(e:Error)
            {
                Common.log(e.message, "ERROR");
            };
        }

        private static function installFile():File
        {
            var installDB:File;
            try
            {
                installDB = File.applicationDirectory.resolvePath(Constants.PRODUCT_DB);
                if (!installDB.exists)
                {
                    installDB = File.applicationDirectory.resolvePath(Constants.PRODUCT_DB_DEV);
                };
            }
            catch(e:Error)
            {
                Common.log(e.message, "ERROR");
            };
            return (installDB);
        }

        private static function productDBcopy():void
        {
            var _local1:File = installFile();
            _local1.copyTo(File.applicationStorageDirectory.resolvePath(Constants.PRODUCT_DB), true);
            productDBopen();
			
			
			
        }

        private static function productDBopen():void
        {
            var _local1:File = File.applicationStorageDirectory.resolvePath(Constants.PRODUCT_DB);
            _productDBConnection = new SQLConnection();
            _productDBConnection.addEventListener(SQLEvent.OPEN, onProductSQLConnectionOpen);
            _productDBConnection.addEventListener(SQLErrorEvent.ERROR, onProductSQLError);
            _productDBConnection.open(_local1, SQLMode.READ);
        }

        private static function onProductSQLError(_arg1:SQLErrorEvent):void
        {
            _productDBConnection.removeEventListener(SQLEvent.OPEN, onProductSQLConnectionOpen);
            _productDBConnection.removeEventListener(SQLErrorEvent.ERROR, onProductSQLError);
        }

        private static function onProductSQLConnectionOpen(_arg1:SQLEvent):void
        {
            var event:SQLEvent = _arg1;
            try
            {
                _productDBConnection.removeEventListener(SQLEvent.OPEN, onProductSQLConnectionOpen);
                _productDBConnection.removeEventListener(SQLErrorEvent.ERROR, onProductSQLError);
            }
            catch(e:Error)
            {
                Common.log(e.message, "ERROR");
                return;
            };
            if (_callback != null)
            {
                _callback();
            };
        }

        public static function get productDBConnection():SQLConnection
        {
            return (_productDBConnection);
        }


    }
}//package at.polypex.badplaner.core.manager

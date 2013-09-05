package com.adobe.gamebuilder.editor.core
{
    import mx.resources.ResourceManager;

    public class Locale 
    {

        public static const DE:String = "de_DE";
        public static const EN:String = "en_US";

        private static var _currentLang:String="en";


        public static function get currentLang():String
        {
            return (_currentLang);
        }

        public static function get defaultLocale():String
        {
            return (Locale.EN);
        }

        public static function setLanguage(_arg1:String):void
        {
            if (isAvailable(_arg1))
            {
                setChain(_arg1);
            }
            else
            {
                setChain(shortLocaleCode(defaultLocale));
            };
        }

        private static function setChain(_arg1:String):void
        {
            if (_arg1 == "de")
            {
                ResourceManager.getInstance().localeChain = [DE, EN];
            }
            else
            {
                ResourceManager.getInstance().localeChain = [EN, DE];
            };
            _currentLang = _arg1;
        }

        public static function isAvailable(_arg1:String):Boolean
        {
            var _local2:String = longLocaleCode(_arg1);
            return (!((new Array(DE, EN).indexOf(_local2) == -1)));
        }

        public static function longLocaleCode(_arg1:String):String
        {
            switch (_arg1)
            {
                case "de":
                    return (DE);
                case "de_DE":
                    return (DE);
                case "de-DE":
                    return (DE);
                case "en":
                    return (EN);
                case "en_US":
                    return (EN);
                case "en-US":
                    return (EN);
                default:
                    return (defaultLocale);
            };
        }

        public static function styleCode(_arg1:String):String
        {
            return (longLocaleCode(_arg1).replace("_", "-"));
        }

        public static function shortLocaleCode(_arg1:String):String
        {
            return (_arg1.substr(0, 2));
        }


    }
}//package at.polypex.badplaner.core

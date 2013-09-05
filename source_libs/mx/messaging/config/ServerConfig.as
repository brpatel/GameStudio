//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging.config
{
    import mx.resources.IResourceManager;
    import mx.messaging.ChannelSet;
    import mx.resources.ResourceManager;
    import mx.core.mx_internal;
    import mx.utils.ObjectUtil;
    import mx.messaging.Channel;
    import mx.messaging.errors.InvalidDestinationError;
    import flash.utils.getQualifiedClassName;
    import mx.messaging.MessageAgent;
    import mx.messaging.errors.InvalidChannelError;
    import flash.utils.getDefinitionByName;
    import mx.collections.ArrayCollection;

    use namespace mx_internal;

    public class ServerConfig 
    {

        public static const CLASS_ATTR:String = "type";
        public static const URI_ATTR:String = "uri";

        private static var _resourceManager:IResourceManager;
        public static var serverConfigData:XML;
        private static var _channelSets:Object = {};
        private static var _clusteredChannels:Object = {};
        private static var _unclusteredChannels:Object = {};
        private static var _configFetchedChannels:Object;
        public static var channelSetFactory:Class = ChannelSet;


        private static function get resourceManager():IResourceManager
        {
            if (!_resourceManager)
            {
                _resourceManager = ResourceManager.getInstance();
            };
            return (_resourceManager);
        }

        public static function get xml():XML
        {
            if (serverConfigData == null)
            {
                serverConfigData = <services/>
                ;
            };
            return (serverConfigData);
        }

        public static function set xml(_arg1:XML):void
        {
            serverConfigData = _arg1;
            _channelSets = {};
            _clusteredChannels = {};
            _unclusteredChannels = {};
        }

        public static function checkChannelConsistency(_arg1:String, _arg2:String):void
        {
            var _local3:Array = getChannelIdList(_arg1);
            var _local4:Array = getChannelIdList(_arg2);
            if (ObjectUtil.compare(_local3, _local4) != 0)
            {
                throw (new ArgumentError("Specified destinations are not channel consistent"));
            };
        }

        public static function getChannel(_arg1:String, _arg2:Boolean=false):Channel
        {
            var _local3:Channel;
            if (!_arg2)
            {
                if ((_arg1 in _unclusteredChannels))
                {
                    return (_unclusteredChannels[_arg1]);
                };
                _local3 = createChannel(_arg1);
                _unclusteredChannels[_arg1] = _local3;
                return (_local3);
            };
            if ((_arg1 in _clusteredChannels))
            {
                return (_clusteredChannels[_arg1]);
            };
            _local3 = createChannel(_arg1);
            _clusteredChannels[_arg1] = _local3;
            return (_local3);
        }

        public static function getChannelSet(_arg1:String):ChannelSet
        {
            var _local2:XML = getDestinationConfig(_arg1);
            return (internalGetChannelSet(_local2, _arg1));
        }

        public static function getProperties(_arg1:String):XMLList
        {
            var destination:XMLList;
            var message:String;
            var destinationId:String = _arg1;
            destination = xml..destination.(@id == destinationId);
            if (destination.length() > 0)
            {
                return (destination.properties);
            };
            message = resourceManager.getString("messaging", "unknownDestination", [destinationId]);
            throw (new InvalidDestinationError(message));
        }

        mx_internal static function channelSetMatchesDestinationConfig(_arg1:ChannelSet, _arg2:String):Boolean
        {
            var csUris:Array;
            var csChannels:Array;
            var i:uint;
            var ids:Array;
            var dsUris:Array;
            var dsChannels:XMLList;
            var channelConfig:XML;
            var endpoint:XML;
            var dsUri:String;
            var j:uint;
            var channelSet:ChannelSet = _arg1;
            var destination:String = _arg2;
            if (channelSet != null)
            {
                if (ObjectUtil.compare(channelSet.channelIds, getChannelIdList(destination)) == 0)
                {
                    return (true);
                };
                csUris = [];
                csChannels = channelSet.channels;
                i = 0;
                while (i < csChannels.length)
                {
                    csUris.push(csChannels[i].uri);
                    i = (i + 1);
                };
                ids = getChannelIdList(destination);
                dsUris = [];
                j = 0;
                while (j < ids.length)
                {
                    dsChannels = xml.channels.channel.(@id == ids[j]);
                    channelConfig = dsChannels[0];
                    endpoint = channelConfig.endpoint;
                    dsUri = (((endpoint.length() > 0)) ? endpoint[0].attribute(URI_ATTR).toString() : null);
                    if (dsUri != null)
                    {
                        dsUris.push(dsUri);
                    };
                    j = (j + 1);
                };
                return ((ObjectUtil.compare(csUris, dsUris) == 0));
            };
            return (false);
        }

        mx_internal static function fetchedConfig(_arg1:String):Boolean
        {
            return (((!((_configFetchedChannels == null))) && (!((_configFetchedChannels[_arg1] == null)))));
        }

        mx_internal static function getChannelIdList(_arg1:String):Array
        {
            var _local2:XML = getDestinationConfig(_arg1);
            return (((_local2) ? getChannelIds(_local2) : getDefaultChannelIds()));
        }

        mx_internal static function needsConfig(_arg1:Channel):Boolean
        {
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            var _local5:Array;
            var _local6:int;
            var _local7:int;
            if ((((_configFetchedChannels == null)) || ((_configFetchedChannels[_arg1.endpoint] == null))))
            {
                _local2 = _arg1.channelSets;
                _local3 = _local2.length;
                _local4 = 0;
                while (_local4 < _local3)
                {
                    if (getQualifiedClassName(_local2[_local4]).indexOf("Advanced") != -1)
                    {
                        return (true);
                    };
                    _local5 = ChannelSet(_local2[_local4]).messageAgents;
                    _local6 = _local5.length;
                    _local7 = 0;
                    while (_local7 < _local6)
                    {
                        if (MessageAgent(_local5[_local7]).needsConfig)
                        {
                            return (true);
                        };
                        _local7++;
                    };
                    _local4++;
                };
            };
            return (false);
        }

        mx_internal static function updateServerConfigData(_arg1:ConfigMap, _arg2:String=null):void
        {
            var newServices:XML;
            var newService:XML;
            var newChannels:XMLList;
            var oldServices:XMLList;
            var oldDestinations:XMLList;
            var newDestination:XML;
            var oldService:XML;
            var oldChannels:XML;
            var serverConfig:ConfigMap = _arg1;
            var endpoint = _arg2;
            if (serverConfig != null)
            {
                if (endpoint != null)
                {
                    if (_configFetchedChannels == null)
                    {
                        _configFetchedChannels = {};
                    };
                    _configFetchedChannels[endpoint] = true;
                };
                newServices = <services></services>
                ;
                convertToXML(serverConfig, newServices);
                xml["default-channels"] = newServices["default-channels"];
                for each (newService in newServices..service)
                {
                    oldServices = xml.service.(@id == newService.@id);
                    if (oldServices.length() != 0)
                    {
                        oldService = oldServices[0];
                        for each (newDestination in newService..destination)
                        {
                            oldDestinations = oldService.destination.(@id == newDestination.@id);
                            if (oldDestinations.length() != 0)
                            {
                                delete oldDestinations[0];
                            };
                            oldService.appendChild(newDestination.copy());
                        };
                    }
                    else
                    {
                        for each (newDestination in newService..destination)
                        {
                            oldDestinations = xml..destination.(@id == newDestination.@id);
                            if (oldDestinations.length() != 0)
                            {
                                oldDestinations[0] = newDestination[0].copy();
                                delete newService..destination.(@id == newDestination.@id)[0];
                            };
                        };
                        if (newService.children().length() > 0)
                        {
                            xml.appendChild(newService);
                        };
                    };
                };
                newChannels = newServices.channels;
                if (newChannels.length() > 0)
                {
                    oldChannels = xml.channels[0];
                    if ((((oldChannels == null)) || ((oldChannels.length() == 0))))
                    {
                        xml.appendChild(newChannels);
                    };
                };
            };
        }

        private static function createChannel(_arg1:String):Channel
        {
            var message:String;
            var channels:XMLList;
            var channelConfig:XML;
            var className:String;
            var endpoint:XMLList;
            var uri:String;
            var channel:Channel;
            var channelClass:Class;
            var channelId:String = _arg1;
            channels = xml.channels.channel.(@id == channelId);
            if (channels.length() == 0)
            {
                message = resourceManager.getString("messaging", "unknownChannelWithId", [channelId]);
                throw (new InvalidChannelError(message));
            };
            channelConfig = channels[0];
            className = channelConfig.attribute(CLASS_ATTR).toString();
            endpoint = channelConfig.endpoint;
            uri = (((endpoint.length() > 0)) ? endpoint[0].attribute(URI_ATTR).toString() : null);
            channel = null;
            try
            {
                channelClass = (getDefinitionByName(className) as Class);
                channel = new channelClass(channelId, uri);
                channel.applySettings(channelConfig);
                if (((!((LoaderConfig.parameters == null))) && (!((LoaderConfig.parameters.WSRP_ENCODED_CHANNEL == null)))))
                {
                    channel.url = LoaderConfig.parameters.WSRP_ENCODED_CHANNEL;
                };
            }
            catch(e:ReferenceError)
            {
                message = resourceManager.getString("messaging", "unknownChannelClass", [className]);
                throw (new InvalidChannelError(message));
            };
            return (channel);
        }

        private static function convertToXML(_arg1:ConfigMap, _arg2:XML):void
        {
            var _local3:Object;
            var _local4:Object;
            var _local5:Array;
            var _local6:int;
            var _local7:XML;
            var _local8:XML;
            for (_local3 in _arg1)
            {
                _local4 = _arg1[_local3];
                if ((_local4 is String))
                {
                    if (_local3 == "")
                    {
                        _arg2.appendChild(_local4);
                    }
                    else
                    {
                        _arg2.@[_local3] = _local4;
                    };
                }
                else
                {
                    if ((((_local4 is ArrayCollection)) || ((_local4 is Array))))
                    {
                        if ((_local4 is ArrayCollection))
                        {
                            _local5 = ArrayCollection(_local4).toArray();
                        }
                        else
                        {
                            _local5 = (_local4 as Array);
                        };
                        _local6 = 0;
                        while (_local6 < _local5.length)
                        {
                            _local7 = new XML((((("<" + _local3) + "></") + _local3) + ">"));
                            _arg2.appendChild(_local7);
                            convertToXML((_local5[_local6] as ConfigMap), _local7);
                            _local6++;
                        };
                    }
                    else
                    {
                        _local8 = new XML((((("<" + _local3) + "></") + _local3) + ">"));
                        _arg2.appendChild(_local8);
                        convertToXML((_local4 as ConfigMap), _local8);
                    };
                };
            };
        }

        private static function getChannelIds(_arg1:XML):Array
        {
            var _local2:Array = [];
            var _local3:XMLList = _arg1.channels.channel;
            var _local4:int = _local3.length();
            var _local5:int;
            while (_local5 < _local4)
            {
                _local2.push(_local3[_local5].@ref.toString());
                _local5++;
            };
            return (_local2);
        }

        private static function getDefaultChannelIds():Array
        {
            var _local1:Array = [];
            var _local2:XMLList = xml["default-channels"].channel;
            var _local3:int = _local2.length();
            var _local4:int;
            while (_local4 < _local3)
            {
                _local1.push(_local2[_local4].@ref.toString());
                _local4++;
            };
            return (_local1);
        }

        private static function getDestinationConfig(_arg1:String):XML
        {
            var destinations:XMLList;
            var destinationCount:int;
            var destinationId:String = _arg1;
            destinations = xml..destination.(@id == destinationId);
            destinationCount = destinations.length();
            if (destinationCount == 0)
            {
                return (null);
            };
            return (destinations[0]);
        }

        private static function internalGetChannelSet(_arg1:XML, _arg2:String):ChannelSet
        {
            var _local3:Array;
            var _local4:Boolean;
            var _local6:String;
            var _local7:ChannelSet;
            var _local8:int;
            if (_arg1 == null)
            {
                _local3 = getDefaultChannelIds();
                if (_local3.length == 0)
                {
                    _local6 = resourceManager.getString("messaging", "noChannelForDestination", [_arg2]);
                    throw (new InvalidDestinationError(_local6));
                };
                _local4 = false;
            }
            else
            {
                _local3 = getChannelIds(_arg1);
                _local4 = (((_arg1.properties.network.cluster.length())>0) ? true : false);
            };
            var _local5:String = ((_local3.join(",") + ":") + _local4);
            if ((_local5 in _channelSets))
            {
                return (_channelSets[_local5]);
            };
            _local7 = new channelSetFactory(_local3, _local4);
            _local8 = serverConfigData["flex-client"]["heartbeat-interval-millis"];
            if (_local8 > 0)
            {
                _local7.heartbeatInterval = _local8;
            };
            if (_local4)
            {
                _local7.initialDestinationId = _arg2;
            };
            _channelSets[_local5] = _local7;
            return (_local7);
        }


    }
}//package mx.messaging.config

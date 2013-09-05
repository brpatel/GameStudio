package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.util.ArrayUtil;
    
    import __AS3__.vec.Vector;

    public class MarkerOrganizer 
    {

        private var _leftMainMarkers:Vector.<MeasureLine>;
        private var _leftInterMarkers:Vector.<MeasureLine>;
        private var _leftOpeningMarkers:Vector.<MeasureLine>;
        private var _rightMainMarkers:Vector.<MeasureLine>;
        private var _rightInterMarkers:Vector.<MeasureLine>;
        private var _rightOpeningMarkers:Vector.<MeasureLine>;
        private var _topMainMarkers:Vector.<MeasureLine>;
        private var _topInterMarkers:Vector.<MeasureLine>;
        private var _topOpeningMarkers:Vector.<MeasureLine>;
        private var _bottomMainMarkers:Vector.<MeasureLine>;
        private var _bottomInterMarkers:Vector.<MeasureLine>;
        private var _bottomOpeningMarkers:Vector.<MeasureLine>;

        public function MarkerOrganizer()
        {
            this._leftMainMarkers = new Vector.<MeasureLine>();
            this._leftInterMarkers = new Vector.<MeasureLine>();
            this._leftOpeningMarkers = new Vector.<MeasureLine>();
            this._rightMainMarkers = new Vector.<MeasureLine>();
            this._rightInterMarkers = new Vector.<MeasureLine>();
            this._rightOpeningMarkers = new Vector.<MeasureLine>();
            this._topMainMarkers = new Vector.<MeasureLine>();
            this._topInterMarkers = new Vector.<MeasureLine>();
            this._topOpeningMarkers = new Vector.<MeasureLine>();
            this._bottomMainMarkers = new Vector.<MeasureLine>();
            this._bottomInterMarkers = new Vector.<MeasureLine>();
            this._bottomOpeningMarkers = new Vector.<MeasureLine>();
        }

        public function resetMarkers(_arg1:String):void
        {
            if ((((_arg1 == "main")) || ((_arg1 == "all"))))
            {
                this._leftMainMarkers.length = 0;
                this._rightMainMarkers.length = 0;
                this._topMainMarkers.length = 0;
                this._bottomMainMarkers.length = 0;
            };
            if ((((_arg1 == "inter")) || ((_arg1 == "all"))))
            {
                this._leftInterMarkers.length = 0;
                this._rightInterMarkers.length = 0;
                this._topInterMarkers.length = 0;
                this._bottomInterMarkers.length = 0;
            };
            if ((((_arg1 == "opening")) || ((_arg1 == "all"))))
            {
                this._leftOpeningMarkers.length = 0;
                this._rightOpeningMarkers.length = 0;
                this._topOpeningMarkers.length = 0;
                this._bottomOpeningMarkers.length = 0;
            };
        }

        public function showMarkers(_arg1:String):void
        {
            var _local2:int;
            var _local3:Vector.<MeasureLine>;
            if (_arg1 == "main")
            {
                _local3 = this._topMainMarkers.concat(this._bottomMainMarkers, this._leftMainMarkers, this._rightMainMarkers);
                _local2 = 0;
                while (_local2 < _local3.length)
                {
                    _local3[_local2].visible = true;
                    _local2++;
                };
            }
            else
            {
                if (_arg1 == "inter")
                {
                    _local3 = this._topInterMarkers.concat(this._bottomInterMarkers, this._leftInterMarkers, this._rightInterMarkers);
                    _local2 = 0;
                    while (_local2 < _local3.length)
                    {
                        _local3[_local2].visible = true;
                        _local2++;
                    };
                }
                else
                {
                    if (_arg1 == "opening")
                    {
                        _local3 = this._topOpeningMarkers.concat(this._bottomOpeningMarkers, this._leftOpeningMarkers, this._rightOpeningMarkers);
                        _local2 = 0;
                        while (_local2 < _local3.length)
                        {
                            _local3[_local2].visible = true;
                            _local2++;
                        };
                    };
                };
            };
        }

        public function addMarker(_arg1:MeasureLine, _arg2:String, _arg3:String):void
        {
            if (_arg2 == "left")
            {
                if (_arg3 == "main")
                {
                    this._leftMainMarkers.push(_arg1);
                }
                else
                {
                    if (_arg3 == "inter")
                    {
                        this._leftInterMarkers.push(_arg1);
                    }
                    else
                    {
                        this._leftOpeningMarkers.push(_arg1);
                    };
                };
            }
            else
            {
                if (_arg2 == "right")
                {
                    if (_arg3 == "main")
                    {
                        this._rightMainMarkers.push(_arg1);
                    }
                    else
                    {
                        if (_arg3 == "inter")
                        {
                            this._rightInterMarkers.push(_arg1);
                        }
                        else
                        {
                            this._rightOpeningMarkers.push(_arg1);
                        };
                    };
                }
                else
                {
                    if (_arg2 == "top")
                    {
                        if (_arg3 == "main")
                        {
                            this._topMainMarkers.push(_arg1);
                        }
                        else
                        {
                            if (_arg3 == "inter")
                            {
                                this._topInterMarkers.push(_arg1);
                            }
                            else
                            {
                                this._topOpeningMarkers.push(_arg1);
                            };
                        };
                    }
                    else
                    {
                        if (_arg2 == "bottom")
                        {
                            if (_arg3 == "main")
                            {
                                this._bottomMainMarkers.push(_arg1);
                            }
                            else
                            {
                                if (_arg3 == "inter")
                                {
                                    this._bottomInterMarkers.push(_arg1);
                                }
                                else
                                {
                                    this._bottomOpeningMarkers.push(_arg1);
                                };
                            };
                        };
                    };
                };
            };
        }

        public function getMarkersAtPosition(_arg1:String):Vector.<MeasureLine>
        {
            if (_arg1 == "top")
            {
                return (this._topMainMarkers.concat(this._topOpeningMarkers, this._topInterMarkers).sort(this.horizontalSort));
            };
            if (_arg1 == "bottom")
            {
                return (this._bottomMainMarkers.concat(this._bottomOpeningMarkers, this._bottomInterMarkers).sort(this.horizontalSort));
            };
            if (_arg1 == "left")
            {
                return (this._leftMainMarkers.concat(this._leftOpeningMarkers, this._leftInterMarkers).sort(this.verticalSort));
            };
            if (_arg1 == "right")
            {
                return (this._rightMainMarkers.concat(this._rightOpeningMarkers, this._rightInterMarkers).sort(this.verticalSort));
            };
            return (null);
        }

        public function getMarkersOfType(_arg1:String):Vector.<MeasureLine>
        {
            if (_arg1 == "main")
            {
                return (this._topMainMarkers.concat(this._bottomMainMarkers, this._leftMainMarkers, this._rightMainMarkers));
            };
            if (_arg1 == "inter")
            {
                return (this._topInterMarkers.concat(this._bottomInterMarkers, this._leftInterMarkers, this._rightInterMarkers));
            };
            if (_arg1 == "opening")
            {
                return (this._topOpeningMarkers.concat(this._bottomOpeningMarkers, this._leftOpeningMarkers, this._rightOpeningMarkers));
            };
            return (null);
        }

        public function getLength(... _args):int
        {
            var _local2:int;
            if (ArrayUtil.contains(_args, "main"))
            {
                _local2 = (_local2 + this.getMarkersOfType("main").length);
            };
            if (ArrayUtil.contains(_args, "inter"))
            {
                _local2 = (_local2 + this.getMarkersOfType("inter").length);
            };
            if (ArrayUtil.contains(_args, "opening"))
            {
                _local2 = (_local2 + this.getMarkersOfType("opening").length);
            };
            return (_local2);
        }

        private function verticalSort(_arg1:MeasureLine, _arg2:MeasureLine):Number
        {
            return ((_arg1.y - _arg2.y));
        }

        private function horizontalSort(_arg1:MeasureLine, _arg2:MeasureLine):Number
        {
            return ((_arg1.x - _arg2.x));
        }


    }
}//package at.polypex.badplaner.view.comps

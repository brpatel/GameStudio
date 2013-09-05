package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.core.Constants;
    
    import starling.display.Quad;
    import starling.display.Sprite;

    public class OutlineCorner extends Sprite 
    {

        public function OutlineCorner(_arg1:String, _arg2:uint=14, _arg3:uint=14)
        {
            var _local4:Quad = new Quad(2, _arg3, Constants.OUTLINE_COLOR);
            addChild(_local4);
            var _local5:Quad = new Quad(_arg2, 2, Constants.OUTLINE_COLOR);
            addChild(_local5);
            if (_arg1 == "TL")
            {
                _local4.x = -2;
                _local4.y = -2;
                _local5.x = -2;
                _local5.y = -2;
            }
            else
            {
                if (_arg1 == "TR")
                {
                    _local4.x = 0;
                    _local4.y = -2;
                    _local5.x = -((_local5.width - 2));
                    _local5.y = -2;
                }
                else
                {
                    if (_arg1 == "BL")
                    {
                        _local4.x = -2;
                        _local4.y = -((_local4.height - 2));
                        _local5.x = -2;
                        _local5.y = 0;
                    }
                    else
                    {
                        if (_arg1 == "BR")
                        {
                            _local4.x = 0;
                            _local4.y = -((_local4.height - 2));
                            _local5.x = -((_local5.width - 2));
                            _local5.y = 0;
                        };
                    };
                };
            };
        }

    }
}//package at.polypex.badplaner.view.comps

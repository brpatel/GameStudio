//Created by Action Script Viewer - http://www.buraks.com/asv
package com.adobe.utils
{
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    import flash.utils.Endian;
    import flash.utils.*;

    public class AGALMiniAssembler 
    {

        protected static const USE_NEW_SYNTAX:Boolean = false;
        protected static const REGEXP_OUTER_SPACES:RegExp = /^\s+|\s+$/g;
        private static const OPMAP:Dictionary = new Dictionary();
        private static const REGMAP:Dictionary = new Dictionary();
        private static const SAMPLEMAP:Dictionary = new Dictionary();
        private static const MAX_NESTING:int = 4;
        private static const MAX_OPCODES:int = 0x0100;
        private static const FRAGMENT:String = "fragment";
        private static const VERTEX:String = "vertex";
        private static const SAMPLER_TYPE_SHIFT:uint = 8;
        private static const SAMPLER_DIM_SHIFT:uint = 12;
        private static const SAMPLER_SPECIAL_SHIFT:uint = 16;
        private static const SAMPLER_REPEAT_SHIFT:uint = 20;
        private static const SAMPLER_MIPMAP_SHIFT:uint = 24;
        private static const SAMPLER_FILTER_SHIFT:uint = 28;
        private static const REG_WRITE:uint = 1;
        private static const REG_READ:uint = 2;
        private static const REG_FRAG:uint = 32;
        private static const REG_VERT:uint = 64;
        private static const OP_SCALAR:uint = 1;
        private static const OP_INC_NEST:uint = 2;
        private static const OP_DEC_NEST:uint = 4;
        private static const OP_SPECIAL_TEX:uint = 8;
        private static const OP_SPECIAL_MATRIX:uint = 16;
        private static const OP_FRAG_ONLY:uint = 32;
        private static const OP_NO_DEST:uint = 128;
        private static const MOV:String = "mov";
        private static const ADD:String = "add";
        private static const SUB:String = "sub";
        private static const MUL:String = "mul";
        private static const DIV:String = "div";
        private static const RCP:String = "rcp";
        private static const MIN:String = "min";
        private static const MAX:String = "max";
        private static const FRC:String = "frc";
        private static const SQT:String = "sqt";
        private static const RSQ:String = "rsq";
        private static const POW:String = "pow";
        private static const LOG:String = "log";
        private static const EXP:String = "exp";
        private static const NRM:String = "nrm";
        private static const SIN:String = "sin";
        private static const COS:String = "cos";
        private static const CRS:String = "crs";
        private static const DP3:String = "dp3";
        private static const DP4:String = "dp4";
        private static const ABS:String = "abs";
        private static const NEG:String = "neg";
        private static const SAT:String = "sat";
        private static const M33:String = "m33";
        private static const M44:String = "m44";
        private static const M34:String = "m34";
        private static const IFZ:String = "ifz";
        private static const INZ:String = "inz";
        private static const IFE:String = "ife";
        private static const INE:String = "ine";
        private static const IFG:String = "ifg";
        private static const IFL:String = "ifl";
        private static const IEG:String = "ieg";
        private static const IEL:String = "iel";
        private static const ELS:String = "els";
        private static const EIF:String = "eif";
        private static const REP:String = "rep";
        private static const ERP:String = "erp";
        private static const BRK:String = "brk";
        private static const KIL:String = "kil";
        private static const TEX:String = "tex";
        private static const SGE:String = "sge";
        private static const SLT:String = "slt";
        private static const SGN:String = "sgn";
        private static const SEQ:String = "seq";
        private static const SNE:String = "sne";
        private static const VA:String = "va";
        private static const VC:String = "vc";
        private static const VT:String = "vt";
        private static const VO:String = ((USE_NEW_SYNTAX) ? "vo" : "op");
        private static const I:String = ((USE_NEW_SYNTAX) ? "i" : "v");
        private static const FC:String = "fc";
        private static const FT:String = "ft";
        private static const FS:String = "fs";
        private static const FO:String = ((USE_NEW_SYNTAX) ? "fo" : "oc");
        private static const D2:String = "2d";
        private static const D3:String = "3d";
        private static const CUBE:String = "cube";
        private static const MIPNEAREST:String = "mipnearest";
        private static const MIPLINEAR:String = "miplinear";
        private static const MIPNONE:String = "mipnone";
        private static const NOMIP:String = "nomip";
        private static const NEAREST:String = "nearest";
        private static const LINEAR:String = "linear";
        private static const CENTROID:String = "centroid";
        private static const SINGLE:String = "single";
        private static const DEPTH:String = "depth";
        private static const REPEAT:String = "repeat";
        private static const WRAP:String = "wrap";
        private static const CLAMP:String = "clamp";
        private static const RGBA:String = "rgba";
        private static const DXT1:String = "dxt1";
        private static const DXT5:String = "dxt5";

        private static var initialized:Boolean = false;

        private var _agalcode:ByteArray = null;
        private var _error:String = "";
        private var debugEnabled:Boolean = false;
        public var verbose:Boolean = false;

        public function AGALMiniAssembler(_arg1:Boolean=false):void
        {
            this.debugEnabled = _arg1;
            if (!initialized)
            {
                init();
            };
        }

        private static function init():void
        {
            initialized = true;
            OPMAP[MOV] = new OpCode(MOV, 2, 0, 0);
            OPMAP[ADD] = new OpCode(ADD, 3, 1, 0);
            OPMAP[SUB] = new OpCode(SUB, 3, 2, 0);
            OPMAP[MUL] = new OpCode(MUL, 3, 3, 0);
            OPMAP[DIV] = new OpCode(DIV, 3, 4, 0);
            OPMAP[RCP] = new OpCode(RCP, 2, 5, 0);
            OPMAP[MIN] = new OpCode(MIN, 3, 6, 0);
            OPMAP[MAX] = new OpCode(MAX, 3, 7, 0);
            OPMAP[FRC] = new OpCode(FRC, 2, 8, 0);
            OPMAP[SQT] = new OpCode(SQT, 2, 9, 0);
            OPMAP[RSQ] = new OpCode(RSQ, 2, 10, 0);
            OPMAP[POW] = new OpCode(POW, 3, 11, 0);
            OPMAP[LOG] = new OpCode(LOG, 2, 12, 0);
            OPMAP[EXP] = new OpCode(EXP, 2, 13, 0);
            OPMAP[NRM] = new OpCode(NRM, 2, 14, 0);
            OPMAP[SIN] = new OpCode(SIN, 2, 15, 0);
            OPMAP[COS] = new OpCode(COS, 2, 16, 0);
            OPMAP[CRS] = new OpCode(CRS, 3, 17, 0);
            OPMAP[DP3] = new OpCode(DP3, 3, 18, 0);
            OPMAP[DP4] = new OpCode(DP4, 3, 19, 0);
            OPMAP[ABS] = new OpCode(ABS, 2, 20, 0);
            OPMAP[NEG] = new OpCode(NEG, 2, 21, 0);
            OPMAP[SAT] = new OpCode(SAT, 2, 22, 0);
            OPMAP[M33] = new OpCode(M33, 3, 23, OP_SPECIAL_MATRIX);
            OPMAP[M44] = new OpCode(M44, 3, 24, OP_SPECIAL_MATRIX);
            OPMAP[M34] = new OpCode(M34, 3, 25, OP_SPECIAL_MATRIX);
            OPMAP[IFZ] = new OpCode(IFZ, 1, 26, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[INZ] = new OpCode(INZ, 1, 27, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IFE] = new OpCode(IFE, 2, 28, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[INE] = new OpCode(INE, 2, 29, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IFG] = new OpCode(IFG, 2, 30, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IFL] = new OpCode(IFL, 2, 31, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IEG] = new OpCode(IEG, 2, 32, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IEL] = new OpCode(IEL, 2, 33, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[ELS] = new OpCode(ELS, 0, 34, ((OP_NO_DEST | OP_INC_NEST) | OP_DEC_NEST));
            OPMAP[EIF] = new OpCode(EIF, 0, 35, (OP_NO_DEST | OP_DEC_NEST));
            OPMAP[REP] = new OpCode(REP, 1, 36, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[ERP] = new OpCode(ERP, 0, 37, (OP_NO_DEST | OP_DEC_NEST));
            OPMAP[BRK] = new OpCode(BRK, 0, 38, OP_NO_DEST);
            OPMAP[KIL] = new OpCode(KIL, 1, 39, (OP_NO_DEST | OP_FRAG_ONLY));
            OPMAP[TEX] = new OpCode(TEX, 3, 40, (OP_FRAG_ONLY | OP_SPECIAL_TEX));
            OPMAP[SGE] = new OpCode(SGE, 3, 41, 0);
            OPMAP[SLT] = new OpCode(SLT, 3, 42, 0);
            OPMAP[SGN] = new OpCode(SGN, 2, 43, 0);
            OPMAP[SEQ] = new OpCode(SEQ, 3, 44, 0);
            OPMAP[SNE] = new OpCode(SNE, 3, 45, 0);
            REGMAP[VA] = new Register(VA, "vertex attribute", 0, 7, (REG_VERT | REG_READ));
            REGMAP[VC] = new Register(VC, "vertex constant", 1, 127, (REG_VERT | REG_READ));
            REGMAP[VT] = new Register(VT, "vertex temporary", 2, 7, ((REG_VERT | REG_WRITE) | REG_READ));
            REGMAP[VO] = new Register(VO, "vertex output", 3, 0, (REG_VERT | REG_WRITE));
            REGMAP[I] = new Register(I, "varying", 4, 7, (((REG_VERT | REG_FRAG) | REG_READ) | REG_WRITE));
            REGMAP[FC] = new Register(FC, "fragment constant", 1, 27, (REG_FRAG | REG_READ));
            REGMAP[FT] = new Register(FT, "fragment temporary", 2, 7, ((REG_FRAG | REG_WRITE) | REG_READ));
            REGMAP[FS] = new Register(FS, "texture sampler", 5, 7, (REG_FRAG | REG_READ));
            REGMAP[FO] = new Register(FO, "fragment output", 3, 0, (REG_FRAG | REG_WRITE));
            SAMPLEMAP[RGBA] = new Sampler(RGBA, SAMPLER_TYPE_SHIFT, 0);
            SAMPLEMAP[DXT1] = new Sampler(DXT1, SAMPLER_TYPE_SHIFT, 1);
            SAMPLEMAP[DXT5] = new Sampler(DXT5, SAMPLER_TYPE_SHIFT, 2);
            SAMPLEMAP[D2] = new Sampler(D2, SAMPLER_DIM_SHIFT, 0);
            SAMPLEMAP[D3] = new Sampler(D3, SAMPLER_DIM_SHIFT, 2);
            SAMPLEMAP[CUBE] = new Sampler(CUBE, SAMPLER_DIM_SHIFT, 1);
            SAMPLEMAP[MIPNEAREST] = new Sampler(MIPNEAREST, SAMPLER_MIPMAP_SHIFT, 1);
            SAMPLEMAP[MIPLINEAR] = new Sampler(MIPLINEAR, SAMPLER_MIPMAP_SHIFT, 2);
            SAMPLEMAP[MIPNONE] = new Sampler(MIPNONE, SAMPLER_MIPMAP_SHIFT, 0);
            SAMPLEMAP[NOMIP] = new Sampler(NOMIP, SAMPLER_MIPMAP_SHIFT, 0);
            SAMPLEMAP[NEAREST] = new Sampler(NEAREST, SAMPLER_FILTER_SHIFT, 0);
            SAMPLEMAP[LINEAR] = new Sampler(LINEAR, SAMPLER_FILTER_SHIFT, 1);
            SAMPLEMAP[CENTROID] = new Sampler(CENTROID, SAMPLER_SPECIAL_SHIFT, (1 << 0));
            SAMPLEMAP[SINGLE] = new Sampler(SINGLE, SAMPLER_SPECIAL_SHIFT, (1 << 1));
            SAMPLEMAP[DEPTH] = new Sampler(DEPTH, SAMPLER_SPECIAL_SHIFT, (1 << 2));
            SAMPLEMAP[REPEAT] = new Sampler(REPEAT, SAMPLER_REPEAT_SHIFT, 1);
            SAMPLEMAP[WRAP] = new Sampler(WRAP, SAMPLER_REPEAT_SHIFT, 1);
            SAMPLEMAP[CLAMP] = new Sampler(CLAMP, SAMPLER_REPEAT_SHIFT, 0);
        }


        public function get error():String
        {
            return (this._error);
        }

        public function get agalcode():ByteArray
        {
            return (this._agalcode);
        }

        public function assemble(_arg1:String, _arg2:String):ByteArray
        {
            var _local8:int;
            var _local10:String;
            var _local11:int;
            var _local12:int;
            var _local13:Array;
            var _local14:Array;
            var _local15:OpCode;
            var _local16:Array;
            var _local17:Boolean;
            var _local18:uint;
            var _local19:uint;
            var _local20:int;
            var _local21:Boolean;
            var _local22:Array;
            var _local23:Array;
            var _local24:Register;
            var _local25:Array;
            var _local26:uint;
            var _local27:uint;
            var _local28:Array;
            var _local29:Boolean;
            var _local30:Boolean;
            var _local31:uint;
            var _local32:uint;
            var _local33:int;
            var _local34:uint;
            var _local35:uint;
            var _local36:int;
            var _local37:Array;
            var _local38:Register;
            var _local39:Array;
            var _local40:Array;
            var _local41:uint;
            var _local42:uint;
            var _local43:Number;
            var _local44:Sampler;
            var _local45:String;
            var _local46:uint;
            var _local47:uint;
            var _local48:String;
            var _local3:uint = getTimer();
            this._agalcode = new ByteArray();
            this._error = "";
            var _local4:Boolean;
            if (_arg1 == FRAGMENT)
            {
                _local4 = true;
            }
            else
            {
                if (_arg1 != VERTEX)
                {
                    this._error = (((((('ERROR: mode needs to be "' + FRAGMENT) + '" or "') + VERTEX) + '" but is "') + _arg1) + '".');
                };
            };
            this.agalcode.endian = Endian.LITTLE_ENDIAN;
            this.agalcode.writeByte(160);
            this.agalcode.writeUnsignedInt(1);
            this.agalcode.writeByte(161);
            this.agalcode.writeByte(((_local4) ? 1 : 0));
            var _local5:Array = _arg2.replace(/[\f\n\r\v]+/g, "\n").split("\n");
            var _local6:int;
            var _local7:int;
            var _local9:int = _local5.length;
            _local8 = 0;
            while ((((_local8 < _local9)) && ((this._error == ""))))
            {
                _local10 = new String(_local5[_local8]);
                _local10 = _local10.replace(REGEXP_OUTER_SPACES, "");
                _local11 = _local10.search("//");
                if (_local11 != -1)
                {
                    _local10 = _local10.slice(0, _local11);
                };
                _local12 = _local10.search(/<.*>/g);
                if (_local12 != -1)
                {
                    _local13 = _local10.slice(_local12).match(/([\w\.\-\+]+)/gi);
                    _local10 = _local10.slice(0, _local12);
                };
                _local14 = _local10.match(/^\w{3}/ig);
                if (!_local14)
                {
                    if (_local10.length >= 3)
                    {
                    };
                }
                else
                {
                    _local15 = OPMAP[_local14[0]];
                    if (this.debugEnabled)
                    {
                    };
                    if (_local15 == null)
                    {
                        if (_local10.length >= 3)
                        {
                        };
                    }
                    else
                    {
                        _local10 = _local10.slice((_local10.search(_local15.name) + _local15.name.length));
                        if ((_local15.flags & OP_DEC_NEST))
                        {
                            --_local6;
                            if (_local6 < 0)
                            {
                                this._error = "error: conditional closes without open.";
                                break;
                            };
                        };
                        if ((_local15.flags & OP_INC_NEST))
                        {
                            _local6++;
                            if (_local6 > MAX_NESTING)
                            {
                                this._error = (("error: nesting to deep, maximum allowed is " + MAX_NESTING) + ".");
                                break;
                            };
                        };
                        if ((((_local15.flags & OP_FRAG_ONLY)) && (!(_local4))))
                        {
                            this._error = "error: opcode is only allowed in fragment programs.";
                            break;
                        };
                        if (this.verbose)
                        {
                        };
                        this.agalcode.writeUnsignedInt(_local15.emitCode);
                        _local7++;
                        if (_local7 > MAX_OPCODES)
                        {
                            this._error = (("error: too many opcodes. maximum is " + MAX_OPCODES) + ".");
                            break;
                        };
                        if (USE_NEW_SYNTAX)
                        {
                            _local16 = _local10.match(/vc\[([vif][acost]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vif][acost]?)(\d*)?(\.[xyzw]{1,4})?/gi);
                        }
                        else
                        {
                            _local16 = _local10.match(/vc\[([vof][actps]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vof][actps]?)(\d*)?(\.[xyzw]{1,4})?/gi);
                        };
                        if (((!(_local16)) || (!((_local16.length == _local15.numRegister)))))
                        {
                            this._error = (((("error: wrong number of operands. found " + _local16.length) + " but expected ") + _local15.numRegister) + ".");
                            break;
                        };
                        _local17 = false;
                        _local18 = ((64 + 64) + 32);
                        _local19 = _local16.length;
                        _local20 = 0;
                        while (_local20 < _local19)
                        {
                            _local21 = false;
                            _local22 = _local16[_local20].match(/\[.*\]/ig);
                            if (((_local22) && ((_local22.length > 0))))
                            {
                                _local16[_local20] = _local16[_local20].replace(_local22[0], "0");
                                if (this.verbose)
                                {
                                };
                                _local21 = true;
                            };
                            _local23 = _local16[_local20].match(/^\b[A-Za-z]{1,2}/ig);
                            if (!_local23)
                            {
                                this._error = (((("error: could not parse operand " + _local20) + " (") + _local16[_local20]) + ").");
                                _local17 = true;
                                break;
                            };
                            _local24 = REGMAP[_local23[0]];
                            if (this.debugEnabled)
                            {
                            };
                            if (_local24 == null)
                            {
                                this._error = (((("error: could not parse operand " + _local20) + " (") + _local16[_local20]) + ").");
                                _local17 = true;
                                break;
                            };
                            if (_local4)
                            {
                                if (!(_local24.flags & REG_FRAG))
                                {
                                    this._error = (((("error: register operand " + _local20) + " (") + _local16[_local20]) + ") only allowed in vertex programs.");
                                    _local17 = true;
                                    break;
                                };
                                if (_local21)
                                {
                                    this._error = (((("error: register operand " + _local20) + " (") + _local16[_local20]) + ") relative adressing not allowed in fragment programs.");
                                    _local17 = true;
                                    break;
                                };
                            }
                            else
                            {
                                if (!(_local24.flags & REG_VERT))
                                {
                                    this._error = (((("error: register operand " + _local20) + " (") + _local16[_local20]) + ") only allowed in fragment programs.");
                                    _local17 = true;
                                    break;
                                };
                            };
                            _local16[_local20] = _local16[_local20].slice((_local16[_local20].search(_local24.name) + _local24.name.length));
                            _local25 = ((_local21) ? _local22[0].match(/\d+/) : _local16[_local20].match(/\d+/));
                            _local26 = 0;
                            if (_local25)
                            {
                                _local26 = uint(_local25[0]);
                            };
                            if (_local24.range < _local26)
                            {
                                this._error = (((((("error: register operand " + _local20) + " (") + _local16[_local20]) + ") index exceeds limit of ") + (_local24.range + 1)) + ".");
                                _local17 = true;
                                break;
                            };
                            _local27 = 0;
                            _local28 = _local16[_local20].match(/(\.[xyzw]{1,4})/);
                            _local29 = (((_local20 == 0)) && (!((_local15.flags & OP_NO_DEST))));
                            _local30 = (((_local20 == 2)) && ((_local15.flags & OP_SPECIAL_TEX)));
                            _local31 = 0;
                            _local32 = 0;
                            _local33 = 0;
                            if (((_local29) && (_local21)))
                            {
                                this._error = "error: relative can not be destination";
                                _local17 = true;
                                break;
                            };
                            if (_local28)
                            {
                                _local27 = 0;
                                _local35 = _local28[0].length;
                                _local36 = 1;
                                while (_local36 < _local35)
                                {
                                    _local34 = (_local28[0].charCodeAt(_local36) - "x".charCodeAt(0));
                                    if (_local34 > 2)
                                    {
                                        _local34 = 3;
                                    };
                                    if (_local29)
                                    {
                                        _local27 = (_local27 | (1 << _local34));
                                    }
                                    else
                                    {
                                        _local27 = (_local27 | (_local34 << ((_local36 - 1) << 1)));
                                    };
                                    _local36++;
                                };
                                if (!_local29)
                                {
                                    while (_local36 <= 4)
                                    {
                                        _local27 = (_local27 | (_local34 << ((_local36 - 1) << 1)));
                                        _local36++;
                                    };
                                };
                            }
                            else
                            {
                                _local27 = ((_local29) ? 15 : 228);
                            };
                            if (_local21)
                            {
                                _local37 = _local22[0].match(/[A-Za-z]{1,2}/ig);
                                _local38 = REGMAP[_local37[0]];
                                if (_local38 == null)
                                {
                                    this._error = "error: bad index register";
                                    _local17 = true;
                                    break;
                                };
                                _local31 = _local38.emitCode;
                                _local39 = _local22[0].match(/(\.[xyzw]{1,1})/);
                                if (_local39.length == 0)
                                {
                                    this._error = "error: bad index register select";
                                    _local17 = true;
                                    break;
                                };
                                _local32 = (_local39[0].charCodeAt(1) - "x".charCodeAt(0));
                                if (_local32 > 2)
                                {
                                    _local32 = 3;
                                };
                                _local40 = _local22[0].match(/\+\d{1,3}/ig);
                                if (_local40.length > 0)
                                {
                                    _local33 = _local40[0];
                                };
                                if ((((_local33 < 0)) || ((_local33 > 0xFF))))
                                {
                                    this._error = (("error: index offset " + _local33) + " out of bounds. [0..255]");
                                    _local17 = true;
                                    break;
                                };
                                if (this.verbose)
                                {
                                };
                            };
                            if (this.verbose)
                            {
                            };
                            if (_local29)
                            {
                                this.agalcode.writeShort(_local26);
                                this.agalcode.writeByte(_local27);
                                this.agalcode.writeByte(_local24.emitCode);
                                _local18 = (_local18 - 32);
                            }
                            else
                            {
                                if (_local30)
                                {
                                    if (this.verbose)
                                    {
                                    };
                                    _local41 = 5;
                                    _local42 = (((_local13 == null)) ? 0 : _local13.length);
                                    _local43 = 0;
                                    _local36 = 0;
                                    while (_local36 < _local42)
                                    {
                                        if (this.verbose)
                                        {
                                        };
                                        _local44 = SAMPLEMAP[_local13[_local36]];
                                        if (_local44 == null)
                                        {
                                            _local43 = Number(_local13[_local36]);
                                            if (this.verbose)
                                            {
                                            };
                                        }
                                        else
                                        {
                                            if (_local44.flag != SAMPLER_SPECIAL_SHIFT)
                                            {
                                                _local41 = (_local41 & ~((15 << _local44.flag)));
                                            };
                                            _local41 = (_local41 | (uint(_local44.mask) << uint(_local44.flag)));
                                        };
                                        _local36++;
                                    };
                                    this.agalcode.writeShort(_local26);
                                    this.agalcode.writeByte(int((_local43 * 8)));
                                    this.agalcode.writeByte(0);
                                    this.agalcode.writeUnsignedInt(_local41);
                                    if (this.verbose)
                                    {
                                    };
                                    _local18 = (_local18 - 64);
                                }
                                else
                                {
                                    if (_local20 == 0)
                                    {
                                        this.agalcode.writeUnsignedInt(0);
                                        _local18 = (_local18 - 32);
                                    };
                                    this.agalcode.writeShort(_local26);
                                    this.agalcode.writeByte(_local33);
                                    this.agalcode.writeByte(_local27);
                                    this.agalcode.writeByte(_local24.emitCode);
                                    this.agalcode.writeByte(_local31);
                                    this.agalcode.writeShort(((_local21) ? (_local32 | (1 << 15)) : 0));
                                    _local18 = (_local18 - 64);
                                };
                            };
                            _local20++;
                        };
                        _local20 = 0;
                        while (_local20 < _local18)
                        {
                            this.agalcode.writeByte(0);
                            _local20 = (_local20 + 8);
                        };
                        if (_local17) break;
                    };
                };
                _local8++;
            };
            if (this._error != "")
            {
                this._error = (this._error + ((("\n  at line " + _local8) + " ") + _local5[_local8]));
                this.agalcode.length = 0;
            };
            if (this.debugEnabled)
            {
                _local45 = "generated bytecode:";
                _local46 = this.agalcode.length;
                _local47 = 0;
                while (_local47 < _local46)
                {
                    if (!(_local47 % 16))
                    {
                        _local45 = (_local45 + "\n");
                    };
                    if (!(_local47 % 4))
                    {
                        _local45 = (_local45 + " ");
                    };
                    _local48 = this.agalcode[_local47].toString(16);
                    if (_local48.length < 2)
                    {
                        _local48 = ("0" + _local48);
                    };
                    _local45 = (_local45 + _local48);
                    _local47++;
                };
            };
            if (this.verbose)
            {
            };
            return (this.agalcode);
        }


    }
}//package com.adobe.utils

class OpCode 
{

    private var _emitCode:uint;
    private var _flags:uint;
    private var _name:String;
    private var _numRegister:uint;

    public function OpCode(_arg1:String, _arg2:uint, _arg3:uint, _arg4:uint)
    {
        this._name = _arg1;
        this._numRegister = _arg2;
        this._emitCode = _arg3;
        this._flags = _arg4;
    }

    public function get emitCode():uint
    {
        return (this._emitCode);
    }

    public function get flags():uint
    {
        return (this._flags);
    }

    public function get name():String
    {
        return (this._name);
    }

    public function get numRegister():uint
    {
        return (this._numRegister);
    }

    public function toString():String
    {
        return ((((((((('[OpCode name="' + this._name) + '", numRegister=') + this._numRegister) + ", emitCode=") + this._emitCode) + ", flags=") + this._flags) + "]"));
    }


}
class Register 
{

    private var _emitCode:uint;
    private var _name:String;
    private var _longName:String;
    private var _flags:uint;
    private var _range:uint;

    public function Register(_arg1:String, _arg2:String, _arg3:uint, _arg4:uint, _arg5:uint)
    {
        this._name = _arg1;
        this._longName = _arg2;
        this._emitCode = _arg3;
        this._range = _arg4;
        this._flags = _arg5;
    }

    public function get emitCode():uint
    {
        return (this._emitCode);
    }

    public function get longName():String
    {
        return (this._longName);
    }

    public function get name():String
    {
        return (this._name);
    }

    public function get flags():uint
    {
        return (this._flags);
    }

    public function get range():uint
    {
        return (this._range);
    }

    public function toString():String
    {
        return ((((((((((('[Register name="' + this._name) + '", longName="') + this._longName) + '", emitCode=') + this._emitCode) + ", range=") + this._range) + ", flags=") + this._flags) + "]"));
    }


}
class Sampler 
{

    private var _flag:uint;
    private var _mask:uint;
    private var _name:String;

    public function Sampler(_arg1:String, _arg2:uint, _arg3:uint)
    {
        this._name = _arg1;
        this._flag = _arg2;
        this._mask = _arg3;
    }

    public function get flag():uint
    {
        return (this._flag);
    }

    public function get mask():uint
    {
        return (this._mask);
    }

    public function get name():String
    {
        return (this._name);
    }

    public function toString():String
    {
        return ((((((('[Sampler name="' + this._name) + '", flag="') + this._flag) + '", mask=') + this.mask) + "]"));
    }


}

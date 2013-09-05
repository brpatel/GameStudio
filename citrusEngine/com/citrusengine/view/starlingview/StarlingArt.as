package com.citrusengine.view.starlingview {
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.IState;
	import com.citrusengine.physics.Box2D;
	import com.citrusengine.physics.Nape;
	import com.citrusengine.system.components.ViewComponent;
	import com.citrusengine.view.ISpriteView;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import Box2DAS.Dynamics.b2DebugDraw;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.extensions.particles.PDParticleSystem;
	import starling.extensions.textureAtlas.DynamicAtlas;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;

	/**
	 * This is the class that all art objects use for the StarlingView state view. If you are using the StarlingView (as opposed to the blitting view, for instance),
	 * then all your graphics will be an instance of this class. There are 2 ways to manage MovieClip :
	 * - specify a "object.swf" in the view property of your object's creation.
	 * - add an AnimationSequence to your view property of your object's creation, see the AnimationSequence for more informations about it.
	 * The AnimationSequence is more optimized than the .swf which creates textures "on the fly" thanks to the DynamicAtlas class.
	 * 
	 * This class does the following things:
	 * 
	 * 1) Creates the appropriate graphic depending on your CitrusObject's view property (loader, sprite, or bitmap), and loads it if it is a non-embedded graphic.
	 * 2) Aligns the graphic with the appropriate registration (topLeft or center).
	 * 3) Calls the MovieClip's appropriate frame label based on the CitrusObject's animation property.
	 * 4) Updates the graphic's properties to be in-synch with the CitrusObject's properties once per frame.
	 * 
	 * These objects will be created by the Citrus Engine's StarlingView, so you should never make them yourself. When you use state.getArt() to gain access to your game's graphics
	 * (for adding click events, for instance), you will get an instance of this object. It extends Sprite, so you can do all the expected stuff with it, 
	 * such as add click listeners, change the alpha, etc.
	 **/
	public class StarlingArt extends Sprite {
		
		/**
		 * The content property is the actual display object that your game object is using. For graphics that are loaded at runtime
		 * (not embedded), the content property will not be available immediately. You can listen to the COMPLETE event on the loader
		 * (or rather, the loader's contentLoaderInfo) if you need to know exactly when the graphic will be loaded.
		 */
		public var content:DisplayObject;

		/**
		 * For objects that are loaded at runtime, this is the object that loades them. Then, once they are loaded, the content
		 * property is assigned to loader.content.
		 */
		public var loader:Loader;

		// properties :
		
		// determines animations playing in loop. You can add one in your state class : StarlingArt.setLoopAnimations(["walk", "climb"]);
		private static var _loopAnimation:Dictionary = new Dictionary();
		
		private var _citrusObject:ISpriteView;
		private var _physicsComponent:*;
		private var _registration:String;
		private var _view:*;
		private var _animation:String;
		private var _group:int;

		private var _texture:Texture;
		private var _textureAtlas:TextureAtlas;

		public function StarlingArt(object:ISpriteView = null) {
			
			if (object)
				initialize(object);
		}
		
		public function initialize(object:ISpriteView):void {
			
			_citrusObject = object;
			
			CitrusEngine.getInstance().onPlayingChange.add(_pauseAnimation);
			
			var ceState:IState = CitrusEngine.getInstance().state;
			
			if (_citrusObject is ViewComponent && (ceState.getFirstObjectByType(Box2D) as Box2D || ceState.getFirstObjectByType(Nape) as Nape))
				_physicsComponent = (_citrusObject as ViewComponent).entity.components["physics"];
			
			this.name = (_citrusObject as CitrusObject).name;
			
			if (_loopAnimation["walk"] != true) {
				_loopAnimation["walk"] = true;
			}
		}

		public function destroy(viewChanged:Boolean = false):void {
			
			if (viewChanged) {
				
				removeChild(content);
				
			} else {
				
				CitrusEngine.getInstance().onPlayingChange.remove(_pauseAnimation);
				_view = null;
			}
			
			if (content is MovieClip) {
					
				Starling.juggler.remove(content as MovieClip);
				if (_textureAtlas)
					_textureAtlas.dispose();
				content.dispose();
			
			} else if (content is AnimationSequence) {
				
				(content as AnimationSequence).destroy();
				content.dispose();
				
			} else if (content is Image) {
				
				if (_texture)
					_texture.dispose();
					
				content.dispose();
				
			} else if (content is PDParticleSystem) {
				
				Starling.juggler.remove(content as PDParticleSystem);
				(content as PDParticleSystem).stop(true);
				content.dispose();
			} else if (content is StarlingTileSystem) {
				(content as StarlingTileSystem).destroy();
				content.dispose();
			}
			
		}
		
		/**
		 * Add a loop animation to the Dictionnary.
		 * @param tab an array with all the loop animation names.
		 */
		static public function setLoopAnimations(tab:Array):void {
			
			for each (var animation:String in tab) {
				_loopAnimation[animation] = true;
			}
		}
		
		static public function get loopAnimation():Dictionary {
			return _loopAnimation;
		}
		
		public function moveRegistrationPoint(registrationPoint:String):void {
			
			if (registrationPoint == "topLeft") {
				content.x = 0;
				content.y = 0;
			} else if (registrationPoint == "center") {
				content.x = -content.width / 2;
				content.y = -content.height / 2;
			}
		}

		public function get registration():String {
			return _registration;
		}

		public function set registration(value:String):void {

			if (_registration == value || !content)
				return;

			_registration = value;
			
			moveRegistrationPoint(_registration);
		}

		public function get view():* {
			return _view;
		}

		public function set view(value:*):void {

			if (_view == value)
				return;
				
			if (content && content.parent)
				destroy(true);

			_view = value;

			if (_view) {
				if (_view is String) {
					// view property is a path to an image?
					var classString:String = _view;
					var suffix:String = classString.substring(classString.length - 4).toLowerCase();
					if (suffix == ".swf" || suffix == ".png" || suffix == ".gif" || suffix == ".jpg") {
						loader = new Loader();
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleContentLoaded);
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleContentIOError);
						loader.load(new URLRequest(classString));
					}
					// view property is a fully qualified class name in string form. 
					else {
						var artClass:Class = getDefinitionByName(classString) as Class;
						content = new artClass();
						moveRegistrationPoint(_citrusObject.registration);
						addChild(content);
					}
					
				} else if (_view is Class) {
					// view property is a class reference
					content = new citrusObject.view();
					moveRegistrationPoint(_citrusObject.registration);
					addChild(content);

				} else if (_view is DisplayObject) {
					// view property is a Display Object reference
					content = _view;
					moveRegistrationPoint(_citrusObject.registration);
					addChild(content);
					
					if (_view is MovieClip)
						Starling.juggler.add(content as MovieClip);
					else if (_view is PDParticleSystem)
						Starling.juggler.add(content as PDParticleSystem);
					
				} else {
					throw new Error("StarlingArt doesn't know how to create a graphic object from the provided CitrusObject " + citrusObject);
					return;
				}

				if (content && content.hasOwnProperty("initialize"))
					content["initialize"](_citrusObject);
					
			}
		}

		public function get animation():String {
			return _animation;
		}

		public function set animation(value:String):void {

			if (_animation == value)
				return;

			_animation = value;
			
			if (_animation != null && _animation != "") {
				
				var animLoop:Boolean = _loopAnimation[_animation];
				
				if (content is MovieClip)
					(content as DynamicMovieClip).changeTextures(_textureAtlas.getTextures(_animation), animLoop);
				
				if (content is AnimationSequence)
					(content as AnimationSequence).changeAnimation(_animation, animLoop);
			}
		}

		public function get group():int {
			return _group;
		}

		public function set group(value:int):void {
			_group = value;
		}

		public function get citrusObject():ISpriteView {
			return _citrusObject;
		}

		public function update(stateView:StarlingView):void {
			
			scaleX = _citrusObject.inverted ? -1 : 1;
			// The position = object position + (camera position * inverse parallax)

			if (content is Box2DDebugArt) {

				// Box2D view is not on the Starling display list, but on the classical flash display list.
				// So we need to move its view here, not in the StarlingView.
				// modified for better
				var localStage:Stage = Starling.current.nativeStage;
				for (var i:int = 0; i < localStage.numChildren; i++) 
				{
					if(localStage.getChildAt(i) is b2DebugDraw){
						break;
					}
				}
				
				var box2dDebugArt:b2DebugDraw = (localStage.getChildAt(i) as b2DebugDraw);

				if (stateView.cameraTarget) {

					box2dDebugArt.x = stateView.viewRoot.x;
					box2dDebugArt.y = stateView.viewRoot.y;
				}

				box2dDebugArt.visible = _citrusObject.visible;
				
			} else if (content is NapeDebugArt) {
				
				// Nape view is not on the Starling display list, but on the classical flash display list.
				// So we need to move its view here, not in the StarlingView.
				
				var napeDebugArt:flash.display.DisplayObject = (Starling.current.nativeStage.getChildAt(2) as flash.display.DisplayObject);
				
				if (stateView.cameraTarget) {

					napeDebugArt.x = stateView.viewRoot.x;
					napeDebugArt.y = stateView.viewRoot.y;
				}

				napeDebugArt.visible = _citrusObject.visible;
				
			} else if (_physicsComponent) {
				
				x = _physicsComponent.x + (-stateView.viewRoot.x * (1 - _citrusObject.parallax)) + _citrusObject.offsetX * scaleX;
				y = _physicsComponent.y + (-stateView.viewRoot.y * (1 - _citrusObject.parallax)) + _citrusObject.offsetY;
				rotation = deg2rad(_physicsComponent.rotation);

			} else {

				x = _citrusObject.x + (-stateView.viewRoot.x * (1 - _citrusObject.parallax)) + _citrusObject.offsetX * scaleX;
				y = _citrusObject.y + (-stateView.viewRoot.y * (1 - _citrusObject.parallax)) + _citrusObject.offsetY;
				rotation = deg2rad(_citrusObject.rotation);
			}
			
			visible = _citrusObject.visible;
			registration = _citrusObject.registration;
			view = _citrusObject.view;
			animation = _citrusObject.animation;
			group = _citrusObject.group;
		}
		
		/**
		 * Remove or add to the Juggler if the Citrus Engine is playing or not
		 */
		private function _pauseAnimation(value:Boolean):void {
			
			if (content is MovieClip)
				value ? Starling.juggler.add(content as MovieClip) : Starling.juggler.remove(content as MovieClip);
			else if (content is AnimationSequence)
				(content as AnimationSequence).pauseAnimation(value);
			else if (content is PDParticleSystem)
				value ? Starling.juggler.add(content as PDParticleSystem) : Starling.juggler.remove(content as PDParticleSystem);
		}

		private function handleContentLoaded(evt:Event):void {

			if (evt.target.loader.content is flash.display.MovieClip) {

				_textureAtlas = DynamicAtlas.fromMovieClipContainer(evt.target.loader.content, 1, 0, true, true);
				content = new DynamicMovieClip(_textureAtlas.getTextures(animation));
				Starling.juggler.add(content as MovieClip);
			}

			if (evt.target.loader.content is Bitmap) {
				
				_texture = Texture.fromBitmap(evt.target.loader.content);
				content = new Image(_texture);
			}
			
			moveRegistrationPoint(_citrusObject.registration);
			
			addChild(content);
		}

		private function handleContentIOError(evt:IOErrorEvent):void {
			throw new Error(evt.text);
		}

	}
}

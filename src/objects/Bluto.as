package objects  {
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Baddy;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.view.starlingview.AnimationSequence;
	import com.citrusengine.view.starlingview.StarlingArt;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	
	import starling.display.MovieClip;
	
	/**
	 * This is a common example of a side-scrolling bad guy. He has limited logic, basically
	 * only turning around when he hits a wall.
	 * 
	 * When controlling collision interactions between two objects, such as a Horo and Baddy,
	 * I like to let each object perform its own actions, not control one object's action from the other object.
	 * For example, the Hero doesn't contain the logic for killing the Baddy, and the Baddy doesn't contain the
	 * logic for making the hero "Spring" when he kills him. 
	 */	
	public class Bluto extends Baddy
	{
		public static const PLATFORM_DIFF:Number = 63;
		public static var shouldClimbUp:Boolean = false;
		public static var shouldClimbDown:Boolean = false;
		
		public var direction:int = 0;
		private var prev_x_pos:Number = 0;

		private var ladderType:String;

		private var collider:Box2DPhysicsObject;

		private var hero:Popeye;
		private var myTimer:Timer;

		public function Bluto(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if(CitrusEngine.getInstance()!=null)
				var hero:Popeye = CitrusEngine.getInstance().state.getFirstObjectByType(Popeye) as Popeye;
			if(this.speed == 0)
			{
				var content:AnimationSequence = AnimationSequence(StarlingArt(_ce.state.view.getArt(this)).content);
				//var content:DynamicMovieClip = DynamicMovieClip(StarlingArt(_ce.state.view.getArt(this)).content);
				if(content.getChildAt(0) is MovieClip){
					MovieClip(content.getChildAt(0)).stop();
				//content.stop();
				}
			}
			
			var position:V2 = _body.GetPosition();
			if (_lastXPos > prev_x_pos) {
				direction = 1;	//right
			}
			else if (_lastXPos < prev_x_pos) {
				direction = -1;	//left
			}
			else {
				direction = 0;	//stationary
			}
			
			_lastXPos = position.x;
			prev_x_pos = _lastXPos;
			
			//Turn around when they pass their left/right bounds
			if ((_inverted && position.x * 30 < leftBound) || (!_inverted && position.x * 30 > rightBound)){
				
				turnAround();
			}
			
			var velocity:V2 = _body.GetLinearVelocity();
			if (!_hurt)
			{
				if (_inverted)
					velocity.x = -speed;
				else
					velocity.x = speed;
			}
			
			if(shouldClimbDown){
				this.y +=30;
				if(this.x < 500)
					this.x -= 15
				else
					this.x += 10;
				shouldClimbDown = false;
				velocity.x =0;
			}
			
			if(shouldClimbUp){
				this.y -= 130;
				this.x += 2;
				shouldClimbUp = false;
				velocity.x =0;
			}
			_body.SetLinearVelocity(velocity);
			updateAnimation();
		}
		
		override public function handleSensorBeginContact(e:ContactEvent):void
		{
			trace("Contact made with sensor - in BlutoClass");
			if (_body.GetLinearVelocity().x < 0 && e.fixture == _rightSensorFixture)
				return;
			
			if (_body.GetLinearVelocity().x > 0 && e.fixture == _leftSensorFixture)
				return;
			
			collider = e.other.GetBody().GetUserData();
			trace("Collider is : " + collider);
			
			if (collider is Platform || collider is Baddy)
			{
				trace("collider is not Ladder");
				turnAround();
			}
		}
		
		public function mod(num:int):int 
		{
			if (num < 0) num = num * -1;
			return num;
		}
		
		override public function turnAround():void
		{
			trace("turnAround!");
			_inverted = !_inverted;
			_lastTimeTurnedAround = new Date().time;
		}
		
		public function climbUpStairs():void{
			trace("Climb Up Stairs!");
			shouldClimbUp = true;
		}
		
		public function climbDownStairs():void{
			trace("Climb Down Stairs!");
			shouldClimbDown = true;
		}
		
		protected function fireMissle(event:TimerEvent):void
		{
			//var missile:Missile = new Missile("Missile" , {view:"Mario-assets/bullet.png",x:startX, y:startY});
			//CitrusEngine.getInstance().state.add(missile);
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
		}
	}
}

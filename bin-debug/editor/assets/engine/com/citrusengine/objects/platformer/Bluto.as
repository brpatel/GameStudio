package objects  {
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Baddy;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.objects.platformer.box2d.Sensor;
	
	import flash.events.TimerEvent;
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
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
		[Property(value="Bluto.png")]
		public var iconImage:String = "Bluto.png";
		
		[Property(value="1.0")]
		public var speed:Number = 1.3;
		
		public static const PLATFORM_DIFF:Number = 30;
		public var shouldClimbUp:Boolean = false;
		public var shouldClimbDown:Boolean = false;
		public function Bluto(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			var position:V2 = _body.GetPosition();
			
			_lastXPos = position.x;
			
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
			
		/*	if ( _ce.input.justPressed(Keyboard.UP))
			{
				velocity.y = -10;
				
			}*/
			if(shouldClimbDown){
				this.y +=30;
				this.x -= 20;
				shouldClimbDown = false;
				velocity.x =0;
			}
			
			if(shouldClimbUp){
				this.y -=130;
				this.x += 20;
				shouldClimbUp = false;
				velocity.x =0;
			}else{
				
				
			}
			
			_body.SetLinearVelocity(velocity);
			
			updateAnimation();
		}
		
		override public function handleSensorBeginContact(e:ContactEvent):void
		{
			
			if (_body.GetLinearVelocity().x < 0 && e.fixture == _rightSensorFixture)
				return;
			
			if (_body.GetLinearVelocity().x > 0 && e.fixture == _leftSensorFixture)
				return;
			
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			
			var _stairs:Vector.<CitrusObject> = CitrusEngine.getInstance().state.getObjectsByType(Sensor);
			for (var i:int = 0; i < _stairs.length; i++) 
			{
				Sensor(_stairs[i]).onBeginContact.add(contactListener);
			}
			
			
			if (collider is Sensor|| collider is Ladder)
			{
				trace("Bluto on Stairs!");
			}
			
			if (collider is Platform || collider is Baddy)
			{
				if(!(collider is Stairs))
					turnAround();
			
			}
		}
		
		public function contactListener(e:ContactEvent):void
		{
			trace("Stairs contact!");
		//	Sensor(e.fixture.GetBody().GetUserData()).onBeginContact.remove(contactListener);
			/*var _stairs:Vector.<CitrusObject> = CitrusEngine.getInstance().state.getObjectsByType(Sensor);
			for (var i:int = 0; i < _stairs.length; i++) 
			{
				Sensor(_stairs[i]).onBeginContact.remove(contactListener);
			}*/
			decisionTime();
		
		}
		
		private function decisionTime():void
		{
			trace("Decision time!");
			
			var hero:Popeye = CitrusEngine.getInstance().state.getFirstObjectByType(Popeye) as Popeye;
			//	trace("Hero- x: "+hero.x +" y: "+hero.y);
			//	trace("Bluto- x: "+this.x +" y: "+this.y);
			
			if(hero.y - this.y >= PLATFORM_DIFF){
						trace("Diff: "+(hero.y - this.y));
				climbDownStairs();
				turnAround();
			}else if (hero.y - this.y <= PLATFORM_DIFF ){
						trace("Diff: "+(hero.y - this.y));
				climbUpStairs();
			}else{
				trace("just turnAround!");
				turnAround();
			}
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
			/*var velocity:V2 = _body.GetLinearVelocity();			
			velocity.y = -10;			
			_body.SetLinearVelocity(velocity);
			*/
		}
		
		public function climbDownStairs():void{
			trace("Climb Down Stairs!");
			
			shouldClimbDown = true;
			
			/*var velocity:V2 = _body.GetLinearVelocity();			
			velocity.y = 10;			
			_body.SetLinearVelocity(velocity);*/
		}
		
		public function climbUpLadder():void{
			trace("Climb Up Ladder!");
			var velocity:V2 = _body.GetLinearVelocity();			
			velocity.y = -10;			
			_body.SetLinearVelocity(velocity);
			
		}
		
		public function climbDownLadder():void{
			trace("Climb Down Ladder!");
			var velocity:V2 = _body.GetLinearVelocity();			
			velocity.y = 10;			
			_body.SetLinearVelocity(velocity);
		}
		
		protected function fireMissle(event:TimerEvent):void
		{
			//var missile:Missile = new Missile("Missile" , {view:"Mario-assets/bullet.png",x:startX, y:startY});
			//CitrusEngine.getInstance().state.add(missile);
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			
			//if (collider is _enemyClass && collider.body.GetLinearVelocity().y > enemyKillVelocity)
			//if (collider is _enemyClass)
			
		}
	}
}


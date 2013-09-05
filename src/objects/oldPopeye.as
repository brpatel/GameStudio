package objects
{
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.utils.LevelManager;
	
	import flash.ui.Keyboard;
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	
	public class oldPopeye extends Hero
	{
		// properties for ladder
		public var originalGravity:V2;
		public var canClimb:Boolean = false;
		public var climbVelocity:Number = 3;
		public var ladder:Ladder;
		protected var _onLadder:Boolean = false;
		protected var _climbing:Boolean = false;
		protected var _climbAnimation:String = "ladderIdle";
		//end properties for ladder
		
		
		public function oldPopeye(name:String, params:Object=null)
		{
			super(name, params);
			originalGravity = _box2D.world.GetGravity();
			jumpHeight = 7;
			jumpAcceleration = 0.05;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if(x>1024)
				x=0;
			if(x<0)
				x=1000;
			
			var velocity:V2 = _body.GetLinearVelocity();
			
			if (controlsEnabled)
			{
				var moveKeyPressed:Boolean = false;
				
				if (_ce.input.isDown(Keyboard.RIGHT))
				{
					if (canClimb) {
						setGravity()
						_climbing = false;
					}
					velocity.x += (acceleration);
					moveKeyPressed = true;
				}
				
				if (_ce.input.isDown(Keyboard.LEFT))
				{
					if (canClimb) {
						setGravity();
						_climbing = false;
					}
					velocity.x -= (acceleration);
					moveKeyPressed = true;
				}
				
				_onLadder = ((_ce.input.isDown(Keyboard.DOWN) || _ce.input.isDown(Keyboard.UP)) && canClimb);
				if (_onLadder) {
					if (x < ladder.x) 
						x++;
					if (x > ladder.x)
						x--;
				}
				
				if (_ce.input.isDown(Keyboard.UP) && canClimb) {
					_onLadder = _climbing = true;
					//_climbAnimation = "ladderClimbUp";
					velocity = new V2(0, 0);
					velocity.y -= climbVelocity;
					removeGravity();
					moveKeyPressed = true;
				}
				
				if (_ce.input.isDown(Keyboard.DOWN) && canClimb) {
					_onLadder = _climbing = true;
					//_climbAnimation = "ladderClimbDown";
					velocity = new V2(0, 0);
					velocity.y += climbVelocity;
					removeGravity();
					moveKeyPressed = true;
				}
				
				// Remove velocity if just stop climbing
				if ((_ce.input.justReleased(Keyboard.UP) || _ce.input.justReleased(Keyboard.DOWN)) && canClimb) {
					//_climbAnimation = "ladderIdle";
					velocity.y = 0;
				}
				
				//If player just started moving the hero this tick.
				if (moveKeyPressed && !_playerMovingHero)
				{
					_playerMovingHero = true;
					_fixture.SetFriction(0); //Take away friction so he can accelerate.
				}
					//Player just stopped moving the hero this tick.
				else if (!moveKeyPressed && _playerMovingHero)
				{
					_playerMovingHero = false;
					_fixture.SetFriction(_friction); //Add friction so that he stops running
				}
				
		/*		if (_onGround && _ce.input.justPressed(Keyboard.UP))
				{
					velocity.y = -jumpHeight;
					onJump.dispatch();
				}
				
				if (_ce.input.isDown(Keyboard.UP) && !_onGround && velocity.y < 0)
				{
					velocity.y -= jumpAcceleration;
				}
				
				if (_springOffEnemy != -1)
				{
					if (_ce.input.isDown(Keyboard.UP))
						velocity.y = -enemySpringJumpHeight;
					else
						velocity.y = -enemySpringHeight;
					_springOffEnemy = -1;
				}*/
				
				//Cap velocities
				if (velocity.x > (maxVelocity))
					velocity.x = maxVelocity;
				else if (velocity.x < (-maxVelocity))
					velocity.x = -maxVelocity;
				
				//update physics with new velocity
				_body.SetLinearVelocity(velocity);
			}
			
			updateAnimation();
		}
		
		override protected function handlePreSolve(e:ContactEvent):void 
		{
			if (e.other.GetBody().GetUserData() is Platform && canClimb && (_climbing || !_onGround)) {
				if ((y + height / 2) < (ladder.y + ladder.height / 2)) {
					e.contact.Disable();
				}
			}
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
			var colliderBody:b2Body = e.other.GetBody();
			
			if (_enemyClass && colliderBody.GetUserData() is _enemyClass)
			{
				Level1.lifeRemaining -= 1;
				kill = true;
				if(Level1.lifeRemaining > 0)
					restartLevel()
				/*if (_body.GetLinearVelocity().y < killVelocity && !_hurt)
				{
					hurt();
					
					//fling the hero
					var hurtVelocity:V2 = _body.GetLinearVelocity();
					hurtVelocity.y = -hurtVelocityY;
					hurtVelocity.x = hurtVelocityX;
					if (colliderBody.GetPosition().x > _body.GetPosition().x)
						hurtVelocity.x = -hurtVelocityX;
					_body.SetLinearVelocity(hurtVelocity);
				}
				else
				{
					_springOffEnemy = colliderBody.GetPosition().y * _box2D.scale - height;
					onGiveDamage.dispatch();
				}*/
			}
			
			if (colliderBody.GetUserData() is Ladder && colliderBody.GetUserData().isLadder) {
				canClimb = true;
				ladder = colliderBody.GetUserData();
			}
			
			//Collision angle
			if (e.normal) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{
				var collisionAngle:Number = new MathVector(e.normal.x, e.normal.y).angle * 180 / Math.PI;
				if (collisionAngle > 45 && collisionAngle < 135)
				{
					_groundContacts.push(e.other);
					_onGround = true;
				}
			}
		}
		
		private function restartLevel():void
		{
			var levelManager:LevelManager = LevelManager.getInstance()
			levelManager.gotoLevel();
		}
		
		override protected function handleEndContact(e:ContactEvent):void
		{
			//Remove from ground contacts, if it is one.
			var index:int = _groundContacts.indexOf(e.other);
			if (index != -1)
			{
				_groundContacts.splice(index, 1);
				if (_groundContacts.length == 0)
					_onGround = true;
			}
			
			if (e.other.GetBody().GetUserData() is Ladder && e.other.GetBody().GetUserData().isLadder) {
				_climbing = canClimb = false;
				setGravity();
				_onGround = true;
			}
		}
		
		private function setGravity():void
		{
			_box2D.world.SetGravity(originalGravity);
		}
		
		/**
		 * Removes gravity for one tick. A value of 1 removes all gravity. A value of .9 is suitable for water.
		 * 
		 */
		private function removeGravity(value:Number = 1):void
		{
			var noGravity:V2 = new V2();
			_box2D.world.SetGravity(noGravity);
		}
	}
}
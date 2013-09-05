package objects
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.utils.LevelManager;
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	
	
	public class Popeye extends Hero
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
		public var _lastXPos:Number;

		private var bluto:Bluto;

		private var myTimer:Timer;

		private var last_time:Number = 0;

		private var timelineRight:TimelineLite;
		private var timelineLeft:TimelineLite;

		private var fallTimer:Timer;
		private var myTimer1:Timer;
		
		public function Popeye(name:String, params:Object=null)
		{
			super(name, params);
			originalGravity = _box2D.world.GetGravity();
			jumpHeight = 10;
			jumpAcceleration = 0.05;
			maxVelocity = 3;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			
			//this is a temporary fix to just kill hero if in case he jumps out of ship for any weird reason(mainly ladders :D)
			if(y > 800)
			{
				kill = true;
				myRestartLevel();
			}
			
			var position:V2 = _body.GetPosition();
			_lastXPos = position.x;
			
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
					{
						x++;
					}
					if (x > ladder.x)
					{
						x--;
					}
				}
			
				if (_ce.input.isDown(Keyboard.UP) && canClimb) {
					_onLadder = _climbing = true;
					velocity = new V2(0, 0);
					velocity.y -= climbVelocity;
					removeGravity();
					moveKeyPressed = true;
				}
				
				if (_ce.input.isDown(Keyboard.DOWN) && canClimb) {
					//trace("Moving Down");
					_onLadder = _climbing = true;
					velocity = new V2(0, 0);
					velocity.y += climbVelocity;
					removeGravity();
					moveKeyPressed = true;
					
				}
			
				// Remove velocity if just stop climbing
				if ((_ce.input.justReleased(Keyboard.UP) || _ce.input.justReleased(Keyboard.DOWN)) && canClimb) {
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
				
				if (_onGround && _ce.input.justPressed(Keyboard.SPACE) && !_ducking)
				{
					trace("popeye jumped"+_onGround);
					velocity.y = -jumpHeight;
					onJump.dispatch();
				}
				
				if (_ce.input.isDown(Keyboard.SPACE) && !_onGround && velocity.y < 0)
				{
					velocity.y -= jumpAcceleration;
				}

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
			var date:Date = new Date;
			var curr_time:Number = date.getTime();
			if (_enemyClass && colliderBody.GetUserData() is _enemyClass && (curr_time - 10000) > last_time)
			{
				/*if(ALevel.particles != null){
					ALevel.particles.x = this.x;
					ALevel.particles.y = this.y;
					ALevel.particles.start(0.2);
				}*/
				
				SoundManager.getInstance().stopSound("popeye");
				SoundManager.getInstance().playSound("hit",0.2,1);
				
				trace("Current_time " + curr_time);
				trace("Last time : " + last_time);
				last_time = curr_time;
				bluto = CitrusEngine.getInstance().state.getFirstObjectByType(Bluto) as Bluto;
				bluto.speed = 0;
				
				var currentDate:Date = new Date();
				try{
					if(_inverted)
					{
						timelineLeft = new TimelineLite();
						timelineLeft.insertMultiple([
//													new TweenLite(this, 0.5, {rotation:15}),
//													 new TweenLite(this, 0.5, {rotation:-15}),
//													 new TweenLite(this, 0.5, {rotation:15}),
//													 new TweenLite(this, 0.5, {rotation:-15}),
													 new TweenLite(this, 0.5, {rotation:95}),
													 new TweenLite(this, 3,{offsetY:500})],
													 0,
													 TweenAlign.START,0.5);
					}
					else
					{
						timelineLeft = new TimelineLite();
						timelineLeft.insertMultiple([
//							new TweenLite(this, 0.5, {rotation:-15}),
//							new TweenLite(this, 0.5, {rotation:15}),
//							new TweenLite(this, 0.5, {rotation:-15}),
//							new TweenLite(this, 0.5, {rotation:15}),
							new TweenLite(this, 0.5, {rotation:-95}),
							new TweenLite(this, 3, {offsetY:500})],
							0,
							TweenAlign.START,0.5);
					}
				}
				catch(e:Error)
				{
					trace("Exception");
				}
				myTimer = new Timer(4000); // 2 second
				myTimer.addEventListener(TimerEvent.TIMER, pauseGame);
				myTimer.start();
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
		
		protected function pauseGame(event:TimerEvent):void
		{
			myTimer.removeEventListener(TimerEvent.TIMER, pauseGame);
			kill = true;
			super.destroy();
			_ce.gameData.lives--;
			SoundManager.getInstance().stopSound("hit");
			myRestartLevel();
		}
		
		public function myRestartLevel():void
		{
			/*if(_ce.gameData.lives >= 1)
			{
				
				var levelManager:LevelManager = LevelManager.getInstance();
				levelManager.gotoLevel();
			}
			else
			{
				var endScreen:EndScreen = new EndScreen;
				_ce.starling.stage.addChild(endScreen);
			}*/
		}
		
		override protected function handleEndContact(e:ContactEvent):void
		{
			//Remove from ground contacts, if it is one.
			var index:int = _groundContacts.indexOf(e.other);
			if (index != -1)
			{
				_groundContacts.splice(index, 1);
				//if (_groundContacts.length == 0)
					_onGround = false;
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
		
		public function setGroundContacts(arr:Array):void
		{
			_groundContacts = arr;	
		}
	}
}
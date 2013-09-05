package objects 
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Sensor;
	
	import flash.display.MovieClip;
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	/**
	 * Sensors simply listen for when an object begins and ends contact with them. They disaptch a signal
	 * when contact is made or ended, and this signal can be used to perform custom game logic such as
	 * triggering a scripted event, ending a level, popping up a dialog box, and virtually anything else.
	 * 
	 * Remember that signals dispatch events when ANY Box2D object collides with them, so you will want
	 * your collision handler to ignore collisions with objects that it is not interested in, or extend
	 * the sensor and use maskBits to ignore collisions altogether.  
	 * 
	 * Events
	 * onBeginContact - Dispatches on first contact with the sensor.
	 * onEndContact - Dispatches when the object leaves the sensor.
	 */   
	public class Ladder extends Sensor
	{
		public static const PLATFORM_DIFF:Number = 63;
		
		public var isLadder:Boolean = true;
		public var ladderType:String = "large"; 

		private var collider:Box2DPhysicsObject;
		
		public static function Make(name:String, x:Number, y:Number, width:Number, height:Number, view:* = null):Ladder
		{
			if (view == null) view = MovieClip;
			return new Ladder(name, { x: x, y: y, width: width, height: height, view: view } );
		}
		
		public function Ladder(name:String, params:Object=null)
		{
			super(name, params);
			this.onBeginContact.add(contactListener);
		}
		
		private function contactListener(e:ContactEvent):void
		{
			collider = e.other.GetBody().GetUserData();
			trace("Sensor listener activated!");
			
			if (collider is Bluto)
			{
 				decisionTime();
			}
		}
		
		public function mod(num:int):int 
		{
			if (num < 0) num = num * -1;
			return num;
		}
		
		private function decisionTime():void
		{
			trace("Decision time!");
			
			var hero:Popeye = CitrusEngine.getInstance().state.getFirstObjectByType(Popeye) as Popeye;
			var bluto:Bluto = CitrusEngine.getInstance().state.getFirstObjectByType(Bluto) as Bluto;
			if(hero!=null)		
			{	var currentPosition:V2 = bluto.body.GetPosition();
				
				if(mod(hero.y - collider.y) >= PLATFORM_DIFF){
					trace("Hero and baddie on different level");
					trace("Diff: "+(hero.y - collider.y));
					trace("Hero.y : " + hero.y);
					trace("Baddy.y : " + collider.y);
					trace("Ladder.y : " + this.y);
					
					if (hero.y > collider.y && collider.y < this.y) {
						bluto.climbDownStairs();
					}
					else if (hero.y < collider.y && collider.y > this.y) {
						bluto.climbUpStairs();
					}
				}else if (mod(hero.y - collider.y) <= PLATFORM_DIFF ){
					trace("Hero and baddie on same level");
					trace(hero._lastXPos+ ":"+ currentPosition.x);
					
					if(collider.x > 900 && collider.y > 380 && mod(hero.y - collider.y) > 30)
						bluto.climbUpStairs();
						
					if (hero._lastXPos > currentPosition.x) {
						trace("hero on the right");
						if(bluto.direction == -1) {
							bluto.turnAround();
						}
					}
					else if (hero._lastXPos < currentPosition.x) {
						trace("hero on the left");
						if(bluto.direction == 1) {	//baddie movement right
							bluto.turnAround();
						}
					}
				}
			}
		}		
	}
}
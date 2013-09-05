package objects
{
	import com.adobe.gamebuilder.game.preview.GameState;
	import com.citrusengine.objects.platformer.box2d.Ball;
	import com.citrusengine.objects.platformer.box2d.Coin;
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	
	public class RavanaHead extends Coin
	{
		private var last_time:Number = 0;
		
		public function RavanaHead(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
			var colliderBody:b2Body = e.other.GetBody();
			var date:Date = new Date;
			var curr_time:Number = date.getTime();
			if (colliderBody.GetUserData() is Ball && (curr_time - 10000) > last_time)
			{
				trace("Hit!");
				if(GameState.particles != null){
					GameState.particles.x = this.x;
					GameState.particles.y = this.y;
					GameState.particles.start(0.2);
				}
				this.kill = true;
				last_time = date.getTime();	
			}
		}
		
		/*override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			var ravana:Ravana = Ravana(getFirstObjectByType(Ravana));
		}*/
	}
}
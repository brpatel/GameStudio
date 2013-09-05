package objects
{
	import com.citrusengine.objects.platformer.box2d.Coin;
	
	import Box2DAS.Dynamics.b2Body;
	
	public class Heart extends Coin
	{
		public function Heart(name:String, params:Object=null)
		{
			super(name, params);
			this.view = "editor\\assets\\embed\\InGame\\Hearttexture.png";
			_body.m_type = b2Body.b2_staticBody;
			visible = false;
		}
	}
}
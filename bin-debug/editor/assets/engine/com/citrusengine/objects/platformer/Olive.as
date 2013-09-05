package objects
{
	import com.citrusengine.objects.platformer.box2d.Baddy;
	
	
	public class Olive extends Baddy
	{
		[Property(value="Olive.png")]
		public var iconImage:String = "Olive.png";
		
		public static var oliveHit:int = 0;
		public static var coinCount:int = 0;
		
		public function Olive(name:String, params:Object=null)
		{
			super(name, params);
		}
	}
}
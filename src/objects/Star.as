package objects
{
	public class Star 
	{
		public function Star()
		{
		}
		
		private var speed:int;
		
		public function onLoad()
		{
			speed = Math.random()*10+5;
			_x = Math.random()*400+50;
			_y = -10;
		}
		
		public function onEnterFrame()
		{
			_y += speed;
			_rotation -= 5;
			
			if(_y > 310)
			{
				this.removeMovieClip();
			}
		}
	}
}
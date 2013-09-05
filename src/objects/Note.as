package objects
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.objects.platformer.box2d.Coin;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	public class Note extends Coin
	{
		[Embed(source="../editor/assets/embed/welcomeScreen/heart.png")]
		private var _notePng:Class;
		
		public static var heartVisibilityCount:int = 0;
		private var direction:Boolean = true;  //for right direction. false for left
		private var count:int = 1;

		private var randomX:Number;
		private var myTimer:Timer;

		public function Note(name:String, params:Object=null)
		{
			super(name, params);
			collectorClass = objects.Popeye;
			this.view = "editor/assets/embed/InGame/Hearttexture.png";
			randomX = randomNumber(x+350, x-350);
		}		
		
		private function randomNumber(min:Number, max:Number):Number
		{
			return Math.floor(Math.random() * (1 + max - min) + min);
		}
		
		
		override public function update(timeDelta:Number):void
		{
			var notePosition:V2 = body.GetPosition();
			if(y<700)
				this.y +=1;
			else
				kill = true;
			
			if(direction)
				this.x = this.x + 1;
			else
				this.x = this.x - 1;
			count++;
			if(count == 100)
			{	direction = !direction;
				count = 0;
			}
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
			super.handleBeginContact(e);
			
			var bluto:Bluto = CitrusEngine.getInstance().state.getFirstObjectByType(Bluto) as Bluto;
			var popeye:Popeye = CitrusEngine.getInstance().state.getFirstObjectByType(Popeye) as Popeye;
			var olive:Olive = CitrusEngine.getInstance().state.getFirstObjectByType(Olive) as Olive;
			
			if (objects.Popeye && e.other.GetBody().GetUserData() is objects.Popeye)
			{
				kill = true;
				if(popeye!=null && _ce.gameData.score < 1800 && popeye.kill == false)
				{
					_ce.gameData.score += 300;
					var heart:Heart = Heart(Scoreboard.heartList[heartVisibilityCount++]);
					if(heart!= null)
						heart.visible = true;
					heart = Heart(Scoreboard.heartList[heartVisibilityCount++]);
					if(heart!= null)
						heart.visible = true;
					heart = Heart(Scoreboard.heartList[heartVisibilityCount++]);
					if(heart!= null)
						heart.visible = true;
					
				if(ALevel.coinparticles!=null){
					ALevel.coinparticles.x = this.x;
					ALevel.coinparticles.y = this.y;
					ALevel.coinparticles.start(0.1);
				}
					CitrusEngine.getInstance().sound.playSound("drip",1,1);
				}
				
				if(_ce.gameData.score == 1800)
				{ 
					if(WelcomeScreen.skyparticles != null && ALevel.endparticles!=null){
						WelcomeScreen.skyparticles.stop(true);
						ALevel.endparticles.x = 1000;
						ALevel.endparticles.start();
					}
					
					if(bluto)
						bluto.kill = true;
					if(olive)
						olive.kill = true;
					if(popeye)
						popeye.kill = true;

					if(popeye)
					{
						CitrusEngine.getInstance().sound.stopSound("popeye");
						CitrusEngine.getInstance().sound.playSound("baazigar",1,1);	
					}
					
					TweenLite.to(CitrusEngine.getInstance().state,2,{x:-780,scaleX:1.8, scaleY:1.8});
					if(ALevel.endImage!=null )
						TweenMax.to(ALevel.endImage,10, {alpha:1, ease:Expo.easeOut});
					else if(GameState.endImage != null)
						TweenMax.to(GameState.endImage,10, {alpha:1, ease:Expo.easeOut});
					
					myTimer = new Timer(15000); 
					myTimer.addEventListener(TimerEvent.TIMER, pauseGame);
					myTimer.start();
				}
			}
		}
		
		protected function pauseGame(event:TimerEvent):void
		{
			if(myTimer!=null)
				myTimer.stop();
			
			_ce.starling.stage.removeChildren(0,_ce.starling.stage.numChildren-1);
			var endScreen:EndScreen = new EndScreen;
			_ce.starling.stage.addChild(endScreen);
			if(ALevel.endparticles!=null)
				ALevel.endparticles.stop(false);
			//if(SoundManager.getInstance().getSoundChannel("baazigar").position == 15000)
			CitrusEngine.getInstance().sound.stopSound("baazigar");
		}
		
	}
}
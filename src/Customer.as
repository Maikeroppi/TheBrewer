package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.motion.LinearMotion;
	//import Math;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Customer extends Entity 
	{
		
		[Embed(source = "../Hopbro.png")]
		public static const HopbroImageEmbed:Class;
		
		[Embed(source = "../Stoutdude.png")]
		public static const StoutdudeImageEmbed:Class;
				
		[Embed(source = "../Pilsnerguy.png")]
		public static const PilsnerguyImageEmbed:Class;
		
		private var CustImage_:Image;
		private var LikedBeerType_:String;
		private var MoveTween_:LinearMotion;
		private var FadeTween_:ColorTween;
		
		private var OldX_:int;
		private var OldY_:int;
		
		public function Customer() 
		{
			var RandNum:int = Math.floor(Math.random() * 3);
			switch(RandNum) {
				case 0:
					CustImage_ = new Image(HopbroImageEmbed);
					LikedBeerType_ = "ipa";
					break;
				case 1:
					CustImage_ = new Image(StoutdudeImageEmbed);
					LikedBeerType_ = "stout";
					break;
					
				default:
					CustImage_ = new Image(PilsnerguyImageEmbed);
					LikedBeerType_ = "pils";
					break;
			}
			graphic = CustImage_;
			
			MoveTween_ = new LinearMotion(moveDone);
			addTween(MoveTween_);
			
			FadeTween_ = new ColorTween(fadeDone);
			addTween(FadeTween_);
			
			OldX_ = OldY_ = 0;
		}
		
		public function slideCustomer():void
		{
			MoveTween_.setMotion(x, y, 200, y, 0.5);
			MoveTween_.start();
		}
		
		private function moveDone():void
		{
			MoveTween_.cancel();
		}
		
		private function fadeDone():void
		{
			FadeTween_.cancel();
		}
		
		public function setAlpha(NewAlpha:Number):void
		{
			CustImage_.alpha = NewAlpha;
		}
		
		override public function update():void
		{
			if (MoveTween_.active) {
				OldX_ = x;
				OldY_ = y;
				x = MoveTween_.x;
				y = MoveTween_.y;
			}
			
			if (collide("customer", x, y)) {
				x = OldX_;
				y = OldY_;
			}
			
			
			//if (FadeTween_.active) {
				//HopbroImage_.alpha = FadeTween_.alpha;
			//}			
			
			super.update();
		}
		
		public function giveBeer(BeerGlass:BeerMug):Boolean
		{
			//BeerGlass.sendDownBar();
			//FadeTween_.tween(0.3, 0xffffffff, 0xfffffff, 1.0, 0.0001);
			//FadeTween_.start();
			
			if (BeerGlass.BeerType == LikedBeerType_) {
				return true;
			} else {
				return false;
			}
		}
		
	}

}
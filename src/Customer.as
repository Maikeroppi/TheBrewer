package  
{
	import net.flashpunk.FP;
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
		
		[Embed(source = "../MisterBrown.png")]
		public static const MisterBrownImageEmbed:Class;
				
		[Embed(source = "../OktoberMan.png")]
		public static const OktoberManImageEmbed:Class;
		
		
		
		private var CustImage_:Image;
		private var LikedBeerType_:String;
		private var MoveTween_:LinearMotion;
		private var FadeTween_:ColorTween;
		private const VelocityX_:Number = 75;
		private const XLimit_:Number = 200;
		
		private var OldX_:int;
		private var OldY_:int;
		
		public function Customer() 
		{			
			MoveTween_ = new LinearMotion(moveDone);
			addTween(MoveTween_);
			
			FadeTween_ = new ColorTween(fadeDone);
			addTween(FadeTween_);
			
			OldX_ = OldY_ = 0;
		}
		
		public function SetBeerType(BeerType:String):void
		{
			LikedBeerType_ = BeerType;
			switch(LikedBeerType_) {
			case "ipa":
				graphic = new Image(HopbroImageEmbed);
			break;
			case "stout":
				graphic = new Image(StoutdudeImageEmbed);
			break;
			case "pils":
				graphic = new Image(PilsnerguyImageEmbed);
			break;
			case "brown":
				graphic = new Image(MisterBrownImageEmbed);
			break;
			case "oktober":
				graphic = new Image(OktoberManImageEmbed);
				break;
			default:
				trace("Unknown BeerType in Customer.SetBeerType!");
			}
		}
		
		public function slideCustomer():void
		{
			//MoveTween_.setMotion(x, y, 200, y, 0.5);
			//MoveTween_.start();
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
			//if (MoveTween_.active) {
				//OldX_ = x;
				//OldY_ = y;
				//x = MoveTween_.x;
				//y = MoveTween_.y;
			//}
			
			OldX_ = x;
			OldY_ = y;
			x = OldX_ - (VelocityX_ * FP.elapsed);
			if (x < XLimit_ ) x = OldX_;
			
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
			FadeTween_.tween(0.3, 0xffffffff, 0xfffffff, 1.0, 0.0001);
			FadeTween_.start();
			
			BrewerWorld.GotBeerSound.play();
			
			if (BeerGlass.BeerType == LikedBeerType_) {
				return true;
			} else {
				return false;
			}
		}
		
	}

}
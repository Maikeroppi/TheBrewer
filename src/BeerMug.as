package  
{
	import net.flashpunk.FP;
	import flash.display.InteractiveObject;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.Tweener;
	import net.flashpunk.tweens.motion.LinearMotion;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class BeerMug extends Entity 
	{
		[Embed(source = "../Beers.png")]
		public static const BeersImage:Class;
		
		private var BeersMap_:Spritemap;
		private var FillTween_:VarTween;
		private var MoveTween_:LinearMotion;
		private var BeingTweened_:Boolean;
		public var PerviousY:Number;
		private var VeloctiyY:Number = 10;
		
		
		public var FillLevel:int;
		public var BeerType:String;
		
		
		public function BeerMug() 
		{
			BeersMap_ = new Spritemap(BeersImage, 32, 32);
			BeersMap_.add("empty", [0]);
			BeersMap_.add("ipa", [1]);
			BeersMap_.add("stout", [2]);
			BeersMap_.add("pils", [3]);
			BeersMap_.play("empty");
			graphic = BeersMap_;
			
			setHitbox(32, 32);
			
			BeerType = "empty";
			FillLevel = 0;
			PerviousY = 0;
			
			type = "mug";
			
			FillTween_ = new VarTween(beerFilled);
			addTween(FillTween_);
			
			MoveTween_ = new LinearMotion(moveDone);
			addTween(MoveTween_);
			BeingTweened_ = false;
		}
		
		public function canSend():Boolean
		{
			return (FillLevel == 1.0)?true:false;
		}
		
		public function moveDone():void
		{
			//visible = false;
			VeloctiyY = 100;
		}
		
		public function beerFilled():void 
		{
			BeersMap_.play(BeerType);
		}
		
		public function fillBeer(Type:String):void
		{
			//if (BeingTweened_ == true) removeTween(FillTween_);
			BeersMap_.play("empty");
			visible = true;
			FillLevel = 0.0;
			FillTween_.tween(this, "FillLevel", 1.0, 0.75);
			BeingTweened_ = true;
			BeerType = Type;
			
			//BrewerWorld.FillBeerSound.play();
		}
		
		public function sendDownBar():void
		{
			// Adjust motion x and time for how far down the bar it already is.
			var TimeDuration:Number = (235 - x) / (235 - 70);
			
			MoveTween_.setMotion(x, y, 235, y, TimeDuration);
			MoveTween_.start();
			
			BrewerWorld.SlideSound.play();
		}
		
		override public function update():void
		{
			if(MoveTween_.active) {
				x = MoveTween_.x;
				//y = MoveTween_.y;				
			}
			
			PerviousY = y;
			y += VeloctiyY * FP.elapsed;
			
			super.update();
		}
		
	}

}
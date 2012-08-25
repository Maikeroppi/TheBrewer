package net 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Customer extends Entity 
	{
		
		[Embed(source = "../../Hopbro.png")]
		public static const HopbroImage:Class;
		
		private var LikedBeerType_:String;
		
		public function Customer() 
		{
			graphic = new Image(HopbroImage);
			LikedBeerType_ = "ipa";
		}
		
		override public function update():void
		{
			super.update();
		}
		
		public function giveBeer(BeerGlass:BeerMug):Boolean
		{
			BeerGlass.sendDownBar();			
			
			if (BeerGlass.BeerType == LikedBeerType_) {
				
				return true;
			} else {
				
				return false;
			}
		}
		
	}

}
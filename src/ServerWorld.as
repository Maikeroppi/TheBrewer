package  
{
	import net.Customer;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class ServerWorld extends World 
	{
		[Embed(source = "../Background.png")]
		public static const Background:Class;
		
		[Embed(source = "../RedTap.png")]
		public static const RedTapImage:Class;
		
		[Embed(source = "../BlackTap.png")]
		public static const BlackTapImage:Class;
		
		[Embed(source = "../YellowTap.png")]
		public static const YellowTapImage:Class;
		
		private var BackgroundEntity_:Entity;
		private var BlackTap_:Entity;
		private var RedTap_:Entity;
		private var YellowTap_:Entity;
		
		private var CurrentMug_:BeerMug;
		
		private var CustomerTween_:Tween;
		private var Customer_:Customer;
		private var CurrentScore_:Number;
		
		
		public function ServerWorld() 
		{
			BackgroundEntity_ = new Entity(0, 0, new Image(Background));
			add(BackgroundEntity_);
			
			RedTap_ = new Entity(70, 80, new Image(RedTapImage));
			RedTap_.type = "red_tap";
			RedTap_.setHitbox(32, 32);
			add(RedTap_);
			
			BlackTap_ = new Entity(102, 80, new Image(BlackTapImage));
			BlackTap_.type = "black_tap";
			BlackTap_.setHitbox(32, 32);
			add(BlackTap_);
					
			YellowTap_ = new Entity(134, 80, new Image(YellowTapImage));
			YellowTap_.type = "yellow_tap";
			YellowTap_.setHitbox(32, 32);
			add(YellowTap_);
			
			CurrentMug_ = new BeerMug();
			CustomerTween_ = new Tween(2, Tween.PERSIST, addCustomer);
			CustomerTween_.start();
			addTween(CustomerTween_);
			
			CurrentScore_ = 0;
		}
		
		public function addCustomer():void 
		{
			CustomerTween_.cancel();
			
			Customer_ = new Customer();
			Customer_.setHitbox(64, 128);
			Customer_.type = "customer";
			Customer_.x = 245;
			Customer_.y = 74;
			add(Customer_);
		}
		
		override public function update():void 
		{
			updateCollision();
			super.update();
		}
		
		public function updateCollision():void
		{
			var Mug:BeerMug;
			
			// Check for clicks
			if (Input.mouseReleased) {
				if (collidePoint("red_tap", mouseX, mouseY)) {
					CurrentMug_.x = 70;
					CurrentMug_.y = 111;
					CurrentMug_.fillBeer("ipa");
					add(CurrentMug_);
				}
				
				if (collidePoint("black_tap", mouseX, mouseY)) {
					CurrentMug_.x = 102;
					CurrentMug_.y = 111;
					CurrentMug_.fillBeer("stout");
					add(CurrentMug_);
				}
				
				if (collidePoint("yellow_tap", mouseX, mouseY)) {
					CurrentMug_.x = 134;
					CurrentMug_.y = 111;
					CurrentMug_.fillBeer("pils");
					add(CurrentMug_);
				}
				
				Mug = collidePoint("mug", mouseX, mouseY) as BeerMug;
				if (Mug != null && Mug.canSend()) {					
					if (Customer_.giveBeer(Mug) == true) {
						CurrentScore_ += 1;
					} else {
						CurrentScore_ -= 1 ;
					}					
					trace("Score: " + CurrentScore_);
				}
			}
		}
	}

}
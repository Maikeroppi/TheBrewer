package  
{
	import Customer;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class ServerWorld extends World 
	{
		[Embed(source = "../Background.png")]
		public static const Background:Class;
		
		[Embed(source = "../GameOverScreen.png")]
		public static const GameOverScreen:Class;
		public var GameOverEntity:Entity;
		
		[Embed(source = "../RedTap.png")]
		public static const RedTapImage:Class;
		
		[Embed(source = "../BlackTap.png")]
		public static const BlackTapImage:Class;
		
		[Embed(source = "../YellowTap.png")]
		public static const YellowTapImage:Class;
		
		[Embed(source = "../Server.png")]
		public static const ServerImage:Class;
		
		public var CurrentTime:Number;
		private var TimeoutTween:Tween;
		
		private var BackgroundEntity_:Entity;
		private var BlackTap_:Entity;
		private var RedTap_:Entity;
		private var YellowTap_:Entity;
		
		private var CurrentMug_:BeerMug;
		
		private var CustomerTween_:Tween;
		private var Customer_:Customer;
		
		
		
		private var TheBar_:Entity;
		private var TheFloor_:Entity;
		
		private var FadeTween_:ColorTween;
		
		private var ScoreText_:Text;
		private var ScoreEntity_:Entity;
		private var CurrentScore_:Number;
		private var TargetScore_:Number;
		
		private var ServerEntity_:Entity;
			
		public function ServerWorld() 
		{
			BackgroundEntity_ = new Entity(0, 0, new Image(Background));
			add(BackgroundEntity_);
			
			GameOverEntity = new Entity(0, 0, new Image(GameOverScreen));
			
			
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
			CustomerTween_ = new Tween(4, Tween.PERSIST, addCustomer);
			addTween(CustomerTween_);
			
			FadeTween_ = new ColorTween(fadeDone);
			addTween(FadeTween_);
			
			TimeoutTween = new Tween(60, Tween.PERSIST, timeoutHappened);
			addTween(TimeoutTween);
			
			CurrentScore_ = 0;
			TargetScore_ = 20;
			CurrentTime = 0;
			
			TheBar_ = new Entity(0, 141);
			TheBar_.setHitbox(231, 56);
			TheBar_.type = "bar";
			add(TheBar_);
			
			TheFloor_ = new Entity(0, 197);
			TheFloor_.setHitbox(320, 240 - 197);
			TheFloor_.type = "floor";
			add(TheFloor_);
			
			ScoreText_ = new Text("Score: 0", 0, 0);
			ScoreText_.color = 0xffffffff;
			
			ScoreEntity_ = new Entity(0, 220, ScoreText_);
			add(ScoreEntity_);
			
			ServerEntity_ = new Entity(0, 47, new Image(ServerImage));
			add(ServerEntity_);
		}
		
		override public function begin():void
		{
			TimeoutTween.start();
			CustomerTween_.start();
		}
		
		public function timeoutHappened():void
		{
			// Stop those darn tweens!
			CustomerTween_.cancel();
			
			removeAll();
			add(GameOverEntity);
		}
		
		public function addCustomer():void 
		{
			Customer_ = new Customer();
			Customer_.setHitbox(64, 128);
			Customer_.type = "customer";
			Customer_.x = 330;
			Customer_.y = 74;
			Customer_.slideCustomer();
			add(Customer_);
			
			CustomerTween_.start();
		}
		
		public function fadeDone():void
		{
			FadeTween_.cancel();
			remove(Customer_);
			remove(CurrentMug_);
		}
		
		override public function update():void 
		{
			updateCollision();
			super.update();
		}
		
		public function updateCollision():void
		{
			var Mug:BeerMug;
			var Mugs:Vector.<BeerMug> = new Vector.<BeerMug>();
			var CollidedCustomer:Customer;
			
			// Check for clicks
			if (Input.mouseReleased) {
				if (collidePoint("red_tap", mouseX, mouseY)) {
					CurrentMug_ = new BeerMug();
					CurrentMug_.x = 70;
					CurrentMug_.y = 108;
					CurrentMug_.fillBeer("ipa");
					add(CurrentMug_);
				}
				
				if (collidePoint("black_tap", mouseX, mouseY)) {
					CurrentMug_ = new BeerMug();
					CurrentMug_.x = 102;
					CurrentMug_.y = 108;
					CurrentMug_.fillBeer("stout");
					add(CurrentMug_);
				}
				
				if (collidePoint("yellow_tap", mouseX, mouseY)) {
					CurrentMug_ = new BeerMug();
					CurrentMug_.x = 134;
					CurrentMug_.y = 108;
					CurrentMug_.fillBeer("pils");
					add(CurrentMug_);
				}
				
				if (FadeTween_.active) {
					Customer_.setAlpha(FadeTween_.alpha);
				}
				
				Mug = collidePoint("mug", mouseX, mouseY) as BeerMug;
				if (Mug != null && Mug.canSend()) {
					Mug.sendDownBar();
					//CurrentMug_ = Mug;
					//if (Customer_.giveBeer(Mug) == true) {
						//CurrentScore_ += 1;
					//} else {
						//CurrentScore_ -= 1 ;
					//}
					//FadeTween_.tween(0.5, 0xffffffff, 0xfffffff, 1.0, 0.0, Ease.backOut);
					//FadeTween_.start();
					
					
				}			
			}

			// Check this collision; could happen without mouse clicks
			getType("mug", Mugs);
			for each (Mug in Mugs) {
				CollidedCustomer = Mug.collide("customer", Mug.x, Mug.y) as Customer;
				if (CollidedCustomer != null) {
					if (CollidedCustomer.giveBeer(Mug)) {
						CurrentScore_ += 1;
					} else {
						CurrentScore_ -= 1;
					}
					remove(CollidedCustomer);
					remove(Mug);
					trace("Score: " + CurrentScore_);
				}
				
				// Mug hit bar
				if (Mug.collide("bar", Mug.x, Mug.y)) {
					Mug.y = Mug.PerviousY;
				}
				
				// Mug hit the floor
				if (Mug.collide("floor", Mug.x, Mug.y)) { 
					CurrentScore_ -= 1;
					remove(Mug);
					trace("Score: " + CurrentScore_);
				}
			}
			
			// Update score text
			ScoreText_.text = "Score: " + CurrentScore_ + ", Target: " + TargetScore_ + ", Time: " + Math.floor(1.0 / TimeoutTween.percent);
		}
	}

}
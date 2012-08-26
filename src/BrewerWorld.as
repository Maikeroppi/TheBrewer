package  
{
	import Customer;
	import flash.utils.getTimer;
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class BrewerWorld extends World 
	{
		[Embed(source="../TastingRoomBackground.png")]
		public static const TastingRoomBackground:Class;
		
		[Embed(source = "../HomebrewBackground.png")]
		public static const HomebrewBackground:Class;
		
		[Embed(source="../Blackscreen.png")]
		public static const TransitionScreen:Class;
		public var TransitionEntity:Entity;
		
		[Embed(source = "../RedTap.png")]
		public static const RedTapImage:Class;
		
		[Embed(source = "../BlackTap.png")]
		public static const BlackTapImage:Class;
		
		[Embed(source = "../YellowTap.png")]
		public static const YellowTapImage:Class;
		
		[Embed(source = "../Server.png")]
		public static const ServerImage:Class;
		
		// Sound effects
		[Embed(source = "../BrokeGlass.mp3")]
		private static const BrokeGlassSoundEmbed_:Class;
		public static const BrokeGlassSound:Sfx = new Sfx(BrokeGlassSoundEmbed_);
		
		[Embed(source = "../FillBeer.mp3")]
		private static const FillBeerSoundEmbed_:Class;
		public static const FillBeerSound:Sfx = new Sfx(FillBeerSoundEmbed_);
		
		[Embed(source = "../GotBeer.mp3")]
		private static const GotBeerSoundEmbed_:Class;
		public static const GotBeerSound:Sfx = new Sfx(GotBeerSoundEmbed_);
				
		[Embed(source = "../Slide.mp3")]
		private static const SlideSoundEmbed_:Class;
		public static const SlideSound:Sfx = new Sfx(SlideSoundEmbed_);
		
		public var CurrentTime:Number;
		private var TimeoutTween:Tween;
		
		private var BackgroundEntity_:Entity;
		private var BlackTap_:Entity;
		private var RedTap_:Entity;
		private var YellowTap_:Entity;
		
		private var CurrentMug_:BeerMug;
		private var CurrentLevel_:String;
		
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
		
		private var StartTime_:int;
		private var NumBeers_:int;
		
		private var TransitionText_:Text;
		private var TransitionTextEntity_:Entity;
		private var TransitionTween_:Tween;
		
		private var Timeout_:int;
			
		public function BrewerWorld() 
		{
			// Lower the volume for sound effects
			FP.volume = 0.5;
			
			BackgroundEntity_ = new Entity(0, 0, new Image(TastingRoomBackground));
			add(BackgroundEntity_);
			
			TransitionEntity = new Entity(0, 0, new Image(TransitionScreen));
			
			// Initialize all the stuff, but don't add; this is done in changeLevel
			RedTap_ = new Entity(70, 80, new Image(RedTapImage));
			RedTap_.type = "red_tap";
			RedTap_.setHitbox(32, 32);
						
			BlackTap_ = new Entity(102, 80, new Image(BlackTapImage));
			BlackTap_.type = "black_tap";
			BlackTap_.setHitbox(32, 32);
								
			YellowTap_ = new Entity(134, 80, new Image(YellowTapImage));
			YellowTap_.type = "yellow_tap";
			YellowTap_.setHitbox(32, 32);
						
			CurrentMug_ = new BeerMug();
			CustomerTween_ = new Tween(4, Tween.PERSIST, addCustomer);
			FadeTween_ = new ColorTween(fadeDone);
										
			TheBar_ = new Entity(0, 141);
			TheBar_.setHitbox(231, 56);
			TheBar_.type = "bar";
						
			TheFloor_ = new Entity(0, 197);
			TheFloor_.setHitbox(320, 240 - 197);
			TheFloor_.type = "floor";
						
			ScoreText_ = new Text("Score: 0", 0, 0);
			ScoreText_.color = 0xffffffff;
			
			ScoreEntity_ = new Entity(0, 220, ScoreText_);
			ServerEntity_ = new Entity(0, 47, new Image(ServerImage));
			
			TransitionText_ = new Text("", 0, 0);
			TransitionText_.color = 0xffffffff;
			TransitionText_.size = 20;
			TransitionTextEntity_ = new Entity(0, 0, TransitionText_);
			
			TransitionTween_ = new Tween(2, Tween.PERSIST, transition);
			addTween(TransitionTween_);
			
			NumBeers_ = 0;
			
			
			// seed random generator
			FP.randomizeSeed();
			changeLevel("Homebrew");
			
			// Add them tweens
			//addTween(CustomerTween_);
			addTween(FadeTween_);
			//addTween(TimeoutTween);
						
		}
		
		public function changeLevel(LevelName:String):void
		{
			add(BackgroundEntity_);
			CurrentLevel_ = LevelName;
			if (LevelName == "Homebrew") {
				add(RedTap_);
				add(BlackTap_);
				NumBeers_ = 2;
				CustomerTween_ = new Tween(3, Tween.PERSIST, addCustomer);
				TargetScore_ = 10;
				Timeout_ = 40;
				BackgroundEntity_.graphic = new Image(HomebrewBackground);
			} else if (LevelName == "TastingRoom") {
				add(RedTap_);
				add(BlackTap_);
				add(YellowTap_);
				NumBeers_ = 3;
				TargetScore_ = 15;
				Timeout_ = 40;
				CustomerTween_ = new Tween(2, Tween.PERSIST, addCustomer);
				BackgroundEntity_.graphic = new Image(TastingRoomBackground);
			}
			
			//TimeoutTween = new Tween(Timeout_, Tween.PERSIST, timeoutHappened);
			StartTime_ = getTimer();
						
			// This stuff is in every level
			addTween(CustomerTween_, true);
						
			add(TheFloor_);
			add(ScoreEntity_);
			add(ServerEntity_);
			add(TheBar_);
			
			// Initialize scores	
			CurrentScore_ = 0;
		}
		
		override public function begin():void
		{
			//TimeoutTween.start();
			//CustomerTween_.start();
			//
			//StartTime_ = flash.utils.getTimer();
			super.begin();
		}
		
		public function timeoutHappened():void
		{
			// Stop those darn tweens!
			CustomerTween_.cancel();
			
			removeAll();
			if(CurrentScore_ < TargetScore_) {
				setTransitionTextCentered("Game is Over");
			} else {
				if (CurrentLevel_ == "TastingRoom") {
					setTransitionTextCentered("You are a master brewer!");
				} else {
					setTransitionTextCentered("Success! Next level...");
					TransitionTween_.start();
				}
			}		
			
			add(TransitionEntity);
			add(TransitionTextEntity_);						
		}
		
		public function setTransitionTextCentered(TheText:String):void
		{
			TransitionText_.text = TheText;
			TransitionText_.x = (FP.screen.width / 2) - (TransitionText_.width / 2);
			TransitionText_.y = (FP.screen.height / 2) - (TransitionText_.height / 2);
		}
		
		public function transition():void
		{
			removeAll();
			if (CurrentLevel_ == "Homebrew") {
				changeLevel("TastingRoom");
			} else if (CurrentLevel_ == "TastingRoom") {
			}
			
		}
		
		public function addCustomer():void 
		{
			Customer_ = new Customer();
			Customer_.setHitbox(64, 128);
			Customer_.type = "customer";
			Customer_.x = 330;
			Customer_.y = 74;
			Customer_.slideCustomer();
			
			var RandNum:int = FP.rand(NumBeers_); //Math.floor(Math.random() * 3);
			switch(RandNum) {
				case 0:
					Customer_.SetBeerType("ipa");
					break;
				case 1:
					Customer_.SetBeerType("stout");
					break;
					
				case 2:
					Customer_.SetBeerType("pils");
					break;
			}
						
			add(Customer_);
			
			CustomerTween_.start();
		}
		
		public function fadeDone():void
		{
			FadeTween_.cancel();
			remove(Customer_);
			
			// Reactivate tap when we remove mug
			//switch(CurrentMug_.BeerType) {
			//case "ipa": RedTap_.collidable = true;  break;
			//case "stout": BlackTap_.collidable = true;  break;
			//case "pils": YellowTap_.collidable = true; break;
			//default:
			//}
			remove(CurrentMug_);
		}
		
		override public function update():void 
		{
			if (Input.released(Key.M)) {
				FP.volume = 0.0;
			}
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
					
					//RedTap_.collidable = false;
				}
				
				if (collidePoint("black_tap", mouseX, mouseY)) {
					CurrentMug_ = new BeerMug();
					CurrentMug_.x = 102;
					CurrentMug_.y = 108;
					CurrentMug_.fillBeer("stout");
					add(CurrentMug_);
					
					//BlackTap_.collidable = false;
				}
				
				if (collidePoint("yellow_tap", mouseX, mouseY)) {
					CurrentMug_ = new BeerMug();
					CurrentMug_.x = 134;
					CurrentMug_.y = 108;
					CurrentMug_.fillBeer("pils");
					add(CurrentMug_);
					
					//YellowTap_.collidable = false;
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
					BrewerWorld.BrokeGlassSound.play();
					trace("Score: " + CurrentScore_);
				}
			}
			
			// Update score text
			var Countdown:Number = Timeout_ - ((getTimer() - StartTime_ ) / 1000);
			ScoreText_.text = "Score: " + CurrentScore_ + ", Target: " + TargetScore_ 
			+ ", Time: " + 
			Math.floor(
				Countdown
				);
				
			if(!TransitionTween_.active) {
				if (Countdown < 0) timeoutHappened();
			}
		}
	}

}
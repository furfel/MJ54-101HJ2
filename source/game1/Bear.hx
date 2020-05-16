package game1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearMotion;
import flixel.util.FlxColor;

class Bear extends FlxSprite
{
	public static final RANDOMOFFSET = 280.0;
	public static final RANDOM_YOFFSET = 40.0;
	public static final STAMPEDE_SPEED = 200.0;
	public static final STAMPEDE_EXTRASPEED = 40.0;
	public static final BOUNCINESS = 20.0;

	private var stampede:BearStampede;

	public function new(X:Float, Y:Float, stampede:BearStampede)
	{
		super(X, Y);
		this.stampede = stampede;
		makeGraphic(192, 72, FlxG.random.float() < 0.5 ? FlxColor.CYAN : FlxG.random.float() > 0.5 ? FlxColor.RED : FlxColor.LIME);
		reset(X, Y);
		kill();
	}

	override function reset(X:Float, Y:Float)
	{
		if (updownTween != null)
			updownTween.cancelChain();

		super.reset(X + FlxG.random.float(-RANDOMOFFSET, RANDOMOFFSET), Y + FlxG.random.float(-RANDOM_YOFFSET, RANDOM_YOFFSET));
		this.velocity.set(STAMPEDE_SPEED + FlxG.random.float(0, STAMPEDE_EXTRASPEED), 0);
		tweenUp(null);
	}

	private function tweenUp(_:FlxTween)
	{
		if (FlxG.random.float() < 0.25)
			stampede.randomDust(this.x - 32, this.y + this.height - 32);
		else if (FlxG.random.float() > 0.75)
			stampede.randomDust(this.x + this.width - 32, this.y + this.height - 32);

		updownTween = FlxTween.tween(this, {y: this.y - BOUNCINESS}, 0.2, {
			type: ONESHOT,
			ease: FlxEase.elasticIn,
			onComplete: tweenDown
		});
	}

	private function tweenDown(_:FlxTween)
	{
		updownTween = FlxTween.tween(this, {y: this.y + BOUNCINESS}, 0.2, {
			type: ONESHOT,
			ease: FlxEase.elasticIn,
			onComplete: tweenUp
		});
	}

	private var updownTween:FlxTween = null;

	override function kill()
	{
		super.kill();
		if (updownTween != null)
			updownTween.cancelChain();
		updownTween = null;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.x > FlxG.width)
			kill();
	}
}

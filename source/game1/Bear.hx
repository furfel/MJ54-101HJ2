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
	public static final STAMPEDE_SPEED = 240.0;
	public static final STAMPEDE_EXTRASPEED = 60.0;
	public static final BOUNCINESS = 20.0;

	public static final DUST_MARGIN = 72.0;

	private var stampede:BearStampede;

	public function new(X:Float, Y:Float, stampede:BearStampede)
	{
		super(X, Y);
		this.stampede = stampede;
		loadGraphic("assets/images/first/bear.png", true, 320, 200);

		animation.add("a1", [1, 5, 2, 6], 13);
		animation.add("a2", [3, 5, 2, 0], 13);
		animation.add("a3", [2, 6, 1, 0], 13);

		reset(X, Y);
		kill();
	}

	private var startX = 0.0;
	private var endX = 0.0;

	override function reset(X:Float, Y:Float)
	{
		if (updownTween != null)
			updownTween.cancelChain();

		super.reset(X + FlxG.random.float(-RANDOMOFFSET, RANDOMOFFSET), Y + FlxG.random.float(-RANDOM_YOFFSET, RANDOM_YOFFSET));
		startX = this.x;
		endX = this.x + FlxG.width + this.width * 2;
		this.velocity.set(STAMPEDE_SPEED + FlxG.random.float(0, STAMPEDE_EXTRASPEED), 0);
		animation.play("a" + FlxG.random.int(1, 3));
		tweenUp(null);
	}

	private function tweenUp(_:FlxTween)
	{
		if (FlxG.random.float() < 0.25)
			stampede.randomDust(this.x + DUST_MARGIN, this.y + this.height - DUST_MARGIN);
		else if (FlxG.random.float() > 0.75)
			stampede.randomDust(this.x + this.width - DUST_MARGIN, this.y + this.height - DUST_MARGIN);

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

		if (this.x > endX)
			kill();
	}
}

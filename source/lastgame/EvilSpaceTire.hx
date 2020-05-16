package lastgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class EvilSpaceTire extends FlxSprite
{
	public static final WIDTH = 323;
	public static final HEIGHT = 480;
	public static final TARGET_X = 1000;

	private var parent:LastState = null;

	private var TARGET_Y = 100.0;

	public function new(parent:LastState)
	{
		super(FlxG.width + 500, 100);

		loadGraphic("assets/images/last/tire.png", true, WIDTH, HEIGHT);

		animation.add("wobble", [0, 1, 2], 13);
		animation.play("wobble");

		screenCenter(Y);
		TARGET_Y = this.y;

		this.parent = parent;
	}

	private var initialized = false;

	public function bringToGame()
	{
		FlxTween.linearMotion(this, this.x, this.y, TARGET_X, this.y, 3.0, true, {
			ease: FlxEase.cubeIn,
			onComplete: (tw) ->
			{
				initialized = true;
				parent.showTire();
				health = 100;
				startMoving();
			}
		});
	}

	private function startMoving()
	{
		new FlxTimer().start(0.75, _ ->
		{
			tweenUp();
		});
	}

	private function tweenUp()
	{
		FlxTween.linearMotion(this, this.x, this.y, this.x, -this.height / 2, 1.4, true, {
			ease: FlxEase.cubeInOut,
			onComplete: _ ->
			{
				if (this.alive)
					tweenLeft();
			},
			type: ONESHOT
		});
	}

	private function tweenDown()
	{
		FlxTween.linearMotion(this, this.x, this.y, this.x, FlxG.height - this.height / 2, 1.4, true, {
			ease: FlxEase.sineInOut,
			onComplete: _ ->
			{
				if (this.alive)
					tweenRight();
			},
			type: ONESHOT
		});
	}

	private function tweenLeft()
	{
		FlxTween.linearMotion(this, this.x, this.y, -this.width / 2, this.y, 2.3, true, {
			ease: FlxEase.circInOut,
			onComplete: _ ->
			{
				if (this.alive)
					tweenDown();
			},
			type: ONESHOT
		});
	}

	private function tweenRight()
	{
		FlxTween.linearMotion(this, this.x, this.y, TARGET_X, this.y, 2.3, true, {
			ease: FlxEase.elasticOut,
			onComplete: _ ->
			{
				if (this.alive)
					tweenUp();
			},
			type: ONESHOT
		});
	}

	private function tweenAlpha()
	{
		FlxTween.tween(this, {}, 1.2, {
			onUpdate: tc ->
			{
				alpha = 0.6 + FlxMath.fastSin(Math.PI * 40.0 * tc.percent) * 0.2;
			},
			onComplete: _ ->
			{
				alpha = 1.0;
			}
		});
	}

	private var cooldown:Float = 0.0;

	public function getShot()
	{
		if (!initialized || cooldown > 0)
			return;

		health -= 10;
		cooldown = 1.2;
		tweenAlpha();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (cooldown > 0.0)
			cooldown -= elapsed;

		if (health <= 0)
		{
			kill();
		}
	}
}

package game1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class EvilIceCreamStand extends FlxSprite
{
	private var parent:Game1State;

	public static final LEFT_BOUND_MAX = 3.0;
	public static final RIGHT_BOUND_MAX = 6.5;
	public static final LEFT_BOUND_MIN = 1.1;
	public static final RIGHT_BOUND_MIN = 2.2;

	private var mintime = LEFT_BOUND_MAX;
	private var maxtime = RIGHT_BOUND_MAX;

	public function new(X:Float, Y:Float, parent:Game1State)
	{
		super(X, Y);
		loadGraphic("assets/images/first/stand.png", true, 384, 419);
		animation.add("a", [0, 1, 2], 13);
		animation.play("a");
		this.parent = parent;
		this.health = 100.0;
	}

	public function throwCone()
	{
		var cone = parent.getCone();
		if (cone != null && cooldown <= 0.0)
			cone.reset(this.x + this.width / 2 - cone.width / 2, this.y);

		if (mintime > LEFT_BOUND_MIN)
			mintime -= FlxG.random.float(0.1, 0.3);

		if (maxtime > RIGHT_BOUND_MIN)
			maxtime -= FlxG.random.float(0.1, 0.3);

		if (mintime > maxtime)
		{
			var min = maxtime;
			maxtime = mintime;
			mintime = min;
		}
		new FlxTimer().start(FlxG.random.float(mintime, maxtime), _ -> if (alive) throwCone());
	}

	private function tweenAlpha()
	{
		FlxTween.tween(this, {}, 2.5, {
			onUpdate: tc ->
			{
				alpha = 0.6 + FlxMath.fastSin(Math.PI * 20.0 * tc.percent) * 0.2;
			},
			onComplete: _ ->
			{
				alpha = 1.0;
			}
		});
	}

	private var cooldown = 2.5;

	public function getHit()
	{
		if (cooldown > 0.0)
			return;
		else
		{
			this.health -= 19.0;
			cooldown = 3.5;
			tweenAlpha();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (cooldown > 0)
			cooldown -= elapsed;
	}
}

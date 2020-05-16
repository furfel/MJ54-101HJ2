package lastgame;

import flixel.FlxG;
import flixel.FlxSprite;

class Star extends FlxSprite
{
	public static final FRAMERATE = 13;
	public static final MIN_SCALE = 0.5;
	public static final MAX_SCALE = 0.9;
	public static final MIN_ALPHA = 0.5;
	public static final MAX_ALPHA = 0.8;
	public static final MIN_SPEED = 300.0;
	public static final MAX_SPEED = 500.0;

	public function new()
	{
		super(FlxG.random.int(128, Std.int(5 * FlxG.width / 4)), FlxG.random.int(0, FlxG.height - 96));

		loadGraphic("assets/images/last/stars.png", true, 96, 96);

		animation.add("star1", [0, 1, 2], FRAMERATE);
		animation.add("star2", [2, 3, 4], FRAMERATE);
		animation.add("star3", [0, 3, 2], FRAMERATE);
		animation.add("star4", [4, 2, 1], FRAMERATE);
		animation.add("star5", [2, 4, 0], FRAMERATE);
		animation.add("star6", [3, 1, 2], FRAMERATE);
		animation.add("star7", [1, 3, 2], FRAMERATE);

		randomize();
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(FlxG.random.int(FlxG.width, Std.int(3 * FlxG.width / 2)), FlxG.random.int(0, FlxG.height - 96));
		this.last.set(x, y);
		alive = true;
		exists = true;
		randomize();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (this.x < -this.width)
			reset(0, 0);
	}

	private function randomize()
	{
		var _scale = FlxG.random.float(MIN_SCALE, MAX_SCALE);
		scale.set(_scale, _scale);
		animation.play("star" + FlxG.random.int(1, 7));
		alpha = FlxG.random.float(MIN_ALPHA, MAX_ALPHA);
		this.velocity.set(-FlxG.random.float(MIN_SPEED, MAX_SPEED), 0);
	}
}

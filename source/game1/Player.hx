package game1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearMotion;
import flixel.util.FlxColor;
import haxe.display.Display.Package;

class Player extends FlxSprite
{
	private var parent:Game1State = null;

	public static final GRAVITY = 60.0;

	public static final SPEED = 1700.0;

	public function new(parent:Game1State)
	{
		super(72, FlxG.height - 230.0);
		loadGraphic("assets/images/first/player.png", true, 108, 144);
		animation.add("stand", [
			0, 2, 4, 0, 2, 4, 0, 2, 4, 0, 2, 4, 5, 1, 3, 1, 5, 0, 2, 4, 0, 2, 4, 0, 2, 4, 0, 2, 4, 0, 2, 4
		], 13);
		animation.add("walk", [6, 7, 8, 9], 13);
		this.parent = parent;
		maxVelocity.set(90, 340);
	}

	/**
		Jumping stuff

	**/
	private var jumpTween:LinearMotion = null;

	public static final JUMP_TIME_MAX = 0.5;

	private var jumpTime = -1.0;

	private function jump(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed([W]))
		{
			if (velocity.y == 0)
			{
				jumpTime = 0.0;
			}
		}

		if (FlxG.keys.anyPressed([W]) && jumpTime >= 0.0)
		{
			jumpTime += elapsed;
			if (jumpTime > JUMP_TIME_MAX)
			{
				jumpTime = -1.0;
			}
			else if (jumpTime > 0)
			{
				velocity.y = -0.6 * maxVelocity.y;
			}
		}
	}

	/**

		Combat stuff

	**/
	public static final LOITER_X = 60;

	public static final LOITER_Y = 60;

	private var loiterAmnt = 1;

	private function loiter()
	{
		if (loiterAmnt > 0)
		{
			parent.doLoiter(this.x + LOITER_X, this.y + LOITER_Y);
			loiterAmnt--;
		}
	}

	public function addLoiter()
	{
		loiterAmnt++;
	}

	public function hasLoiter():Bool
		return loiterAmnt > 0;

	private function move() {}

	private function checkKeys()
	{
		if (FlxG.keys.anyJustPressed([SPACE])
			|| (FlxG.gamepads.numActiveGamepads > 0 && FlxG.gamepads.lastActive.anyJustPressed([A, B, X, Y])))
			loiter();

		velocity.x = 0;

		var left = FlxG.keys.anyPressed([LEFT, A])
			|| (FlxG.gamepads.numActiveGamepads > 0 && FlxG.gamepads.firstActive.analog.value.LEFT_STICK_X < -0.1);
		var right = FlxG.keys.anyPressed([RIGHT, D])
			|| (FlxG.gamepads.numActiveGamepads > 0 && FlxG.gamepads.firstActive.analog.value.LEFT_STICK_X > 0.1);

		if (!(left && right))
		{
			if (left)
			{
				velocity.x = -SPEED;
				flipX = true;
			}

			if (right)
			{
				velocity.x = SPEED;
				flipX = false;
			}

			if (velocity.x == 0)
				animation.play("stand");
			else
				animation.play("walk");
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		checkKeys();

		if (x < -this.width / 2)
		{
			x = -this.width / 2;
		}

		if (x > 0.9 * FlxG.width - this.width)
			x = 0.9 * FlxG.width - this.width;
	}

	override function kill()
	{
		alive = false;
		exists = true;
		angularVelocity = 920;
		FlxTween.tween(this, {alpha: 0}, 1.0, {
			ease: FlxEase.cubeOut,
			type: ONESHOT,
			onComplete: _ ->
			{
				parent.gameover();
			}
		});
	}
}

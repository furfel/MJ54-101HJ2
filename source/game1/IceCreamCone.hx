package game1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class IceCreamCone extends FlxSprite
{
	private var isBackcone:Bool = false;
	private var parent:Game1State;

	public static var Acell = 200.0;
	public static var Vel = 200.0;

	public static final MAX_ACCEL = 500.0;
	public static final MAX_VEL = 300.0;

	private var rects = new Array<FlxRect>();

	public function new(X:Float, Y:Float, parent:Game1State, isBackcone = false)
	{
		super(X, Y);
		loadGraphic("assets/images/first/cone.png", true, 156, 256);
		animation.add("a", [0, 1, 2], 13);
		animation.play("a");

		alive = false;
		exists = false;
		this.isBackcone = isBackcone;
		this.parent = parent;

		if (!isBackcone)
		{
			rects.push(new FlxRect(this.x, this.y, this.width, this.height / 3));
			rects.push(new FlxRect(this.x + this.width / 8, this.y + this.height / 3, 3 * this.width / 4, this.height / 3));
			rects.push(new FlxRect(this.x + this.width / 4, this.y + 2 * this.height / 3, this.width / 2, this.height / 3));
		}
		else
		{
			color = FlxColor.fromRGB(160, 160, 160);
		}
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(X, Y);
		flipY = true;
		exists = true;
		alive = true;
		if (this.isBackcone)
		{
			acceleration.y = 0;
			FlxTween.linearMotion(this, this.x, this.y, this.x, -this.height * 1.5, 0.5, true, {
				ease: FlxEase.cubeOut,
				type: ONESHOT,
				onComplete: fallDown
			});
		}
		else
		{
			flipY = false;
			this.x = FlxG.random.float(0, FlxG.width - this.width);
			this.y = FlxG.random.float(-this.height * 1.5, -this.height);
			velocity.y = IceCreamCone.Vel;
			acceleration.y = IceCreamCone.Acell;
			if (IceCreamCone.Vel < MAX_VEL)
				IceCreamCone.Vel += 10.0;
			if (IceCreamCone.Acell < MAX_ACCEL)
				IceCreamCone.Acell += 10.0;
		}

		animation.play("a");
	}

	private function fallDown(_:FlxTween)
	{
		if (this.isBackcone)
		{
			kill();
			if (FlxG.random.float() < 0.09)
			{
				var i = parent.getIcePop();
				if (i != null)
					i.reset(0, 0);
			}
			else
			{
				var c = parent.getDownCone();
				if (c != null)
					c.reset(0, 0);
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.y > FlxG.height)
			kill();

		if (!isBackcone && alive)
		{
			rects[0].setPosition(this.x, this.y);
			rects[1].setPosition(this.x + this.width / 8, this.y + this.height / 3);
			rects[2].setPosition(this.x + this.width / 4, this.y + 2 * this.height / 3);
		}
	}

	public function collide(r:FlxRect):Bool
	{
		for (r2 in rects)
			if (r.overlaps(r2))
				return true;
		return false;
	}
}

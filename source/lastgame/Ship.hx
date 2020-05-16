package lastgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.util.FlxCollision;

class Ship extends FlxSprite
{
	public static final SHIP_HEIGHT = 467;
	public static final SHIP_WIDTH = 512;

	public static final TALL_RECT_X = 180.0;
	public static final LONG_RECT_Y = 184.0;

	public static final MOTION_SPEED = 600.0;

	public static final BULLET_X = 430;
	public static final BULLET_Y = 300;

	private var collision1:FlxRect = new FlxRect(TALL_RECT_X, 0, 132, SHIP_HEIGHT);
	private var collision2:FlxRect = new FlxRect(0, LONG_RECT_Y, SHIP_WIDTH, 146);

	private var parent:LastState;

	public function new(parent:LastState)
	{
		super(32, FlxG.height / 2);

		loadGraphic("assets/images/last/ship.png", true, SHIP_WIDTH, SHIP_HEIGHT);

		screenCenter(Y);
		animation.add("fly", [0, 1, 2], 13);
		animation.play("fly");

		this.parent = parent;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.x < -this.width / 2)
			this.x = -this.width / 2;
		else if (this.x > FlxG.width / 2)
			this.x = FlxG.width / 2;

		if (this.y < -height / 2)
			this.y = -height / 2;
		else if (this.y > FlxG.height - this.height / 2)
			this.y = FlxG.height - this.height / 2;

		collision1.setPosition(x + TALL_RECT_X, y);
		collision2.setPosition(x, y + LONG_RECT_Y);

		checkKeys();
		checkShoot();
	}

	private function checkShoot()
	{
		if (FlxG.keys.anyJustPressed([SPACE, L]) || FlxG.gamepads.anyJustPressed(B))
			if (parent != null)
				parent.shootLazer(this.x + BULLET_X, this.y + BULLET_Y);
	}

	private function checkKeys()
	{
		var up = FlxG.keys.anyPressed([W, UP]) || FlxG.gamepads.lastActive.analog.value.LEFT_STICK_Y < -0.1;
		var down = FlxG.keys.anyPressed([S, DOWN]) || FlxG.gamepads.lastActive.analog.value.LEFT_STICK_Y > 0.1;
		var left = FlxG.keys.anyPressed([A, LEFT]) || FlxG.gamepads.lastActive.analog.value.LEFT_STICK_X < -0.1;
		var right = FlxG.keys.anyPressed([D, RIGHT]) || FlxG.gamepads.lastActive.analog.value.LEFT_STICK_X > 0.1;

		var _x = 0.0, _y = 0.0;

		if (up && down)
			_y = 0;
		else if (up)
			_y = -MOTION_SPEED;
		else if (down)
			_y = MOTION_SPEED;

		if (left && right)
			_x = 0;
		else if (left)
			_x = -MOTION_SPEED;
		else if (right)
			_x = MOTION_SPEED;

		velocity.set(_x, _y);
	}

	public function overlapTire(tire:EvilSpaceTire):Bool
	{
		return collision1.overlaps(tire.getHitbox()) || collision2.overlaps(tire.getHitbox());
	}
}

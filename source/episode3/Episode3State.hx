package episode3;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import outro.OutroState;

class Episode3State extends FlxState
{
	private var dog:Dog;
	private var char:Char;
	private var target:Target;
	private var aim:Aim;
	private var trash:Trash;
	private var sign:FlxSprite;

	private var background1:FlxSprite;
	private var background2:FlxSprite;

	override function create()
	{
		super.create();

		bgColor = FlxColor.WHITE;

		add(background1 = new FlxSprite(0, FlxG.height / 4).loadGraphic("assets/images/ep3/bg.png", true, 1280, 68));
		background1.animation.add("a", [0, 1, 2], 13);
		background1.animation.play("a");
		add(background2 = new FlxSprite(FlxG.width / 2 - 200, FlxG.height / 4 + 64).loadGraphic("assets/images/ep3/border.png", true, 300, 512));
		background2.animation.add("a", [0, 1, 2], 13);
		background2.animation.play("a");

		create_sign();

		add(target = new Target(FlxG.width / 2 + 190, FlxG.height / 4 + 130));
		add(char = new Char(150, FlxG.height / 4 + 130));
		add(dog = new Dog(250, FlxG.height / 4 + 140, this));

		add(aim = new Aim(char.x + 23, char.y + 30));
		add(trash = new Trash(aim.x - 16, aim.y - 10, this));

		FlxG.camera.fade(FlxColor.WHITE, 0.4, true);
	}

	private function create_sign()
	{
		sign = new FlxSprite(FlxG.width / 2 + 200, FlxG.height / 2 + 100).loadGraphic("assets/images/ep3/nodogs.png", true, 300, Std.int(498 / 3));
		sign.animation.add("a", [0, 1, 2], 13);
		sign.animation.play("a");
		add(sign);
	}

	private var backwards = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (aim.isMoving()
			&& (FlxG.keys.anyJustPressed([SPACE])
				|| (FlxG.gamepads.numActiveGamepads > 0 && FlxG.gamepads.firstActive.anyJustPressed([A, B, X, Y]))))
		{
			aim.stop();
			char.throwtrash();
			dog.fetch(target.x - 50, target.y + 20);
			trash.throwme(aim);
		}
	}

	public function checkTarget()
	{
		if (trash.getHitbox().overlaps(target.getHitbox()))
		{
			new FlxTimer().start(0.5, _ ->
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
				{
					FlxG.switchState(new OutroState());
				});
			});
		}
		else
		{
			restart();
		}
	}

	public function restart()
	{
		FlxG.camera.fade(FlxColor.WHITE, 0.3, false, () ->
		{
			FlxG.resetState();
		});
	}
}

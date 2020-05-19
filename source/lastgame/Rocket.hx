package lastgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Rocket extends FlxSprite
{
	public function new()
	{
		super(FlxG.width + 20, FlxG.height / 4);

		loadGraphic("assets/images/last/rocket.png", true, 300, 100);

		animation.add("a", [0, 1, 2], 13);
		animation.play("a");
		replace();
	}

	private function replace()
	{
		new FlxTimer().start(FlxG.random.float(9.0, 18.0), _ ->
		{
			x = FlxG.width + 20;
			y = FlxG.random.float(30.0, FlxG.height - 30.0 - this.height);
			velocity.x = -FlxG.random.float(200.0, 450.0);
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.x < -this.width - 20)
		{
			velocity.x = 0;
			replace();
		}
	}
}

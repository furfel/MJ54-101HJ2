package game1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Episode1State extends FlxState
{
	override function create()
	{
		super.create();

		bgColor = FlxColor.WHITE;

		var episode = new FlxSprite(FlxG.width / 2 - 250 - 108 - 24, FlxG.height / 2 - 98 - 16).loadGraphic("assets/images/episode.png", true, 250, 98);
		episode.animation.add("a", [0, 1, 2], 13);
		episode.animation.play("a");
		var number = new FlxSprite(FlxG.width / 2 + 24, FlxG.height / 2 - 98 - 16).loadGraphic("assets/images/number.png", true, 108, 98);
		number.animation.add("a", [0, 1, 2], 13);
		number.animation.play("a");
		var icecreamstand = new FlxSprite(FlxG.width / 2 - 320, FlxG.height / 2 + 16).loadGraphic("assets/images/first/theicecreamstand.png", true, 640, 98);
		icecreamstand.animation.add("a", [0, 1, 2], 13);
		icecreamstand.animation.play("a");

		add(episode);
		add(number);
		add(icecreamstand);

		FlxG.camera.fade(FlxColor.WHITE, 0.4, true);

		new FlxTimer().start(1.5, _ ->
		{
			FlxG.camera.fade(FlxColor.WHITE, 0.4, false, nextState);
		});
	}

	private function nextState()
	{
		FlxG.switchState(new Game1State());
	}
}

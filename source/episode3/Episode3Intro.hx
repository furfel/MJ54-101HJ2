package episode3;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Episode3Intro extends FlxState
{
	override function create()
	{
		super.create();

		bgColor = FlxColor.WHITE;

		FlxG.camera.fade(FlxColor.BLACK, 0.4, true);

		var episode = new FlxSprite(FlxG.width / 2 - 250 - 108 - 24, FlxG.height / 2 - 98 - 16).loadGraphic("assets/images/episode.png", true, 250, 98);
		episode.animation.add("a", [0, 1, 2], 13);
		episode.animation.play("a");
		var number = new FlxSprite(FlxG.width / 2 + 24, FlxG.height / 2 - 98 - 16).loadGraphic("assets/images/number.png", true, 108, 98);
		number.animation.add("a", [6, 7, 8], 13);
		number.animation.play("a");
		var space = new FlxSprite(FlxG.width / 2 - 160, FlxG.height / 2 + 16).loadGraphic("assets/images/ep3/fetch.png", true, 320, 100);
		space.animation.add("a", [0, 1, 2], 13);
		space.animation.play("a");

		add(episode);
		add(number);
		add(space);

		new FlxTimer().start(1.5, _ ->
		{
			FlxG.camera.fade(FlxColor.WHITE, 0.4, false, nextState);
		});
	}

	private function nextState()
	{
		FlxG.switchState(new Episode3State());
	}
}

package intro;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import game1.Episode1State;
import lastgame.LastState;

class IntroState extends FlxState
{
	var youknowwhat = [
		{
			x: 94,
			y: 183,
			w: 222,
			h: 194,
			word: "you"
		},
		{
			x: 328,
			y: 221,
			w: 256,
			h: 155,
			word: "know"
		},
		{
			x: 592,
			y: 243,
			w: 240,
			h: 111,
			word: "what"
		},
		{
			x: 840,
			y: 221,
			w: 306,
			h: 184,
			word: "brings"
		},
		{
			x: 37,
			y: 388,
			w: 267,
			h: 136,
			word: "back"
		},
		{
			x: 304,
			y: 407,
			w: 402,
			h: 162,
			word: "positive"
		},
		{
			x: 700,
			y: 415,
			w: 430,
			h: 109,
			word: "memories"
		},
		{
			x: 1130,
			y: 399,
			w: 77,
			h: 125,
			word: "question"
		}
	];

	var handdrawn = [
		{
			x: 36,
			y: 75,
			w: 280,
			h: 130,
			word: "hand"
		},
		{
			x: 316,
			y: 70,
			w: 329,
			h: 151,
			word: "drawn"
		},
		{
			x: 634,
			y: 65,
			w: 561,
			h: 156,
			word: "animation"
		},
		{
			x: 1176,
			y: 79,
			w: 80,
			h: 123,
			word: "exclamation"
		}
	];

	var youknowwhat_group = new FlxTypedGroup<FlxSprite>();
	var handdrawn_group = new FlxTypedGroup<FlxSprite>();

	var createTimer:FlxTimer;

	override function create()
	{
		super.create();

		youknowwhat_create();
		handdrawn_create();

		createTimer = new FlxTimer().start(4.0, _ ->
		{
			this.add(youknowwhat_group);
			FlxG.camera.fade(FlxColor.BLACK, 1.4, true, () ->
			{
				handdrawn_stage();
			});
		});
	}

	public static final MARGIN_TOP = 50;

	private function youknowwhat_create()
	{
		for (w in youknowwhat)
		{
			var sp = new FlxSprite(w.x, w.y - MARGIN_TOP).loadGraphic("assets/images/intro/" + w.word + ".png", true, w.w, w.h);
			sp.animation.add("wobble", [0, 1, 2], 13);
			sp.animation.play("wobble");
			youknowwhat_group.add(sp);
		}
	}

	private function handdrawn_create()
	{
		for (w in handdrawn)
		{
			var sp = new FlxSprite(w.x, w.y).loadGraphic("assets/images/intro/" + w.word + ".png", true, w.w, w.h);
			sp.animation.add("wob", [0, 1, 2], 13);
			sp.animation.play("wob");
			handdrawn_group.add(sp);
		}
	}

	private var handdrawnTimer:FlxTimer;

	private function handdrawn_stage()
	{
		handdrawnTimer = new FlxTimer().start(2.8, _ ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false, () ->
			{
				remove(youknowwhat_group);
				add(handdrawn_group);

				FlxG.camera.fade(FlxColor.BLACK, 0.7, true, () ->
				{
					post_stage();
				});
			});
		});
	}

	private var postTimer:FlxTimer;

	private function post_stage()
	{
		postTimer = new FlxTimer().start(3.7, _ ->
		{
			FlxG.camera.fade(FlxColor.WHITE, 0.7, false, () ->
			{
				switchState();
			});
		});
	}

	override function destroy()
	{
		super.destroy();
		if (youknowwhat_group != null)
		{
			remove(youknowwhat_group);
			youknowwhat_group = null;
		}

		if (handdrawn_group != null)
		{
			remove(handdrawn_group);
			handdrawn_group = null;
		}
	}

	private function switchState()
	{
		FlxG.switchState(new Episode1State());
	}

	var skip = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!skip)
			if (FlxG.keys.anyJustPressed([SPACE])
				|| (FlxG.gamepads.numActiveGamepads > 0 && FlxG.gamepads.firstActive.anyJustPressed([A, B, X, Y])))
			{
				skip = true;

				if (handdrawnTimer != null)
					handdrawnTimer.cancel();

				if (postTimer != null)
					postTimer.cancel();

				if (createTimer != null)
					createTimer.cancel();

				FlxG.camera.fade(FlxColor.WHITE, 0.7, false, () ->
				{
					switchState();
				});
			}
	}
}

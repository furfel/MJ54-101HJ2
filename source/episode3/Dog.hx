package episode3;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Dog extends FlxSprite
{
	var parent:Episode3State;

	public function new(X:Float, Y:Float, parent:Episode3State)
	{
		super(X, Y);

		loadGraphic("assets/images/ep3/dog.png", true, 160, 106);

		animation.add("stand", [0, 1, 2], 13);
		animation.add("walk", [3, 4, 5, 6], 7);

		animation.play("stand");

		this.parent = parent;
	}

	public function fetch(X:Float, Y:Float)
	{
		animation.play("walk");
		FlxG.sound.play("assets/sounds/dog.ogg");
		FlxTween.linearMotion(this, this.x, this.y, X, Y, 1.5, true, {
			ease: FlxEase.cubeInOut,
			type: ONESHOT,
			onComplete: _ ->
			{
				animation.play("stand");
				FlxTween.tween(this, {"scale.x": -1.0}, 0.4, {
					ease: FlxEase.cubeInOut,
					type: ONESHOT,
					onComplete: _ ->
					{
						parent.checkTarget();
					}
				});
			}
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

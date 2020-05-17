package game1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxAxes;

class BearStampede extends FlxTypedGroup<FlxSprite>
{
	private var bears = new Array<Bear>();
	private var dusts = new Array<Dust>();

	public function new()
	{
		super();

		for (i in 0...8)
		{
			var b = new Bear(-192.0, FlxG.height / 2, this);
			bears.push(b);
			add(b);
		}

		for (i in 0...18)
		{
			var d = new Dust();
			dusts.push(d);
			add(d);
		}
	}

	public function startStampede(x:Float)
	{
		for (b in bears)
			if (b.alive)
				return;

		var maxBears = FlxG.random.int(3, 7);
		for (b in bears)
		{
			b.reset(-400.0, FlxG.height / 2);
			maxBears--;
			if (maxBears <= 0)
				break;
		}

		FlxG.sound.play("assets/sounds/bears.ogg");
		FlxG.sound.play("assets/sounds/bears1.ogg");

		FlxG.camera.shake(0.07, 6.0, FlxAxes.Y);
	}

	public function randomDust(X:Float, Y:Float)
	{
		var _d:Dust = null;
		for (d in dusts)
			if (!d.alive)
			{
				_d = d;
				break;
			}

		if (_d != null)
			_d.reset(X, Y);
	}

	public function collideWithIceCreamStand(e:EvilIceCreamStand):Bool
	{
		var coll = false;
		FlxG.overlap(this, e, (b, e) ->
		{
			if ((e is EvilIceCreamStand) && (b is Bear))
			{
				cast(e, EvilIceCreamStand).getHit();
			}
		});
		return coll;
	}
}

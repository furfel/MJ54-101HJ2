package lastgame;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class LastState extends FlxState
{
	private var stars:FlxTypedGroup<Star> = new FlxTypedGroup<Star>(30);
	private var playerLazers:FlxTypedGroup<Lazer> = new FlxTypedGroup<Lazer>(20);
	private var player:Ship;
	private var tire:EvilSpaceTire;

	private var tirehealthbar:TireHealthBar;
	private var tirehealthlabel:TireHealthLabel;

	override function create()
	{
		super.create();

		bgColor = FlxColor.BLACK;

		createStars();
		add(new Rocket());
		createLazers();

		add(tire = new EvilSpaceTire(this));
		add(player = new Ship(this));

		add(tirehealthlabel = new TireHealthLabel());
		add(tirehealthbar = new TireHealthBar(tirehealthlabel));

		trace("last State");

		FlxG.camera.fade(FlxColor.BLACK, 1.2, true, () ->
		{
			new FlxTimer().start(1.0, _ ->
			{
				tire.bringToGame();
			});
		});
	}

	private function createLazers()
	{
		for (_ in 0...playerLazers.maxSize)
			playerLazers.add(new Lazer());

		add(playerLazers);
	}

	private function createStars()
	{
		for (_ in 0...29)
			stars.add(new Star());

		add(stars);
	}

	public function shootLazer(X:Float, Y:Float)
	{
		var lz = playerLazers.getFirstAvailable();
		if (lz == null)
			return;
		lz.reset(X, Y);
		FlxG.sound.play("assets/sounds/shoot.ogg");
	}

	override function destroy()
	{
		super.destroy();

		if (tire != null)
		{
			remove(tire);
			tire = null;
		}

		if (player != null)
		{
			remove(player);
			player = null;
		}

		if (tirehealthlabel != null)
		{
			remove(tirehealthlabel);
			tirehealthlabel = null;
		}

		if (tirehealthbar != null)
		{
			remove(tirehealthbar);
			tirehealthbar = null;
		}

		if (stars != null)
		{
			remove(stars);
			stars = null;
		}

		if (playerLazers != null)
		{
			remove(playerLazers);
			playerLazers = null;
		}
	}

	public function showTire()
	{
		tirehealthbar.visible = true;
		tirehealthlabel.visible = true;
	}

	var oversoundPlayed = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.overlap(tire, playerLazers, (t, l) ->
		{
			if ((l is Lazer) && (t is EvilSpaceTire))
			{
				cast(l, Lazer).kill();
				cast(t, EvilSpaceTire).getShot();
			}
		});

		if (tire.alive && player.overlapTire(tire))
		{
			if (!oversoundPlayed)
			{
				FlxG.sound.play("assets/sounds/over.ogg");
				oversoundPlayed = true;
			}
			restart();
		}

		if (!outro && !tire.alive)
			do_outro();

		tirehealthbar.setHealth(tire.health, 100);
	}

	private function restart()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.4, false, () ->
		{
			FlxG.switchState(new LastState());
		});
	}

	private var outro = false;

	private function do_outro()
	{
		outro = true;
		FlxG.camera.fade(FlxColor.BLACK, 0.4, false, () ->
		{
			FlxG.switchState(new episode3.Episode3Intro());
		});
	}
}

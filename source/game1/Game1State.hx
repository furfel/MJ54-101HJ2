package game1;

import flixel.FlxState;

class Game1State extends FlxState
{
	private var loiter:Loiter;
	private var bearStampede:BearStampede;

	override function create()
	{
		super.create();

		add(bearStampede = new BearStampede());
		add(new Player(this));
		add(loiter = new Loiter(this));
	}

	public function doLoiter(x:Float, y:Float)
	{
		if (!loiter.alive)
			loiter.reset(x, y);
	}

	public function stampede()
	{
		bearStampede.startStampede();
	}
}

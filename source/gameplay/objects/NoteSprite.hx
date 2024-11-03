package gameplay.objects;

import backend.Music;
import flixel.FlxSprite;

class NoteSprite extends FlxSprite
{
	public var id:Int = 0;
	public var time:Float = 0;
	public var robot:Bool = false;
	public var distance:Float;

	var strumline:Strumline;

	public override function new(id:Int, time:Float, robot:Bool)
	{
		super(-1000);
		makeGraphic(75, 15, 0xffffffff);
		this.id = id;
		this.time = time;
		this.robot = robot;
		strumline = robot ? PlayState.current.opponentSide : PlayState.current.playerSide;

		if (time < Music.primary.position - (500 / PlayState.current.chart.scrollSpeed))
		{
			destroy();
			strumline.displayNotes.remove(this);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		x = strumline.members[id].x;
		distance = (time - Music.primary.position) * .45 * PlayState.current.chart.scrollSpeed;
		y = strumline.members[id].y - distance;
	}
}
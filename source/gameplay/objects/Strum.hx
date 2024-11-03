package gameplay.objects;

import flixel.FlxG;
import flixel.FlxSprite;

class Strum extends FlxSprite
{
	var strumline:Strumline;

	public function new(?x:Float = 0, strumline:Strumline)
	{
		super(x, FlxG.height - 96.5);
		makeGraphic(75, 25, 0xffffffff);
		updateHitbox();
		this.strumline = strumline;
	}

	public function onPress()
	{
		scale.set(.95, .95);
	}

	public function onRelease()
	{
		scale.set(1, 1);
	}
}
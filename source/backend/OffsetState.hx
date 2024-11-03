package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.text.FlxText;
import ui.TitleScreen;

class OffsetState extends FlxState
{
	var offsetText:FlxText;
	var offsetSquare:FlxShapeCircle;
	var offsetLine:FlxSprite;
	var initY:Float;

	override public function create()
	{
		super.create();
		FlxG.camera.bgColor = 0xffec5a9e;
		add({
			var t = new FlxText(0, 32, 0, "esc to go to menu").setFormat(Assets.font("Daydream"), 32, 0xffeeeeee, CENTER);
			t.screenCenter(X);
			t;
		});
		add(new Music(Assets.song("offset-loop")));
		Music.primary.music.looped = true;
		Music.primary.bpm = 120;
		offsetSquare = new FlxShapeCircle(0, 0, 15, {thickness: 0, color: 0}, 0xffeeeeee);
		offsetSquare.screenCenter(X);
		initY = offsetSquare.y = ((FlxG.height * .75) - offsetSquare.y - 32);
		add(offsetSquare);
		offsetLine = new FlxSprite().makeGraphic(1000, 2);
		offsetLine.screenCenter(X);
		offsetLine.y = offsetSquare.y + offsetSquare.height + offsetLine.height;
		add(offsetLine);
		offsetText = new FlxText(0, 32, 0, '${Music.offset} ms').setFormat(Assets.font("Daydream"), 32, 0xffeeeeee, CENTER);
		offsetText.screenCenter(X);
		offsetText.y = FlxG.height - (FlxG.height - offsetLine.y + offsetLine.height / 2) + (offsetText.height / 2);
		add(offsetText);
		Music.primary.play();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		offsetSquare.y = initY - (Math.abs(Math.sin(((Music.primary.beatDec - 2) * Math.PI) / 4)) * 250);
		if (FlxG.keys.anyJustPressed([LEFT, RIGHT]))
		{
			if (FlxG.keys.justPressed.RIGHT)
				Music.offset += 5.0;
			else
				Music.offset -= 5.0;
			Music.offset = Math.floor(Music.offset);
			offsetText.text = '${Music.offset} ms';
			offsetText.screenCenter(X);
		}
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(TitleScreen.new);
	}

	override public function destroy()
	{
		Music.primary.destroy();
		super.destroy();
	}
}
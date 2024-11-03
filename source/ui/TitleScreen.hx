package ui;

import backend.Assets;
import backend.OffsetState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouse;
import flixel.text.FlxText;

using ui.TitleScreen; // lol

class TitleScreen extends FlxState
{
	public var playTutorialText:FlxText;
	public var playRadioactiveText:FlxText;
	public var hsTutorialText:FlxText;
	public var hsRadioactiveText:FlxText;
	public var offsetText:FlxText;

	public override function create()
	{
		FlxG.mouse.visible = true;
		super.create();
		#if TO_PLAYSTATE
		FlxG.mouse.visible = false;
		FlxG.switchState(() -> new gameplay.PlayState("radioactive"));
		#end
		FlxG.camera.bgColor = 0xffAA336A;
		offsetText = new FlxText(0, 0, 0, "set offset").setFormat(Assets.font("Daydream"), 32, 0xffeeeeee, CENTER);
		offsetText.y = FlxG.height - offsetText.height - 32;
		offsetText.screenCenter(X);
		add(offsetText);
		playRadioactiveText = new FlxText(32, 0, 0, "play radioactive").setFormat(Assets.font("Daydream"), 32, 0xffeeeeee, CENTER);
		playRadioactiveText.y = offsetText.y - playRadioactiveText.height - 32;
		add(playRadioactiveText);
		playTutorialText = new FlxText(32, 0, 0, "play tutorial").setFormat(Assets.font("Daydream"), 32, 0xffeeeeee, CENTER);
		playTutorialText.y = playRadioactiveText.y - playTutorialText.height - 32;
		add(playTutorialText);
		hsRadioactiveText = new FlxText(32, 0, 0,
			'highscore: ${FlxG.save.data.highscoreRadioactive}').setFormat(Assets.font("Daydream"), 16, 0xffeeeeee, CENTER);
		hsRadioactiveText.x = FlxG.width - hsRadioactiveText.width - 32;
		hsRadioactiveText.y = playRadioactiveText.y + (playRadioactiveText.height / 2) - (hsRadioactiveText.height / 2);
		add(hsRadioactiveText);
		hsTutorialText = new FlxText(32, 0, 0, 'highscore: ${FlxG.save.data.highscoreTutorial}').setFormat(Assets.font("Daydream"), 16, 0xffeeeeee, CENTER);
		hsTutorialText.x = FlxG.width - hsTutorialText.width - 32;
		hsTutorialText.y = playTutorialText.y + (playTutorialText.height / 2) - (hsTutorialText.height / 2);
		add(hsTutorialText);
		add({
			var t = new FlxText(0, 32, 0, "monkey\nsee\nmonkey\npress").setFormat(Assets.font("Daydream"), 64, 0xffeeeeee, CENTER);
			t.screenCenter(X);
			t;
		});
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		var over = FlxG.mouse.checkMouseOver(offsetText);
		if (over && FlxG.mouse.justPressed)
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(OffsetState.new);
		}
		if (over && offsetText.color == 0xffeeeeee)
		{
			offsetText.color = 0xffcccccc;
			return;
		}
		else if (!over && offsetText.color == 0xffcccccc)
			offsetText.color = 0xffeeeeee;

		over = FlxG.mouse.checkMouseOver(playRadioactiveText);
		if (over && FlxG.mouse.justPressed)
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(() -> new gameplay.PlayState("radioactive"));
		}
		if (over && playRadioactiveText.color == 0xffeeeeee)
		{
			playRadioactiveText.color = 0xffcccccc;
			return;
		}
		else if (!over && playRadioactiveText.color == 0xffcccccc)
			playRadioactiveText.color = 0xffeeeeee;

		over = FlxG.mouse.checkMouseOver(playTutorialText);
		if (over && FlxG.mouse.justPressed)
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(() -> new gameplay.PlayState("tutorial"));
		}
		if (over && playTutorialText.color == 0xffeeeeee)
		{
			playTutorialText.color = 0xffcccccc;
			return;
		}
		else if (!over && playTutorialText.color == 0xffcccccc)
			playTutorialText.color = 0xffeeeeee;
	}

	static function checkMouseOver(mouse:FlxMouse, sprite:FlxSprite)
	{
		return (mouse.x >= sprite.x && mouse.x <= sprite.x + sprite.width) && (mouse.y >= sprite.y && mouse.y <= sprite.y + sprite.height);
	}
}
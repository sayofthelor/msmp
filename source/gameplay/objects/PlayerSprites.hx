package gameplay.objects;

import backend.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

class PlayerSprites extends FlxSpriteGroup
{
	public var player:FlxSprite;
	public var hands:Array<FlxSprite> = [];
	public var box:FlxSprite;
	public var buttons:Array<FlxSprite> = [];
	public var buttons_pressed:Array<FlxSprite> = [];

	public var robot:Bool;

	public function new(?robot:Bool = false)
	{
		super();
		this.robot = robot;
		player = new FlxSprite().loadGraphic(robot ? Assets.image("opp") : Assets.image("player"));
		player.x = robot ? 16 : FlxG.width - player.width - 16;
		player.y = FlxG.height - player.height - 64;
		player.origin = FlxPoint.get(player.width / 2, player.height);
		add(player);
		box = new FlxSprite().loadGraphic(Assets.image("buttonBox"));
		box.antialiasing = false;
		box.scale *= 2;
		box.updateHitbox();
		box.x = player.x + (player.width / 2) - (box.width / 2);
		box.y = player.y + (player.height) - (box.height * 0.25) - 10;
		add(box);
		hands.push(new FlxSprite().loadGraphic(Assets.image(robot ? "hands_opp" : "hands")));
		hands[0].scale /= 2;
		hands[0].updateHitbox();
		hands[0].x = box.x - 10;
		hands[0].y = (box.y - hands[0].height);
		add(hands[0]);
		hands.push(new FlxSprite().loadGraphic(Assets.image(robot ? "hands_opp" : "hands")));
		hands[1].scale /= 2;
		hands[1].updateHitbox();
		hands[1].x = box.x + box.width - hands[1].width + 10;
		hands[1].y = (box.y - hands[1].height);
		hands[1].flipX = true;
		add(hands[1]);
		buttons.push(new FlxSprite().loadGraphic(Assets.image("button_pressed1")));
		buttons[0].antialiasing = false;
		buttons[0].x = box.x + 10;
		buttons[0].y = box.y - buttons[0].height;
		add(buttons[0]);
		buttons.push(new FlxSprite().loadGraphic(Assets.image("button_pressed1")));
		buttons[1].antialiasing = false;
		buttons[1].x = box.x + box.width - buttons[1].width - 10;
		buttons[1].y = box.y - buttons[1].height;
		add(buttons[1]);
		buttons_pressed.push(new FlxSprite().loadGraphic(Assets.image("button_pressed2")));
		buttons_pressed[0].antialiasing = false;
		buttons_pressed[0].x = box.x + 10;
		buttons_pressed[0].y = box.y - buttons[0].height;
		add(buttons_pressed[0]);
		buttons_pressed.push(new FlxSprite().loadGraphic(Assets.image("button_pressed2")));
		buttons_pressed[1].antialiasing = false;
		buttons_pressed[1].x = box.x + box.width - buttons[1].width - 10;
		buttons_pressed[1].y = box.y - buttons[1].height;
		add(buttons_pressed[1]);
		buttons_pressed[0].visible = buttons_pressed[1].visible = false;
		if (robot)
		{
			player.y += 80;
			player.origin.y -= 80;
			player.clipRect = new FlxRect(0, 0, player.width, player.height - 80);
		}
	}

	var isPressed:Array<Bool> = [false, false];

	public function pressButton(right:Bool)
	{
		var index = right ? 1 : 0;
		buttons[index].visible = false;
		buttons_pressed[index].visible = true;
		hands[index].y = (box.y - hands[index].height) + 15;
		isPressed[index] = true;
	}

	public function releaseButton(right:Bool)
	{
		var index = right ? 1 : 0;
		buttons[index].visible = true;
		buttons_pressed[index].visible = false;
		hands[index].y = (box.y - hands[index].height);
		isPressed[index] = false;
	}

	var realAngle:Float;
	var realScale:FlxPoint = new FlxPoint(1, 1);

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		player.angle = FlxMath.lerp(realAngle, player.angle, 1 - (elapsed * 15));
		player.scale.x = FlxMath.lerp(realScale.x, player.scale.x, 1 - (elapsed * 15));
		player.scale.y = FlxMath.lerp(realScale.y, player.scale.y, 1 - (elapsed * 15));
	}

	public function onStep(step:Int)
	{
		switch (Math.floor((step % 8) / 2))
		{
			case 0:
				realAngle = robot ? 2.5 : -2.5;
				realScale.set(.95, .95);
			case 2:
				realAngle = robot ? -2.5 : 2.5;
				realScale.set(.95, .95);
			default:
				realAngle = 0;
				realScale.set(1, 1);
		}
		if (robot)
		{
			for (i in 0...2)
			{
				if (isPressed[i])
					releaseButton(i == 1);
			}
		}
	}
}
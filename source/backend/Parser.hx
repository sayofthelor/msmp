package backend;

import backend.Assets;
import haxe.Exception;
import haxe.Json;

using StringTools;

typedef Note =
{
	time:Float,
	id:Int,
	mustPress:Bool
}

typedef Event =
{
	time:Float,
	name:String,
	parameters:Array<String>
}

typedef Chart =
{
	bpm:Float,
	scrollSpeed:Float,
	notes:Array<Note>,
	events:Array<Event>
}

// reads psych engine charts because i really didn't wanna write a chart editor
class Parser
{
	public static function parseChart(song:String, diff:String):Chart
	{
		var data:Dynamic = Json.parse(Assets.json('songs/${song.toLowerCase().replace(" ", "-")}', diff));

		if (data.codenameChart)
		{
			throw new Exception("Codename Engine charts not supported");
			return null;
		}

		var json:Dynamic = data.song;

		var ret:Chart = {
			bpm: json.bpm,
			scrollSpeed: json.speed,
			notes: [],
			events: []
		};
		for (section in (json.notes : Array<Dynamic>))
		{
			if (section == null)
				continue;

			for (note in (section.sectionNotes : Array<Dynamic>))
			{
				ret.notes.push({
					time: note[0],
					id: Std.int(note[1]) % 2,
					mustPress: section.mustHitSection != (Std.int(note[1]) >= 4)
				});
			}
		}
		json.notes.sort((a, b) -> Std.int(a.time - b.time));
		return ret;
	}
}
package backend;

import hscript.Interp;
import hscript.Parser;

class Script
{
	var interp:Interp;
	var filename(default, null):String;

	function set(k:String, v:Dynamic)
	{
		interp?.variables.set(k, v);
	}

	public function new(path:String)
	{
		filename = Assets.hxs(path);
		var file = Assets.getText(filename);
		interp = new Interp();
		var parser = new Parser();
		parser.allowTypes = parser.allowJSON = true;
		interp.execute(parser.parseString(file, filename));
		trace('loaded ${Assets.hxs(path)}');
	}

	public function call(method:String, ?args:Array<Dynamic>)
	{
		if (!interp.variables.exists(method) || !Reflect.isFunction(interp.variables.get(method)))
			return null;
		try
		{
			return interp?.callMethod(method, args);
		}
		catch (e:haxe.Exception)
		{
			var infos = interp.posInfos();
			trace('Error at ${filename}: ' + e.message);
			return null;
		}
	}
}
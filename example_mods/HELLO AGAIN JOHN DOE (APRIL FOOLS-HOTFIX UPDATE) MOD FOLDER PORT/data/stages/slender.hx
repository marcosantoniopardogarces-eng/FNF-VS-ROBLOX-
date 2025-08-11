import flixel.addons.display.FlxBackdrop;

var drunk = new CustomShader("drunk");
drunk.strength = 0.3;
drunk.daTime = 0;

var mynewheats = new CustomShader('heatwave');
mynewheats.uAmountDiv = 544;
mynewheats.uWaves = 16;
mynewheats.uTime = 0;

function postCreate()
{
	var elhelp = new FlxSprite().loadGraphic(Paths.image("stages/seezeedman/smokethesequel"));
	add(elhelp);
	elhelp.alpha = 0.66;
	elhelp.scale.set(5, 5);
	elhelp.screenCenter();
	testing.shader = mynewheats;
	
	for (i in 0...3)
	{
		var smoke = new FlxBackdrop(Paths.image("stages/seezeedman/smoke"), 0x01);
		smoke.scale.set(4, 4 + i*2);
		smoke.y += 820 - i*320;
		smoke.scrollFactor.set(1, 1);
		smoke.alpha = 0.5;
		smoke.blend = 3;
		smoke.velocity.x = 64 / (i+1);
		smoke.shader = drunk;
		
		if (i == 0)
			add(smoke);
		else
			insert(members.indexOf(boyfriend), smoke);
	}
}

function update(elapsed) { drunk.daTime += elapsed; mynewheats.uTime += elapsed/16; }
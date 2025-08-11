import openfl.display.BlendMode;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween.FlxTweenType;
import haxe.crypto.BaseCode;
import haxe.io.Bytes;
import funkin.backend.scripting.Script;

var home = stage.stageSprites.get("testing");
var scenePower = 1;
var platformerMode = 0;
var floorShit:FlxGroup;
var coinShit:FlxGroup;
var ow:FlxGroup;
var canJump = true;
var helloCam:FlxCamera;
var whatitshouldbe = 0;
var dPos = [[FlxG.random.int(-2000,2000), FlxG.random.int(-2000,2000)], [FlxG.random.int(-2000,2000), FlxG.random.int(-2000,2000)]];

function postCreate() {
	powerrs = new CustomShader("drunk");
	powerrs.daTime = 0;
	powerrs.strength = 0.0;
	
	heats = new CustomShader("heatwave");
	heats.uAmountDiv = 500;
	heats.uWaves = 1;
	heats.uTime = 0;
	
	GameOverSubstate.script = "data/states/HJDsafestishere";
	//posBruh = [boyfriend.x, boyfriend.y, dad.x, dad.y];
	
    rgb = new CustomShader("ColorSwap");
    rgb.uTime = 0;

    flashingImgs = new FlxGroup();
    flashingImgs.camera = camHUD;
    insert(0, flashingImgs);
    for (i in 1...8) {
        scary = new FunkinSprite().loadGraphic(Paths.image("stages/seezeedman/thebeginning/" + i));
        scary.screenCenter();
        scary.alpha = 0;
        scary.blend = BlendMode.ADD;
        flashingImgs.add(scary);
    }
	
	camGame.alpha = 0;
	FlxTween.tween(camGame, {alpha: 1}, 13, {ease: FlxEase.quartIn});
	text = Script.fromString(new BaseCode(Bytes.ofString("sz")).decodeString(CoolUtil.coolTextFile(Paths.txt("texts/exitTexts"))[0]), "exit_text.hx");
	text.load();
	scripts.add(text);
}

function powers() {
    var img = flashingImgs.members[scenePower];
    img.alpha = 1;
	FlxTween.tween(img, {alpha: 0}, (Conductor.crochet / 1000) * 4);
	scenePower += 1;
}

function bgchange(heo) {
    switch (heo)
	{
		case "0":
			FlxTween.tween(home, {alpha: 1}, 0.5);
		case "1":
			FlxTween.tween(home, {alpha: 0.5}, 0.5);
		case "2":			
			importScript("data/scripts/april fools");
			initializeAf();
			FlxG.updateFramerate = FlxG.drawFramerate = 30;
			
			if (Options.flashingMenu)
			{
				camGame.addShader(powerrs);
				camGame.addShader(rgb);
				camGame.addShader(heats);
				
				boyfriend.debugMode = true;
				boyfriend.playAnim("singLEFTmiss", true);
				dad.color = FlxColor.RED;
				
				import flixel.addons.effects.FlxTrail;
				var traildad = new FlxTrail(dad, null, 5, 32, 0.5, 0.05);
				insert(members.indexOf(dad)-1, traildad);
				
				var trailbf = new FlxTrail(boyfriend, null, 5, 32, 0.5, 0.05);
				insert(members.indexOf(boyfriend)-1, trailbf);   
				FlxTween.tween(camGame, {zoom: 1.2}, 4, {ease: FlxEase.quartIn});
			}
			else
			{
				curCameraTarget = 2;
				FlxTween.tween(camGame, {zoom: 0.6}, 4, {ease: FlxEase.quartIn});
			}
	}
}

function makeMyItem(_x, _y, _width, _height, _type)
{
	_width ??= 64;
	_height ??= 64;
	_type ??= 0;
	
	switch (_type)
	{
		case 0:
			//.makeGraphic(_width, _height, 0xFFAAAAAA);
			var b = new FlxSprite(_x, _y).loadGraphic(Paths.image("stages/seezeedman/game/floor"));
			b.setGraphicSize(_width, _height);
			b.updateHitbox();
			b.immovable = true;
			floorShit.add(b);
		case 1:
			//.makeGraphic(32, 32, 0xFFAAAAAA);
			var c = new FlxSprite(_x, _y).loadGraphic(Paths.image("stages/seezeedman/game/Page_Forest"));
			coinShit.add(c);
			c.angle = -8;
			FlxTween.tween(c, {angle: 8}, 0.8, {ease: FlxEase.quadInOut, type: FlxTweenType.PINGPONG, startDelay: FlxG.random.float(0, 2)});
			FlxTween.tween(c, {y: c.y - 10}, 1, {ease: FlxEase.quadInOut, type: FlxTweenType.PINGPONG});
		case 2:
			var d = new FlxSprite(_x+12, _y+24).makeGraphic(35,36);
			d.immovable = true;
			ow.add(d);		

			var theRealShit = new FlxSprite(_x, _y).loadGraphic(Paths.image("stages/seezeedman/game/spike"));
			theRealShit.cameras = [helloCam];
			add(theRealShit);
	}
}

function itsover()
{
	FlxG.worldBounds.set(0, 0, 10240, 10240);
	
	camGame.removeShader(powerrs);
	camGame.removeShader(rgb);
	floorShit = new FlxGroup();
	coinShit = new FlxGroup();
	ow = new FlxGroup();

	platformerMode = 1;
	helloCam = new FlxCamera();
	FlxG.cameras.add(helloCam, false);
	helloCam.flash(0xFFFFFFFF, 1);
	helloCam.zoom = 1.2;
	
	br = new FlxBackdrop(Paths.image("stages/seezeedman/game/sky"), 0x11);
	br.scale.set(6, 6);
	br.screenCenter();
	br.cameras = [helloCam];
	br.velocity.x = -128;
	add(br);
	
	cube = new FlxSprite(64, 416).makeGraphic(64, 64);
	add(cube);
	
	fakeCube = new FlxSprite(64, 416).loadGraphic(Paths.image("stages/seezeedman/game/cube"));
	fakeCube.cameras = [helloCam];
	add(fakeCube);
	
	cube.velocity.x = 256;
	
	makeMyItem(0, 480, 512, 128, 0);
	makeMyItem(640, 420, 256, 128, 0);
	makeMyItem(1024, 344, 96, 96, 0);
	makeMyItem(1400, 420, 96, 96, 0);
	makeMyItem(1656, 548, 1024, 256, 0);
	
	for (i in 0...4)
	{
		makeMyItem(192 + i * 72, 432, 0, 0, 1);
		makeMyItem(640 + i * 72, 372, 0, 0, 1);
		makeMyItem(1656 + 128 + i * 72, 500, 0, 0, 1);
	}
	makeMyItem(1056, 296, 0, 0, 1);
	
	makeMyItem(2150, 487, 0, 0, 2);
	makeMyItem(2214, 487, 0, 0, 2);
	
	add(floorShit);
	add(coinShit);
	add(ow);
	floorShit.cameras = coinShit.cameras = [helloCam];
	
    var JPG = new CustomShader('JPG');
    JPG.pixel_size = 1;
    helloCam.addShader(JPG);
	
	var heh = new CustomShader('fisheye');
	heh.MAX_POWER = 0.1;
	helloCam.addShader(heh);
	
	scorTextt = new FlxText(218, 128, 0, "score: "+PlayState.instance.songScore);
	scorTextt.font = Paths.font('ARIAL.TTF');
	scorTextt.size = 10;
	scorTextt.scale.set(4, 4);
	scorTextt.cameras = [helloCam];
	scorTextt.scrollFactor.set();
	add(scorTextt);
	
	jumo = new FlxText(230, 174, 0, "press space/up to jump my good friend");
	jumo.font = Paths.font('ARIAL.TTF');
	jumo.size = 10;
	jumo.scale.set(2, 7);
	jumo.color = FlxColor.RED;
	jumo.cameras = [helloCam];
	jumo.scrollFactor.set();
	add(jumo);
}

/*function welcomeback()
{
	platformerMode = 2;
	FlxG.cameras.remove(helloCam, false);
	remove(cube);
}
*/

function collectCoin(Player:FlxSprite, Obj:FlxSprite):Bool{
    songScore += 100;
	Obj.kill();
	scorTextt.text = "score: "+PlayState.instance.songScore;
	
	FlxG.sound.play(Paths.sound("collectmypages"));
	
	if (Options.flashingMenu)
	{
		FlxTween.cancelTweensOf(helloCam);
		helloCam.zoom = 1.4;
		FlxTween.tween(helloCam, {zoom: 1.2}, 0.3, {ease: FlxEase.quadOut});
		
		if (FlxG.random.bool(1))
		{
			poop = new FunkinSprite().loadGraphic(Paths.image("stages/seezeedman/game/headache" + FlxG.random.int(1,2)));
			poop.scale.set(1.5, 1.5);
			poop.screenCenter();
			poop.scrollFactor.set();
			poop.cameras = [helloCam];
			add(poop);
			new FlxTimer().start(0.1, function() {poop.destroy();});
		}
	}
}

function die(Player:FlxSprite, Obj:FlxSprite):Bool{
    PlayState.instance.health = -66666666;
}

function update(elapsed) 
{
	powerrs.daTime += elapsed;
	if (platformerMode == 1) 
	{
		cube.velocity.y += 720 * elapsed;
		FlxG.collide(cube, floorShit);
		FlxG.overlap(cube, coinShit, collectCoin);
		FlxG.overlap(cube, ow, die);
		
		fakeCube.x = cube.x;
		fakeCube.y = cube.y;
		if ((cube.y >= 640) || (cube.velocity.x < 128))
			health = -3124;
		
		if (cube.velocity.y == 0)
			canJump = true;
		
		if (canJump == true)
			fakeCube.angle = FlxMath.lerp(fakeCube.angle, whatitshouldbe, 0.5);
		else
		{
			fakeCube.angle += 280 * elapsed;
			whatitshouldbe = Math.ceil(fakeCube.angle/90)*90;
		}
		
		if (canJump && (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.UP))
		{
			FlxG.sound.play(Paths.sound("jump"));
			cube.velocity.y = -360;
			canJump = false;
		}
		
		helloCam.scroll.x = cube.x - 320;
		return;
	}

	if ((curStep >= 640) && (curStep < 688) && (Options.flashingMenu))
	{
		rgb.uTime += elapsed;
		powerrs.strength += elapsed * 4;
		heats.uTime += elapsed;
		dad.angle += FlxG.random.int(1,10);
		camGame.angle += 35 * elapsed;
		boyfriend.angle -= FlxG.random.int(1,10);	
		boyfriend.x += dPos[0][0] * elapsed; 
		boyfriend.y += dPos[0][1] * elapsed;
		dad.x += dPos[1][0] * elapsed; 
		dad.y += dPos[1][1] * elapsed;
		
		if (boyfriend.x < -80 || boyfriend.x > 1200)
			dPos[0][0] *= -1.2;
			
		if (boyfriend.y < -300 || boyfriend.y > 728)
			dPos[0][1] *= -1.2;
			
		if (dad.x < -80 || dad.x > 1200)
			dPos[1][0] *= -1.2;
			
		if (dad.y < -300 || dad.y > 728)
			dPos[1][1] *= -1.2;
	}
}
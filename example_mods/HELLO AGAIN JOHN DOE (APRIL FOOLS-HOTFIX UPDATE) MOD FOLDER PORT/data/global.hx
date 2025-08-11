import funkin.backend.utils.ShaderResizeFix;
import funkin.backend.utils.WindowUtils;
import openfl.system.Capabilities;
import lime.graphics.Image;
import funkin.menus.BetaWarningState;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import funkin.editors.charter.Charter;
import funkin.backend.MusicBeatState;
import sys.io.Process;
import funkin.backend.system.framerate.Framerate;

FlxG.save.data.superSoulfulExperience ??= true;
FlxG.save.data.copyrightWorld ??= true;
FlxG.save.data.pezTabletNotes ??= false;


	WindowUtils.winTitle = StringTools.replace(WindowUtils.winTitle, "Friday Night Funkin' - Codename Engine", "hello again john doe");

	camVol = new FlxCamera();
	camVol.bgColor = 0;
    FlxG.cameras.add(camVol, false);
    camVol.visible = false;

    hjdSoundTray = new FlxGroup();
    hjdSoundTray.camera = camVol;
    FlxG.state.add(hjdSoundTray);

    volumeBar = new FunkinSprite().makeGraphic(FlxG.width*2,40,FlxColor.BLACK);
    volumeBar.origin.y = 0;
    volumeBar.screenCenter(FlxAxes.X);
    hjdSoundTray.add(volumeBar);
    
    volumeTxt = new FlxText(0,10,FlxG.width,"volume",15);
    volumeTxt.font = Paths.font('ARIAL.TTF');
    volumeTxt.alignment = "center";
    volumeTxt.scale.set(2,2);
    hjdSoundTray.add(volumeTxt);

    volTimer = new FlxTimer();

    volumeSound = FlxG.sound.load(Paths.sound("menu/volume"));
}

var lastVolumeNumber = 0;
public static var volumeVisible = false;
function update() {
    if (FlxG.keys.anyJustReleased(FlxG.sound.volumeDownKeys) || FlxG.keys.anyJustReleased(FlxG.sound.volumeUpKeys) || FlxG.keys.anyJustReleased(FlxG.sound.muteKeys)) {
		var globalVolume:Int = FlxG.sound.muted ? 0 : Math.round(FlxG.sound.volume * 10);

        volTimer.cancel();

		if (FlxG.cameras.list.contains(camVol)) FlxG.cameras.remove(camVol, false);
		FlxG.cameras.add(camVol, false);
        camVol.visible = true;

        volumeTxt.text = "volume: " + globalVolume + "/10";
        volumeTxt.screenCenter(FlxAxes.X);
        volumeTxt.screenCenter(FlxAxes.X);

        volumeVisible = true;
        volTimer = new FlxTimer().start(1, () -> {
            camVol.visible = false;
            volumeVisible = false;
        });

        if (globalVolume != lastVolumeNumber) volumeSound.play(true);
        lastVolumeNumber = globalVolume;
    }
}

public static function windowShit(newWidth:Int, newHeight:Int, ?winScale:Float = 0.9){
     if(newWidth != 1280 || newHeight != 720) {
        aspectShit(newWidth, newHeight);
        FlxG.resizeWindow(winWidth * winScale, winHeight * winScale);
    } else
        FlxG.resizeWindow(newWidth, newHeight);
    FlxG.resizeGame(newWidth, newHeight);
    FlxG.scaleMode.width = FlxG.width = FlxG.initialWidth = newWidth;
    FlxG.scaleMode.height = FlxG.height = FlxG.initialHeight = newHeight;
    ShaderResizeFix.doResizeFix = true;
    ShaderResizeFix.fixSpritesShadersSizes();
    window.x = Capabilities.screenResolutionX/2 - window.width/2;
    window.y = Capabilities.screenResolutionY/2 - window.height/2;
}

function aspectShit(width:Int, height:Int):String {
    var idk1:Int = height;
    var idk2:Int = width;
    while (idk1 != 0) {
        idk1 = idk2 % idk1;
        idk2 = height;
    }
    winWidth = Math.floor(Capabilities.screenResolutionX * ((height / idk2) / (width / idk2))) > Capabilities.screenResolutionY ? Math.floor(Capabilities.screenResolutionY * ((width / idk2) / (height / idk2))) : Capabilities.screenResolutionX;
    winHeight = Math.floor(Capabilities.screenResolutionX * ((height / idk2) / (width / idk2))) > Capabilities.screenResolutionY ? Capabilities.screenResolutionY : Math.floor(Capabilities.screenResolutionX * ((height / idk2) / (width / idk2)));
}

public static function graphicSize(sprite:FlxSprite, ?width:Float, ?height:Float, ?updatehitbox)
{
    width ??= 0;
    height ??= 0;
    updatehitbox ??= true;

	if (width <= 0 && height <= 0)
		return sprite;

	var newScaleX:Float = width / sprite.frameWidth;
	var newScaleY:Float = height / sprite.frameHeight;
	sprite.scale.set(newScaleX, newScaleY);

	if (width <= 0)
		sprite.scale.x = newScaleY;
	else if (height <= 0)
		sprite.scale.y = newScaleX;

	if (updatehitbox) sprite.updateHitbox();
	return sprite;
}

public static function centerOnSprite(sprite, center)
    sprite.setPosition(
        center.x + center.width / 2 - sprite.width / 2,
        center.y + center.height / 2 - sprite.height / 2
    );

public static function actuallyOverlaps(sprite:FlxBasic, ?camera:FlxCamera) {
    camera ??= FlxG.camera; // shouldve added this a long time ago
	var posthing = FlxG.mouse.getWorldPosition(camera);
	return FlxMath.inBounds(posthing.x, sprite.x, sprite.x + sprite.width) && FlxMath.inBounds(posthing.y, sprite.y, sprite.y + sprite.height);
}

public static function isProgramOpen(program:String) {
    var process = new Process("tasklist", []);
    var output = process.stdout.readAll().toString();
    if (output.indexOf(program + ".exe") != -1) return true;
    else return false;
}
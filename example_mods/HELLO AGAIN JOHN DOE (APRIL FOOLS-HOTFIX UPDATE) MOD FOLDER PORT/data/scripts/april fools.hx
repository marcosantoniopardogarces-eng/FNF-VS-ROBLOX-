import flixel.tweens.FlxTween.FlxTweenType;

var tweenEases = ["linear", "back", "bounce", "circ", "cube", "elastic", "expo", "quad", "quart", "quint", "sine", "smoothStep", "smootherStep"];
var heh = ["In", "Out", "InOut"];

// welcome to postPostCreate
public function initializeAf()
{
	timeTxt.font = Paths.font("sans.ttf");
    hpText.font = Paths.font("papyrus.ttf");
    hpText.italic = true;
    FlxG.updateFramerate = FlxG.drawFramerate = 20;
    hypercam = new FunkinSprite().loadGraphic(Paths.image("af/HYPERCAM"));
    hypercam.zoomFactor = 0;
    hypercam.camera = camHUD;
    hypercam.origin.set();
    hypercam.scale.set(2, 2);
    add(hypercam);
    
    if (!Options.flashingMenu) return;
    deepfry = new CustomShader('deepfry');
    deepfry.saturation = 1.5;
    deepfry.luminance = [0.2125, 0.7154, 0.0721];
    deepfry.contrast = 1.5;
    deepfry.noiseAmount = 0.1;
    camGame.addShader(deepfry);
    JPEG = new CustomShader('jpeg_artifacts');
    JPEG.quality = 0.001;
    JPEG.blockSize = 8;
    camGame.addShader(JPEG);
    camHUD.addShader(JPEG);
    JPG = new CustomShader('JPG');
    JPG.pixel_size = 1;
    camGame.addShader(JPG);
    camHUD.addShader(JPG);
	list = Paths.getFolderContent("images/af/boiImagePack2017");

    // scary mode lazy fix
    if (scaryMode) {
        var scary = new FunkinSprite().makeGraphic(1, 1, 0xFFFF1111);
        scary.scale.set(FlxG.height*1.5, FlxG.width*1.5);
        scary.screenCenter();
        scary.blend = 2;
        scary.scrollFactor.set();
        scary.zoomFactor = 0;
        insert(999, scary);
    }
}

function postCreate() new FlxTimer().start(0.001, () -> {
    initializeAf();
});

function onSongStart() new FlxTimer().start(0.001, () -> {
    var newTweens = 0;
    var myHeadHurts = FlxG.random.int(0,12);
    if (myHeadHurts == 0)
        newTweens = FlxEase.linear;
    else
        newTweens = Reflect.field(FlxEase, tweenEases[myHeadHurts]+heh[FlxG.random.int(0,2)]);
    FlxTween.tween(timeTxt, {angle: FlxG.random.float(-65535, 65535), "scale.x": FlxG.random.float(0.5, 5), "scale.y": FlxG.random.float(0.5, 5)}, FlxG.random.float(20, FlxG.sound.music.time / 1000), {ease: newTweens, type: FlxTweenType.PINGPONG});
    hpText.angle = -10;
    hpText.scale.set(0.5, 2);
    FlxTween.tween(hpText, {"scale.x": 2, "scale.y": 0.5, angle: 10}, FlxG.random.float(0.5, 5), {type: FlxTweenType.PINGPONG});
});

function onNoteHit(e) {
    if (FlxG.random.bool(2)) painItUp();
    if (FlxG.random.bool(1))
        FlxTween.tween(player.members[e.direction], switch(e.direction) {
            case 0: {x: player.members[e.direction].x - 10};
            case 1: {y: player.members[e.direction].y + 10 * (downscroll ? -1 : 1)};
            case 2: {y: player.members[e.direction].y - 10 * (downscroll ? -1 : 1)};
            case 3: {x: player.members[e.direction].x + 10};
        }, 0.25);
}
function onPlayerMiss(e) painItUp(5);

function painItUp(?amount:Int) {
    if (!Options.flashingMenu) return; // ACTUAL SEIZURE HAZARD
    amount ??= 1;
    for (i in 0...amount) {
        var boi = new FunkinSprite().loadGraphic(Paths.getPath("images/af/boiImagePack2017/" + FlxG.random.getObject(list)));
        boi.scale.set(FlxG.width/boi.width, FlxG.height/boi.height);
        boi.origin.set();
        boi.zoomFactor = 0;
        boi.camera = camHUD;
        insert(0, boi);
        new FlxTimer().start(FlxG.random.float(0.01, 0.2), () -> {
            remove(boi.destroy());
        });
    }
}

function randColor(?prevColor:FlxColor):FlxColor {
    var colorTables = [
        0xFFFFFF00,
        0xFFFF00FF,
        0xFF00FFFF,
        0xFFFF0000,
        0xFF00FF00,
        0xFF0000FF
    ];
    colorTables.remove(prevColor);
    return FlxG.random.getObject(colorTables);
}

function onPostNoteCreation(e) {
    var noty = e.note;
    new FlxTimer().start(0.001, {
        noty.color = randColor();
    });
}
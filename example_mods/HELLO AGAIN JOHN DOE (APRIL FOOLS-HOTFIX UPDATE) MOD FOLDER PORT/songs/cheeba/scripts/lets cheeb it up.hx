import funkin.editors.charter.Charter;
import funkin.savedata.FunkinSave;
import flixel.addons.display.FlxBackdrop;

songEnded = false;

var dadow = cpuStrums.characters[1];
var walls = stage.stageSprites.get("isolation");
var dud = false;
var hudFaded = false;

function postCreate() {
    dadow.alpha = 0;
    new FlxTimer().start(0.001, function() {
        hudStuffs = [timeTxt, hpText, hpBar_under, hpBar_over, topBar];
    });

    macBanner = new FlxBackdrop();
    macBanner.frames = Paths.getFrames("stages/cheeba/mac0head");
    // im so sorry
    macBanner.animation.addByIndices("head0", "head", [0,1,2,3,4,5,6,7,8,9,10,11,12], "", 37);
    macBanner.animation.addByIndices("head1", "head", [13,14,15,16,17,18,19,20,21,22,23,24], "", 37);
    macBanner.animation.addByIndices("head2", "head", [25,26,27,28,29,30,31,32,33,34,35,36], "", 37);
    macBanner.animation.addByIndices("head3", "head", [37,38,39,40,41,42,43,44,45,46,47,48], "", 37);
    macBanner.animation.addByIndices("head4", "head", [12,11,10,9,8,7,6,5,4,3,2,1,0], "", 37);
    macBanner.animation.addByIndices("head5", "head", [24,23,22,21,20,19,18,17,16,15,14,13], "", 37);
    macBanner.animation.addByIndices("head6", "head", [36,35,34,33,32,31,30,29,28,27,26,25], "", 37);
    macBanner.animation.addByIndices("head7", "head", [48,47,46,45,44,43,42,41,40,39,38,37], "", 37);
    macBanner.alpha = 0;
    macBanner.velocity.x = macBanner.velocity.y = 200;
    macBanner.spacing.set(0, 40);
    macBanner.color = 0xFFCCCCFF;
    insert(members.indexOf(boyfriend), macBanner);
    goodShader = new CustomShader("fisheye");
    goodShader.MAX_POWER = 0;

    if (PlayState.instance.chartingMode && Charter.startHere) return;
    walls.alpha = dad.alpha = boyfriend.alpha = camHUD.alpha = 0;
    boyfriend.cameraOffset.x += 175;
    dud = true;
    canPause = false;
    new FlxTimer().start(0.002, function() {
        for (i in hudStuffs) i.alpha = 0;
    });
}

function update() {
    if (curCameraTarget == 0 && dud) {
        dud = false;
        boyfriend.cameraOffset.x -= 175;
    }
}

function onSongEnd() {
    songEnded = true;
}

function destroy() {
    if (FlxG.save.data.copyrightWorld && !PlayState.instance.chartingMode && songEnded) {
        FlxG.switchState(new ModState("HJDPlayMenu", "sus/Enormous Penis - Da Vinci's Notebook"));
    }
}

var beat = Conductor.crochet / 1000;
function onSongStart() {
    if (PlayState.instance.chartingMode && Charter.startHere) return;
    FlxTween.num(0, 20, 30 * beat, {ease: FlxEase.sineInOut}, function(num) {
        boyfriend.alpha = Math.floor(num)/20;
    });
    new FlxTimer().start(beat * 28, function() {
        canPause = true;
        FlxTween.num(0, 20, 4 * beat, {ease: FlxEase.sineInOut}, function(num) {
            camHUD.alpha = Math.floor(num)/20;
        });
    });
}

var flipCheck = false;
var flipy = false;

function flipIt() flipCheck = !flipCheck;

function tweenAlphas(thing) switch(thing) {
    case "mac is here": 
        FlxTween.num(0, 20, 2 * beat, {ease: FlxEase.sineInOut}, function(num) {
            dadow.alpha = Math.floor(num)/20;
        });
    case "welcome":
        dad.alpha = 1;
        FlxTween.num(0, 20, 4 * beat, {ease: FlxEase.sineOut, onComplete: function() {hudFaded = true; walls.alpha = dad.alpha = 1; dadow.alpha = 0;}}, function(num) {
            walls.alpha = Math.floor(num)/20;
            if (!hudFaded) for (i in hudStuffs) i.alpha = walls.alpha;
            dadow.alpha = 1 - walls.alpha;
        });
    case "allOut":
        FlxTween.num(20, 0, 4 * beat, {ease: FlxEase.sineIn}, function(num) {
            dad.alpha = boyfriend.alpha = walls.alpha = Math.floor(num)/20;
        });
    case "bfIn":
        FlxTween.num(0, 20, 4 * beat, {ease: FlxEase.sineIn, onComplete: function() {boyfriend.alpha = 1;}}, function(num) {
            boyfriend.alpha = Math.floor(num)/20;
        });
    case "wallsOut":
        FlxTween.num(20, 0, 4 * beat, {ease: FlxEase.sineIn}, function(num) {
            walls.alpha = Math.floor(num)/20;
            dadow.alpha = 1 - walls.alpha;
        });
    case "finalOut":
        dad.alpha = 0;
        var purpl = new FunkinSprite().makeGraphic(1, 1, 0xFFB785F8);
        purpl.scale.set(FlxG.width, FlxG.height);
        purpl.scrollFactor.set();
        purpl.zoomFactor = 0;
        purpl.alpha = 0;
        purpl.screenCenter();
        insert(999, purpl);
        FlxTween.num(20, 0, 2 * beat, {ease: FlxEase.sineIn}, function(num) {
            camHUD.alpha = Math.floor(num)/20;
            purpl.alpha = 1 - camHUD.alpha;
        });
}

var darkenTween:FlxTween;
var isItDark = false;

function darkenIt() {
    if (darkenTween != null) darkenTween.cancel();
    darkenTween = FlxTween.num(20, 0, isItDark ? 0.5 : 0.75, {ease: FlxEase.circOut}, function(num) {
        walls.color = CoolUtil.lerpColor(isItDark ? 0xFF333355 : 0xFFFFFFFF, isItDark ? 0xFFFFFFFF : 0xFF333355, Math.floor(num)/20);
    });
    isItDark = !isItDark;
}

function randItUp(text:FlxText, scale:Float) {
    var posx = text.x + text.width/2;
    var oldheight = text.height;
    text.color = randColor(text.color);
    text.text = randCaps(text.text);
    var fonts = [
        "ARIAL.TTF",
        "ArialCEItalic.ttf",
        "vcr.ttf",
        "DroidSerif-Italic.ttf",
        "Merriweather.ttf",
        "Montserrat.ttf",
        "Roboto Mono.ttf"
    ];
    text.font = Paths.font(FlxG.random.getObject(fonts));
    text.updateHitbox();
    var scaly = (oldheight/text.height) * scale;
    text.scale.set(scaly, scaly);
    text.updateHitbox();
    text.x = posx - text.width/2;
    text.italic = FlxG.random.bool();
    text.bold = FlxG.random.bool();
}

function randCaps(text:String) {
    var chars = text.split('');
    for (i in 0...chars.length) {
        chars[i] = FlxG.random.bool() ? chars[i].toUpperCase() : chars[i].toLowerCase();
    }
    return chars.join('');
}

function randColor(?prevColor:FlxColor):FlxColor {
    if (!Options.flashingMenu) return prevColor;
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

var superDrunky = false;
function beatHit(curBeat) {
    if (PlayState.instance.chartingMode && Charter.startHere) {
        var beatsSkipped = Math.floor(Charter.startTime / Conductor.crochet);
        if (curBeat < beatsSkipped) return;
    }
    if (superDrunky) {
        randItUp(timeTxt, 2);
        timeTxt.y = topBar.y + topBar.height - timeTxt.height;
        timeName = randCaps(timeName);
        randItUp(hpText, 1);
        macBanner.animation.play("head" + curBeat % 8);
    }
    if (flipCheck) {
        for (i=>cam in [camGame, camHUD]) {
            cam.angle = (i == 0 ? 2 : 1) * (flipy ? 1 : -1);
            FlxTween.tween(cam, {angle: 0}, Conductor.crochet / 1000 - 0.05, {ease: FlxEase.quadOut});
        }
        flipy = !flipy;
    }
}


function itsSuperDrunkTime() {
    superDrunky = !superDrunky;
    if (!superDrunky) {
        FlxTween.cancelTweensOf(macBanner);
        FlxTween.tween(macBanner, {alpha: 0}, 1, {ease: FlxEase.sineOut});
        FlxTween.cancelTweensOf(goodShader);
        FlxTween.tween(goodShader, {MAX_POWER: 0}, 1, {ease: FlxEase.sineOut});
        timeTxt.scale.set(2, 2);
        timeTxt.font = Paths.font("ARIAL.TTF");
        timeTxt.color = FlxColor.WHITE;
        timeTxt.updateHitbox();
        timeTxt.y = 0;
        timeTxt.screenCenter(FlxAxes.X);
        timeName = "time: ";
        hpText.scale.set(1, 1);
        hpText.font = Paths.font("ArialCEItalic.ttf");
        hpText.color = FlxColor.BLUE;
        hpText.text = "health";
        hpText.updateHitbox();
        hpText.x = hpBar_under.x + hpBar_under.width / 2 - hpText.width / 2;
    }
}

function itsHeadTime() {
    darkenIt();
    if (Options.flashingMenu) camGame.addShader(goodShader);
    FlxTween.tween(macBanner, {alpha: 1}, 3, {ease: FlxEase.sineIn});
    FlxTween.tween(goodShader, {MAX_POWER: 0.25}, 1, {ease: FlxEase.sineIn});
}
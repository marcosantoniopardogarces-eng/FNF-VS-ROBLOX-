import funkin.editors.charter.Charter;
import flixel.tweens.FlxTweenType;
import openfl.display.BlendMode;

var john = playerStrums.characters[1];
var noob = cpuStrums.characters[1];
var povdad = cpuStrums.characters[2];
var scripter = cpuStrums.characters[3];
var home = stage.stageSprites.get("bg1");

function postCreate() {
    john.visible = dad.visible = povdad.visible = scripter.visible = false;

    noobHead = new FlxSprite(noob.x + 100, noob.y + 440);
    noobHead.scale.set(1.6, 1.6);
    noobHead.frames = Paths.getFrames("characters/noobead");
    noobHead.animation.addByPrefix("idle", "spin", 20);
    noobHead.animation.play("idle");
    noobHead.visible = false;
    noobGravity = false;
    noobSpin = new FlxTimer();
    insert(members.indexOf(noob) + 1, noobHead);

    if (PlayState.instance.chartingMode && Charter.startHere) {
        noob.visible = false;
        dad.visible = true;
    }

    fire = new FlxSprite(0, 30);
	fire.frames = Paths.getFrames('menu/rolbox/sm/fire');
	fire.animation.addByPrefix('i','fire',24);
	fire.animation.play('i');
    fire.camera = camHUD;
    fire.visible = false;
    fire.blend = BlendMode.ADD;
    graphicSize(fire, 0, FlxG.height);
	insert(0, fire);

    povCam = new FlxCamera();
    povCam.bgColor = 0;
    povCam.alpha = 0;
    povCam.zoom = 0.85;
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(povCam, false);
    FlxG.cameras.add(camHUD, false);

    povdad.camera = povCam;
    povdad.screenCenter();
    povdad.y += 275;

    povBg = new FlxSprite().loadGraphic(Paths.image("stages/hello-again/povworld/povhome"));
    povBg.camera = povCam;
    povBg.scrollFactor.set(0.25, 0.25);
    povBg.screenCenter();
    insert(members.indexOf(povdad), povBg);

    chudgf = new FlxSprite().loadGraphic(Paths.image("stages/hello-again/povworld/chudgf"));
    chudgf.scale.set(0.4, 0.4);
    chudgf.camera = povCam;
    chudgf.scrollFactor.set();
    chudgf.screenCenter();
    chudgf.y += 75;
    chudgf.visible = false;
    insert(members.indexOf(povdad), chudgf);

    chudbf = new FlxSprite().loadGraphic(Paths.image("stages/hello-again/povworld/chudbf"));
    chudbf.scale.set(0.5, 0.5);
    chudbf.camera = povCam;
    chudbf.scrollFactor.set();
    chudbf.screenCenter();
    chudbf.y += 100;
    chudbf.visible = false;
    insert(members.indexOf(povdad), chudbf);

    liljohn = new FlxSprite().loadGraphic(Paths.image("stages/hello-again/povworld/littledoe"));
    liljohn.scale.set(0.75, 0.75);
    liljohn.camera = povCam;
    liljohn.scrollFactor.set();
    liljohn.screenCenter();
    liljohn.y += 100;
    liljohn.visible = false;
    insert(members.indexOf(povdad), liljohn);

    heats = new CustomShader("heatwave");
    heats.uTime = 0;
    heats.uAmountDiv = 300;
    heats.uWaves = 20;
    povCam.addShader(heats);

    drunk = new CustomShader("drunk");
    drunk.strength = 5;
    povBg.shader = drunk;

    fireCam = new FlxCamera();
    fireCam.bgColor = 0;
    fireCam.zoom = 0.75;
    fireCam.visible = false;
    FlxG.cameras.add(fireCam, false);
    
    fireTime = new Alphabet(0, -135, "TIME: 69", true);
    fireTime.camera = fireCam;
    fireTime.updateHitbox();
    fireTime.screenCenter(FlxAxes.X);
    add(fireTime);

    noobImgs = new FlxGroup();
    noobImgs.camera = camHUD;
    insert(0, noobImgs);
    for (i in 0...5) {
        noobImg = new FunkinSprite().loadGraphic(Paths.image("stages/hello-again/noob/noob" + (i + 1)));
        noobImg.scale.set(768/noobImg.height, 768/noobImg.height);
        noobImg.screenCenter();
        noobImg.alpha = 0;
        noobImg.blend = BlendMode.ADD;
        noobImgs.add(noobImg);
    }

    glitchy = new CustomShader("invertGlitch");
    glitchy.AMT = 0.7;
    glitchy.SPEED = 8;
    glitchy.iTime = 0;
    glitchy.isActive = false;

    heh = new FlxSprite().loadGraphic(Paths.image("stages/hello-again/xp"));
    centerOnSprite(heh, scripter);
    heh.x -= 100;
    heh.y += 500;
    heh.visible = false;
    heh.scale.set(2, 2);
    insert(members.indexOf(scripter) + 1, heh);
}

var strumy:Float;
function fireHUD() {
    if (!fireCam.visible) {
        fireCam.visible = true;
        fireCam.alpha = 0;
        FlxTween.tween(fireCam, {alpha: 1}, 1);
        FlxTween.tween(topBar, {"scale.y": 1.6}, 1, {ease: FlxEase.circOut});
        strumy = playerStrums.members[0].y;
        for (i in playerStrums.members)
            FlxTween.tween(i, {y: strumy + 25}, 1, {ease: FlxEase.circOut});
    } else {
        FlxTween.cancelTweensOf(topBar);
        FlxTween.tween(topBar, {"scale.y": 1}, 1, {ease: FlxEase.circOut});
        FlxTween.cancelTweensOf(fireCam);
        FlxTween.tween(fireCam, {alpha: 0}, 1, {onComplete: () -> {fireCam.visible = false;}});
        FlxTween.tween(timeTxt, {alpha: 1}, 1);
        for (i in playerStrums.members) {
            FlxTween.cancelTweensOf(i);
            FlxTween.tween(i, {y: strumy}, 1, {ease: FlxEase.circOut});
        }
    }
}

var time = 0;
function postUpdate(elapsed) {
    time += elapsed;
    if (povdad.visible) {
        fireTime.text = timeTxt.text;
        fireTime.visible = !volumeVisible;
        fireTime.screenCenter(FlxAxes.X);
        fireCam.zoom = camHUD.zoom * 0.75;
        if (!povdad.debugMode) povBg.color = CoolUtil.lerpColor(0xFF330000, 0xFFFF3311, Math.sin(time/2 * Math.PI) / 4 + 0.25);
        heats.uTime = time/4;
        drunk.daTime = time/2;
        var offsetX = switch(true) {
            case povdad.animation.curAnim.name == "singLEFT": -camNoteOffset * 2;
            case povdad.animation.curAnim.name == "singRIGHT": camNoteOffset * 2;
            case boyfriend.animation.curAnim.name == "singLEFT": -camNoteOffset;
            case boyfriend.animation.curAnim.name == "singRIGHT": camNoteOffset;
            default: 0;
        }
        var offsetY = switch(true) {
            case povdad.animation.curAnim.name == "singUP": -camNoteOffset * 2;
            case povdad.animation.curAnim.name == "singDOWN": camNoteOffset * 2;
            case boyfriend.animation.curAnim.name == "singUP": -camNoteOffset;
            case boyfriend.animation.curAnim.name == "singDOWN": camNoteOffset;
            default: 0;
        }
        if (!povdad.debugMode) povCam.scroll.set(
            CoolUtil.fpsLerp(povCam.scroll.x, offsetX, camGame.followLerp),
            CoolUtil.fpsLerp(povCam.scroll.y, offsetY, camGame.followLerp)
        );
    }
    glitchy.isActive = StringTools.endsWith(john.animation.curAnim.name, "-alt");
    glitchy.iTime = time;
}

function onNoteHit(e) {
    if (e.character == dad && povdad.visible) health = Math.max(health - (e.note.isSustainNote ? 0.005 : 0.025), 0.1);
}

function onCutsceneTrigger(id, isEnd) if (id == "noob intro") {
    if (PlayState.instance.chartingMode && Charter.startHere) return;
    if (!isEnd) {

    } else {
        noob.debugMode = true;
        noob.playAnim("die");
        noob.animation.finishCallback = function(name) {
            if (name == "die") noob.visible = false;
        }
        new FlxTimer().start(0.1, function() {
            noobHead.visible = true;
            noobGravity = true;
            noobHead.velocity.x = 1100;
            noobHead.velocity.y = -1500;
            noobSpin.start(0.1, function(timer) {
                noobHead.angle = switch(timer.elapsedLoops % 3) {
                    case 0: 0;
                    case 1: 45;
                    case 2: 195;
                }
            }, 0);
            new FlxTimer().start(1, function() {
                noobSpin.cancel();
                noobGravity = false;
                remove(noobHead.destroy());
                dad.color = FlxColor.black;
                dad.visible = true;
                dad.alpha = 0;
                FlxTween.num(0, 20, 2, {ease: FlxEase.sineOut, onComplete: function() {
                    dad.color = FlxColor.WHITE;
                    dad.alpha = 1;
                }}, function(num) {
                    if (num < 10) dad.alpha = Math.floor(num) / 10;
                    else dad.color = CoolUtil.lerpColor(FlxColor.BLACK, FlxColor.WHITE, Math.floor(num - 10) / 10);
                });
            });
        });
    }
}

function hesHere() {
    FlxTween.color(povBg, 1, povBg.color, FlxColor.WHITE, {ease: FlxEase.circOut});
    FlxTween.tween(drunk, {strength: 0}, 1, {ease: FlxEase.circOut});
    FlxTween.tween(heats, {uAmountDiv: 99999}, 1, {ease: FlxEase.circOut, onComplete: () -> {povCam.removeShader(heats);}});
    chudbf.visible = chudgf.visible = liljohn.visible = povdad.debugMode = true;
    chudbf.scrollFactor.set(-0.2, -0.2);
    chudgf.scrollFactor.set(-0.4, -0.4);
    liljohn.scrollFactor.set(-0.6, -0.6);
    povBg.scrollFactor.set(-0.6, -0.6);
    for (n=>i in [chudbf, chudgf]) new FlxTimer().start(n*0.25, () -> {
        i.loadGraphic(Paths.image("stages/hello-again/povworld/fuckedup" + (n == 1 ? "gf" : "bf")));
        FlxTween.tween(i, {angle: 360*3, y: -i.height}, 1, {ease: FlxEase.quadIn});
    });
    FlxTween.tween(povCam, {"scroll.x": 300}, 1, {ease: FlxEase.circOut});
    povdad.playAnim("trans");
    fireItUp("tween it");
    fireHUD();
}

var fireIs = false;
var fireTween:FlxTween;
function fireItUp(?tween) {
    tween ??= "";
    fireIs = !fireIs;
    if (tween != "tween it") fire.visible = fireIs;
    else {
        if (fireTween != null) fireTween.cancel();
        fire.visible = true;
        fireTween = FlxTween.num(fireIs ? 0 : 20, fireIs ? 20 : 0, fireIs ? 0.75 : 0.5, {ease: FlxEase.sineOut, onComplete: function() {
            if (fire.alpha == 0) fire.visible = false;
        }}, function(num) {
            fire.alpha = Math.floor(num)/20;
        });
    }
}

var esTwen:FlxTween;
var noobId = 0;
function superTuffScenes(scene) switch(scene) {
    case "bfsolo":
        FlxTween.tween(boyfriend, {"cameraOffset.x": boyfriend.cameraOffset.x + 175}, Conductor.crochet / 500, {ease: FlxEase.quadOut});
        esTwen = FlxTween.num(20, 0, 0.75, {ease: FlxEase.sineIn}, function(num) {
            gf.alpha = dad.alpha = Math.floor(num)/20;
        });
    case "noobimg":
        var img = noobImgs.members[noobId];
        img.alpha = 1;
        FlxTween.tween(img, {alpha: 0}, (Conductor.crochet / 1000) * 6);
        noobId += 1;
    case "bfOut":
        esTwen = FlxTween.num(20, 0, Conductor.crochet / 125, {ease: FlxEase.sineInOut}, function(num) {
            boyfriend.alpha = timeTxt.alpha = Math.floor(num)/20;
        });
}

var fuck:FlxTween;
function POVChange(yep) {
    if (yep != "yep") {
        fuck = FlxTween.num(0, 20, Conductor.crochet / 250, {ease: FlxEase.sineInOut}, function(num) {
            povCam.alpha = Math.floor(num)/20;
        });
        povdad.visible = true;
        fireItUp("tween it");
        fireHUD();
    } else povCam.visible = povdad.visible = camGame.visible = false;
}

function johnIsHere() {
    dad.visible = boyfriend.visible = false;
    scripter.visible = john.visible = camGame.visible = true;
    home.shader = glitchy;
}

function haha() {
    heh.visible = scripter.debugMode = true;
    scripter.animation.stop();
}

function update(elapsed) {
    if (noobGravity) noobHead.velocity.y += 4500 * elapsed;
}
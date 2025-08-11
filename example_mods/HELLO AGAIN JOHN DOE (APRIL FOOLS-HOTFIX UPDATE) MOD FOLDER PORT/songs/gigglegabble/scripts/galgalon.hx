import funkin.editors.charter.Charter;
import flixel.graphics.frames.FlxAtlasFrames;

var land = stage.stageSprites.get("glaggleland");
var runway = stage.stageSprites.get("runway");

function postCreate() {
    FlxG.updateFramerate = Options.framerate;

    cuts = [];
    currentCut = 0;
    cutOn = false;

    for (i in 0...5) {
        var cut = new FunkinSprite();
        cut.scrollFactor.set();
        cut.zoomFactor = 0;
        cut.camera = camHUD;
        insert(0, cut);
        cut.visible = false;
        cuts.push(cut);
        switch(i) {
            case 0:
                cut.frames = Paths.getFrames("characters/giggler");
                cut.animation.addByPrefix("danceLeft", "danceleft", 20, false);
                cut.addOffset("danceLeft", 25, -15);
                cut.animation.addByPrefix("danceRight", "danceright", 20, false);
                cut.addOffset("danceRight", 10, -15);
                cut.playAnim("danceLeft");
            default:
                cut.frames = FlxAtlasFrames.fromSparrow(Paths.image("stages/gigglegabble/glog/glag" + i, null, false, "jpg"), Paths.file("images/stages/gigglegabble/glog/glag" + i + ".xml"));
                cut.animation.addByPrefix("idle", "idle", 60);
                cut.scale.set(i == 4 ? 0.5 : 0.25, i == 4 ? 0.5 : 0.25);
                cut.playAnim("idle");
        }
        cut.screenCenter();
    }

    if (PlayState.instance.chartingMode && Charter.startHere) return;
    camGame.alpha = 0;
}

function showCut(iS, beatsS, ?waitS) {
    if (cutOn) return;
    var i = Std.parseInt(iS);
    var beats = Std.parseFloat(beatsS);
    var wait = waitS == null ? 0 : Std.parseInt(waitS);
    currentCut = i;
    cutOn = true;
    new FlxTimer().start((Conductor.crochet / 1000) * wait, () -> {
        cuts[i].visible = true;
        camGame.visible = false;
        new FlxTimer().start((Conductor.crochet / 1000) * (beats) - 0.05, () -> {
            cuts[i].visible = cutOn = false;
            camGame.visible = true;
        });
    });
}

function onSongStart() {
    if (PlayState.instance.chartingMode && Charter.startHere) return;
    FlxTween.num(0, 20, (Conductor.crochet / 1000) * 16, {ease: FlxEase.sineOut}, function(num) {
        camGame.alpha = Math.floor(num)/20;
    });
}

function fire() {
    FlxTween.num(20, 0, Conductor.crochet / 1000, {ease: FlxEase.sineIn, onComplete: () -> {
        new FlxTimer().start(Conductor.crochet / 500, () -> {
            FlxTween.num(0, 20, Conductor.crochet / 1000, {ease: FlxEase.sineOut}, function(num) {
                boyfriend.alpha = gf.alpha = land.alpha = runway.alpha = Math.floor(num)/20;
            });
        });
    }}, function(num) {
        boyfriend.alpha = gf.alpha = land.alpha = runway.alpha = Math.floor(num)/20;
    });
}

var flipy = false;
var flipCheck = false;

function flipIt() flipCheck = !flipCheck;

function beatHit(curBeat) {
    if (flipCheck) {
        for (i=>cam in [camGame, camHUD]) {
            cam.angle = (i == 0 ? 2 : 1) * (flipy ? 1 : -1);
            FlxTween.tween(cam, {angle: 0}, Conductor.crochet / 1000 - 0.05, {ease: FlxEase.quadOut});
        }
        flipy = !flipy;
    }
    if (cutOn) {
        var cut = cuts[currentCut];
        switch(currentCut) {
            case 0:
                cut.playAnim(curBeat % 2 == 0 ? "danceRight" : "danceLeft");
        }
    }
}

function getMeOutOfHere() {
    FlxTween.num(20, 0, (Conductor.crochet / 1000) * 16, {ease: FlxEase.sineIn, startDelay: Conductor.crochet / 250}, function(num) {
        camGame.alpha = Math.floor(num)/20;
    });
}
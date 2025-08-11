importScript("data/scripts/april fools");

import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.MusicBeatState;
importScript("data/states/HJDElevator");

var newEndings = new FlxVideoSprite();
var endingPlayed = false;
var videoLoaded = false;
var yoButFuckingWaitForMe = true;
var hehBro = false;

// fake transition
function create() {
    MusicBeatState.skipTransIn = true;
    
    camSkip = new FlxCamera();
    camSkip.bgColor = 0;
    FlxG.cameras.add(camSkip, false);
    
    camTrans = new FlxCamera();
    camTrans.bgColor = 0;
    FlxG.cameras.add(camTrans, false);
    
    elevator(camTrans);
    monitor.animation.play("staticlooped");
    songName.text = lastLoadingMsg;
}

function postCreate() {
	newEndings.load(Assets.getPath(Paths.video("its earthworm sally")));
    newEndings.camera = camHUD;
    newEndings.bitmap.onFormatSetup.add(function():Void {
        if (newEndings.bitmap != null && newEndings.bitmap.bitmapData != null) {
            final scale:Float = Math.max(FlxG.width / newEndings.bitmap.bitmapData.width, FlxG.height / newEndings.bitmap.bitmapData.height);
            newEndings.setGraphicSize(newEndings.bitmap.bitmapData.width * scale, newEndings.bitmap.bitmapData.height * scale);
            newEndings.updateHitbox();
            newEndings.screenCenter();
        }
    });
	newEndings.bitmap.onEndReached.add(function () {newEndings.visible = endingPlayed = false;});
    newEndings.play();
    insert(0, newEndings);
    newEndings.visible = camGame.visible = false;

    new FlxTimer().start(0.001, () -> {
        if (scaryMode) {
            newEndings.color = 0xFFFF1111;
            newEndings.bitmap.rate = 0.8;
        }
    });
}

function onStartCountdown(e) {
    if (!videoLoaded) {
        e.cancelled = true;
    } else {
        newEndings.stop();
        newEndings.bitmap.position = 0;
    }
}

function onStartSong() {
    var texts = CoolUtil.coolTextFile(Paths.txt("texts/completeTexts"));
    songName.text = FlxG.random.getObject(texts);
    door.animation.play("open");
    door.animation.finishCallback = (s)->{
        if (s == "open") {
            FlxTween.tween(camTrans, {zoom: 5}, 0.6, {onComplete: Void->{
                elevatorRetro = null;
                FlxG.cameras.remove(camTrans, true);
            }});
        }
    }
}

function draw() {
    if (!videoLoaded && newEndings != null && newEndings.bitmap.position > 0) {
        videoLoaded = true;
        startCountdown();
        newEndings.stop();
        newEndings.bitmap.position = 0;
    }
}

function onCutsceneTrigger(id, isEnd, skipped) if (id == "its earthworm sally") {
    if (!isEnd) {
        newEndings.play();
        newEndings.visible = camGame.visible = true;
        endingPlayed = true;
        yoButFuckingWaitForMe = false;
    } else {
        newEndings.stop();
        newEndings.visible = endingPlayed = false;
    }
}

function onSubstateOpen() {
    hehBro = true;
    if (endingPlayed) newEndings.pause();
}

function onFocus() {
    if (endingPlayed && hehBro) newEndings.pause();
    if (yoButFuckingWaitForMe && videoLoaded) {
        newEndings.pause();
        newEndings.bitmap.position = 0;
    }
}

function onSubstateClose() {
    hehBro = false;
    if (endingPlayed) newEndings.resume();
}

function destroy() {
    newEndings.destroy();
}

function itsEarthwormSally() {
    newEndings.bitmap.position = 0;
    if (!endingPlayed) {
        camGame.visible = false;
        newEndings.play();
        endingPlayed = true;
    } else newEndings.visible = false;
    new FlxTimer().start(0.1, () -> {newEndings.visible = true;});
};

function friend() {
    for (i in [dad, boyfriend, stage.stageSprites.get("highschool")]) {
        FlxTween.tween(i, {alpha: 0}, Conductor.crochet / 50, {ease: FlxEase.sineIn});
    }
}
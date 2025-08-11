import hxvlc.flixel.FlxVideoSprite;

var newEndings = new FlxVideoSprite();
var endingPlayed = false;
var videoLoaded = false;
var yoButFuckingWaitForMe = true;
var hehBro = false;

function postCreate() {
	newEndings.load(Assets.getPath(Paths.video("homonculus")));
    newEndings.camera = camHUD;
    newEndings.bitmap.onFormatSetup.add(function():Void {
        if (newEndings.bitmap != null && newEndings.bitmap.bitmapData != null) {
            final scale:Float = Math.max(FlxG.width / newEndings.bitmap.bitmapData.width, FlxG.height / newEndings.bitmap.bitmapData.height);
            newEndings.setGraphicSize(newEndings.bitmap.bitmapData.width * scale * 1.25, newEndings.bitmap.bitmapData.height * scale * 1.25);
            newEndings.updateHitbox();
            newEndings.screenCenter();
        }
    });
	newEndings.bitmap.onEndReached.add(function () {remove(newEndings.destroy()); endingPlayed = false; myFuckFucking();});
    newEndings.play();
    new FlxTimer().start(0.001, () -> {
        add(newEndings);
        if (scaryMode) {
            newEndings.color = 0xFFFF1111;
            newEndings.bitmap.rate = 0.8;
        }
    });
    newEndings.visible = false;
}

function draw() {
    if (!videoLoaded && newEndings != null && newEndings.bitmap.position > 0) {
        videoLoaded = true;
        newEndings.stop();
        newEndings.bitmap.position = 0;
    }
}

function onCutsceneTrigger(id, isEnd, skipped) if (id == "kill the fetus") {
    if (!isEnd) {
        newEndings.play();
        newEndings.visible = true;
        endingPlayed = true;
        yoButFuckingWaitForMe = false;
    } else {
        newEndings.stop();
        remove(newEndings.destroy());
        endingPlayed = false;
        myFuckFucking();
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
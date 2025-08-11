import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.MusicBeatState;
importScript("data/states/HJDElevator");

var newEndings = new FlxVideoSprite();
var endingPlayed = false;
var videoLoaded = false;
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
    camHUD.alpha = 0;
    camGame.visible = false;
	newEndings.load(Assets.getPath(Paths.video("dumb ah ah noob")));
    newEndings.scrollFactor.set();
    newEndings.bitmap.onFormatSetup.add(function():Void {
        if (newEndings.bitmap != null && newEndings.bitmap.bitmapData != null) {
            final scale:Float = Math.min(FlxG.width / newEndings.bitmap.bitmapData.width, FlxG.height / newEndings.bitmap.bitmapData.height);
            newEndings.setGraphicSize(newEndings.bitmap.bitmapData.width * scale, newEndings.bitmap.bitmapData.height * scale);
            newEndings.updateHitbox();
            newEndings.screenCenter();
        }
    });
	newEndings.bitmap.onEndReached.add(function () {remove(newEndings.destroy()); endingPlayed = false; camHUD.alpha = 1;});
    newEndings.bitmap.volume = 0;
	insert(999, newEndings);

    newEndings.alpha = 0.001;
    endingPlayed = true;
    newEndings.play();

    new FlxTimer().start(0.001, () -> {
        if (scaryMode) {
            newEndings.color = 0xFFFF1111;
            newEndings.bitmap.rate = 0.8;
        }
    });
}

function onCutsceneTrigger(id, isEnd) if (id == "noob intro" && isEnd && endingPlayed) {remove(newEndings.destroy()); endingPlayed = false; camHUD.alpha = 1;}

function onStartCountdown(e) {
    if (!videoLoaded) {
        e.cancelled = true;
    } else {
        newEndings.pause();
        newEndings.bitmap.position = 0;
    }
}

function draw() {
    if (newEndings != null && !videoLoaded && newEndings.bitmap.position > 0) {
        videoLoaded = true;
        newEndings.pause();
        newEndings.bitmap.position = 0;
        startCountdown();
    }
    if (newEndings != null && endingPlayed){
        newEndings.scale.set((1.9 / camGame.zoom) * 1.035, (1.9 / camGame.zoom) * 1.035);
        if (curCameraTarget == 0) {
            newEndings.alpha = Math.floor(CoolUtil.fpsLerp(newEndings.alpha, 0, 0.025) * 20) / 20;
            camHUD.alpha = 1 - newEndings.alpha;
        }
    }
}

function onStartSong() {
    newEndings.resume();
    newEndings.alpha = 1;
    newEndings.bitmap.position = 0;
    camGame.visible = true;
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
    csSkipText.camera = csBlackBox.camera = camSkip;
}

function onSubstateOpen() {
    hehBro = true;
    if (endingPlayed) newEndings.pause();
}

function onFocus() {
    if (endingPlayed && hehBro) newEndings.pause();
}

function onSubstateClose() {
    hehBro = false;
    if (endingPlayed && !startingSong) newEndings.resume();
}

function destroy() {
    newEndings.destroy();
}
import funkin.editors.charter.Charter;

function postCreate() {
    if (PlayState.instance.chartingMode && Charter.startHere) return;
    camGame.zoom = defaultCamZoom = 0.55;
}

var flipy = false;
var flipCheck = false;

function flipIt() flipCheck = !flipCheck;

function beatHit() if (flipCheck) {
    for (i=>cam in [camGame, camHUD]) {
        cam.angle = (i == 0 ? 2 : 1) * (flipy ? 1 : -1);
        FlxTween.tween(cam, {angle: 0}, Conductor.crochet / 1000 - 0.05, {ease: FlxEase.quadOut});
    }
    flipy = !flipy;
}

function yup(yeah) switch (yeah) {
    case "1": FlxTween.tween(camGame, {angle: 3}, Conductor.crochet / 500, {ease: FlxEase.backIn});
    case "2": FlxTween.tween(camGame, {angle: 2}, Conductor.crochet / 500, {ease: FlxEase.quadOut});
    case "3": FlxTween.tween(camGame, {angle: -3}, Conductor.crochet / 1000, {ease: FlxEase.backIn});
}
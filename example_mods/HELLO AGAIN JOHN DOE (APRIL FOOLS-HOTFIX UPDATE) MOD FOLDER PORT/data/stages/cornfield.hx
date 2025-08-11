var cycles:Float = 0;
function create() {
    rgb = new CustomShader("ColorSwap");
    rgb.uTime = 0;

    contrast = new CustomShader("contrast");
    contrast.contrast = 1;
    contrast.saturation = 1;

    drunk = new CustomShader("drunk");
    drunk.strength = 0;
    drunk.daTime = 0;
}

var drunkMode = false;
function itsSuperDrunkTime() {
    if (!Options.flashingMenu) return;
    drunkMode = !drunkMode;
    if (drunkMode) {
        camGame.addShader(contrast);
        camGame.addShader(drunk);
        isolation.shader = rgb;
        FlxTween.num(0, 0.5, 3, {ease: FlxEase.sineInOut}, function(num) {
            cycles = num;
        });
        FlxTween.tween(contrast, {saturation: 10, contrast: 1.5}, 3, {ease: FlxEase.sineInOut});
        FlxTween.tween(drunk, {strength: 1}, 3, {ease: FlxEase.sineInOut});
    } else {
        FlxTween.cancelTweensOf(contrast);
        FlxTween.cancelTweensOf(drunk);
        FlxTween.tween(contrast, {saturation: 1, contrast: 1}, 1, {ease: FlxEase.sineInOut});
        FlxTween.tween(drunk, {strength: 0}, 1, {ease: FlxEase.sineInOut});
        FlxTween.tween(rgb, {uTime: Math.ceil(rgb.uTime)}, 1.5, {ease: FlxEase.sineInOut});
    }
}

function update(elapsed) if (drunkMode) {
    drunk.daTime += (elapsed * 2) * cycles;
    rgb.uTime += (elapsed / 5) * cycles;
}
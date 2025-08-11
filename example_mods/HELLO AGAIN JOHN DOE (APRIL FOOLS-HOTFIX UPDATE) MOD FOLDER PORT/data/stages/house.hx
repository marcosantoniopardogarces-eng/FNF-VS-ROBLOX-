function postCreate() {
    house2.visible = false;
    powers = new CustomShader("drunk");
    powers.daTime = 0.0;
    powers.strength = 0.0;
}

function update(elapsed) powers.daTime += elapsed;

function boiii() trace(camFollow);

function toggleCheese() for (housy in [house, house2]) housy.visible = !housy.visible;

function itsTime() {
    camGame.addShader(powers);
    FlxTween.tween(powers, {strength: 1}, 5, {ease: FlxEase.circInOut});
    FlxTween.num(0, 20, 5, {ease: FlxEase.circInOut}, function(num) {
        house2.color = CoolUtil.lerpColor(0xFFFFFFFF, 0xFFFFAA22, Math.floor(num)/20);
    });
}

function ohHesGone() {
    FlxTween.tween(powers, {strength: 0}, 1, {ease: FlxEase.circOut, onComplete: (_) -> {
        camGame.removeShader(powers);
    }});
    FlxTween.num(20, 0, 1, {ease: FlxEase.circOut}, function(num) {
        house2.color = CoolUtil.lerpColor(0xFFFFFFFF, 0xFFFFAA22, Math.floor(num)/20);
    });
}
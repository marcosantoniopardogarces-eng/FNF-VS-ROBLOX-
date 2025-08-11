var darkenTween:FlxTween;
var isItDark = false;

function darkenIt() {
    if (darkenTween != null) darkenTween.cancel();
    darkenTween = FlxTween.num(20, 0, isItDark ? 0.5 : 0.75, {ease: FlxEase.circOut}, function(num) {
        highschool.color = CoolUtil.lerpColor(isItDark ? 0xFF333355 : 0xFFFFFFFF, isItDark ? 0xFFFFFFFF : 0xFF333355, Math.floor(num)/20);
    });
    isItDark = !isItDark;
}
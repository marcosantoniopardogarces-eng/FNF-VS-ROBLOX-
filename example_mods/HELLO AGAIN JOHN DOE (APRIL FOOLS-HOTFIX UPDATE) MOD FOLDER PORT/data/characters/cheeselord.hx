import flixel.tweens.FlxTweenType;

function postCreate() {
    this.x -= 200;
    FlxTween.tween(this, {x: this.x + 400}, 3, {ease: FlxEase.sineInOut, type: FlxTweenType.PINGPONG});
    FlxTween.tween(this, {y: this.y + 100}, 1.5, {ease: FlxEase.sineInOut, type: FlxTweenType.PINGPONG});
}
// guys its like the one from hello john doe guys !! its like the same thing guys.

function update() {
    if (FlxG.keys.justPressed.TWO) {
        FlxG.sound.music.time += 10000;
        resyncVocals();
        // cne doesnt have an equivalent to clearNotesBefore i dont think
        for (strumLine in strumLines.members) for (note in strumLine.notes)
            if (note.strumTime < Conductor.songPosition) remove(note.destroy(), false);
    }
}
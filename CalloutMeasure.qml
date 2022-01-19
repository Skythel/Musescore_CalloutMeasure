//=============================================================================
//  Callout Measure by Skythel (2022)
// 	based on the Count Notes Plugin
//  Copyright (C)2011 Mike Magatagan
//  port to qml: Copyright (C) 2016 Johan Temmerman (jeetee)
//  update to MS3: Copyright (C) 2020 Johan Temmerman (jeetee)
//  note name detection from the Note Names plugin of the MuseScore distribution
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//=============================================================================
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0
// FileDialog
import Qt.labs.folderlistmodel 2.1
import QtQml 2.2

import MuseScore 3.0

MuseScore {
	menuPath: 'Plugins.Notes.CalloutMeasure'
	version: '0.0.1'
	description: 'A modified version of CountNotes that writes the counted notes into bars at the front of the score.'
	requiresScore: true

	width:  360
	height: 90

	onRun: {
		if (!curScore) {
			console.log(qsTranslate("QMessageBox", "No score open.\nThis plugin requires an open score to run.\n"));
			Qt.quit();
		}
              countNotes();
              Qt.quit();
	}

	function countNotes()
	{
		var count = {
			flats: 0,
			sharps: 0,
			bells: 0,
			notes: []//octaves array, for each octave nest the pitches as properties
		};
		var cursor = curScore.newCursor();
		var note = null;//used in the analysis loop
		
		for (var track = curScore.ntracks; track-- > 0; ) {
			cursor.track = track;
			cursor.rewind(0);
			//loop over all chords in this track
			while (cursor.segment) {
				if (cursor.element && (cursor.element.type === Element.CHORD)) {
					//graceNotes are a chord-array
					for (var gc = cursor.element.graceNotes.length; gc-- > 0; ) {
					//each note in this graceChord
						for (note = cursor.element.graceNotes[gc].notes.length; note-- > 0; ) {
							processNoteIntoCount(cursor.element.graceNotes[gc].notes[note], count);
						}
					}
					//normal notes
					for (note = cursor.element.notes.length; note-- > 0; ) {
						processNoteIntoCount(cursor.element.notes[note], count);
					}
				}
				cursor.next();
			} //end segment loop
		}
		saveNotes(count);
	}

	function processNoteIntoCount(note, count)
	{
		var octave = Math.floor(note.pitch / 12); //MIDI pitch to octave
		if (!count.notes[octave]) { //didn't have this octave yet
			count.notes[octave] = [];
		}
		var tpc = getTpcInfo(note.tpc); //tonal pitch class
		//check if we've already registered this note
		var i = 0;
		while ((i < count.notes[octave].length) && (count.notes[octave][i].pitch < note.pitch)) {
			i++;
		}
		if (   (i == count.notes[octave].length)
			|| (count.notes[octave][i] && (count.notes[octave][i].pitch > note.pitch))
			) {//last or higher pitched notes in this octave were already detected
			for (var j = count.notes[octave].length; j > i; --j) { //shift them
				count.notes[octave][j] = count.notes[octave][j - 1];
			}
			//add new note
			count.bells++;
			count.notes[octave][i] = {
				pitch: note.pitch,
				text: tpc.text + (octave - 1)
			};
			if (tpc.isFlat) {
				count.flats++;
			}
			else if (tpc.isSharp) {
				count.sharps++;
			}
		}
	}

	function getTpcInfo(tpc)
	{
		var res = {
			isFlat: (tpc < 13),
			isSharp: (tpc > 19),
			text: '-' //default case
		};
		switch (tpc) {
			case -1: res.text = qsTranslate("InspectorAmbitus", "F♭♭"); break;
			case  0: res.text = qsTranslate("InspectorAmbitus", "C♭♭"); break;
			case  1: res.text = qsTranslate("InspectorAmbitus", "G♭♭"); break;
			case  2: res.text = qsTranslate("InspectorAmbitus", "D♭♭"); break;
			case  3: res.text = qsTranslate("InspectorAmbitus", "A♭♭"); break;
			case  4: res.text = qsTranslate("InspectorAmbitus", "E♭♭"); break;
			case  5: res.text = qsTranslate("InspectorAmbitus", "B♭♭"); break;
			
			case  6: res.text = qsTranslate("InspectorAmbitus", "F♭"); break;
			case  7: res.text = qsTranslate("InspectorAmbitus", "C♭"); break;
			case  8: res.text = qsTranslate("InspectorAmbitus", "G♭"); break;
			case  9: res.text = qsTranslate("InspectorAmbitus", "D♭"); break;
			case 10: res.text = qsTranslate("InspectorAmbitus", "A♭"); break;
			case 11: res.text = qsTranslate("InspectorAmbitus", "E♭"); break;
			case 12: res.text = qsTranslate("InspectorAmbitus", "B♭"); break;
			
			case 13: res.text = qsTranslate("InspectorAmbitus", "F"); break;
			case 14: res.text = qsTranslate("InspectorAmbitus", "C"); break;
			case 15: res.text = qsTranslate("InspectorAmbitus", "G"); break;
			case 16: res.text = qsTranslate("InspectorAmbitus", "D"); break;
			case 17: res.text = qsTranslate("InspectorAmbitus", "A"); break;
			case 18: res.text = qsTranslate("InspectorAmbitus", "E"); break;
			case 19: res.text = qsTranslate("InspectorAmbitus", "B"); break;
			
			case 20: res.text = qsTranslate("InspectorAmbitus", "F♯"); break;
			case 21: res.text = qsTranslate("InspectorAmbitus", "C♯"); break;
			case 22: res.text = qsTranslate("InspectorAmbitus", "G♯"); break;
			case 23: res.text = qsTranslate("InspectorAmbitus", "D♯"); break;
			case 24: res.text = qsTranslate("InspectorAmbitus", "A♯"); break;
			case 25: res.text = qsTranslate("InspectorAmbitus", "E♯"); break;
			case 26: res.text = qsTranslate("InspectorAmbitus", "B♯"); break;
			
			case 27: res.text = qsTranslate("InspectorAmbitus", "F♯♯"); break;
			case 28: res.text = qsTranslate("InspectorAmbitus", "C♯♯"); break;
			case 29: res.text = qsTranslate("InspectorAmbitus", "G♯♯"); break;
			case 30: res.text = qsTranslate("InspectorAmbitus", "D♯♯"); break;
			case 31: res.text = qsTranslate("InspectorAmbitus", "A♯♯"); break;
			case 32: res.text = qsTranslate("InspectorAmbitus", "E♯♯"); break;
			case 33: res.text = qsTranslate("InspectorAmbitus", "B♯♯"); break;
		}
		/*if (useSafeASCII.checked) {
			res.text = res.text.replace('♭', 'b').replace('♯', '#').replace('?', 'b'); //replace ? as well, as some translations currently already return that
		}*/
		return res;
	}


	function saveNotes(count)
	{
             
		var octaveRange = { min: 11, max: 0 };
             
             var cursor = curScore.newCursor();
             cursor.rewind(0);
             // possible way to dynamically insert measures: 
             // remember the "first" measure object and check if cursor.next matches
             
             // select the first measure
             cmd("first-element");
             // placeholder insert 12 measures
             for(var i=0; i<12; i++) 
                  cmd("insert-measure");
             
             cmd("first-element");
             
             /*
             // change time sig
             var num = count.bells;
             var den = 4;
             var ts = newElement(Element.TIMESIG);
             ts.timesig = fraction(num, den);
             cursor.add(ts);
             */
             
             // 2 cursors for bass and treble
             var trebcursor = curScore.newCursor();
             var basscursor = curScore.newCursor();
             trebcursor.rewind(0);
             basscursor.rewind(0);
             trebcursor.staffIdx = 0;
             basscursor.staffIdx = 1;
             
		for (var octave = 0; octave < count.notes.length; ++octave) {
			if (count.notes[octave] && count.notes[octave].length) {//octave is used
				// content += crlf; //separate octaves with a blank line
				if (octave < octaveRange.min) {
					octaveRange.min = octave;
				}
				if (octave > octaveRange.max) {
					octaveRange.max = octave;
				}
				//save the notes of this octave
				for (var note = 0; note < count.notes[octave].length; ++note) {
					console.log(count.notes[octave][note].text);
					var pitch = count.notes[octave][note].pitch;
					console.log("add note pitch "+pitch);
					// put C4 and below in bass clef
					if(pitch > 60) {
						trebcursor.addNote(pitch);
					}
					else {
						basscursor.addNote(pitch);
					}
				}
			}
		}
		/*
		cmd("first-element");
		// select the measures
		for(var i=0; i<10; i++) {
			cmd("select-next-measure");
		}
		cmd("join-measures");
		// delete empty measures
		// cmd("del-empty-measures");
		*/
	}

}

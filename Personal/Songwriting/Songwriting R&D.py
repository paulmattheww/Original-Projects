import pandas as pd
import numpy as np
from collections import OrderedDict
import math

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)
 
class song:
    def __init__(self, dictionary):
        for k, v in dictionary.items():
            setattr(self, k, v)
 
    def generate_song_structure(self):
        ## Count up the beats in each section
        introBeats = sum(self.introSequence.values())
        oneVerseBeats = sum(self.verseSequence.values())
        allVerseBeats = oneVerseBeats * self.nVerses
        oneChorusBeats = sum(self.chorusSequence.values())
        allChorusBeats = oneChorusBeats * self.nVerses
        surpriseBeats = sum(self.surpriseSequence.values())
        bridgeBeats = sum(self.bridgeSequence.values())
        soloBeats = oneVerseBeats * self.solo
        if self.abruptEnding==False:
            outroBeats = introBeats
        else:
            outroBeats = 0
        totalBeats = introBeats+allVerseBeats+allChorusBeats+surpriseBeats+bridgeBeats+soloBeats+outroBeats
        IX = np.arange(0,totalBeats)
       
        ## Get all beats into one dictionary
        beatDict = {}
        allDicts = [self.introSequence,self.verseSequence,self.chorusSequence,
                                  self.surpriseSequence,self.bridgeSequence,self.verseSequence,self.introSequence]
        df = pd.DataFrame()
       
        t = 1
        for i, dic in enumerate(allDicts):
            for key, value in dic.items():
                for beat in range(value):
                    df.loc[t, 'Chord'] = key
                    t += 1
                  
        df.index.name = 'Beat@'+str(self.bpm)+'BPM'
        df['BeatInMeasure'] = ((df.index.values-1) % self.timeSignatureUpper)+1
        df['Measure'] = df.groupby('BeatInMeasure').BeatInMeasure.cumcount()
        #[np.repeat(i, self.timeSignatureUpper) 
                         #for i in np.arange(0, math.floor(df.index.values.max() / self.timeSignatureUpper))]
        return df
 
 
# chord : beats
introSeq = OrderedDict([('A',6), ('G',6), ('D',6), ('A',6), ('E',3), ('E7',3), ('A',6)])
verseSeq = OrderedDict([('A',6), ('E',6), ('F#m',6), ('D',6)])
chorusSeq = OrderedDict([('A',6), ('G',6), ('Dsus2',6), ('A',6), ('E',3), ('E7',3), ('A',6)])
surpriseSeq = OrderedDict([('A',6), ('Am',6), ('Dm',3), ('Dm/F',3), ('Bb/F',6), ('A',6), ('E',6)])
bridgeSeq = OrderedDict([('A',3), ('D',3), ('C#m/D',3), ('Bm',3), ('A',3), ('G',3), ('D',3)])
nVerses = 4
nSolos = 3
accentBeat = 5
nSocialIssues = nVerses
energyLevel = 6/10
BPM = 77
 
newSong = {'name':'Sails of Thought',
           'key':'A major',
           'timeSignatureUpper':6,
           'timeSignatureLower':8,
           'bpm':BPM,
           'verseSequence':verseSeq,
           'chorusSequence':chorusSeq,
           'surpriseSequence':surpriseSeq,
           'bridgeSequence':bridgeSeq,
           'theme':'Shortcomings of Humanity',
           'imagery':'Self inflicted wounds',
           'dominantEmotion':'Being Misunderstood',
           'contrasts':nVerses,
           'rhymeStructure':True,
           'melodicTheme':False,
           'backupVocals':True,
           'counterpoint':True,
           'keyChange':True,
           'metaphor':True,
           'onomonopoea':True,
           'solo':nSolos,
           'soloInstruments':1,
           'accentBeat':accentBeat,
           'socialIssues':nSocialIssues,
           'nVerses':nVerses,
           'introSequence':introSeq,
           'crescendo':True,
           'energyLevel':energyLevel,
           'tensionReleaseCycle':True,
           'doubleEntendre':False,
           'internalConflict':True,
           'abruptEnding':True}
df = song(newSong).generate_song_structure()
df.transpose()

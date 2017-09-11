# -*- coding: utf-8 -*-

import textgridParser
import re
from zhon.hanzi import punctuation as puncChinese
# from string import punctuation as puncWestern
import os

def boundaryLabWriter(boundaryList, outputFilename, label=False):
    '''
    Write the boundary list into .lab
    :param boundaryList:
    :param outputFilename:
    :return:
    '''

    directory,_ = os.path.split(outputFilename)
    if not os.path.exists(directory):
        os.makedirs(directory)

    with open(outputFilename, "w") as lab_file:
        for list in boundaryList:
            if label:
                # delete Chinese punctuation
                syllable = re.sub(ur"[%s]+" %puncChinese, "", list[2])
                syllable = re.sub(ur"[%s]+" %puncChinese, "", syllable)
                syllable = syllable.replace(" ", "")

                lab_file.write("{0:.4f} {1:.4f} {2}\n".format(list[0],list[1],syllable))
            else:
                lab_file.write("{0:.4f} {1:.4f}\n".format(list[0],list[1]))

def phraseBoundaryWriter(textgrid_file, outputFilename):
    '''
    Write phrase boundary from textgrid into outputFilename, example: .syll.lab
    :param textgrid_file:
    :param outputFilename:
    :return:
    '''

    # read phrase list and utterance list
    lineList                    = textgridParser.textGrid2WordList(textgrid_file, whichTier='line')
    utteranceList               = textgridParser.textGrid2WordList(textgrid_file, whichTier='dianSilence')

    # parse lines of groundtruth
    nestedUtteranceLists, numLines, numUtterances = textgridParser.wordListsParseByLines(lineList, utteranceList)

    # phrase start, end time
    nonEmptyLineList            = []

    for list in nestedUtteranceLists:
        nonEmptyLineList.append(list[0])

    boundaryLabWriter(nonEmptyLineList, outputFilename)
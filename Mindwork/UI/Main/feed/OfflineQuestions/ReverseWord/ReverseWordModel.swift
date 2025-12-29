//
//  ReverseWordModel.swift
//  ReverseWord
//
//  Created by Sena Yıldız on 21.12.2025.
//

import Foundation

struct ReverseWordModel {

    static let wordBankByLength: [Int: [String]] = [
        3: [
            "cat","sun","map","pen","cup","fog","ice","key","owl","box",
            "dog","car","hat","run","toy","bat","pie","jam","bee","sky",
            "fox","egg","gum","lid","oak","ink","fan","net","zip","ray"
        ],
        4: [
            "game","note","wind","lamp","tree","book","milk","road","fish","time",
            "door","star","rain","ship","ring","desk","snow","rock","sand","fire",
            "gold","blue","pink","seed","wolf","bird","code","mint","base","hope"
        ],
        5: [
            "apple","train","light","smile","stone","water","chair","bread","world","phone",
            "music","dream","magic","happy","smart","table","glass","beach","river","plant",
            "heart","sweet","fresh","brave","quiet","flame","candy","watch","grape","storm"
        ],
        6: [
            "planet","orange","silver","bridge","flower","memory","puzzle","wonder","screen","travel",
            "rocket","castle","forest","little","answer","camera","school","inside","moment","circle",
            "victor","bright","monkey","summer","winter","basket","garden","button","rabbit","damage"
        ],
        7: [
            "science","company","picture","morning","kitchen","teacher","balance","journey","diamond","imagine",
            "general","project","freedom","history","present","support","library","fitness","whisper","village",
            "promise","natural","curious","another","justice","passion","nervous","breathe","genuine","holiday"
        ],
        8: [
            "computer","elephant","football","hospital","language","mountain","notebook","triangle","building","practice",
            "airplane","sandwich","calendar","football","painting","strategy","wireless","password","tutorial","keyboard",
            "overcome","sunshine","storybook","headline","wildlife","weekend","handmade","bluebird","pipeline","reliable"
        ],
        9: [
            "education","beautiful","adventure","important","chocolate","different","breakfast","strawberry","knowledge","happiness",
            "connection","calculator","dictionary","invitation","government","wonderful","community","foundation","motivation","developer",
            "algorithm","revolution","incredible","confidence","challenge","classroom","discovery","improving","smartphone","transport"
        ],
        10: [
            "basketball","friendship","technology","programming","imagination","motivation","celebration","photography","navigation","repetition",
            "collections","development","application","reflection","competition","information","environment","performance","conversation","generation",
            "enrichment","interesting","exploration","projection","calibration","inspection","interaction","presentation","arrangement","foundation"
        ]
    ]

    static func reversed(_ word: String) -> String {
        String(word.reversed())
    }
}

require "spec"
require "./day19"

describe "Day 19" do
  describe "problem19" do
    it "sample" do
      input = [
        "--- scanner 0 ---",
        "404,-588,-901",
        "528,-643,409",
        "-838,591,734",
        "390,-675,-793",
        "-537,-823,-458",
        "-485,-357,347",
        "-345,-311,381",
        "-661,-816,-575",
        "-876,649,763",
        "-618,-824,-621",
        "553,345,-567",
        "474,580,667",
        "-447,-329,318",
        "-584,868,-557",
        "544,-627,-890",
        "564,392,-477",
        "455,729,728",
        "-892,524,684",
        "-689,845,-530",
        "423,-701,434",
        "7,-33,-71",
        "630,319,-379",
        "443,580,662",
        "-789,900,-551",
        "459,-707,401",
        "",
        "--- scanner 1 ---",
        "686,422,578",
        "605,423,415",
        "515,917,-361",
        "-336,658,858",
        "95,138,22",
        "-476,619,847",
        "-340,-569,-846",
        "567,-361,727",
        "-460,603,-452",
        "669,-402,600",
        "729,430,532",
        "-500,-761,534",
        "-322,571,750",
        "-466,-666,-811",
        "-429,-592,574",
        "-355,545,-477",
        "703,-491,-529",
        "-328,-685,520",
        "413,935,-424",
        "-391,539,-444",
        "586,-435,557",
        "-364,-763,-893",
        "807,-499,-711",
        "755,-354,-619",
        "553,889,-390",
        "",
        "--- scanner 2 ---",
        "649,640,665",
        "682,-795,504",
        "-784,533,-524",
        "-644,584,-595",
        "-588,-843,648",
        "-30,6,44",
        "-674,560,763",
        "500,723,-460",
        "609,671,-379",
        "-555,-800,653",
        "-675,-892,-343",
        "697,-426,-610",
        "578,704,681",
        "493,664,-388",
        "-671,-858,530",
        "-667,343,800",
        "571,-461,-707",
        "-138,-166,112",
        "-889,563,-600",
        "646,-828,498",
        "640,759,510",
        "-630,509,768",
        "-681,-892,-333",
        "673,-379,-804",
        "-742,-814,-386",
        "577,-820,562",
        "",
        "--- scanner 3 ---",
        "-589,542,597",
        "605,-692,669",
        "-500,565,-823",
        "-660,373,557",
        "-458,-679,-417",
        "-488,449,543",
        "-626,468,-788",
        "338,-750,-386",
        "528,-832,-391",
        "562,-778,733",
        "-938,-730,414",
        "543,643,-506",
        "-524,371,-870",
        "407,773,750",
        "-104,29,83",
        "378,-903,-323",
        "-778,-728,485",
        "426,699,580",
        "-438,-605,-362",
        "-469,-447,-387",
        "509,732,623",
        "647,635,-688",
        "-868,-804,481",
        "614,-800,639",
        "595,780,-596",
        "",
        "--- scanner 4 ---",
        "727,592,562",
        "-293,-554,779",
        "441,611,-461",
        "-714,465,-776",
        "-743,427,-804",
        "-660,-479,-426",
        "832,-632,460",
        "927,-485,-438",
        "408,393,-506",
        "466,436,-512",
        "110,16,151",
        "-258,-428,682",
        "-393,719,612",
        "-211,-452,876",
        "808,-476,-593",
        "-575,615,604",
        "-485,667,467",
        "-680,325,-822",
        "-627,-443,-432",
        "872,-547,-609",
        "833,512,582",
        "807,604,487",
        "839,-516,451",
        "891,-625,532",
        "-652,-548,-490",
        "30,-46,-14",
      ]
      actual = problem19(input)
      actual.should eq(79)
    end
  end

  describe Scanner do
    describe "#overlap" do
      it "sample one" do
        input = [
          "--- scanner 0 ---",
          "404,-588,-901",
          "528,-643,409",
          "-838,591,734",
          "390,-675,-793",
          "-537,-823,-458",
          "-485,-357,347",
          "-345,-311,381",
          "-661,-816,-575",
          "-876,649,763",
          "-618,-824,-621",
          "553,345,-567",
          "474,580,667",
          "-447,-329,318",
          "-584,868,-557",
          "544,-627,-890",
          "564,392,-477",
          "455,729,728",
          "-892,524,684",
          "-689,845,-530",
          "423,-701,434",
          "7,-33,-71",
          "630,319,-379",
          "443,580,662",
          "-789,900,-551",
          "459,-707,401",
          "",
          "--- scanner 1 ---",
          "686,422,578",
          "605,423,415",
          "515,917,-361",
          "-336,658,858",
          "95,138,22",
          "-476,619,847",
          "-340,-569,-846",
          "567,-361,727",
          "-460,603,-452",
          "669,-402,600",
          "729,430,532",
          "-500,-761,534",
          "-322,571,750",
          "-466,-666,-811",
          "-429,-592,574",
          "-355,545,-477",
          "703,-491,-529",
          "-328,-685,520",
          "413,935,-424",
          "-391,539,-444",
          "586,-435,557",
          "-364,-763,-893",
          "807,-499,-711",
          "755,-354,-619",
          "553,889,-390",
        ]
        scanners = Scanner.parse(input)
        actual = scanners[0].overlap(scanners[1])
        actual.size.should eq(12)
      end

      it "2d example" do
        input = [
          "--- scanner 0 ---",
          "0,2,0",
          "4,1,0",
          "3,3,0",
          "",
          "--- scanner 1 ---",
          "-1,-1,0",
          "-5,0,0",
          "-2,1,0",
        ]
        scanners = Scanner.parse(input)
        actual = scanners[0].overlap(scanners[1])
        actual.size.should eq(3)
      end
    end

    describe "#detect_scanner_coord" do
      it "find scanner 1" do
        input = [
          "--- scanner 0 ---",
          "404,-588,-901",
          "528,-643,409",
          "-838,591,734",
          "390,-675,-793",
          "-537,-823,-458",
          "-485,-357,347",
          "-345,-311,381",
          "-661,-816,-575",
          "-876,649,763",
          "-618,-824,-621",
          "553,345,-567",
          "474,580,667",
          "-447,-329,318",
          "-584,868,-557",
          "544,-627,-890",
          "564,392,-477",
          "455,729,728",
          "-892,524,684",
          "-689,845,-530",
          "423,-701,434",
          "7,-33,-71",
          "630,319,-379",
          "443,580,662",
          "-789,900,-551",
          "459,-707,401",
          "",
          "--- scanner 1 ---",
          "686,422,578",
          "605,423,415",
          "515,917,-361",
          "-336,658,858",
          "95,138,22",
          "-476,619,847",
          "-340,-569,-846",
          "567,-361,727",
          "-460,603,-452",
          "669,-402,600",
          "729,430,532",
          "-500,-761,534",
          "-322,571,750",
          "-466,-666,-811",
          "-429,-592,574",
          "-355,545,-477",
          "703,-491,-529",
          "-328,-685,520",
          "413,935,-424",
          "-391,539,-444",
          "586,-435,557",
          "-364,-763,-893",
          "807,-499,-711",
          "755,-354,-619",
          "553,889,-390",
        ]
        scanners = Scanner.parse(input)
        actual = scanners[0].detect_scanner_coord(scanners[1])
        scanners[1].coord.should eq({68, -1246, -43})
      end

      it "three scanners" do
        input = [
          "--- scanner 0 ---",
          "404,-588,-901",
          "528,-643,409",
          "-838,591,734",
          "390,-675,-793",
          "-537,-823,-458",
          "-485,-357,347",
          "-345,-311,381",
          "-661,-816,-575",
          "-876,649,763",
          "-618,-824,-621",
          "553,345,-567",
          "474,580,667",
          "-447,-329,318",
          "-584,868,-557",
          "544,-627,-890",
          "564,392,-477",
          "455,729,728",
          "-892,524,684",
          "-689,845,-530",
          "423,-701,434",
          "7,-33,-71",
          "630,319,-379",
          "443,580,662",
          "-789,900,-551",
          "459,-707,401",
          "",
          "--- scanner 1 ---",
          "686,422,578",
          "605,423,415",
          "515,917,-361",
          "-336,658,858",
          "95,138,22",
          "-476,619,847",
          "-340,-569,-846",
          "567,-361,727",
          "-460,603,-452",
          "669,-402,600",
          "729,430,532",
          "-500,-761,534",
          "-322,571,750",
          "-466,-666,-811",
          "-429,-592,574",
          "-355,545,-477",
          "703,-491,-529",
          "-328,-685,520",
          "413,935,-424",
          "-391,539,-444",
          "586,-435,557",
          "-364,-763,-893",
          "807,-499,-711",
          "755,-354,-619",
          "553,889,-390",
          "",
          "--- scanner 4 ---",
          "727,592,562",
          "-293,-554,779",
          "441,611,-461",
          "-714,465,-776",
          "-743,427,-804",
          "-660,-479,-426",
          "832,-632,460",
          "927,-485,-438",
          "408,393,-506",
          "466,436,-512",
          "110,16,151",
          "-258,-428,682",
          "-393,719,612",
          "-211,-452,876",
          "808,-476,-593",
          "-575,615,604",
          "-485,667,467",
          "-680,325,-822",
          "-627,-443,-432",
          "872,-547,-609",
          "833,512,582",
          "807,604,487",
          "839,-516,451",
          "891,-625,532",
          "-652,-548,-490",
          "30,-46,-14",
        ]
        scanners = Scanner.parse(input)
        subject = scanners[0]
        subject.merge(scanners[1])

        subject.detect_scanner_coord(scanners[2])
        scanners[2].coord.should eq({-20, -1133, 1061})
        scanners[2].orientation.should eq({-1, -1, 1, 1, 2, 0})
      end
    end

    describe "#merge" do
      it "two first scanners" do
        input = [
          "--- scanner 0 ---",
          "404,-588,-901",
          "528,-643,409",
          "-838,591,734",
          "390,-675,-793",
          "-537,-823,-458",
          "-485,-357,347",
          "-345,-311,381",
          "-661,-816,-575",
          "-876,649,763",
          "-618,-824,-621",
          "553,345,-567",
          "474,580,667",
          "-447,-329,318",
          "-584,868,-557",
          "544,-627,-890",
          "564,392,-477",
          "455,729,728",
          "-892,524,684",
          "-689,845,-530",
          "423,-701,434",
          "7,-33,-71",
          "630,319,-379",
          "443,580,662",
          "-789,900,-551",
          "459,-707,401",
          "",
          "--- scanner 1 ---",
          "686,422,578",
          "605,423,415",
          "515,917,-361",
          "-336,658,858",
          "95,138,22",
          "-476,619,847",
          "-340,-569,-846",
          "567,-361,727",
          "-460,603,-452",
          "669,-402,600",
          "729,430,532",
          "-500,-761,534",
          "-322,571,750",
          "-466,-666,-811",
          "-429,-592,574",
          "-355,545,-477",
          "703,-491,-529",
          "-328,-685,520",
          "413,935,-424",
          "-391,539,-444",
          "586,-435,557",
          "-364,-763,-893",
          "807,-499,-711",
          "755,-354,-619",
          "553,889,-390",
        ]
        scanners = Scanner.parse(input)
        subject = scanners[0]
        actual = subject.merge(scanners[1])
        subject.beacons.size.should eq(38)
      end

      it "2d example" do
        input = [
          "--- scanner 0 ---",
          "0,2,0",
          "4,1,0",
          "3,3,0",
          "",
          "--- scanner 1 ---",
          "-1,-1,0",
          "-5,0,0",
          "-2,1,0",
        ]
        scanners = Scanner.parse(input)
        scanners[0].merge(scanners[1])
        scanners[0].beacons.size.should eq(3)
      end

      it "three scanners" do
        input = [
          "--- scanner 0 ---",
          "404,-588,-901",
          "528,-643,409",
          "-838,591,734",
          "390,-675,-793",
          "-537,-823,-458",
          "-485,-357,347",
          "-345,-311,381",
          "-661,-816,-575",
          "-876,649,763",
          "-618,-824,-621",
          "553,345,-567",
          "474,580,667",
          "-447,-329,318",
          "-584,868,-557",
          "544,-627,-890",
          "564,392,-477",
          "455,729,728",
          "-892,524,684",
          "-689,845,-530",
          "423,-701,434",
          "7,-33,-71",
          "630,319,-379",
          "443,580,662",
          "-789,900,-551",
          "459,-707,401",
          "",
          "--- scanner 1 ---",
          "686,422,578",
          "605,423,415",
          "515,917,-361",
          "-336,658,858",
          "95,138,22",
          "-476,619,847",
          "-340,-569,-846",
          "567,-361,727",
          "-460,603,-452",
          "669,-402,600",
          "729,430,532",
          "-500,-761,534",
          "-322,571,750",
          "-466,-666,-811",
          "-429,-592,574",
          "-355,545,-477",
          "703,-491,-529",
          "-328,-685,520",
          "413,935,-424",
          "-391,539,-444",
          "586,-435,557",
          "-364,-763,-893",
          "807,-499,-711",
          "755,-354,-619",
          "553,889,-390",
          "",
          "--- scanner 4 ---",
          "727,592,562",
          "-293,-554,779",
          "441,611,-461",
          "-714,465,-776",
          "-743,427,-804",
          "-660,-479,-426",
          "832,-632,460",
          "927,-485,-438",
          "408,393,-506",
          "466,436,-512",
          "110,16,151",
          "-258,-428,682",
          "-393,719,612",
          "-211,-452,876",
          "808,-476,-593",
          "-575,615,604",
          "-485,667,467",
          "-680,325,-822",
          "-627,-443,-432",
          "872,-547,-609",
          "833,512,582",
          "807,604,487",
          "839,-516,451",
          "891,-625,532",
          "-652,-548,-490",
          "30,-46,-14",
        ]
        scanners = Scanner.parse(input)
        subject = scanners[0]
        subject.merge(scanners[1])

        beacons = subject.overlap(scanners[2])
        beacons.size.should eq(12)
        beacons.keys.map(&.coord).sort.should eq([
          {459, -707, 401},
          {-739, -1745, 668},
          {-485, -357, 347},
          {432, -2009, 850},
          {528, -643, 409},
          {423, -701, 434},
          {-345, -311, 381},
          {408, -1815, 803},
          {534, -1912, 768},
          {-687, -1600, 576},
          {-447, -329, 318},
          {-635, -1737, 486},
        ].sort)

        puts beacons.join("\n")
      end

      it "four scanners" do
        input = [
          "--- scanner 0 ---",
          "404,-588,-901",
          "528,-643,409",
          "-838,591,734",
          "390,-675,-793",
          "-537,-823,-458",
          "-485,-357,347",
          "-345,-311,381",
          "-661,-816,-575",
          "-876,649,763",
          "-618,-824,-621",
          "553,345,-567",
          "474,580,667",
          "-447,-329,318",
          "-584,868,-557",
          "544,-627,-890",
          "564,392,-477",
          "455,729,728",
          "-892,524,684",
          "-689,845,-530",
          "423,-701,434",
          "7,-33,-71",
          "630,319,-379",
          "443,580,662",
          "-789,900,-551",
          "459,-707,401",
          "",
          "--- scanner 1 ---",
          "686,422,578",
          "605,423,415",
          "515,917,-361",
          "-336,658,858",
          "95,138,22",
          "-476,619,847",
          "-340,-569,-846",
          "567,-361,727",
          "-460,603,-452",
          "669,-402,600",
          "729,430,532",
          "-500,-761,534",
          "-322,571,750",
          "-466,-666,-811",
          "-429,-592,574",
          "-355,545,-477",
          "703,-491,-529",
          "-328,-685,520",
          "413,935,-424",
          "-391,539,-444",
          "586,-435,557",
          "-364,-763,-893",
          "807,-499,-711",
          "755,-354,-619",
          "553,889,-390",
          "",
          "--- scanner 2 ---",
          "649,640,665",
          "682,-795,504",
          "-784,533,-524",
          "-644,584,-595",
          "-588,-843,648",
          "-30,6,44",
          "-674,560,763",
          "500,723,-460",
          "609,671,-379",
          "-555,-800,653",
          "-675,-892,-343",
          "697,-426,-610",
          "578,704,681",
          "493,664,-388",
          "-671,-858,530",
          "-667,343,800",
          "571,-461,-707",
          "-138,-166,112",
          "-889,563,-600",
          "646,-828,498",
          "640,759,510",
          "-630,509,768",
          "-681,-892,-333",
          "673,-379,-804",
          "-742,-814,-386",
          "577,-820,562",
          "",
          "--- scanner 3 ---",
          "-589,542,597",
          "605,-692,669",
          "-500,565,-823",
          "-660,373,557",
          "-458,-679,-417",
          "-488,449,543",
          "-626,468,-788",
          "338,-750,-386",
          "528,-832,-391",
          "562,-778,733",
          "-938,-730,414",
          "543,643,-506",
          "-524,371,-870",
          "407,773,750",
          "-104,29,83",
          "378,-903,-323",
          "-778,-728,485",
          "426,699,580",
          "-438,-605,-362",
          "-469,-447,-387",
          "509,732,623",
          "647,635,-688",
          "-868,-804,481",
          "614,-800,639",
          "595,780,-596",
          "",
          "--- scanner 4 ---",
          "727,592,562",
          "-293,-554,779",
          "441,611,-461",
          "-714,465,-776",
          "-743,427,-804",
          "-660,-479,-426",
          "832,-632,460",
          "927,-485,-438",
          "408,393,-506",
          "466,436,-512",
          "110,16,151",
          "-258,-428,682",
          "-393,719,612",
          "-211,-452,876",
          "808,-476,-593",
          "-575,615,604",
          "-485,667,467",
          "-680,325,-822",
          "-627,-443,-432",
          "872,-547,-609",
          "833,512,582",
          "807,604,487",
          "839,-516,451",
          "891,-625,532",
          "-652,-548,-490",
          "30,-46,-14",
        ]
        scanners = Scanner.parse(input)
        s = scanners[0]
        s.beacons.size.should eq(25)

        scanners[1].beacons.size.should eq(25)
        s.merge(scanners[1])
        scanners[1].coord.should eq({68, -1246, -43})
        s.beacons.size.should eq(38)

        scanners[4].beacons.size.should eq(26)
        s.overlap(scanners[4]).size.should eq(12)
        s.merge(scanners[4])
        scanners[4].coord.should eq({-20, -1133, 1061})
        s.beacons.size.should eq(52)

        b = s.overlap(scanners[2])

        s.detect_scanner_coord(scanners[2])
        scanners[2].coord.should eq({1105, -1205, 1229})

        s.merge(scanners[2])
        scanners[2].coord.should eq({1105, -1205, 1229})

        s.merge(scanners[3])
        scanners[3].coord.should eq({-92, -2380, -20})

        s.beacons.size.should eq(79)
      end
    end

    describe "#beacons_against_coord" do
      it "2d example" do
        input = [
          "--- scanner 0 ---",
          "0,2,0",
          "4,1,0",
          "3,3,0",
          "",
          "--- scanner 1 ---",
          "-1,-1,0",
          "-5,0,0",
          "-2,1,0",
        ]
        scanners = Scanner.parse(input)
        scanners[1].coord = {5, 2, 0}
        actual = scanners[1].beacons_against_coord.map(&.coord)
        actual.should eq([
          {4, 1, 0},
          {0, 2, 0},
          {3, 3, 0},
        ])
      end
    end
  end
end

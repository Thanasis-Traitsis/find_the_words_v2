import 'package:find_the_words/features/stage/data/models/current_stage.dart';
import 'package:find_the_words/features/stage/domain/helpers/word_placement_tracker.dart';
import 'package:find_the_words/features/stage/domain/services/word_selection_service.dart';

class BackupStagesEL {
  final WordSelectionService _wordService;

  BackupStagesEL(this._wordService);

  final Map<int, List<CurrentStage Function()>> _backupsByLevel = {
    1: [
      _backupLevel1Option1,
      _backupLevel1Option2,
      _backupLevel1Option3,
      _backupLevel1Option4,
      _backupLevel1Option5,
    ],
    2: [
      _backupLevel2Option1,
      _backupLevel2Option2,
      _backupLevel2Option3,
      _backupLevel2Option4,
      _backupLevel2Option5,
      _backupLevel2Option6,
    ],
    3: [
      _backupLevel3Option1,
      _backupLevel3Option2,
      _backupLevel3Option3,
      _backupLevel3Option4,
      _backupLevel3Option5,
      _backupLevel3Option6,
    ],
    4: [
      _backupLevel4Option1,
      _backupLevel4Option2,
      _backupLevel4Option3,
      _backupLevel4Option4,
      _backupLevel4Option5,
      _backupLevel4Option6,
    ],
    5: [
      _backupLevel5Option1,
      _backupLevel5Option2,
      _backupLevel5Option3,
      _backupLevel5Option4,
      _backupLevel5Option5,
      _backupLevel5Option6,
    ],
    6: [
      _backupLevel6Option1,
      _backupLevel6Option2,
      _backupLevel6Option3,
      _backupLevel6Option4,
      _backupLevel6Option5,
    ],
    7: [
      _backupLevel7Option1,
      _backupLevel7Option2,
      _backupLevel7Option3,
      _backupLevel7Option4,
      _backupLevel7Option5,
    ],
    8: [
      _backupLevel8Option1,
      _backupLevel8Option2,
      _backupLevel8Option3,
      _backupLevel8Option4,
      _backupLevel8Option5,
    ],
    9: [_backupLevel9Option1, _backupLevel9Option2, _backupLevel9Option3],
    10: [_backupLevel10Option1, _backupLevel10Option2, _backupLevel10Option3],
  };

  Future<CurrentStage> getBackupStage(int level) async {
    final stagesForLevel = _backupsByLevel[level];

    for (var builder in stagesForLevel!) {
      final stage = builder();
      bool isValid = await _wordService.validBackupStage(stage);
      if (isValid) return stage;
    }

    final random = stagesForLevel.toList()..shuffle();
    return random.first();
  }

  // LEVEL : 1
  static CurrentStage _backupLevel1Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΝΑΙ', [3, 4, 5]);
    tracker.addPlacement('ΙΝΑ', [0, 3, 6]);

    tracker.commonPositions.addAll([3]);

    final board = List.generate(9, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΝΑΙ', 'ΙΝΑ'];
    final letters = ['Α', 'Ι', 'Ν'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel1Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΙΟΣ', [1, 2, 3]);
    tracker.addPlacement('ΙΣΟ', [1, 5, 9]);
    tracker.addPlacement('ΣΟΙ', [8, 9, 10]);

    tracker.commonPositions.addAll([1, 9]);

    final board = List.generate(16, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΙΟΣ', 'ΙΣΟ', 'ΣΟΙ'];
    final letters = ['Σ', 'Ο', 'Ι'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel1Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΣΙΚ', [0, 1, 2]);
    tracker.addPlacement('ΣΚΙ', [0, 3, 6]);

    tracker.commonPositions.addAll([0]);

    final board = List.generate(9, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΣΙΚ', 'ΣΚΙ'];
    final letters = ['Σ', 'Ι', 'Κ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel1Option4() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΕΑΝ', [7, 8, 9]);
    tracker.addPlacement('ΕΝΑ', [7, 12, 17]);
    tracker.addPlacement('ΝΕΑ', [15, 16, 17]);

    tracker.commonPositions.addAll([7, 17]);

    final board = List.generate(25, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΕΑΝ', 'ΕΝΑ', 'ΝΕΑ'];
    final letters = ['Α', 'Ε', 'Ν'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel1Option5() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΝΤΟ', [6, 7, 8]);
    tracker.addPlacement('ΤΟΝ', [0, 3, 6]);

    tracker.commonPositions.addAll([6]);

    final board = List.generate(9, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΝΤΟ', 'ΤΟΝ'];
    final letters = ['Ο', 'Τ', 'Ν'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  // LEVEL : 2
  static CurrentStage _backupLevel2Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΚΙΤΣ', [10, 11, 12, 13]);
    tracker.addPlacement('ΣΚΙΤ', [3, 10, 17, 24]);
    tracker.addPlacement('ΣΤΙΚ', [23, 24, 25, 26]);
    tracker.addPlacement('ΣΙΚ', [23, 30, 37]);
    tracker.addPlacement('ΣΚΙ', [28, 29, 30]);
    tracker.addPlacement('ΤΙΣ', [14, 21, 28]);
    tracker.addPlacement('ΚΙΤ', [37, 38, 39]);

    tracker.commonPositions.addAll([10, 24, 23, 30, 37, 28]);

    final board = List.generate(49, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΚΙΤΣ',
      'ΣΚΙΤ',
      'ΣΤΙΚ',
      'ΣΙΚ',
      'ΣΚΙ',
      'ΤΙΚ',
      'ΤΙΣ',
      'ΚΙΤ',
    ];
    final letters = ['Ι', 'Τ', 'Σ', 'Κ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel2Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΑΙΝΩ', [0, 1, 2, 3]);
    tracker.addPlacement('ΑΝΩΙ', [0, 6, 12, 18]);
    tracker.addPlacement('ΩΝΙΑ', [12, 13, 14, 15]);
    tracker.addPlacement('ΑΝΩ', [15, 21, 27]);
    tracker.addPlacement('ΝΑΙ', [21, 22, 23]);
    tracker.addPlacement('ΙΝΑ', [23, 29, 35]);

    tracker.commonPositions.addAll([0, 12, 15, 21, 23]);

    final board = List.generate(36, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΑΙΝΩ', 'ΑΝΩΙ', 'ΩΝΙΑ', 'ΑΝΩ', 'ΙΝΑ', 'ΝΑΙ'];
    final letters = ['Ι', 'Ν', 'Α', 'Ω'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel2Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΑΤΟΣ', [37, 38, 39, 40]);
    tracker.addPlacement('ΣΤΟΑ', [16, 23, 30, 37]);
    tracker.addPlacement('ΤΣΑΟ', [15, 16, 17, 18]);
    tracker.addPlacement('ΣΤΑ', [3, 10, 17]);
    tracker.addPlacement('ΤΑΟ', [28, 29, 30]);
    tracker.addPlacement('ΤΣΑ', [28, 35, 42]);

    tracker.commonPositions.addAll([37, 16, 30, 17, 28]);

    final board = List.generate(49, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΑΤΟΣ', 'ΣΤΟΑ', 'ΤΣΑΟ', 'ΣΤΑ', 'ΤΑΟ', 'ΤΣΑ'];
    final letters = ['Σ', 'Ο', 'Α', 'Τ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel2Option4() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΑΡΜΗ', [36, 37, 38, 39]);
    tracker.addPlacement('ΗΜΑΡ', [20, 28, 36, 44]);
    tracker.addPlacement('ΜΑΡΗ', [17, 18, 19, 20]);
    tracker.addPlacement('ΡΗΜΑ', [1, 9, 17, 25]);
    tracker.addPlacement('ΗΡΑ', [0, 1, 2]);
    tracker.addPlacement('ΡΑΜ', [22, 30, 38]);
    tracker.addPlacement('ΑΗΡ', [42, 43, 44]);
    tracker.addPlacement('ΑΜΗ', [42, 50, 58]);
    tracker.addPlacement('ΑΡΜ', [48, 49, 50]);

    tracker.commonPositions.addAll([36, 38, 20, 44, 17, 1, 42, 50]);

    final board = List.generate(64, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΑΡΜΗ',
      'ΗΜΑΡ',
      'ΜΑΡΗ',
      'ΡΗΜΑ',
      'ΗΡΑ',
      'ΡΑΜ',
      'ΑΗΡ',
      'ΑΜΗ',
      'ΑΡΜ',
    ];
    final letters = ['Α', 'Ρ', 'Μ', 'Η'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel2Option5() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΑΓΑΡ', [9, 10, 11, 12]);
    tracker.addPlacement('ΑΓΡΑ', [2, 10, 18, 26]);
    tracker.addPlacement('ΑΡΓΑ', [26, 27, 28, 29]);
    tracker.addPlacement('ΡΑΓΑ', [27, 35, 43, 51]);
    tracker.addPlacement('ΑΡΑ', [51, 52, 53]);
    tracker.addPlacement('ΓΑΡ', [45, 53, 61]);

    tracker.commonPositions.addAll([10, 26, 27, 51, 53]);

    final board = List.generate(64, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΑΓΑΡ', 'ΑΓΡΑ', 'ΑΡΓΑ', 'ΡΑΓΑ', 'ΑΡΑ', 'ΓΑΡ'];
    final letters = ['Γ', 'Α', 'Α', 'Ρ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel2Option6() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΟΥΠΣ', [20, 21, 22, 23]);
    tracker.addPlacement('ΠΟΥΣ', [12, 20, 28, 36]);
    tracker.addPlacement('ΟΥΣ', [34, 35, 36]);
    tracker.addPlacement('ΠΟΥ', [26, 34, 42]);
    tracker.addPlacement('ΣΟΥ', [40, 41, 42]);
    tracker.addPlacement('ΥΠΟ', [14, 22, 30]);

    tracker.commonPositions.addAll([20, 22, 36, 34, 42]);

    final board = List.generate(64, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΟΥΠΣ', 'ΠΟΥΣ', 'ΟΥΣ', 'ΠΟΥ', 'ΣΟΥ', 'ΥΠΟ'];
    final letters = ['Υ', 'Π', 'Σ', 'Ο'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  // LEVEL : 3
  static CurrentStage _backupLevel3Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΠΑΡΦΕ', [34, 35, 36, 37, 38]);
    tracker.addPlacement('ΠΕΡΑ', [34, 42, 50, 58]);
    tracker.addPlacement('ΡΑΠ', [50, 51, 52]);
    tracker.addPlacement('ΡΑΦ', [21, 29, 37]);
    tracker.addPlacement('ΦΑΕ', [40, 41, 42]);
    tracker.addPlacement('ΕΑΡ', [19, 20, 21]);
    tracker.addPlacement('ΑΠΕ', [3, 11, 19]);

    tracker.commonPositions.addAll([34, 37, 42, 50, 21, 19]);

    final board = List.generate(64, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΠΑΡΦΕ', 'ΠΕΡΑ', 'ΡΑΠ', 'ΡΑΦ', 'ΦΑΕ', 'ΑΠΕ', 'ΕΑΡ'];
    final letters = ['Ρ', 'Π', 'Α', 'Ε', 'Φ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel3Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΟΠΕΡΑ', [17, 18, 19, 20, 21]);
    tracker.addPlacement('ΠΕΡΑ', [18, 26, 34, 42]);
    tracker.addPlacement('ΡΕΠΟ', [34, 35, 36, 37]);
    tracker.addPlacement('ΟΠΕΡ', [37, 45, 53, 61]);
    tracker.addPlacement('ΠΟΑ', [45, 46, 47]);
    tracker.addPlacement('ΠΡΟ', [60, 61, 62]);
    tracker.addPlacement('ΡΑΠ', [39, 47, 55]);
    tracker.addPlacement('ΑΠΕ', [3, 11, 19]);
    tracker.addPlacement('ΑΠΟ', [3, 4, 5]);
    tracker.addPlacement('ΟΠΑ', [40, 41, 42]);

    tracker.commonPositions.addAll([18, 19, 34, 42, 37, 45, 61, 47, 3]);

    final board = List.generate(64, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΟΠΕΡΑ',
      'ΠΕΡΑ',
      'ΡΕΠΟ',
      'ΟΠΕΡ',
      'ΠΟΑ',
      'ΠΡΟ',
      'ΡΑΠ',
      'ΑΠΕ',
      'ΑΠΟ',
      'ΕΑΡ',
      'ΟΠΑ',
    ];
    final letters = ['Π', 'Ρ', 'Ε', 'Α', 'Ο'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel3Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΚΟΥΤΙ', [21, 22, 23, 24, 25]);
    tracker.addPlacement('ΟΥΤΙ', [22, 29, 36, 43]);
    tracker.addPlacement('ΟΤΙ', [35, 36, 37]);
    tracker.addPlacement('ΟΥΚ', [7, 14, 21]);
    tracker.addPlacement('ΤΙΚ', [18, 25, 32]);
    tracker.addPlacement('ΤΟΥ', [18, 19, 20]);
    tracker.addPlacement('ΚΙΤ', [32, 33, 34]);
    tracker.addPlacement('ΚΟΥ', [6, 13, 20]);

    tracker.commonPositions.addAll([21, 22, 25, 36, 18, 32, 20]);

    final board = List.generate(49, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΚΟΥΤΙ',
      'ΟΥΤΙ',
      'ΟΤΙ',
      'ΟΥΚ',
      'ΤΙΚ',
      'ΤΟΥ',
      'ΚΙΤ',
      'ΚΟΥ',
    ];
    final letters = ['Υ', 'Κ', 'Ι', 'Ο', 'Τ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel3Option4() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΒΑΡΑΩ', [0, 1, 2, 3, 4]);
    tracker.addPlacement('ΒΑΡΩ', [0, 7, 14, 21]);
    tracker.addPlacement('ΡΑΒΩ', [14, 15, 16, 17]);
    tracker.addPlacement('ΒΡΩ', [16, 23, 30]);
    tracker.addPlacement('ΩΡΑ', [30, 31, 32]);
    tracker.addPlacement('ΑΡΑ', [32, 39, 46]);
    tracker.addPlacement('ΑΡΩ', [46, 47, 48]);

    tracker.commonPositions.addAll([0, 14, 16, 30, 32, 46]);

    final board = List.generate(49, (_) => '');
    tracker.placePositions(board);

    final allWords = ['ΒΑΡΑΩ', 'ΒΑΡΩ', 'ΡΑΒΩ', 'ΒΡΩ', 'ΩΡΑ', 'ΑΡΑ', 'ΑΡΩ'];
    final letters = ['Β', 'Α', 'Α', 'Ω', 'Ρ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel3Option5() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΡΕΝΤΑ', [81, 82, 83, 84, 85]);
    tracker.addPlacement('ΑΝΤΕ', [49, 60, 71, 82]);
    tracker.addPlacement('ΝΕΤΑ', [46, 47, 48, 49]);
    tracker.addPlacement('ΡΑΝΤ', [24, 35, 46, 57]);
    tracker.addPlacement('ΤΑΡ', [22, 23, 24]);
    tracker.addPlacement('ΕΑΝ', [74, 85, 96]);
    tracker.addPlacement('ΕΑΡ', [74, 75, 76]);
    tracker.addPlacement('ΕΝΑ', [53, 64, 75]);
    tracker.addPlacement('ΝΕΑ', [52, 53, 54]);
    tracker.addPlacement('ΝΤΑ', [32, 43, 54]);
    tracker.addPlacement('ΝΤΕ', [96, 97, 98]);

    tracker.commonPositions.addAll([82, 85, 49, 46, 24, 74, 96, 75, 53, 54]);

    final board = List.generate(121, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΡΕΝΤΑ',
      'ΑΝΤΕ',
      'ΝΕΤΑ',
      'ΡΑΝΤ',
      'ΤΑΡ',
      'ΕΑΝ',
      'ΕΑΡ',
      'ΕΝΑ',
      'ΝΕΑ',
      'ΝΤΑ',
      'ΝΤΕ',
      'ΡΕΝ',
    ];
    final letters = ['Ε', 'Ρ', 'Τ', 'Ν', 'Α'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel3Option6() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΥΠΝΟΣ', [39, 40, 41, 42, 43]);
    tracker.addPlacement('ΝΟΥΣ', [21, 30, 39, 48]);
    tracker.addPlacement('ΟΥΠΣ', [45, 46, 47, 48]);
    tracker.addPlacement('ΠΟΥΣ', [36, 45, 54, 63]);
    tracker.addPlacement('ΥΠΟ', [28, 29, 30]);
    tracker.addPlacement('ΟΥΣ', [42, 51, 60]);
    tracker.addPlacement('ΠΟΥ', [10, 19, 28]);
    tracker.addPlacement('ΣΟΥ', [60, 61, 62]);
    tracker.addPlacement('ΣΥΝ', [53, 62, 71]);

    tracker.commonPositions.addAll([39, 42, 30, 48, 45, 28, 60, 62]);

    final board = List.generate(81, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΥΠΝΟΣ',
      'ΝΟΥΣ',
      'ΟΥΠΣ',
      'ΠΟΥΣ',
      'ΥΠΟ',
      'ΟΥΣ',
      'ΠΟΥ',
      'ΣΟΥ',
      'ΣΥΝ',
    ];
    final letters = ['Π', 'Σ', 'Υ', 'Ν', 'Ο'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  // LEVEL : 4
  static CurrentStage _backupLevel4Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΑΣΙΤΙΑ', [51, 52, 53, 54, 55, 56]);
    tracker.addPlacement('ΙΑΤΑΙ', [39, 51, 63, 75, 87]);
    tracker.addPlacement('ΑΙΤΙΑ', [75, 76, 77, 78, 79]);
    tracker.addPlacement('ΑΤΣΑ', [79, 91, 103, 115]);
    tracker.addPlacement('ΙΤΙΑ', [112, 113, 114, 115]);
    tracker.addPlacement('ΣΑΙΤ', [103, 104, 105, 106]);
    tracker.addPlacement('ΣΙΤΑ', [93, 105, 117, 129]);
    tracker.addPlacement('ΤΑΣΙ', [128, 129, 130, 131]);
    tracker.addPlacement('ΤΣΑΙ', [36, 37, 38, 39]);
    tracker.addPlacement('ΑΤΑ', [24, 36, 48]);
    tracker.addPlacement('ΑΤΙ', [101, 113, 125]);
    tracker.addPlacement('ΙΣΑ', [14, 26, 38]);

    tracker.commonPositions.addAll([
      51,
      39,
      75,
      79,
      103,
      115,
      113,
      105,
      129,
      36,
      38,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΑΣΙΤΙΑ',
      'ΙΑΤΑΙ',
      'ΑΙΤΙΑ',
      'ΑΤΣΑ',
      'ΙΤΙΑ',
      'ΣΑΙΤ',
      'ΣΙΤΑ',
      'ΤΑΣΙ',
      'ΤΣΑΙ',
      'ΑΤΑ',
      'ΑΤΙ',
      'ΙΣΑ',
      'ΣΙΑ',
      'ΣΤΑ',
      'ΤΙΣ',
      'ΤΣΑ',
    ];
    final letters = ['Τ', 'Α', 'Ι', 'Ι', 'Α', 'Σ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel4Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΚΟΡΗΜΑ', [75, 76, 77, 78, 79, 80]);
    tracker.addPlacement('ΜΑΡΚΟ', [39, 51, 63, 75, 87]);
    tracker.addPlacement('ΜΑΚΟ', [39, 40, 41, 42]);
    tracker.addPlacement('ΜΑΡΗ', [79, 91, 103, 115]);
    tracker.addPlacement('ΜΟΚΑ', [17, 29, 41, 53]);
    tracker.addPlacement('ΜΟΡΑ', [17, 18, 19, 20]);
    tracker.addPlacement('ΟΡΚΑ', [102, 103, 104, 105]);
    tracker.addPlacement('ΡΑΚΗ', [93, 105, 117, 129]);
    tracker.addPlacement('ΡΗΜΑ', [128, 129, 130, 131]);
    tracker.addPlacement('ΡΟΚΑ', [95, 107, 119, 131]);
    tracker.addPlacement('ΑΚΜΗ', [20, 32, 44, 56]);
    tracker.addPlacement('ΑΚΡΟ', [84, 85, 86, 87]);

    tracker.commonPositions.addAll([
      75,
      79,
      39,
      87,
      41,
      103,
      17,
      20,
      105,
      129,
      131,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΚΟΡΗΜΑ',
      'ΜΑΡΚΟ',
      'ΜΑΚΟ',
      'ΜΑΡΗ',
      'ΜΟΚΑ',
      'ΜΟΡΑ',
      'ΟΡΚΑ',
      'ΟΡΜΗ',
      'ΡΑΚΗ',
      'ΡΗΜΑ',
      'ΡΟΚΑ',
      'ΑΚΜΗ',
      'ΑΚΟΗ',
      'ΑΚΡΗ',
      'ΑΚΡΟ',
      'ΑΜΟΚ',
      'ΑΡΜΗ',
      'ΗΜΑΡ',
      'ΚΑΡΟ',
      'ΚΟΜΗ',
      'ΚΟΡΑ',
      'ΚΟΡΗ',
      'ΚΡΑ',
      'ΟΚΑ',
      'ΡΑΜ',
      'ΡΟΗ',
      'ΡΟΚ',
      'ΡΟΜ',
      'ΑΗΡ',
      'ΑΜΗ',
      'ΑΡΜ',
      'ΗΡΑ',
    ];
    final letters = ['Ρ', 'Μ', 'Α', 'Η', 'Ο', 'Κ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel4Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΚΛΕΙΔΑ', [51, 52, 53, 54, 55, 56]);
    tracker.addPlacement('ΚΛΑΔΙ', [51, 63, 75, 87, 99]);
    tracker.addPlacement('ΛΑΔΙ', [74, 75, 76, 77]);
    tracker.addPlacement('ΛΑΙΚ', [97, 98, 99, 100]);
    tracker.addPlacement('ΛΕΙΑ', [30, 42, 54, 66]);
    tracker.addPlacement('ΔΕΚΑ', [20, 32, 44, 56]);
    tracker.addPlacement('ΕΙΔΑ', [32, 33, 34, 35]);
    tracker.addPlacement('ΕΚΑΙ', [11, 23, 35, 47]);
    tracker.addPlacement('ΕΛΙΑ', [85, 97, 109, 121]);
    tracker.addPlacement('ΚΑΕΙ', [120, 121, 122, 123]);
    tracker.addPlacement('ΙΔΕ', [9, 10, 11]);

    tracker.commonPositions.addAll([51, 54, 56, 75, 99, 97, 32, 35, 11, 121]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΚΛΕΙΔΑ',
      'ΚΛΑΔΙ',
      'ΛΑΔΙ',
      'ΛΑΙΚ',
      'ΛΕΙΑ',
      'ΔΕΚΑ',
      'ΕΙΔΑ',
      'ΕΚΑΙ',
      'ΕΛΙΑ',
      'ΙΔΕΑ',
      'ΚΑΕΙ',
      'ΚΑΛΕ',
      'ΚΑΛΙ',
      'ΚΕΛΙ',
      'ΛΑΚ',
      'ΑΕΙ',
      'ΑΛΙ',
      'ΔΕΙ',
      'ΔΙΑ',
      'ΕΛΑ',
      'ΙΔΕ',
      'ΚΑΙ',
      'ΚΕΙ',
    ];
    final letters = ['Δ', 'Ε', 'Ι', 'Λ', 'Κ', 'Α'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel4Option4() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΑΥΠΝΟΣ', [53, 54, 55, 56, 57, 58]);
    tracker.addPlacement('ΣΟΥΝΑ', [13, 23, 33, 43, 53]);
    tracker.addPlacement('ΣΟΥΠΑ', [13, 14, 15, 16, 17]);
    tracker.addPlacement('ΥΠΝΟΣ', [33, 34, 35, 36, 37]);
    tracker.addPlacement('ΝΑΟΣ', [56, 66, 76, 86]);
    tracker.addPlacement('ΝΟΥΑ', [75, 76, 77, 78]);
    tracker.addPlacement('ΠΑΝΟ', [20, 21, 22, 23]);
    tracker.addPlacement('ΠΑΣΟ', [20, 30, 40, 50]);
    tracker.addPlacement('ΟΠΑ', [1, 11, 21]);
    tracker.addPlacement('ΠΟΑ', [0, 1, 2]);
    tracker.addPlacement('ΑΟΥ', [78, 88, 98]);

    tracker.commonPositions.addAll([53, 56, 13, 23, 33, 76, 78, 20, 21, 1]);

    final board = List.generate(100, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΑΥΠΝΟΣ',
      'ΣΟΥΝΑ',
      'ΣΟΥΠΑ',
      'ΥΠΝΟΣ',
      'ΝΑΟΣ',
      'ΝΟΥΑ',
      'ΝΟΥΣ',
      'ΟΥΠΑ',
      'ΟΥΠΣ',
      'ΠΑΝΟ',
      'ΠΑΣΟ',
      'ΠΟΥΑ',
      'ΠΟΥΣ',
      'ΟΠΑ',
      'ΟΥΣ',
      'ΠΑΝ',
      'ΠΟΑ',
      'ΠΟΥ',
      'ΣΑΝ',
      'ΣΟΥ',
      'ΣΠΑ',
      'ΣΥΝ',
      'ΥΠΟ',
      'ΑΟΥ',
      'ΑΠΟ',
    ];
    final letters = ['Ν', 'Ο', 'Υ', 'Σ', 'Π', 'Α'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel4Option5() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΧΑΡΑΜΙ', [57, 58, 59, 60, 61, 62]);
    tracker.addPlacement('ΧΑΡΜΑ', [57, 68, 79, 90, 101]);
    tracker.addPlacement('ΧΡΑΜΙ', [78, 79, 80, 81, 82]);
    tracker.addPlacement('ΧΑΜΑΙ', [100, 101, 102, 103, 104]);
    tracker.addPlacement('ΑΙΜΑ', [25, 36, 47, 58]);
    tracker.addPlacement('ΑΡΙΑ', [25, 26, 27, 28]);
    tracker.addPlacement('ΑΧΡΙ', [33, 34, 35, 36]);
    tracker.addPlacement('ΙΑΜΑ', [22, 33, 44, 55]);
    tracker.addPlacement('ΜΑΙΑ', [5, 16, 27, 38]);
    tracker.addPlacement('ΜΑΡΑ', [5, 6, 7, 8]);
    tracker.addPlacement('ΡΑΙΧ', [40, 51, 62, 73]);
    tracker.addPlacement('ΡΑΜΙ', [40, 41, 42, 43]);

    tracker.commonPositions.addAll([
      57,
      58,
      62,
      79,
      101,
      25,
      36,
      27,
      33,
      5,
      40,
    ]);

    final board = List.generate(121, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΧΑΡΑΜΙ',
      'ΧΑΡΜΑ',
      'ΧΡΑΜΙ',
      'ΧΑΜΑΙ',
      'ΑΙΜΑ',
      'ΑΡΙΑ',
      'ΑΡΜΑ',
      'ΑΧΡΙ',
      'ΙΑΜΑ',
      'ΜΑΙΑ',
      'ΜΑΡΑ',
      'ΡΑΙΧ',
      'ΡΑΜΙ',
      'ΡΙΜΑ',
      'ΧΑΡΑ',
      'ΑΜΑ',
      'ΑΡΑ',
      'ΑΡΜ',
      'ΜΑΧ',
      'ΡΑΜ',
      'ΧΑΙ',
    ];
    final letters = ['Ρ', 'Ι', 'Α', 'Χ', 'Α', 'Μ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel4Option6() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΤΑΚΙΜΙ', [39, 40, 41, 42, 43, 44]);
    tracker.addPlacement('ΙΤΙΑ', [30, 39, 48, 57]);
    tracker.addPlacement('ΚΑΤΙ', [27, 28, 29, 30]);
    tracker.addPlacement('ΜΑΤΙ', [19, 28, 37, 46]);
    tracker.addPlacement('ΤΙΚ', [23, 32, 41]);
    tracker.addPlacement('ΤΙΜ', [23, 24, 25]);
    tracker.addPlacement('ΑΤΙ', [6, 15, 24]);
    tracker.addPlacement('ΚΑΙ', [5, 6, 7]);
    tracker.addPlacement('ΚΑΤ', [56, 57, 58]);
    tracker.addPlacement('ΚΙΤ', [56, 65, 74]);
    tracker.addPlacement('ΜΑΤ', [72, 73, 74]);

    tracker.commonPositions.addAll([39, 41, 30, 57, 28, 23, 24, 6, 56, 74]);

    final board = List.generate(81, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΤΑΚΙΜΙ',
      'ΙΤΙΑ',
      'ΚΑΤΙ',
      'ΜΑΤΙ',
      'ΤΙΚ',
      'ΤΙΜ',
      'ΑΤΙ',
      'ΚΑΙ',
      'ΚΑΤ',
      'ΚΙΤ',
      'ΜΑΤ',
    ];
    final letters = ['Μ', 'Ι', 'Τ', 'Κ', 'Α', 'Ι'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  // LEVEL: 5
  static CurrentStage _backupLevel5Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΜΑΦΟΡΙΟ', [47, 48, 49, 50, 51, 52, 53]);
    tracker.addPlacement('ΟΜΟΡΦΙΑ', [36, 47, 58, 69, 80, 91, 102]);
    tracker.addPlacement('ΟΜΟΡΦΑ', [66, 67, 68, 69, 70, 71]);
    tracker.addPlacement('ΜΟΙΡΑ', [55, 66, 77, 88, 99]);
    tracker.addPlacement('ΜΟΡΙΟ', [6, 17, 28, 39, 50]);
    tracker.addPlacement('ΟΡΜΙΑ', [4, 5, 6, 7, 8]);
    tracker.addPlacement('ΦΑΡΙΟ', [26, 27, 28, 29, 30]);
    tracker.addPlacement('ΦΙΟΡΟ', [90, 91, 92, 93, 94]);
    tracker.addPlacement('ΦΟΡΜΑ', [42, 53, 64, 75, 86]);
    tracker.addPlacement('ΜΟΡΑ', [83, 94, 105, 116]);
    tracker.addPlacement('ΟΡΙΟ', [33, 34, 35, 36]);
    tracker.addPlacement('ΡΑΜΙ', [2, 13, 24, 35]);
    tracker.addPlacement('ΡΑΦΙ', [105, 106, 107, 108]);

    tracker.commonPositions.addAll([
      47,
      50,
      53,
      36,
      69,
      91,
      66,
      6,
      28,
      94,
      105,
      35,
    ]);

    final board = List.generate(121, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΜΑΦΟΡΙΟ',
      'ΟΜΟΡΦΙΑ',
      'ΟΜΟΡΦΑ',
      'ΜΟΙΡΑ',
      'ΜΟΡΙΟ',
      'ΟΡΜΙΑ',
      'ΦΑΡΙΟ',
      'ΦΙΟΡΟ',
      'ΦΙΡΜΑ',
      'ΦΟΡΜΑ',
      'ΜΟΡΑ',
      'ΟΡΙΟ',
      'ΡΑΜΙ',
      'ΡΑΦΙ',
      'ΡΙΜΑ',
      'ΦΑΡΙ',
      'ΦΟΡΑ',
      'ΑΜΦΙ',
      'ΑΦΡΟ',
      'ΡΑΜ',
      'ΡΑΦ',
      'ΡΙΦ',
      'ΡΟΜ',
      'ΦΟΡ',
      'ΑΡΜ',
      'ΙΜΟ',
    ];
    final letters = ['Ι', 'Φ', 'Μ', 'Α', 'Ο', 'Ρ', 'Ο'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel5Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΡΑΚΛΕΤΑ', [63, 64, 65, 66, 67, 68, 69]);
    tracker.addPlacement('ΚΑΡΤΕΛΑ', [39, 51, 63, 75, 87, 99, 111]);
    tracker.addPlacement('ΡΑΚΕΤΑ', [37, 38, 39, 40, 41, 42]);
    tracker.addPlacement('ΡΑΚΛΕΤ', [37, 49, 61, 73, 85, 97]);
    tracker.addPlacement('ΚΑΡΤΕΛ', [110, 111, 112, 113, 114, 115]);
    tracker.addPlacement('ΚΑΡΑΤΕ', [65, 77, 89, 101, 113, 125]);
    tracker.addPlacement('ΚΑΡΤΑ', [32, 44, 56, 68, 80]);
    tracker.addPlacement('ΛΑΚΑ', [2, 14, 26, 38]);
    tracker.addPlacement('ΤΑΛΚ', [0, 1, 2, 3]);
    tracker.addPlacement('ΤΑΡΑ', [6, 18, 30, 42]);
    tracker.addPlacement('ΤΡΑΚ', [6, 7, 8, 9]);
    tracker.addPlacement('ΚΑΛΤ', [32, 33, 34, 35]);
    tracker.addPlacement('ΑΛΕΑ', [22, 34, 46, 58]);

    tracker.commonPositions.addAll([
      63,
      65,
      68,
      39,
      111,
      37,
      38,
      42,
      113,
      32,
      2,
      6,
      34,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΡΑΚΛΕΤΑ',
      'ΚΑΡΤΕΛΑ',
      'ΡΑΚΕΤΑ',
      'ΡΑΚΛΕΤ',
      'ΚΑΡΤΕΛ',
      'ΚΑΡΑΤΕ',
      'ΚΑΡΤΑ',
      'ΚΛΑΡΑ',
      'ΤΡΑΚΑ',
      'ΛΑΤΡΑ',
      'ΡΕΚΛΑ',
      'ΤΡΕΛΑ',
      'ΡΕΑΛ',
      'ΛΑΚΑ',
      'ΤΑΛΚ',
      'ΤΑΡΑ',
      'ΤΡΑΚ',
      'ΚΑΛΤ',
      'ΚΕΡΑ',
      'ΑΚΡΑ',
      'ΑΛΕΑ',
      'ΛΕΡΑ',
      'ΑΡΑΚ',
      'ΚΑΛΑ',
      'ΚΑΛΕ',
      'ΚΑΡΑ',
      'ΚΑΡΕ',
      'ΚΑΡΤ',
      'ΚΑΤΑ',
      'ΛΑΚ',
      'ΤΑΡ',
      'ΑΛΑ',
      'ΑΛΤ',
      'ΑΤΑ',
      'ΕΑΡ',
      'ΕΛΑ',
      'ΑΡΑ',
      'ΚΑΤ',
      'ΚΡΑ',
    ];
    final letters = ['Α', 'Α', 'Ρ', 'Λ', 'Ε', 'Κ', 'Τ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel5Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΘΟΛΕΡΟΣ', [58, 59, 60, 61, 62, 63, 64]);
    tracker.addPlacement('ΟΛΕΘΡΟΣ', [25, 36, 47, 58, 69, 80, 91]);
    tracker.addPlacement('ΘΟΛΟΣ', [24, 25, 26, 27, 28]);
    tracker.addPlacement('ΛΕΡΟΣ', [77, 78, 79, 80, 81]);
    tracker.addPlacement('ΟΡΘΟΣ', [51, 62, 73, 84, 95]);
    tracker.addPlacement('ΡΟΛΟΣ', [83, 84, 85, 86, 87]);
    tracker.addPlacement('ΘΕΡΟΣ', [67, 78, 89, 100, 111]);
    tracker.addPlacement('ΟΛΟΣ', [86, 97, 108, 119]);
    tracker.addPlacement('ΟΡΟΣ', [116, 117, 118, 119]);
    tracker.addPlacement('ΟΡΣΕ', [6, 17, 28, 39]);
    tracker.addPlacement('ΡΕΣΟ', [3, 4, 5, 6]);
    tracker.addPlacement('ΡΟΛΕ', [17, 18, 19, 20]);
    tracker.addPlacement('ΣΟΛΟ', [111, 112, 113, 114]);

    tracker.commonPositions.addAll([
      58,
      62,
      25,
      80,
      28,
      78,
      84,
      86,
      111,
      119,
      6,
      17,
    ]);

    final board = List.generate(121, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΘΟΛΕΡΟΣ',
      'ΟΛΕΘΡΟΣ',
      'ΘΟΛΟΣ',
      'ΛΕΡΟΣ',
      'ΟΡΘΟΣ',
      'ΡΟΛΟΣ',
      'ΘΕΡΟΣ',
      'ΟΛΟΣ',
      'ΟΡΘΟ',
      'ΟΡΟΣ',
      'ΟΡΣΕ',
      'ΡΕΣΟ',
      'ΡΟΛΕ',
      'ΡΟΛΟ',
      'ΣΟΛΟ',
      'ΕΘΟΣ',
      'ΕΛΟΣ',
      'ΘΕΟΣ',
      'ΟΘΕ',
      'ΟΛΟ',
      'ΟΣΟ',
      'ΣΕΡ',
      'ΣΟΛ',
      'ΕΛΟ',
      'ΕΣΟ',
    ];
    final letters = ['Ρ', 'Ο', 'Θ', 'Σ', 'Ο', 'Ε', 'Λ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel5Option4() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΣΑΚΙΔΙΟ', [63, 64, 65, 66, 67, 68, 69]);
    tracker.addPlacement('ΔΙΚΑΙΟΣ', [28, 40, 52, 64, 76, 88, 100]);
    tracker.addPlacement('ΔΙΚΑΙΟ', [28, 29, 30, 31, 32, 33]);
    tracker.addPlacement('ΔΙΑΚΟΣ', [84, 85, 86, 87, 88, 89]);
    tracker.addPlacement('ΔΙΣΑΚΙ', [73, 85, 97, 109, 121, 133]);
    tracker.addPlacement('ΔΙΣΚΙΟ', [132, 133, 134, 135, 136, 137]);
    tracker.addPlacement('ΔΟΙΑΚΙ', [8, 20, 32, 44, 56, 68]);
    tracker.addPlacement('ΑΔΙΚΟ', [7, 8, 9, 10, 11]);
    tracker.addPlacement('ΔΑΚΟΣ', [67, 79, 91, 103, 115]);
    tracker.addPlacement('ΚΑΔΟΣ', [91, 92, 93, 94, 95]);
    tracker.addPlacement('ΣΙΑΔΙ', [115, 116, 117, 118, 119]);
    tracker.addPlacement('ΟΙΚΙΑ', [11, 23, 35, 47, 59]);
    tracker.addPlacement('ΑΣΚΙ', [37, 38, 39, 40]);

    tracker.commonPositions.addAll([
      64,
      67,
      68,
      28,
      40,
      88,
      32,
      85,
      133,
      8,
      11,
      91,
      115,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΣΑΚΙΔΙΟ',
      'ΔΙΚΑΙΟΣ',
      'ΔΙΚΑΙΟ',
      'ΔΙΑΚΟΣ',
      'ΔΙΣΑΚΙ',
      'ΔΙΣΚΙΟ',
      'ΔΟΙΑΚΙ',
      'ΑΔΙΚΟΣ',
      'ΚΑΙΣΙΟ',
      'ΑΔΙΚΟ',
      'ΙΔΙΟΣ',
      'ΙΙΚΟΣ',
      'ΔΑΚΟΣ',
      'ΔΙΚΙΟ',
      'ΔΙΚΟΣ',
      'ΚΑΔΟΣ',
      'ΣΙΑΔΙ',
      'ΟΙΚΙΑ',
      'ΑΣΚΙ',
      'ΙΣΚΑ',
      'ΙΔΙΑ',
      'ΣΟΔΑ',
      'ΟΙΔΑ',
      'ΣΚΙΑ',
      'ΣΑΚΙ',
      'ΙΔΙΟ',
      'ΚΟΣΑ',
      'ΣΙΚ',
      'ΣΚΑ',
      'ΣΚΙ',
      'ΟΚΑ',
      'ΚΑΣ',
      'ΣΟΙ',
      'ΣΟΚ',
      'ΚΑΙ',
      'ΙΣΟ',
      'ΙΣΑ',
      'ΙΟΣ',
      'ΔΙΑ',
      'ΔΙΣ',
      'ΣΙΑ',
    ];
    final letters = ['Δ', 'Ο', 'Σ', 'Ι', 'Κ', 'Α', 'Ι'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel5Option5() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΤΟΝΙΚΟΣ', [63, 64, 65, 66, 67, 68, 69]);
    tracker.addPlacement('ΚΟΤΙΝΟΣ', [39, 51, 63, 75, 87, 99, 111]);
    tracker.addPlacement('ΚΟΙΝΟΣ', [39, 40, 41, 42, 43, 44]);
    tracker.addPlacement('ΝΟΤΙΟΣ', [87, 88, 89, 90, 91, 92]);
    tracker.addPlacement('ΝΤΙΣΚΟ', [108, 109, 110, 111, 112, 113]);
    tracker.addPlacement('ΟΙΚΤΟΣ', [73, 85, 97, 109, 121, 133]);
    tracker.addPlacement('ΣΚΟΝΤΟ', [133, 134, 135, 136, 137, 138]);
    tracker.addPlacement('ΣΟΚΙΝ', [92, 104, 116, 128, 140]);
    tracker.addPlacement('ΤΙΝΟΣ', [127, 128, 129, 130, 131]);
    tracker.addPlacement('ΤΣΙΚΟ', [82, 94, 106, 118, 130]);
    tracker.addPlacement('ΝΙΟΣ', [8, 20, 32, 44]);
    tracker.addPlacement('ΟΚΙΟ', [18, 19, 20, 21]);
    tracker.addPlacement('ΟΣΤΟ', [4, 16, 28, 40]);

    tracker.commonPositions.addAll([
      63,
      39,
      87,
      111,
      40,
      44,
      92,
      109,
      133,
      128,
      130,
      20,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΤΟΝΙΚΟΣ',
      'ΚΟΤΙΝΟΣ',
      'ΚΟΙΝΟΣ',
      'ΝΟΤΙΟΣ',
      'ΝΤΙΣΚΟ',
      'ΝΤΟΚΟΣ',
      'ΟΙΚΤΟΣ',
      'ΣΚΟΝΤΟ',
      'ΚΟΝΤΟΣ',
      'ΤΟΚΟΣ',
      'ΝΤΙΣΚ',
      'ΟΙΚΟΣ',
      'ΚΟΤΟΝ',
      'ΟΙΝΟΣ',
      'ΟΚΝΟΣ',
      'ΝΟΤΟΣ',
      'ΚΟΙΝΟ',
      'ΤΣΟΝΙ',
      'ΣΟΚΙΝ',
      'ΤΟΝΟΣ',
      'ΤΙΝΟΣ',
      'ΤΣΙΚΟ',
      'ΚΟΤΣΙ',
      'ΤΟΝΙΚ',
      'ΚΟΝΙΣ',
      'ΝΙΟΣ',
      'ΟΚΙΟ',
      'ΟΣΤΟ',
      'ΚΙΤΣ',
      'ΚΙΝΟ',
      'ΣΚΙΤ',
      'ΝΤΟΚ',
      'ΟΝΟΣ',
      'ΤΣΟΚ',
      'ΣΤΙΚ',
      'ΣΤΟΚ',
      'ΤΟΣΟ',
      'ΙΣΟΝ',
      'ΤΙΣ',
      'ΣΟΚ',
      'ΣΚΙ',
      'ΙΟΝ',
      'ΙΟΣ',
      'ΙΣΟ',
      'ΤΙΚ',
      'ΣΙΚ',
      'ΚΙΤ',
      'ΟΤΙ',
      'ΟΣΟ',
      'ΝΤΟ',
      'ΤΟΝ',
      'ΣΟΙ',
    ];
    final letters = ['Ο', 'Τ', 'Κ', 'Ο', 'Ν', 'Ι', 'Σ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel5Option6() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΠΑΓΩΝΙΑ', [63, 64, 65, 66, 67, 68, 69]);
    tracker.addPlacement('ΠΑΓΑΙΝΩ', [63, 75, 87, 99, 111, 123, 135]);
    tracker.addPlacement('ΠΑΓΩΝΙ', [85, 86, 87, 88, 89, 90]);
    tracker.addPlacement('ΑΓΩΝΙΑ', [120, 121, 122, 123, 124, 125]);
    tracker.addPlacement('ΠΑΑΙΝΩ', [6, 18, 30, 42, 54, 66]);
    tracker.addPlacement('ΝΑΓΙΑ', [17, 18, 19, 20, 21]);
    tracker.addPlacement('ΠΑΙΝΩ', [40, 41, 42, 43, 44]);
    tracker.addPlacement('ΠΝΙΓΩ', [85, 97, 109, 121, 133]);
    tracker.addPlacement('ΑΓΑΠΩ', [69, 81, 93, 105, 117]);
    tracker.addPlacement('ΠΑΝΙ', [92, 93, 94, 95]);
    tracker.addPlacement('ΠΑΓΩ', [114, 115, 116, 117]);
    tracker.addPlacement('ΩΝΙΑ', [71, 83, 95, 107]);
    tracker.addPlacement('ΓΑΙΑ', [103, 115, 127, 139]);

    tracker.commonPositions.addAll([
      63,
      66,
      69,
      87,
      123,
      85,
      121,
      18,
      42,
      93,
      117,
      95,
      115,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΠΑΓΩΝΙΑ',
      'ΠΑΓΑΙΝΩ',
      'ΠΑΓΩΝΙ',
      'ΑΓΩΝΙΑ',
      'ΠΑΑΙΝΩ',
      'ΝΑΓΙΑ',
      'ΠΑΙΝΩ',
      'ΠΙΑΝΩ',
      'ΠΝΙΓΩ',
      'ΑΓΑΠΩ',
      'ΑΝΑΓΩ',
      'ΑΠΑΓΩ',
      'ΑΠΑΝΩ',
      'ΓΩΝΙΑ',
      'ΠΑΝΙ',
      'ΠΑΓΩ',
      'ΩΝΙΑ',
      'ΑΓΑΝ',
      'ΑΓΩΙ',
      'ΑΝΩΙ',
      'ΑΙΓΑ',
      'ΑΙΝΩ',
      'ΑΝΙΑ',
      'ΑΠΑΝ',
      'ΠΙΝΑ',
      'ΑΠΩΝ',
      'ΓΑΙΑ',
      'ΓΑΝΑ',
      'ΠΙΝΩ',
      'ΠΑΝΑ',
      'ΝΑΠΑ',
      'ΠΑΩ',
      'ΑΓΩ',
      'ΑΝΑ',
      'ΠΙΑ',
      'ΑΝΩ',
      'ΠΑΝ',
      'ΠΙΝ',
      'ΑΠΩ',
      'ΓΙΑ',
      'ΓΙΝ',
      'ΙΝΑ',
      'ΝΑΙ',
      'ΠΙΩ',
    ];
    final letters = ['Π', 'Α', 'Ω', 'Ν', 'Γ', 'Α', 'Ι'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  // LEVEL: 6
  static CurrentStage _backupLevel6Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΠΑΝΤΙΕΡΑ', [62, 63, 64, 65, 66, 67, 68, 69]);
    tracker.addPlacement('ΑΝΤΙΠΕΡΑ', [14, 26, 38, 50, 62, 74, 86, 98]);
    tracker.addPlacement('ΠΕΝΤΑΡΙ', [24, 25, 26, 27, 28, 29, 30]);
    tracker.addPlacement('ΑΝΤΡΕΙΑ', [98, 99, 100, 101, 102, 103, 104]);
    tracker.addPlacement('ΠΑΤΙΝΕΡ', [24, 36, 48, 60, 72, 84, 96]);
    tracker.addPlacement('ΠΕΝΤΑΡΑ', [8, 20, 32, 44, 56, 68, 80]);
    tracker.addPlacement('ΕΤΑΙΡΑ', [53, 65, 77, 89, 101, 113]);
    tracker.addPlacement('ΤΡΑΠΕΙ', [5, 6, 7, 8, 9, 10]);
    tracker.addPlacement('ΤΙΑΡΑ', [91, 103, 115, 127, 139]);
    tracker.addPlacement('ΠΑΤΕΡ', [138, 139, 140, 141, 142]);
    tracker.addPlacement('ΤΑΠΕΡ', [94, 106, 118, 130, 142]);
    tracker.addPlacement('ΝΕΤΑ', [99, 111, 123, 135]);
    tracker.addPlacement('ΑΡΤΙ', [121, 122, 123, 124]);
    tracker.addPlacement('ΝΤΙΠ', [43, 44, 45, 46]);

    tracker.commonPositions.addAll([
      62,
      65,
      68,
      26,
      98,
      24,
      99,
      101,
      103,
      8,
      44,
      139,
      142,
      123,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΠΑΝΤΙΕΡΑ',
      'ΑΝΤΙΠΕΡΑ',
      'ΠΕΝΤΑΡΙ',
      'ΑΝΤΡΕΙΑ',
      'ΠΑΤΙΝΕΡ',
      'ΠΕΝΤΑΡΑ',
      'ΠΑΤΡΙΑ',
      'ΠΑΤΑΡΙ',
      'ΤΕΡΙΝΑ',
      'ΑΕΤΙΝΑ',
      'ΕΤΑΙΡΑ',
      'ΤΡΑΠΕΙ',
      'ΠΑΝΕΡΙ',
      'ΝΤΑΠΙΑ',
      'ΝΤΡΑΠΕ',
      'ΑΝΤΕΡΙ',
      'ΠΑΡΕΙΑ',
      'ΠΕΤΡΙΑ',
      'ΠΤΕΡΝΑ',
      'ΡΑΠΑΝΙ',
      'ΑΙΠΑΝΤ',
      'ΑΡΙΕΤΑ',
      'ΡΕΠΑΝΙ',
      'ΠΑΤΙΝΑ',
      'ΠΑΡΤΙ',
      'ΤΙΑΡΑ',
      'ΠΑΤΕΡ',
      'ΠΑΡΤΑ',
      'ΑΡΕΝΑ',
      'ΝΤΑΡΑ',
      'ΠΕΙΝΑ',
      'ΡΑΤΑΝ',
      'ΠΕΝΙΑ',
      'ΠΑΡΕΑ',
      'ΠΑΝΤΑ',
      'ΠΕΡΑΝ',
      'ΠΕΤΡΑ',
      'ΤΑΠΙΑ',
      'ΤΑΠΕΡ',
      'ΠΙΕΤΑ',
      'ΠΙΝΤΑ',
      'ΡΕΝΤΑ',
      'ΡΑΝΤΑ',
      'ΝΙΑΤΑ',
      'ΠΕΙΡΑ',
      'ΑΙΝΤΕ',
      'ΠΑΝΑ',
      'ΑΡΠΑ',
      'ΠΑΤΕ',
      'ΤΡΑΠ',
      'ΝΕΤΑ',
      'ΑΡΤΙ',
      'ΑΝΤΑ',
      'ΕΙΠΑ',
      'ΑΝΙΑ',
      'ΑΡΕΙ',
      'ΠΕΝΑ',
      'ΤΑΡΑ',
      'ΝΤΙΠ',
      'ΑΠΑΝ',
      'ΠΕΡΑ',
      'ΑΡΙΑ',
      'ΠΕΡΙ',
      'ΑΝΤΕ',
      'ΠΑΝΕ',
      'ΕΠΤΑ',
      'ΠΑΝΙ',
      'ΤΑΠΑ',
    ];
    final letters = ['Ι', 'Α', 'Ν', 'Π', 'Ρ', 'Ε', 'Τ', 'Α'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel6Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΚΤΗΤΙΚΟΣ', [62, 63, 64, 65, 66, 67, 68, 69]);
    tracker.addPlacement('ΤΗΚΤΙΚΟΣ', [38, 50, 62, 74, 86, 98, 110, 122]);
    tracker.addPlacement('ΚΟΚΙΤΗΣ', [98, 99, 100, 101, 102, 103, 104]);
    tracker.addPlacement('ΤΗΚΤΟΣ', [38, 39, 40, 41, 42, 43]);
    tracker.addPlacement('ΚΙΟΤΗΣ', [9, 21, 33, 45, 57, 69]);
    tracker.addPlacement('ΚΤΙΣΗ', [19, 20, 21, 22, 23]);
    tracker.addPlacement('ΤΣΙΚΟ', [92, 104, 116, 128, 140]);
    tracker.addPlacement('ΚΗΤΟΣ', [137, 138, 139, 140, 141]);
    tracker.addPlacement('ΚΙΣΤΗ', [120, 121, 122, 123, 124]);
    tracker.addPlacement('ΣΚΙΤ', [5, 17, 29, 41]);
    tracker.addPlacement('ΣΤΙΚ', [14, 15, 16, 17]);
    tracker.addPlacement('ΣΤΟΚ', [84, 96, 108, 120]);
    tracker.addPlacement('ΗΤΟΙ', [23, 35, 47, 59]);
    tracker.addPlacement('ΟΤΙ', [90, 102, 114]);

    tracker.commonPositions.addAll([
      62,
      69,
      38,
      98,
      122,
      102,
      104,
      41,
      21,
      23,
      140,
      120,
      17,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΚΤΗΤΙΚΟΣ',
      'ΤΗΚΤΙΚΟΣ',
      'ΚΟΚΙΤΗΣ',
      'ΤΗΚΤΟΣ',
      'ΚΙΟΤΗΣ',
      'ΚΤΙΣΗ',
      'ΤΣΙΚΟ',
      'ΚΗΤΟΣ',
      'ΚΙΣΤΗ',
      'ΚΟΙΤΗ',
      'ΚΟΤΣΙ',
      'ΣΚΙΤ',
      'ΣΤΙΚ',
      'ΣΤΟΚ',
      'ΤΟΣΤ',
      'ΤΣΟΚ',
      'ΗΤΟΙ',
      'ΚΙΤΣ',
      'ΟΤΙ',
      'ΣΙΚ',
      'ΣΚΙ',
      'ΣΟΙ',
      'ΣΟΚ',
      'ΤΗΣ',
      'ΤΙΚ',
      'ΤΙΣ',
      'ΙΟΣ',
      'ΙΣΟ',
      'ΚΙΤ',
      'ΚΟΚ',
    ];
    final letters = ['Ι', 'Ο', 'Τ', 'Σ', 'Κ', 'Κ', 'Τ', 'Η'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel6Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΜΟΥΣΙΤΣΑ', [62, 63, 64, 65, 66, 67, 68, 69]);
    tracker.addPlacement('ΑΥΤΙΣΜΟΣ', [2, 14, 26, 38, 50, 62, 74, 86]);
    tracker.addPlacement('ΣΙΑΤΣΟΥ', [0, 1, 2, 3, 4, 5, 6]);
    tracker.addPlacement('ΣΟΥΣΑΜΙ', [0, 12, 24, 36, 48, 60, 72]);
    tracker.addPlacement('ΣΤΑΣΙΜΟ', [86, 87, 88, 89, 90, 91, 92]);
    tracker.addPlacement('ΣΤΑΣΟΥ', [4, 16, 28, 40, 52, 64]);
    tracker.addPlacement('ΙΑΣΜΟΣ', [8, 20, 32, 44, 56, 68]);
    tracker.addPlacement('ΜΟΥΣΙ', [91, 103, 115, 127, 139]);
    tracker.addPlacement('ΣΟΥΜΑ', [113, 114, 115, 116, 117]);
    tracker.addPlacement('ΙΑΤΟΣ', [139, 140, 141, 142, 143]);
    tracker.addPlacement('ΜΙΣΟΣ', [95, 107, 119, 131, 143]);
    tracker.addPlacement('ΑΟΥΤΣ', [28, 29, 30, 31, 32]);
    tracker.addPlacement('ΤΣΙΣΑ', [87, 99, 111, 123, 135]);
    tracker.addPlacement('ΜΙΑΣ', [133, 134, 135, 136]);

    tracker.commonPositions.addAll([
      62,
      64,
      68,
      2,
      86,
      0,
      4,
      87,
      91,
      28,
      32,
      115,
      139,
      143,
      135,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΜΟΥΣΙΤΣΑ',
      'ΑΥΤΙΣΜΟΣ',
      'ΣΙΑΤΣΟΥ',
      'ΣΟΥΣΑΜΙ',
      'ΣΤΑΣΙΜΟ',
      'ΣΤΑΣΟΥ',
      'ΙΑΣΜΟΣ',
      'ΑΤΙΜΟΣ',
      'ΙΤΑΜΟΣ',
      'ΣΟΥΣΤΑ',
      'ΜΑΣΤΟΣ',
      'ΜΙΣΤΟΣ',
      'ΣΟΥΙΤΑ',
      'ΜΟΥΣΙ',
      'ΣΟΥΜΑ',
      'ΙΑΤΟΣ',
      'ΜΑΤΣΟ',
      'ΜΙΑΟΥ',
      'ΜΟΥΤΑ',
      'ΑΣΙΣΤ',
      'ΜΙΣΟΣ',
      'ΜΙΤΟΣ',
      'ΑΟΥΤΣ',
      'ΜΟΥΣΑ',
      'ΑΤΜΟΣ',
      'ΜΟΥΤΙ',
      'ΜΥΤΙΑ',
      'ΜΥΤΟΣ',
      'ΜΑΟΥΣ',
      'ΣΙΤΟΣ',
      'ΣΟΥΣΙ',
      'ΟΥΣΙΑ',
      'ΑΥΤΟΣ',
      'ΤΣΙΣΑ',
      'ΟΣΤΙΑ',
      'ΙΣΤΟΣ',
      'ΣΤΟΜΑ',
      'ΑΟΥΤ',
      'ΥΙΟΣ',
      'ΜΙΑΣ',
      'ΜΥΙΑ',
      'ΑΣΤΥ',
      'ΟΥΣΤ',
      'ΟΥΤΙ',
      'ΣΑΙΤ',
      'ΜΑΣΤ',
      'ΣΑΣΙ',
      'ΜΟΥΣ',
      'ΑΤΟΣ',
      'ΣΙΜΑ',
      'ΣΙΤΑ',
      'ΜΑΤΣ',
      'ΤΟΥΣ',
      'ΤΑΣΙ',
      'ΜΑΤΙ',
      'ΙΣΟΣ',
      'ΤΣΑΟ',
      'ΣΟΥΣ',
      'ΑΣΟΣ',
      'ΑΤΟΥ',
      'ΑΥΤΙ',
      'ΣΟΥΤ',
      'ΣΤΟΑ',
      'ΑΥΤΟ',
      'ΟΥΑΙ',
      'ΤΣΑΙ',
      'ΣΟΥ',
      'ΤΑΟ',
      'ΣΟΣ',
      'ΤΑΥ',
      'ΤΙΜ',
      'ΤΙΣ',
      'ΤΟΥ',
    ];
    final letters = ['Α', 'Ο', 'Τ', 'Σ', 'Υ', 'Ι', 'Μ', 'Σ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel6Option4() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΜΟΚΑΣΙΝΙ', [62, 63, 64, 65, 66, 67, 68, 69]);
    tracker.addPlacement('ΑΜΙΝΙΚΟΣ', [50, 62, 74, 86, 98, 110, 122, 134]);
    tracker.addPlacement('ΙΝΙΑΚΟΣ', [85, 86, 87, 88, 89, 90, 91]);
    tracker.addPlacement('ΚΑΜΙΝΟΣ', [110, 111, 112, 113, 114, 115, 116]);
    tracker.addPlacement('ΚΑΜΙΟΝΙ', [8, 20, 32, 44, 56, 68, 80]);
    tracker.addPlacement('ΚΟΝΙΣΜΑ', [14, 15, 16, 17, 18, 19, 20]);
    tracker.addPlacement('ΣΜΟΚΙΝ', [40, 41, 42, 43, 44, 45]);
    tracker.addPlacement('ΚΑΣΟΝΙ', [132, 133, 134, 135, 136, 137]);
    tracker.addPlacement('ΚΟΣΑ', [8, 9, 10, 11]);
    tracker.addPlacement('ΑΣΚΙ', [11, 23, 35, 47]);
    tracker.addPlacement('ΜΙΝΚ', [96, 108, 120, 132]);
    tracker.addPlacement('ΙΣΟΝ', [104, 116, 128, 140]);
    tracker.addPlacement('ΣΝΑΚ', [139, 140, 141, 142]);
    tracker.addPlacement('ΙΣΑ', [104, 105, 106]);

    tracker.commonPositions.addAll([
      62,
      68,
      86,
      110,
      134,
      116,
      8,
      20,
      44,
      132,
      11,
      104,
      140,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);
    final allWords = [
      'ΜΟΚΑΣΙΝΙ',
      'ΑΜΙΝΙΚΟΣ',
      'ΙΝΙΑΚΟΣ',
      'ΚΑΜΙΝΟΣ',
      'ΚΑΜΙΟΝΙ',
      'ΚΟΝΙΣΜΑ',
      'ΣΜΟΚΙΝ',
      'ΙΚΑΝΟΣ',
      'ΚΑΣΟΝΙ',
      'ΚΑΙΝΟΣ',
      'ΚΑΙΣΙΟ',
      'ΚΑΜΙΝΙ',
      'ΚΙΟΝΑΣ',
      'ΜΑΝΙΚΙ',
      'ΜΙΣΙΝΑ',
      'ΝΟΜΙΚΑ',
      'ΣΚΑΜΝΙ',
      'ΣΚΟΙΝΙ',
      'ΜΟΝΑΣ',
      'ΝΟΙΚΙ',
      'ΑΜΟΝΙ',
      'ΙΙΚΟΣ',
      'ΑΜΝΙΟ',
      'ΣΟΚΙΝ',
      'ΚΑΝΙΣ',
      'ΚΙΜΑΣ',
      'ΚΙΝΟΑ',
      'ΑΜΝΟΣ',
      'ΚΝΙΣΑ',
      'ΚΟΙΝΑ',
      'ΚΟΜΙΣ',
      'ΚΟΝΙΑ',
      'ΚΟΝΙΣ',
      'ΜΑΟΝΙ',
      'ΜΙΝΙΟ',
      'ΟΙΚΙΑ',
      'ΑΚΟΝΙ',
      'ΜΟΝΙΑ',
      'ΝΟΜΑΣ',
      'ΝΙΟΚΙ',
      'ΑΙΝΟΣ',
      'ΚΟΣΑ',
      'ΜΑΚΟ',
      'ΜΑΝΙ',
      'ΣΙΝΙ',
      'ΜΑΝΟ',
      'ΑΣΚΙ',
      'ΣΙΜΑ',
      'ΜΙΑΣ',
      'ΜΙΝΑ',
      'ΜΙΝΙ',
      'ΚΑΝΟ',
      'ΜΙΝΚ',
      'ΣΑΚΙ',
      'ΑΜΟΚ',
      'ΙΣΟΝ',
      'ΜΟΚΑ',
      'ΣΚΙΑ',
      'ΣΝΑΚ',
      'ΚΙΝΑ',
      'ΝΑΟΣ',
      'ΝΑΣΙ',
      'ΚΙΝΟ',
      'ΙΝΙΟ',
      'ΙΣΚΑ',
      'ΝΙΟΣ',
      'ΙΣΑ',
      'ΜΝΑ',
      'ΟΚΑ',
      'ΜΙΣ',
      'ΣΑΝ',
      'ΣΙΑ',
      'ΣΙΚ',
      'ΜΑΣ',
      'ΙΟΝ',
      'ΣΚΑ',
      'ΚΑΙ',
      'ΣΚΙ',
      'ΙΝΑ',
      'ΙΣΟ',
      'ΚΑΣ',
      'ΚΑΝ',
      'ΣΟΙ',
      'ΣΟΚ',
      'ΙΜΟ',
      'ΝΑΙ',
      'ΙΟΣ',
    ];

    final letters = ['Α', 'Ο', 'Ν', 'Σ', 'Κ', 'Μ', 'Ι', 'Ι'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel6Option5() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΠΛΑΚΩΤΟΣ', [62, 63, 64, 65, 66, 67, 68, 69]);
    tracker.addPlacement('ΠΑΚΤΩΛΟΣ', [3, 15, 27, 39, 51, 63, 75, 87]);
    tracker.addPlacement('ΚΛΟΤΣΑΩ', [27, 28, 29, 30, 31, 32, 33]);
    tracker.addPlacement('ΑΠΛΩΤΟΣ', [2, 3, 4, 5, 6, 7, 8]);
    tracker.addPlacement('ΚΛΟΤΣΩ', [65, 77, 89, 101, 113, 125]);
    tracker.addPlacement('ΠΛΑΤΟΣ', [108, 109, 110, 111, 112, 113]);
    tracker.addPlacement('ΚΟΠΤΣΑ', [56, 68, 80, 92, 104, 116]);
    tracker.addPlacement('ΣΚΑΠΤΩ', [72, 84, 96, 108, 120, 132]);
    tracker.addPlacement('ΣΤΟΚ', [91, 92, 93, 94]);
    tracker.addPlacement('ΠΟΣΤ', [36, 37, 38, 39]);
    tracker.addPlacement('ΤΑΛΚ', [115, 116, 117, 118]);
    tracker.addPlacement('ΤΑΩΣ', [98, 110, 122, 134]);
    tracker.addPlacement('ΤΣΟΚ', [13, 25, 37, 49]);
    tracker.addPlacement('ΚΑΩ', [118, 130, 142]);

    tracker.commonPositions.addAll([
      63,
      65,
      68,
      3,
      27,
      39,
      113,
      108,
      110,
      92,
      116,
      37,
      118,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);
    final allWords = [
      'ΠΛΑΚΩΤΟΣ',
      'ΠΑΚΤΩΛΟΣ',
      'ΚΛΟΤΣΑΩ',
      'ΑΠΛΩΤΟΣ',
      'ΚΛΟΤΣΩ',
      'ΠΛΑΤΟΣ',
      'ΠΛΩΤΟΣ',
      'ΑΠΟΚΤΩ',
      'ΚΟΠΤΣΑ',
      'ΣΚΑΠΤΩ',
      'ΠΟΣΤΑ',
      'ΠΩΛΟΣ',
      'ΛΩΤΟΣ',
      'ΣΚΑΛΠ',
      'ΠΟΛΚΑ',
      'ΣΚΟΠΩ',
      'ΣΚΟΤΑ',
      'ΠΑΛΚΟ',
      'ΣΑΛΤΟ',
      'ΑΠΛΟΣ',
      'ΑΠΛΩΣ',
      'ΠΑΛΤΟ',
      'ΠΛΑΤΣ',
      'ΑΠΤΟΣ',
      'ΚΩΛΟΣ',
      'ΚΑΛΟΣ',
      'ΚΑΛΩΣ',
      'ΚΑΠΩΣ',
      'ΚΑΣΠΟ',
      'ΠΑΤΟΣ',
      'ΑΩΤΟΣ',
      'ΚΛΩΣΑ',
      'ΠΛΑΤΟ',
      'ΚΟΠΤΩ',
      'ΚΟΣΤΑ',
      'ΚΟΤΑΩ',
      'ΤΑΚΟΣ',
      'ΚΟΣΑ',
      'ΚΩΛΟ',
      'ΣΤΟΚ',
      'ΣΤΟΠ',
      'ΠΟΣΤ',
      'ΤΑΛΚ',
      'ΤΑΩΣ',
      'ΤΟΚΑ',
      'ΤΣΑΚ',
      'ΤΣΑΟ',
      'ΤΣΟΚ',
      'ΚΑΛΩ',
      'ΑΛΤΟ',
      'ΑΛΩΣ',
      'ΠΤΟΩ',
      'ΣΤΟΑ',
      'ΠΑΣΟ',
      'ΑΣΚΩ',
      'ΑΤΟΣ',
      'ΚΑΛΟ',
      'ΚΑΛΤ',
      'ΠΑΚΟ',
      'ΣΚΑΩ',
      'ΚΑΠΟ',
      'ΠΑΤΣ',
      'ΣΚΑΤ',
      'ΚΑΣΤ',
      'ΚΑΤΣ',
      'ΚΑΤΩ',
      'ΣΠΟΤ',
      'ΚΟΛΑ',
      'ΚΟΤΩ',
      'ΟΚΤΩ',
      'ΛΑΣΟ',
      'ΛΑΟΣ',
      'ΠΑΤΩ',
      'ΠΟΚΑ',
      'ΚΟΤΑ',
      'ΟΠΑΚ',
      'ΟΠΩΣ',
      'ΟΛΩΣ',
      'ΣΟΛΑ',
      'ΚΛΟΣ',
      'ΚΑΩ',
      'ΚΑΤ',
      'ΠΟΑ',
      'ΚΑΣ',
      'ΣΚΑ',
      'ΣΟΚ',
      'ΣΟΛ',
      'ΣΠΑ',
      'ΠΑΤ',
      'ΑΠΩ',
      'ΠΩΣ',
      'ΠΟΤ',
      'ΑΠΟ',
      'ΠΑΩ',
      'ΛΑΚ',
      'ΑΛΤ',
      'ΤΣΑ',
      'ΣΤΑ',
      'ΟΚΑ',
      'ΤΟΠ',
      'ΤΟΛ',
      'ΟΠΑ',
      'ΤΑΟ',
      'ΠΑΛ',
      'ΩΤΑ',
    ];

    final letters = ['Τ', 'Ο', 'Α', 'Σ', 'Π', 'Ω', 'Κ', 'Λ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  // LEVEL: 7
  static CurrentStage _backupLevel7Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΜΑΤΡΙΟΣΚΑ', [62, 63, 64, 65, 66, 67, 68, 69, 70]);
    tracker.addPlacement('ΑΡΜΑΤΙΚΟΣ', [38, 50, 62, 74, 86, 98, 110, 122, 134]);
    tracker.addPlacement('ΤΑΜΙΑΚΟΣ', [37, 38, 39, 40, 41, 42, 43, 44]);
    tracker.addPlacement('ΚΟΙΤΑΣΜΑ', [96, 97, 98, 99, 100, 101, 102, 103]);
    tracker.addPlacement('ΚΡΑΤΑΙΟΣ', [46, 58, 70, 82, 94, 106, 118, 130]);
    tracker.addPlacement('ΜΑΣΤΟΡΙΑ', [132, 133, 134, 135, 136, 137, 138, 139]);
    tracker.addPlacement('ΤΡΟΙΚΑ', [48, 60, 72, 84, 96, 108]);
    tracker.addPlacement('ΚΑΡΜΑ', [91, 103, 115, 127, 139]);
    tracker.addPlacement('ΜΑΡΚΟ', [88, 100, 112, 124, 136]);
    tracker.addPlacement('ΡΑΚΟΣ', [115, 116, 117, 118, 119]);
    tracker.addPlacement('ΑΙΜΑ', [5, 17, 29, 41]);
    tracker.addPlacement('ΚΙΤΣ', [16, 17, 18, 19]);
    tracker.addPlacement('ΣΑΙΤ', [1, 13, 25, 37]);
    tracker.addPlacement('ΙΣΚΑ', [0, 1, 2, 3]);
    tracker.addPlacement('ΚΟΡΑ', [91, 92, 93, 94]);

    tracker.commonPositions.addAll([
      62,
      70,
      38,
      98,
      134,
      37,
      41,
      96,
      100,
      103,
      94,
      118,
      136,
      139,
      91,
      115,
      17,
      1,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΜΑΤΡΙΟΣΚΑ',
      'ΑΡΜΑΤΙΚΟΣ',
      'ΤΑΜΙΑΚΟΣ',
      'ΚΟΙΤΑΣΜΑ',
      'ΚΡΑΤΑΙΟΣ',
      'ΜΑΚΑΡΙΟΣ',
      'ΜΑΣΤΟΡΙΑ',
      'ΟΣΤΡΑΚΙΑ',
      'ΤΣΟΚΑΡΙΑ',
      'ΑΚΑΤΙΟΣ',
      'ΚΑΜΑΤΟΣ',
      'ΚΑΡΟΤΣΑ',
      'ΚΑΡΟΤΣΙ',
      'ΚΑΣΤΟΡΙ',
      'ΚΑΤΙΜΑΣ',
      'ΚΑΤΡΑΜΙ',
      'ΑΚΡΙΤΟΣ',
      'ΚΟΡΑΣΙΑ',
      'ΚΟΣΜΑΡΑ',
      'ΚΟΤΣΑΡΙ',
      'ΑΚΡΙΤΑΣ',
      'ΑΚΑΙΡΟΣ',
      'ΜΟΣΚΑΡΙ',
      'ΣΑΜΑΡΙΟ',
      'ΜΑΤΑΙΟΣ',
      'ΑΚΡΑΤΟΣ',
      'ΜΑΣΤΑΡΙ',
      'ΑΣΤΡΑΚΙ',
      'ΑΚΜΑΙΟΣ',
      'ΚΡΙΤΑΜΟ',
      'ΑΚΡΑΙΟΣ',
      'ΑΚΟΣΜΙΑ',
      'ΜΙΚΡΑΤΑ',
      'ΑΣΟΡΤΙ',
      'ΚΡΑΤΟΣ',
      'ΚΟΣΑΡΙ',
      'ΚΤΙΣΜΑ',
      'ΑΣΤΑΡΙ',
      'ΜΑΚΑΡΙ',
      'ΤΡΟΙΚΑ',
      'ΜΑΚΡΙΑ',
      'ΚΟΡΑΣΙ',
      'ΜΑΚΤΡΟ',
      'ΜΑΣΚΟΤ',
      'ΚΟΜΑΡΑ',
      'ΑΡΚΤΟΣ',
      'ΑΡΤΙΟΣ',
      'ΚΟΑΣΜΑ',
      'ΜΑΤΑΚΙ',
      'ΜΙΑΡΟΣ',
      'ΚΑΣΤΡΟ',
      'ΜΙΚΡΟΣ',
      'ΜΙΚΤΟΣ',
      'ΚΑΣΑΤΟ',
      'ΚΑΡΑΤΙ',
      'ΤΟΜΑΡΙ',
      'ΟΡΙΣΜΑ',
      'ΑΡΙΣΤΑ',
      'ΟΣΤΡΙΑ',
      'ΡΑΙΣΜΑ',
      'ΚΑΜΑΡΙ',
      'ΡΙΚΟΤΑ',
      'ΚΑΙΡΟΣ',
      'ΑΚΑΤΟΣ',
      'ΣΑΜΑΡΙ',
      'ΙΤΑΜΟΣ',
      'ΣΑΡΑΚΙ',
      'ΣΑΡΚΙΟ',
      'ΣΑΤΙΡΑ',
      'ΜΟΣΤΡΑ',
      'ΑΡΑΙΟΣ',
      'ΑΤΙΜΟΣ',
      'ΣΚΟΤΙΑ',
      'ΤΣΙΡΚΟ',
      'ΣΤΟΡΙΑ',
      'ΣΤΡΑΚΑ',
      'ΤΑΙΣΜΑ',
      'ΙΑΤΡΟΣ',
      'ΤΑΜΙΑΣ',
      'ΤΣΑΡΚΑ',
      'ΤΑΣΑΚΙ',
      'ΤΣΑΚΡΑ',
      'ΤΣΑΚΙΡ',
      'ΜΑΚΡΟΣ',
      'ΤΡΑΚΟ',
      'ΣΙΤΑΡ',
      'ΤΡΙΚΟ',
      'ΤΡΑΚΑ',
      'ΤΣΑΚΑ',
      'ΚΑΡΜΑ',
      'ΚΡΑΣΙ',
      'ΑΤΜΟΣ',
      'ΜΑΚΙΑ',
      'ΤΙΑΡΑ',
      'ΚΡΑΜΑ',
      'ΚΑΡΣΙ',
      'ΚΑΡΣΤ',
      'ΑΡΤΟΣ',
      'ΜΑΡΚΑ',
      'ΜΑΡΚΟ',
      'ΤΑΚΟΣ',
      'ΑΚΡΙΑ',
      'ΚΟΣΤΑ',
      'ΜΑΣΙΑ',
      'ΜΑΣΚΑ',
      'ΣΤΟΡΙ',
      'ΣΤΟΜΑ',
      'ΚΑΡΤΑ',
      'ΚΑΡΤΟ',
      'ΑΚΡΟΣ',
      'ΣΤΑΡΙ',
      'ΑΤΡΙΟ',
      'ΣΤΑΚΑ',
      'ΜΑΤΙΑ',
      'ΤΣΙΚΟ',
      'ΜΑΤΣΑ',
      'ΜΑΤΣΟ',
      'ΑΣΤΡΟ',
      'ΣΜΑΡΙ',
      'ΚΑΣΤΑ',
      'ΜΙΚΡΟ',
      'ΣΚΟΤΑ',
      'ΚΡΙΜΑ',
      'ΣΚΑΡΙ',
      'ΜΙΤΟΣ',
      'ΜΙΤΡΑ',
      'ΜΟΙΡΑ',
      'ΣΚΑΡΑ',
      'ΚΟΡΜΙ',
      'ΑΡΜΟΣ',
      'ΜΟΡΣΑ',
      'ΑΡΤΙΟ',
      'ΣΑΡΚΑ',
      'ΚΡΙΟΣ',
      'ΟΡΑΜΑ',
      'ΙΑΤΟΣ',
      'ΣΑΡΙΑ',
      'ΟΡΜΙΑ',
      'ΟΡΤΣΑ',
      'ΟΣΚΑΡ',
      'ΟΣΤΙΑ',
      'ΚΟΜΙΣ',
      'ΣΑΡΑΙ',
      'ΡΟΚΙΑ',
      'ΚΙΜΑΣ',
      'ΡΑΚΟΣ',
      'ΑΡΙΟΣ',
      'ΡΟΚΑΣ',
      'ΡΙΣΚΟ',
      'ΡΑΣΤΑ',
      'ΡΑΤΣΑ',
      'ΚΟΤΣΙ',
      'ΚΙΤΡΟ',
      'ΑΙΜΑ',
      'ΚΙΤΣ',
      'ΡΟΚΑ',
      'ΡΑΜΙ',
      'ΑΚΡΑ',
      'ΑΡΙΑ',
      'ΡΟΤΑ',
      'ΣΑΙΤ',
      'ΣΑΚΑ',
      'ΣΑΚΙ',
      'ΑΡΑΚ',
      'ΙΣΚΑ',
      'ΣΑΡΑ',
      'ΚΑΤΣ',
      'ΑΡΤΙ',
      'ΣΑΡΙ',
      'ΟΡΚΑ',
      'ΚΑΤΙ',
      'ΚΟΡΑ',
      'ΚΑΤΑ',
      'ΜΟΡΣ',
      'ΜΟΡΑ',
      'ΣΙΜΑ',
      'ΣΙΤΑ',
      'ΑΡΜΑ',
      'ΡΑΣΟ',
      'ΜΟΚΑ',
      'ΑΚΡΟ',
      'ΙΑΜΑ',
      'ΚΟΣΑ',
      'ΣΚΙΑ',
      'ΣΚΙΤ',
      'ΣΚΟΡ',
      'ΑΤΣΑ',
      'ΑΜΟΚ',
      'ΜΙΑΣ',
      'ΤΣΟΚ',
      'ΚΑΣΤ',
      'ΣΟΡΙ',
      'ΜΑΤΣ',
      'ΜΑΤΙ',
      'ΣΤΑΡ',
      'ΚΑΣΑ',
      'ΣΤΙΚ',
      'ΣΤΟΑ',
      'ΣΤΟΚ',
      'ΜΑΣΤ',
      'ΚΑΡΤ',
      'ΜΑΣΑ',
      'ΚΟΤΑ',
      'ΚΑΜΑ',
      'ΡΙΜΑ',
      'ΤΑΜΑ',
      'ΣΚΑΤ',
      'ΜΑΡΑ',
      'ΑΤΟΣ',
      'ΤΣΑΟ',
      'ΤΑΡΑ',
      'ΤΑΡΟ',
      'ΚΡΑΣ',
      'ΤΑΣΙ',
      'ΜΑΚΟ',
      'ΚΑΡΟ',
      'ΑΣΚΙ',
      'ΜΑΙΑ',
      'ΤΟΚΑ',
      'ΚΑΡΑ',
      'ΤΣΑΚ',
      'ΤΡΑΚ',
      'ΚΑΡΙ',
      'ΤΣΑΙ',
      'ΤΡΑΜ',
      'ΤΡΙΑ',
      'ΤΡΙΚ',
      'ΑΣΜΑ',
      'ΤΡΙΟ',
      'ΤΡΙΣ',
      'ΜΑΡΣ',
      'ΜΑΚΑ',
      'ΣΚΑ',
      'ΤΟΡ',
      'ΤΙΣ',
      'ΤΙΜ',
      'ΤΙΚ',
      'ΤΑΡ',
      'ΤΑΟ',
      'ΣΤΑ',
      'ΣΟΚ',
      'ΣΟΙ',
      'ΣΚΙ',
      'ΟΚΑ',
      'ΣΙΚ',
      'ΣΙΑ',
      'ΡΟΜ',
      'ΡΟΚ',
      'ΡΑΜ',
      'ΟΤΙ',
      'ΜΙΣ',
      'ΜΑΤ',
      'ΜΑΣ',
      'ΚΡΑ',
      'ΚΙΤ',
      'ΤΣΑ',
      'ΚΑΣ',
      'ΑΜΑ',
      'ΚΑΙ',
      'ΑΡΑ',
      'ΙΣΟ',
      'ΙΣΑ',
      'ΙΟΣ',
      'ΙΜΟ',
      'ΑΤΙ',
      'ΑΤΑ',
      'ΑΡΜ',
      'ΚΑΤ',
    ];

    final letters = ['Α', 'Κ', 'Ο', 'Τ', 'Α', 'Μ', 'Σ', 'Ρ', 'Ι'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel7Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΚΗΛΙΔΩΤΟΣ', [62, 63, 64, 65, 66, 67, 68, 69, 70]);
    tracker.addPlacement('ΔΗΛΩΤΙΚΟΣ', [40, 52, 64, 76, 88, 100, 112, 124, 136]);
    tracker.addPlacement('ΔΙΩΚΤΗΣ', [40, 41, 42, 43, 44, 45, 46]);
    tracker.addPlacement('ΔΗΛΙΟΣ', [97, 98, 99, 100, 101, 102]);
    tracker.addPlacement('ΔΟΤΙΚΗ', [123, 124, 125, 126, 127, 128]);
    tracker.addPlacement('ΩΔΙΚΗ', [85, 97, 109, 121, 133]);
    tracker.addPlacement('ΙΩΔΗΣ', [92, 104, 116, 128, 140]);
    tracker.addPlacement('ΚΙΣΤΗ', [91, 92, 93, 94, 95]);
    tracker.addPlacement('ΗΛΙΟΣ', [95, 107, 119, 131, 143]);
    tracker.addPlacement('ΤΣΙΚΟ', [26, 38, 50, 62, 74]);
    tracker.addPlacement('ΚΙΤΣ', [24, 25, 26, 27]);
    tracker.addPlacement('ΤΣΟΚ', [7, 19, 31, 43]);
    tracker.addPlacement('ΣΚΙΤ', [4, 5, 6, 7]);
    tracker.addPlacement('ΛΙΤΗ', [9, 21, 33, 45]);
    tracker.addPlacement('ΔΙΚΗ', [0, 12, 24, 36]);

    tracker.commonPositions.addAll([
      62,
      64,
      40,
      100,
      124,
      43,
      45,
      97,
      128,
      92,
      95,
      26,
      24,
      7,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final letters = ['Τ', 'Λ', 'Σ', 'Ω', 'Κ', 'Η', 'Ι', 'Ο', 'Δ'];

    final allWords = [
      'ΚΗΛΙΔΩΤΟΣ',
      'ΔΗΛΩΤΙΚΟΣ',
      'ΔΙΩΚΤΗΣ',
      'ΔΗΛΙΟΣ',
      'ΔΟΤΙΚΗ',
      'ΚΙΟΤΗΣ',
      'ΚΛΗΤΟΣ',
      'ΚΛΙΤΟΣ',
      'ΚΛΟΤΣΩ',
      'ΚΛΩΣΤΗ',
      'ΩΔΙΚΟΣ',
      'ΩΤΙΚΟΣ',
      'ΚΩΛΟΣ',
      'ΩΔΙΚΗ',
      'ΙΩΔΗΣ',
      'ΚΗΤΟΣ',
      'ΚΙΣΤΗ',
      'ΚΟΤΣΙ',
      'ΔΙΚΟΣ',
      'ΚΛΩΣΗ',
      'ΗΛΙΟΣ',
      'ΚΟΙΤΗ',
      'ΚΟΙΤΩ',
      'ΚΤΙΣΗ',
      'ΛΙΤΟΣ',
      'ΛΩΤΟΣ',
      'ΔΗΛΟΣ',
      'ΣΚΟΛΗ',
      'ΣΚΩΤΙ',
      'ΣΛΟΤΙ',
      'ΚΛΙΣΗ',
      'ΣΤΙΛΟ',
      'ΣΤΟΛΗ',
      'ΤΣΙΚΟ',
      'ΤΣΟΛΙ',
      'ΚΙΤΣ',
      'ΤΣΟΚ',
      'ΣΚΙΤ',
      'ΛΙΤΗ',
      'ΔΙΚΗ',
      'ΔΟΣΗ',
      'ΟΙΚΩ',
      'ΟΚΤΩ',
      'ΟΛΚΗ',
      'ΟΛΩΣ',
      'ΣΙΛΟ',
      'ΚΩΛΟ',
      'ΚΙΛΟ',
      'ΚΛΟΣ',
      'ΗΛΙΟ',
      'ΚΙΛΤ',
      'ΣΤΙΚ',
      'ΣΤΙΛ',
      'ΙΩΣΗ',
      'ΗΤΟΙ',
      'ΣΤΟΚ',
      'ΗΛΟΣ',
      'ΚΟΤΩ',
      'ΤΗΚΩ',
      'ΣΟΛ',
      'ΣΚΙ',
      'ΔΙΣ',
      'ΤΗΣ',
      'ΤΙΚ',
      'ΤΙΣ',
      'ΤΟΛ',
      'ΙΟΣ',
      'ΚΙΤ',
      'ΣΙΚ',
      'ΩΔΗ',
      'ΙΣΟ',
      'ΟΤΙ',
      'ΩΣΗ',
      'ΣΟΚ',
      'ΣΟΙ',
      'ΙΛΗ',
    ];
    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel7Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΦΙΛΟΞΕΝΙΑ', [62, 63, 64, 65, 66, 67, 68, 69, 70]);
    tracker.addPlacement('ΞΕΝΟΦΙΛΙΑ', [14, 26, 38, 50, 62, 74, 86, 98, 110]);
    tracker.addPlacement('ΞΙΝΙΛΑ', [14, 15, 16, 17, 18, 19]);
    tracker.addPlacement('ΕΞΑΝΙΟ', [108, 109, 110, 111, 112, 113]);
    tracker.addPlacement('ΦΕΛΟΝΙ', [84, 85, 86, 87, 88, 89]);
    tracker.addPlacement('ΦΙΝΑΛΕ', [36, 37, 38, 39, 40, 41]);
    tracker.addPlacement('ΦΟΙΝΙΞ', [32, 44, 56, 68, 80, 92]);
    tracker.addPlacement('ΑΦΙΟΝΙ', [70, 82, 94, 106, 118, 130]);
    tracker.addPlacement('ΕΝΙΟΙ', [126, 127, 128, 129, 130]);
    tracker.addPlacement('ΑΙΦΟΝ', [12, 24, 36, 48, 60]);
    tracker.addPlacement('ΛΙΝΟ', [103, 115, 127, 139]);
    tracker.addPlacement('ΦΟΛΑ', [43, 44, 45, 46]);
    tracker.addPlacement('ΟΞΙΑ', [10, 22, 34, 46]);
    tracker.addPlacement('ΕΝΑ', [108, 120, 132]);
    tracker.addPlacement('ΕΞΙ', [54, 66, 78]);

    tracker.commonPositions.addAll([
      62,
      66,
      68,
      70,
      14,
      38,
      86,
      110,
      108,
      36,
      44,
      130,
      127,
      46,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΦΙΛΟΞΕΝΙΑ',
      'ΞΕΝΟΦΙΛΙΑ',
      'ΞΙΝΙΛΑ',
      'ΕΞΑΝΙΟ',
      'ΦΕΛΟΝΙ',
      'ΦΙΝΑΛΕ',
      'ΦΟΙΝΙΞ',
      'ΑΦΙΟΝΙ',
      'ΕΝΙΟΙ',
      'ΟΞΕΙΑ',
      'ΦΙΛΙΑ',
      'ΑΙΦΟΝ',
      'ΑΦΝΙΟ',
      'ΕΙΝΑΙ',
      'ΕΛΑΙΟ',
      'ΕΛΑΦΙ',
      'ΛΕΙΑ',
      'ΛΙΝΟ',
      'ΦΛΟΞ',
      'ΟΙΑΞ',
      'ΦΟΛΑ',
      'ΟΞΙΑ',
      'ΦΙΛΑ',
      'ΦΙΛΕ',
      'ΦΛΑΝ',
      'ΦΙΛΙ',
      'ΕΛΙΑ',
      'ΙΝΟΞ',
      'ΛΟΞΑ',
      'ΛΑΦΙ',
      'ΞΕΝΑ',
      'ΙΝΙΟ',
      'ΝΙΛΑ',
      'ΕΞΟΝ',
      'ΞΕΝΟ',
      'ΛΙΑΝ',
      'ΕΝΑ',
      'ΕΞΙ',
      'ΕΛΟ',
      'ΙΝΑ',
      'ΦΙΝ',
      'ΦΑΕ',
      'ΙΟΝ',
      'ΛΑΞ',
      'ΦΙΞ',
      'ΦΕΙ',
      'ΑΛΙ',
      'ΕΛΑ',
      'ΑΕΙ',
      'ΝΑΙ',
      'ΝΕΑ',
      'ΝΕΙ',
      'ΦΑΞ',
      'ΦΑΝ',
      'ΕΑΝ',
    ];
    final letters = ['Ν', 'Ι', 'Ι', 'Ο', 'Α', 'Φ', 'Ε', 'Ξ', 'Λ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel7Option4() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΙΑΜΑΤΙΚΟΣ', [62, 63, 64, 65, 66, 67, 68, 69, 70]);
    tracker.addPlacement('ΑΙΜΑΤΙΚΟΣ', [2, 14, 26, 38, 50, 62, 74, 86, 98]);
    tracker.addPlacement('ΤΑΜΙΑΚΟΣ', [1, 2, 3, 4, 5, 6, 7, 8]);
    tracker.addPlacement('ΑΙΤΙΑΚΟΣ', [38, 39, 40, 41, 42, 43, 44, 45]);
    tracker.addPlacement('ΚΟΙΤΑΣΜΑ', [85, 86, 87, 88, 89, 90, 91, 92]);
    tracker.addPlacement('ΑΣΙΤΙΑ', [58, 70, 82, 94, 106, 118]);
    tracker.addPlacement('ΑΤΙΜΙΑ', [113, 114, 115, 116, 117, 118]);
    tracker.addPlacement('ΑΣΚΙ', [5, 17, 29, 41]);
    tracker.addPlacement('ΜΑΣ', [116, 128, 140]);
    tracker.addPlacement('ΣΙΑ', [140, 141, 142]);
    tracker.addPlacement('ΜΙΣ', [21, 33, 45]);
    tracker.addPlacement('ΜΑΤ', [21, 22, 23]);
    tracker.addPlacement('ΚΙΤ', [48, 49, 50]);
    tracker.addPlacement('ΤΑΟ', [114, 126, 138]);
    tracker.addPlacement('ΚΑΤ', [48, 60, 72]);

    tracker.commonPositions.addAll([
      62,
      70,
      2,
      38,
      50,
      86,
      5,
      41,
      45,
      118,
      114,
      116,
      140,
      21,
      48,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΙΑΜΑΤΙΚΟΣ',
      'ΑΙΜΑΤΙΚΟΣ',
      'ΤΑΜΙΑΚΟΣ',
      'ΑΙΤΙΑΚΟΣ',
      'ΚΟΙΤΑΣΜΑ',
      'ΜΑΤΑΙΟΣ',
      'ΑΚΜΑΙΟΣ',
      'ΑΚΟΣΜΙΑ',
      'ΚΑΤΙΜΑΣ',
      'ΑΚΑΤΙΟΣ',
      'ΚΤΙΣΙΜΟ',
      'ΚΑΜΑΤΟΣ',
      'ΜΑΤΙΣΙΑ',
      'ΑΣΙΤΙΑ',
      'ΑΤΙΜΙΑ',
      'ΑΤΙΜΟΣ',
      'ΣΚΟΤΙΑ',
      'ΙΤΑΜΟΣ',
      'ΤΙΜΙΟΣ',
      'ΚΑΙΣΙΟ',
      'ΚΑΙΤΟΙ',
      'ΙΜΑΤΙΟ',
      'ΚΑΣΑΤΟ',
      'ΑΙΤΙΟΣ',
      'ΤΑΣΑΚΙ',
      'ΤΑΙΣΜΑ',
      'ΚΟΑΣΜΑ',
      'ΚΤΙΣΜΑ',
      'ΜΑΣΚΟΤ',
      'ΤΑΜΙΑΣ',
      'ΜΑΤΑΚΙ',
      'ΜΙΚΤΟΣ',
      'ΤΑΚΙΜΙ',
      'ΑΚΑΤΟΣ',
      'ΣΤΟΜΑ',
      'ΑΙΤΙΟ',
      'ΤΣΙΚΟ',
      'ΑΙΤΙΑ',
      'ΑΤΜΟΣ',
      'ΜΑΣΚΑ',
      'ΚΙΜΑΣ',
      'ΚΑΣΤΑ',
      'ΙΑΤΑΙ',
      'ΚΟΜΙΣ',
      'ΚΟΣΤΑ',
      'ΚΟΤΣΙ',
      'ΙΑΤΟΣ',
      'ΜΑΤΙΑ',
      'ΤΣΑΚΑ',
      'ΜΑΤΣΟ',
      'ΟΙΚΙΑ',
      'ΜΑΣΙΑ',
      'ΟΣΤΙΑ',
      'ΜΙΤΟΣ',
      'ΣΚΟΤΑ',
      'ΣΤΑΚΑ',
      'ΜΑΚΙΑ',
      'ΜΑΤΣΑ',
      'ΙΙΚΟΣ',
      'ΙΣΤΙΟ',
      'ΤΑΚΟΣ',
      'ΑΣΚΙ',
      'ΜΑΙΑ',
      'ΜΑΚΑ',
      'ΚΟΣΑ',
      'ΜΑΚΟ',
      'ΚΙΤΣ',
      'ΜΑΣΑ',
      'ΑΤΣΑ',
      'ΚΑΤΣ',
      'ΑΜΟΚ',
      'ΜΑΣΤ',
      'ΑΤΟΣ',
      'ΤΣΑΚ',
      'ΤΣΑΙ',
      'ΜΑΤΙ',
      'ΚΑΤΙ',
      'ΙΣΚΑ',
      'ΜΑΤΣ',
      'ΤΣΟΚ',
      'ΚΑΣΤ',
      'ΜΙΑΣ',
      'ΤΟΚΑ',
      'ΤΑΜΑ',
      'ΚΑΣΑ',
      'ΜΟΚΑ',
      'ΤΑΣΙ',
      'ΤΣΑΟ',
      'ΑΙΜΑ',
      'ΚΑΜΑ',
      'ΣΑΙΤ',
      'ΣΑΚΑ',
      'ΣΑΚΙ',
      'ΚΟΤΑ',
      'ΣΤΟΚ',
      'ΣΙΜΑ',
      'ΣΙΤΑ',
      'ΣΤΟΑ',
      'ΣΚΑΤ',
      'ΣΤΙΚ',
      'ΣΚΙΑ',
      'ΣΚΙΤ',
      'ΑΣΜΑ',
      'ΙΤΙΑ',
      'ΚΑΤΑ',
      'ΙΑΜΑ',
      'ΣΤΑ',
      'ΣΟΙ',
      'ΣΚΙ',
      'ΣΚΑ',
      'ΣΙΚ',
      'ΜΑΣ',
      'ΣΙΑ',
      'ΟΤΙ',
      'ΟΚΑ',
      'ΜΙΣ',
      'ΜΑΤ',
      'ΚΙΤ',
      'ΤΑΟ',
      'ΚΑΤ',
      'ΚΑΣ',
      'ΤΙΚ',
      'ΤΙΜ',
      'ΚΑΙ',
      'ΤΙΣ',
      'ΙΣΟ',
      'ΤΣΑ',
      'ΙΣΑ',
      'ΙΟΣ',
      'ΙΜΟ',
      'ΑΤΙ',
      'ΑΤΑ',
      'ΑΜΑ',
      'ΣΟΚ',
    ];
    final letters = ['Α', 'Α', 'Ι', 'Κ', 'Μ', 'Σ', 'Ι', 'Τ', 'Ο'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel7Option5() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΤΣΑΡΙΣΜΟΣ', [62, 63, 64, 65, 66, 67, 68, 69, 70]);
    tracker.addPlacement('ΡΑΤΣΙΣΜΟΣ', [38, 50, 62, 74, 86, 98, 110, 122, 134]);
    tracker.addPlacement('ΣΤΑΣΙΜΟΣ', [98, 99, 100, 101, 102, 103, 104, 105]);
    tracker.addPlacement('ΑΣΤΙΣΜΟΣ', [133, 134, 135, 136, 137, 138, 139, 140]);
    tracker.addPlacement('ΑΡΙΣΤΟΣ', [37, 38, 39, 40, 41, 42, 43]);
    tracker.addPlacement('ΤΡΙΣΜΟΣ', [9, 21, 33, 45, 57, 69, 81]);
    tracker.addPlacement('ΙΑΤΡΟΣ', [18, 19, 20, 21, 22, 23]);
    tracker.addPlacement('ΙΣΤΟΣ', [11, 23, 35, 47, 59]);
    tracker.addPlacement('ΣΤΟΜΑ', [67, 79, 91, 103, 115]);
    tracker.addPlacement('ΑΣΣΟΣ', [89, 101, 113, 125, 137]);
    tracker.addPlacement('ΡΑΜΙ', [3, 15, 27, 39]);
    tracker.addPlacement('ΤΣΑΙ', [13, 14, 15, 16]);
    tracker.addPlacement('ΤΙΣ', [72, 73, 74]);
    tracker.addPlacement('ΣΟΣ', [105, 117, 129]);
    tracker.addPlacement('ΑΡΜ', [108, 109, 110]);

    tracker.commonPositions.addAll([
      62,
      67,
      69,
      38,
      74,
      98,
      110,
      134,
      101,
      103,
      105,
      137,
      39,
      21,
      23,
      15,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΤΣΑΡΙΣΜΟΣ',
      'ΡΑΤΣΙΣΜΟΣ',
      'ΣΤΑΣΙΜΟΣ',
      'ΑΣΤΙΣΜΟΣ',
      'ΑΡΙΣΤΟΣ',
      'ΣΤΑΣΙΜΟ',
      'ΤΡΙΣΜΟΣ',
      'ΙΑΤΡΟΣ',
      'ΟΣΤΡΙΑ',
      'ΜΙΣΤΟΣ',
      'ΜΙΑΡΟΣ',
      'ΤΟΜΑΡΙ',
      'ΜΑΣΤΟΣ',
      'ΙΤΑΜΟΣ',
      'ΑΣΟΡΤΙ',
      'ΜΟΣΤΡΑ',
      'ΤΣΙΡΟΣ',
      'ΤΣΑΡΟΣ',
      'ΑΤΙΜΟΣ',
      'ΑΡΤΙΟΣ',
      'ΟΡΙΣΜΑ',
      'ΤΑΡΣΟΣ',
      'ΙΑΣΜΟΣ',
      'ΣΤΟΡΙΑ',
      'ΙΣΤΟΣ',
      'ΣΤΟΜΑ',
      'ΣΤΟΡΙ',
      'ΟΣΤΙΑ',
      'ΣΤΡΑΣ',
      'ΙΑΤΟΣ',
      'ΜΟΡΣΑ',
      'ΑΤΡΙΟ',
      'ΣΤΑΡΙ',
      'ΑΤΜΟΣ',
      'ΜΑΤΣΟ',
      'ΑΣΤΡΟ',
      'ΑΡΜΟΣ',
      'ΟΡΜΙΑ',
      'ΑΣΣΟΣ',
      'ΣΜΑΡΙ',
      'ΑΣΙΣΤ',
      'ΑΡΤΟΣ',
      'ΣΙΤΟΣ',
      'ΣΙΤΑΡ',
      'ΑΡΤΙΟ',
      'ΣΟΡΤΣ',
      'ΜΙΤΟΣ',
      'ΜΙΤΡΑ',
      'ΤΣΙΣΑ',
      'ΑΡΙΟΣ',
      'ΜΟΙΡΑ',
      'ΟΡΤΣΑ',
      'ΜΙΣΟΣ',
      'ΡΑΜΙ',
      'ΤΣΑΙ',
      'ΤΡΙΣ',
      'ΤΡΙΟ',
      'ΤΡΙΑ',
      'ΑΣΟΣ',
      'ΤΡΑΜ',
      'ΡΑΣΟ',
      'ΤΑΣΙ',
      'ΑΤΟΣ',
      'ΤΑΡΟ',
      'ΤΣΑΟ',
      'ΙΣΟΣ',
      'ΣΤΟΑ',
      'ΣΤΑΡ',
      'ΜΑΡΣ',
      'ΜΑΣΤ',
      'ΜΑΤΙ',
      'ΜΑΤΣ',
      'ΣΟΡΙ',
      'ΜΙΑΣ',
      'ΑΡΤΙ',
      'ΣΙΤΑ',
      'ΣΙΜΑ',
      'ΜΟΡΑ',
      'ΜΟΡΣ',
      'ΣΑΣΙ',
      'ΣΑΡΙ',
      'ΣΑΙΤ',
      'ΡΟΤΑ',
      'ΡΙΜΑ',
      'ΤΙΣ',
      'ΣΟΣ',
      'ΙΟΣ',
      'ΙΣΑ',
      'ΑΡΜ',
      'ΙΣΟ',
      'ΣΟΙ',
      'ΤΟΡ',
      'ΤΣΑ',
      'ΣΙΑ',
      'ΑΤΙ',
      'ΤΑΡ',
      'ΜΑΣ',
      'ΣΑΣ',
      'ΤΑΟ',
      'ΣΤΑ',
      'ΜΑΤ',
      'ΡΟΜ',
      'ΤΙΜ',
      'ΟΤΙ',
      'ΡΑΜ',
      'ΙΜΟ',
      'ΜΙΣ',
    ];
    final letters = ['Α', 'Σ', 'Ο', 'Σ', 'Ρ', 'Τ', 'Σ', 'Μ', 'Ι'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  // LEVEL: 8
  static CurrentStage _backupLevel8Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΣΤΟΚΑΔΟΡΟΣ', [
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
    ]);
    tracker.addPlacement('ΚΟΤΣΑΔΟΡΟΣ', [
      25,
      37,
      49,
      61,
      73,
      85,
      97,
      109,
      121,
      133,
    ]);
    tracker.addPlacement('ΣΚΟΡΔΑΤΟΣ', [24, 25, 26, 27, 28, 29, 30, 31, 32]);
    tracker.addPlacement('ΔΡΟΣΑΤΟΣ', [85, 86, 87, 88, 89, 90, 91, 92]);
    tracker.addPlacement('ΟΣΤΡΑΚΟ', [121, 122, 123, 124, 125, 126, 127]);
    tracker.addPlacement('ΣΚΑΡΤΟΣ', [70, 82, 94, 106, 118, 130, 142]);
    tracker.addPlacement('ΚΑΡΟΤΟ', [3, 15, 27, 39, 51, 63]);
    tracker.addPlacement('ΚΟΤΣΟΣ', [3, 4, 5, 6, 7, 8]);
    tracker.addPlacement('ΟΡΚΟΣ', [91, 103, 115, 127, 139]);
    tracker.addPlacement('ΚΟΣΤΑ', [115, 116, 117, 118, 119]);
    tracker.addPlacement('ΣΤΑΡ', [88, 100, 112, 124]);
    tracker.addPlacement('ΣΚΟΡ', [32, 44, 56, 68]);
    tracker.addPlacement('ΚΡΑΣ', [44, 45, 46, 47]);
    tracker.addPlacement('ΣΟΔΑ', [10, 22, 34, 46]);
    tracker.addPlacement('ΤΣΑ', [141, 142, 143]);
    tracker.addPlacement('ΚΑΣ', [0, 12, 24]);

    tracker.commonPositions.addAll([
      61,
      63,
      68,
      70,
      25,
      85,
      121,
      24,
      27,
      32,
      88,
      91,
      124,
      127,
      118,
      142,
      3,
      115,
      44,
      46,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΣΤΟΚΑΔΟΡΟΣ',
      'ΚΟΤΣΑΔΟΡΟΣ',
      'ΣΚΟΡΔΑΤΟΣ',
      'ΔΡΟΣΑΤΟΣ',
      'ΟΣΤΡΑΚΟ',
      'ΣΚΑΡΤΟΣ',
      'ΣΟΡΟΚΟΣ',
      'ΤΣΟΚΑΡΟ',
      'ΔΟΚΤΟΡΑ',
      'ΚΑΡΟΤΟ',
      'ΚΟΤΣΟΣ',
      'ΚΟΣΤΟΣ',
      'ΚΡΑΣΟΣ',
      'ΚΡΑΤΟΣ',
      'ΚΡΟΤΟΣ',
      'ΟΡΑΤΟΣ',
      'ΣΚΟΡΟΣ',
      'ΣΚΑΡΟΣ',
      'ΣΚΟΡΔΟ',
      'ΣΚΟΤΟΣ',
      'ΣΚΡΑΤΣ',
      'ΣΟΚΟΡΟ',
      'ΚΑΣΤΡΟ',
      'ΣΤΟΚΟΣ',
      'ΤΑΡΣΟΣ',
      'ΤΣΑΡΟΣ',
      'ΑΡΚΤΟΣ',
      'ΑΤΟΚΟΣ',
      'ΔΡΑΚΟΣ',
      'ΔΡΟΣΟΣ',
      'ΚΑΔΟΣ',
      'ΔΑΚΟΣ',
      'ΟΡΚΟΣ',
      'ΟΡΤΣΑ',
      'ΣΚΟΤΑ',
      'ΟΣΚΑΡ',
      'ΤΟΡΟΣ',
      'ΣΟΡΟΣ',
      'ΣΟΡΤΣ',
      'ΚΟΣΤΑ',
      'ΡΑΚΟΣ',
      'ΣΤΡΑΣ',
      'ΤΑΚΟΣ',
      'ΑΔΡΟΣ',
      'ΚΑΡΤΟ',
      'ΤΟΚΟΣ',
      'ΔΟΤΟΣ',
      'ΚΟΡΔΑ',
      'ΣΑΚΟΣ',
      'ΑΣΚΟΣ',
      'ΑΡΤΟΣ',
      'ΑΡΟΔΟ',
      'ΚΟΡΟΣ',
      'ΡΟΣΤΟ',
      'ΡΟΚΑΣ',
      'ΚΑΔΡΟ',
      'ΔΟΚΟΣ',
      'ΔΑΣΟΣ',
      'ΑΚΡΟΣ',
      'ΚΑΡΣΤ',
      'ΤΡΑΚΟ',
      'ΑΣΤΡΟ',
      'ΤΟΣΟΣ',
      'ΣΤΟΚ',
      'ΤΟΣΟ',
      'ΚΑΡΤ',
      'ΤΡΑΚ',
      'ΤΟΚΑ',
      'ΡΑΣΟ',
      'ΤΣΑΚ',
      'ΤΣΑΟ',
      'ΡΟΔΑ',
      'ΤΣΟΚ',
      'ΡΟΔΟ',
      'ΚΑΡΟ',
      'ΑΚΡΟ',
      'ΤΑΡΟ',
      'ΚΟΡΑ',
      'ΣΤΟΑ',
      'ΣΤΑΡ',
      'ΚΑΣΤ',
      'ΑΣΟΣ',
      'ΟΔΟΣ',
      'ΡΟΚΑ',
      'ΑΤΟΣ',
      'ΚΟΤΑ',
      'ΟΣΟΣ',
      'ΚΑΤΣ',
      'ΚΟΣΑ',
      'ΔΟΡΑ',
      'ΟΡΟΣ',
      'ΣΚΟΡ',
      'ΡΟΤΑ',
      'ΣΚΑΤ',
      'ΟΡΚΑ',
      'ΚΡΑΣ',
      'ΣΟΔΑ',
      'ΟΣΤΟ',
      'ΤΣΑ',
      'ΤΟΡ',
      'ΤΑΡ',
      'ΚΑΣ',
      'ΣΤΑ',
      'ΣΟΣ',
      'ΚΑΤ',
      'ΣΟΚ',
      'ΣΚΑ',
      'ΣΑΣ',
      'ΡΟΚ',
      'ΟΣΟ',
      'ΟΚΑ',
      'ΚΡΑ',
      'ΤΑΟ',
    ];
    final letters = ['Τ', 'Α', 'Ο', 'Σ', 'Ο', 'Σ', 'Κ', 'Δ', 'Ρ', 'Ο'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel8Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΣΠΙΝΑΡΙΣΜΑ', [
      60,
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
    ]);
    tracker.addPlacement('ΠΡΑΣΙΝΙΣΜΑ', [
      24,
      36,
      48,
      60,
      72,
      84,
      96,
      108,
      120,
      132,
    ]);
    tracker.addPlacement('ΜΑΡΣΙΠΑΝ', [120, 121, 122, 123, 124, 125, 126, 127]);
    tracker.addPlacement('ΑΣΠΡΙΣΜΑ', [14, 26, 38, 50, 62, 74, 86, 98]);
    tracker.addPlacement('ΡΑΠΙΣΜΑ', [13, 14, 15, 16, 17, 18, 19]);
    tracker.addPlacement('ΣΑΜΠΑΝΙ', [52, 64, 76, 88, 100, 112, 124]);
    tracker.addPlacement('ΣΑΠΙΣΜΑ', [57, 69, 81, 93, 105, 117, 129]);
    tracker.addPlacement('ΑΡΠΙΣΜΑ', [19, 31, 43, 55, 67, 79, 91]);
    tracker.addPlacement('ΑΠΑΝ', [102, 114, 126, 138]);
    tracker.addPlacement('ΑΡΠΑ', [41, 42, 43, 44]);
    tracker.addPlacement('ΜΙΣ', [4, 16, 28]);
    tracker.addPlacement('ΙΣΑ', [104, 105, 106]);

    tracker.commonPositions.addAll([
      60,
      62,
      64,
      67,
      69,
      120,
      124,
      126,
      14,
      16,
      19,
      105,
      43,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΣΠΙΝΑΡΙΣΜΑ',
      'ΠΡΑΣΙΝΙΣΜΑ',
      'ΜΑΡΣΙΠΑΝ',
      'ΑΣΠΡΙΣΜΑ',
      'ΡΑΠΙΣΜΑ',
      'ΣΑΜΠΑΝΙ',
      'ΣΑΠΙΣΜΑ',
      'ΠΑΣΜΙΝΑ',
      'ΑΡΠΙΣΜΑ',
      'ΜΠΑΣΙΑ',
      'ΠΡΙΣΜΑ',
      'ΡΑΙΣΜΑ',
      'ΡΑΠΑΝΙ',
      'ΣΑΜΑΡΙ',
      'ΣΑΜΠΑΝ',
      'ΠΙΣΙΝΑ',
      'ΣΑΡΙΣΑ',
      'ΣΑΣΙΜΙ',
      'ΣΑΣΜΑΝ',
      'ΣΙΝΑΠΙ',
      'ΣΠΑΝΙΣ',
      'ΑΜΠΑΡΙ',
      'ΑΜΠΡΑΣ',
      'ΑΡΙΑΝΙ',
      'ΠΑΡΙΑΣ',
      'ΙΑΣΠΙΣ',
      'ΜΑΝΑΡΙ',
      'ΜΑΡΙΝΑ',
      'ΠΡΑΣΙΑ',
      'ΜΑΣΙΝΑ',
      'ΜΙΣΙΝΑ',
      'ΣΑΜΠΙ',
      'ΜΑΠΑΣ',
      'ΣΙΜΠΙ',
      'ΣΜΑΡΙ',
      'ΣΝΑΠΣ',
      'ΠΡΙΜΑ',
      'ΣΑΜΠΑ',
      'ΠΡΑΜΑ',
      'ΑΜΠΙΡ',
      'ΡΑΜΠΑ',
      'ΑΜΠΡΙ',
      'ΠΑΣΑΣ',
      'ΜΑΣΙΑ',
      'ΣΑΡΙΑ',
      'ΜΑΙΝΑ',
      'ΣΑΡΙΝ',
      'ΠΑΡΑΣ',
      'ΣΑΡΑΙ',
      'ΜΠΑΡΑ',
      'ΣΑΡΠΑ',
      'ΜΠΙΡΑ',
      'ΜΑΝΙΑ',
      'ΠΙΣΣΑ',
      'ΡΑΣΠΑ',
      'ΑΠΑΝ',
      'ΠΑΣΑ',
      'ΑΡΙΑ',
      'ΑΝΙΑ',
      'ΠΡΙΝ',
      'ΑΡΜΑ',
      'ΑΡΝΙ',
      'ΑΡΠΑ',
      'ΣΑΡΑ',
      'ΑΣΜΑ',
      'ΡΑΜΙ',
      'ΑΠΑΣ',
      'ΣΑΡΙ',
      'ΑΜΑΝ',
      'ΠΑΡΑ',
      'ΜΑΙΑ',
      'ΑΙΜΑ',
      'ΜΑΝΑ',
      'ΣΠΙΝ',
      'ΜΑΝΙ',
      'ΣΠΑΜ',
      'ΜΑΠΑ',
      'ΝΑΠΑ',
      'ΜΑΡΑ',
      'ΣΙΝΙ',
      'ΜΑΡΣ',
      'ΠΡΙΜ',
      'ΠΑΝΙ',
      'ΜΑΣΑ',
      'ΡΙΝΑ',
      'ΣΙΜΑ',
      'ΜΙΑΣ',
      'ΜΙΝΑ',
      'ΜΙΝΙ',
      'ΠΑΝΑ',
      'ΠΙΣΙ',
      'ΠΑΙΣ',
      'ΝΑΣΙ',
      'ΜΠΑΙ',
      'ΜΠΑΝ',
      'ΜΠΑΡ',
      'ΠΙΝΑ',
      'ΣΑΣΙ',
      'ΡΙΜΑ',
      'ΜΠΙΣ',
      'ΜΠΡΙ',
      'ΙΑΜΑ',
      'ΝΑΜΑ',
      'ΝΑΙ',
      'ΜΠΑ',
      'ΜΝΑ',
      'ΠΑΝ',
      'ΜΙΣ',
      'ΜΑΣ',
      'ΙΣΑ',
      'ΙΝΑ',
      'ΑΡΜ',
      'ΑΡΑ',
      'ΑΝΑ',
      'ΑΜΑ',
      'ΠΙΑ',
      'ΠΙΝ',
      'ΣΙΑ',
      'ΣΑΣ',
      'ΣΑΝ',
      'ΡΑΠ',
      'ΡΑΜ',
      'ΣΠΑ',
    ];
    final letters = ['Σ', 'Α', 'Ι', 'Ν', 'Ι', 'Π', 'Α', 'Ρ', 'Σ', 'Μ'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel8Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΚΕΡΑΜΙΣΤΑΣ', [
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
    ]);
    tracker.addPlacement('ΤΣΕΚΑΡΙΣΜΑ', [
      25,
      37,
      49,
      61,
      73,
      85,
      97,
      109,
      121,
      133,
    ]);
    tracker.addPlacement('ΑΣΤΕΡΙΑΣ', [36, 37, 38, 39, 40, 41, 42, 43]);
    tracker.addPlacement('ΚΤΕΡΙΣΜΑ', [56, 68, 80, 92, 104, 116, 128, 140]);
    tracker.addPlacement('ΤΣΑΚΙΣΜΑ', [100, 101, 102, 103, 104, 105, 106, 107]);
    tracker.addPlacement('ΜΙΚΡΑΤΑ', [136, 137, 138, 139, 140, 141, 142]);
    tracker.addPlacement('ΕΚΣΤΑΣΙ', [10, 22, 34, 46, 58, 70, 82]);
    tracker.addPlacement('ΜΑΡΑΚΕΣ', [5, 6, 7, 8, 9, 10, 11]);
    tracker.addPlacement('ΜΑΤΣΑ', [65, 77, 89, 101, 113]);
    tracker.addPlacement('ΜΑΤΙ', [5, 17, 29, 41]);
    tracker.addPlacement('ΤΑΡΑ', [14, 15, 16, 17]);
    tracker.addPlacement('ΤΑΜΑ', [95, 107, 119, 131]);
    tracker.addPlacement('ΚΡΕΜ', [84, 85, 86, 87]);
    tracker.addPlacement('ΕΙΣ', [32, 33, 34]);
    tracker.addPlacement('ΣΤΑ', [109, 110, 111]);

    tracker.commonPositions.addAll([
      61,
      65,
      68,
      70,
      37,
      85,
      109,
      41,
      104,
      140,
      101,
      107,
      10,
      34,
      5,
      17,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΚΕΡΑΜΙΣΤΑΣ',
      'ΤΣΕΚΑΡΙΣΜΑ',
      'ΑΣΤΕΡΙΑΣ',
      'ΚΤΕΡΙΣΜΑ',
      'ΤΣΑΚΙΣΜΑ',
      'ΜΑΕΣΤΡΙΑ',
      'ΜΙΚΡΑΤΑ',
      'ΚΕΣΑΤΙΑ',
      'ΑΣΤΕΡΑΣ',
      'ΑΚΡΙΤΑΣ',
      'ΑΕΡΙΣΜΑ',
      'ΑΣΤΡΑΚΙ',
      'ΚΕΡΑΣΙΑ',
      'ΚΕΡΑΣΜΑ',
      'ΤΕΣΣΑΡΙ',
      'ΕΚΣΤΑΣΙ',
      'ΣΚΙΑΣΜΑ',
      'ΜΑΡΑΚΕΣ',
      'ΣΚΑΣΤΡΑ',
      'ΜΑΣΤΑΡΙ',
      'ΣΕΡΑΤΙΑ',
      'ΚΕΡΑΤΣΑ',
      'ΜΑΤΙΕΡΑ',
      'ΡΕΜΑΤΙΑ',
      'ΚΑΤΡΑΜΙ',
      'ΤΕΣΣΑΡΑ',
      'ΚΑΤΙΜΑΣ',
      'ΚΑΤΣΕΙ',
      'ΜΙΣΤΕΡ',
      'ΡΑΙΣΜΑ',
      'ΡΑΚΕΤΑ',
      'ΜΕΡΑΚΙ',
      'ΣΑΜΑΡΙ',
      'ΣΑΡΑΚΙ',
      'ΜΑΤΑΚΙ',
      'ΣΑΡΙΣΑ',
      'ΣΑΤΙΡΑ',
      'ΚΑΣΜΑΣ',
      'ΚΑΣΕΤΑ',
      'ΜΑΣΤΕΡ',
      'ΚΑΣΕΡΙ',
      'ΣΙΕΣΤΑ',
      'ΣΙΤΕΜΑ',
      'ΜΕΣΙΑΣ',
      'ΜΑΚΡΙΑ',
      'ΣΚΡΑΤΣ',
      'ΣΤΕΡΙΑ',
      'ΣΤΙΚΕΡ',
      'ΣΤΡΑΚΑ',
      'ΤΑΙΣΜΑ',
      'ΤΑΜΙΑΣ',
      'ΤΑΣΑΚΙ',
      'ΜΑΚΕΤΑ',
      'ΜΑΚΑΡΙ',
      'ΚΑΡΙΤΕ',
      'ΚΑΡΑΤΙ',
      'ΤΣΑΚΙΡ',
      'ΚΤΙΣΜΑ',
      'ΤΣΑΚΡΑ',
      'ΤΣΑΡΚΑ',
      'ΤΣΕΡΚΙ',
      'ΕΤΑΙΡΑ',
      'ΑΕΡΑΚΙ',
      'ΚΕΡΑΙΑ',
      'ΚΡΑΤΕΙ',
      'ΚΑΤΣΕΡ',
      'ΚΑΜΕΡΑ',
      'ΑΡΙΕΤΑ',
      'ΑΡΙΣΤΑ',
      'ΑΡΚΕΣΑ',
      'ΚΑΜΑΡΙ',
      'ΑΣΚΕΡΙ',
      'ΑΣΤΑΡΙ',
      'ΑΣΤΕΙΑ',
      'ΚΙΣΜΕΤ',
      'ΑΣΤΕΡΙ',
      'ΚΕΡΑΣΙ',
      'ΚΕΡΑΣΑ',
      'ΕΚΑΤΣΑ',
      'ΚΑΡΑΤΕ',
      'ΣΤΕΚΑ',
      'ΤΙΑΡΑ',
      'ΜΑΚΙΑ',
      'ΣΑΡΑΙ',
      'ΚΕΡΜΑ',
      'ΣΑΡΙΑ',
      'ΚΡΑΜΑ',
      'ΣΑΡΚΑ',
      'ΜΑΡΚΑ',
      'ΜΑΡΚΕ',
      'ΣΕΙΡΑ',
      'ΣΕΚΤΑ',
      'ΣΕΡΑΙ',
      'ΣΤΑΚΑ',
      'ΜΑΣΙΑ',
      'ΣΙΤΑΡ',
      'ΜΑΣΚΑ',
      'ΚΑΡΤΑ',
      'ΣΚΑΡΑ',
      'ΣΚΑΡΙ',
      'ΜΑΣΚΕ',
      'ΣΚΕΤΣ',
      'ΣΚΙΕΡ',
      'ΚΡΑΣΙ',
      'ΣΜΑΡΙ',
      'ΚΑΡΣΤ',
      'ΡΕΣΤΑ',
      'ΣΤΑΡΙ',
      'ΣΤΕΑΡ',
      'ΣΤΕΙΚ',
      'ΑΕΡΑΣ',
      'ΣΤΕΚΙ',
      'ΚΕΡΑΣ',
      'ΚΑΤΣΕ',
      'ΚΡΕΑΣ',
      'ΣΤΡΑΣ',
      'ΣΤΡΕΣ',
      'ΡΑΣΤΑ',
      'ΕΜΑΣΑ',
      'ΚΙΣΣΑ',
      'ΚΑΣΤΑ',
      'ΚΡΕΜΑ',
      'ΑΡΑΣΕ',
      'ΤΣΑΚΑ',
      'ΤΡΕΣΑ',
      'ΤΡΑΚΑ',
      'ΑΣΙΣΤ',
      'ΜΑΤΣΑ',
      'ΚΑΜΕΑ',
      'ΜΕΤΡΑ',
      'ΙΣΑΜΕ',
      'ΡΑΤΣΑ',
      'ΚΑΡΜΑ',
      'ΑΚΡΙΑ',
      'ΚΙΜΑΣ',
      'ΤΣΙΣΑ',
      'ΕΣΤΙΑ',
      'ΚΡΙΜΑ',
      'ΤΣΕΡΙ',
      'ΤΕΡΜΑ',
      'ΜΕΡΣΙ',
      'ΜΕΡΙΑ',
      'ΜΙΤΡΑ',
      'ΑΡΚΕΙ',
      'ΤΕΡΑΣ',
      'ΜΑΤΙΑ',
      'ΚΑΡΣΙ',
      'ΜΑΤΙ',
      'ΤΑΡΑ',
      'ΤΑΜΑ',
      'ΤΑΣΙ',
      'ΜΑΤΕ',
      'ΣΤΙΚ',
      'ΣΤΑΡ',
      'ΚΡΕΜ',
      'ΜΑΤΣ',
      'ΚΡΑΣ',
      'ΣΚΙΤ',
      'ΚΑΡΙ',
      'ΚΑΡΕ',
      'ΤΡΑΚ',
      'ΜΑΣΤ',
      'ΤΡΑΜ',
      'ΣΚΙΑ',
      'ΤΡΙΑ',
      'ΤΡΙΚ',
      'ΤΡΙΣ',
      'ΚΑΤΣ',
      'ΤΣΑΙ',
      'ΤΣΑΚ',
      'ΚΑΡΤ',
      'ΜΕΡΑ',
      'ΣΚΑΤ',
      'ΣΙΤΑ',
      'ΣΙΜΑ',
      'ΤΣΕΚ',
      'ΣΙΚΕ',
      'ΚΑΣΑ',
      'ΚΑΣΕ',
      'ΜΕΣΑ',
      'ΜΑΣΑ',
      'ΕΤΣΙ',
      'ΑΕΡΙ',
      'ΜΕΤΡ',
      'ΑΙΜΑ',
      'ΑΚΡΑ',
      'ΣΕΡΙ',
      'ΣΕΡΑ',
      'ΚΑΡΑ',
      'ΜΙΑΣ',
      'ΜΑΡΣ',
      'ΑΡΑΚ',
      'ΣΕΙΣ',
      'ΑΡΕΙ',
      'ΑΡΕΣ',
      'ΑΡΙΑ',
      'ΚΕΡΙ',
      'ΣΕΙΚ',
      'ΣΑΣΙ',
      'ΜΑΙΑ',
      'ΚΑΣΤ',
      'ΑΡΜΑ',
      'ΑΡΤΙ',
      'ΜΑΡΑ',
      'ΜΑΚΑ',
      'ΑΣΚΙ',
      'ΑΣΜΑ',
      'ΚΕΡΑ',
      'ΑΣΤΕ',
      'ΚΑΤΙ',
      'ΡΑΜΙ',
      'ΣΑΡΑ',
      'ΣΑΚΙ',
      'ΚΑΤΑ',
      'ΚΑΜΑ',
      'ΚΑΕΙ',
      'ΑΤΣΑ',
      'ΙΣΚΑ',
      'ΣΑΚΕ',
      'ΕΚΑΙ',
      'ΕΚΑΣ',
      'ΣΑΚΑ',
      'ΡΕΜΑ',
      'ΕΜΑΣ',
      'ΣΑΙΤ',
      'ΕΡΜΑ',
      'ΕΣΑΣ',
      'ΕΣΤΙ',
      'ΡΙΜΑ',
      'ΚΙΤΣ',
      'ΙΑΜΑ',
      'ΜΕΤΑ',
      'ΣΑΡΙ',
      'ΤΙΜ',
      'ΕΙΣ',
      'ΕΑΡ',
      'ΑΤΙ',
      'ΚΑΙ',
      'ΑΤΑ',
      'ΑΡΜ',
      'ΑΡΑ',
      'ΑΜΕ',
      'ΑΜΑ',
      'ΑΕΙ',
      'ΤΣΑ',
      'ΤΙΣ',
      'ΙΣΑ',
      'ΤΙΚ',
      'ΤΕΣ',
      'ΤΑΡ',
      'ΣΤΑ',
      'ΣΚΙ',
      'ΣΚΑ',
      'ΚΑΣ',
      'ΣΙΚ',
      'ΣΙΑ',
      'ΣΕΤ',
      'ΣΕΡ',
      'ΕΤΙ',
      'ΣΑΣ',
      'ΡΕΜ',
      'ΚΑΤ',
      'ΡΕΙ',
      'ΡΑΜ',
      'ΜΙΣ',
      'ΜΕΣ',
      'ΜΕΑ',
      'ΜΑΤ',
      'ΜΑΣ',
      'ΚΡΑ',
      'ΚΕΙ',
      'ΚΙΤ',
      'ΣΕΑ',
    ];
    final letters = ['Τ', 'Ρ', 'Ε', 'Κ', 'Ι', 'Α', 'Μ', 'Σ', 'Σ', 'Α'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel8Option4() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΤΡΙΠΟΔΙΚΟΣ', [
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
    ]);
    tracker.addPlacement('ΔΙΟΠΤΡΙΚΟΣ', [
      13,
      25,
      37,
      49,
      61,
      73,
      85,
      97,
      109,
      121,
    ]);
    tracker.addPlacement('ΡΟΔΙΤΙΚΟΣ', [36, 37, 38, 39, 40, 41, 42, 43, 44]);
    tracker.addPlacement('ΔΙΟΠΤΙΚΟΣ', [13, 14, 15, 16, 17, 18, 19, 20, 21]);
    tracker.addPlacement('ΔΙΠΟΡΤΟΣ', [84, 85, 86, 87, 88, 89, 90, 91]);
    tracker.addPlacement('ΙΣΤΟΡΙΚΟ', [120, 121, 122, 123, 124, 125, 126, 127]);
    tracker.addPlacement('ΣΚΟΤΙΔΙ', [70, 82, 94, 106, 118, 130, 142]);
    tracker.addPlacement('ΟΡΚΟΣ', [87, 99, 111, 123, 135]);
    tracker.addPlacement('ΤΟΠΙΚ', [89, 101, 113, 125, 137]);
    tracker.addPlacement('ΠΟΤΟ', [104, 105, 106, 107]);
    tracker.addPlacement('ΣΚΙΤ', [140, 141, 142, 143]);
    tracker.addPlacement('ΙΣΟ', [9, 21, 33]);

    tracker.commonPositions.addAll([
      61,
      70,
      13,
      37,
      85,
      121,
      21,
      87,
      89,
      123,
      125,
      106,
      142,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΤΡΙΠΟΔΙΚΟΣ',
      'ΔΙΟΠΤΡΙΚΟΣ',
      'ΡΟΔΙΤΙΚΟΣ',
      'ΔΙΟΠΤΙΚΟΣ',
      'ΤΡΟΠΙΚΟΣ',
      'ΔΙΠΟΡΤΟΣ',
      'ΙΣΤΟΡΙΚΟ',
      'ΤΡΙΠΟΔΟΣ',
      'ΣΚΟΡΠΙΔΙ',
      'ΣΚΟΤΙΔΙ',
      'ΟΙΚΤΡΟΣ',
      'ΟΠΤΙΚΟΣ',
      'ΠΙΡΟΣΚΙ',
      'ΠΟΔΙΚΟΣ',
      'ΠΡΟΙΚΙΟ',
      'ΔΟΤΙΚΟΣ',
      'ΔΙΟΙΚΟΣ',
      'ΤΟΠΙΚΟΣ',
      'ΤΡΙΟΔΟΣ',
      'ΚΟΡΙΤΣΙ',
      'ΔΙΚΟΠΟΣ',
      'ΚΡΟΤΟΣ',
      'ΚΤΙΡΙΟ',
      'ΟΔΙΚΟΣ',
      'ΔΙΟΠΟΣ',
      'ΔΙΣΚΙΟ',
      'ΠΙΚΡΟΣ',
      'ΣΙΡΟΠΙ',
      'ΣΚΟΡΔΟ',
      'ΚΟΠΡΟΣ',
      'ΣΚΡΙΠΤ',
      'ΚΟΡΙΟΣ',
      'ΣΟΡΟΠΙ',
      'ΣΠΙΡΤΟ',
      'ΣΠΟΡΙΟ',
      'ΟΙΚΤΟΣ',
      'ΤΡΟΠΙΣ',
      'ΤΡΟΠΟΣ',
      'ΤΣΙΡΚΟ',
      'ΚΟΠΙΔΙ',
      'ΤΟΠΟΣ',
      'ΣΤΟΡΙ',
      'ΡΟΙΔΙ',
      'ΟΡΚΟΣ',
      'ΙΣΤΙΟ',
      'ΔΙΚΟΣ',
      'ΔΙΟΤΙ',
      'ΠΙΟΤΙ',
      'ΠΙΟΤΟ',
      'ΠΙΡΟΣ',
      'ΔΙΚΙΟ',
      'ΡΙΠΙΤ',
      'ΚΙΤΡΟ',
      'ΠΟΙΟΣ',
      'ΠΟΡΟΣ',
      'ΠΟΡΤΟ',
      'ΠΟΣΤΟ',
      'ΟΠΤΟΣ',
      'ΠΡΙΤΣ',
      'ΙΡΟΚΟ',
      'ΠΡΟΤΟ',
      'ΡΙΣΚΟ',
      'ΡΟΔΙΟ',
      'ΡΟΙΔΟ',
      'ΤΣΙΚΟ',
      'ΡΟΣΤΟ',
      'ΟΙΚΟΣ',
      'ΤΟΚΟΣ',
      'ΙΔΙΟΣ',
      'ΤΟΠΙΚ',
      'ΚΟΤΣΙ',
      'ΚΟΡΟΣ',
      'ΤΡΙΚΟ',
      'ΤΟΡΟΣ',
      'ΙΔΡΟΣ',
      'ΔΟΤΟΣ',
      'ΤΟΠΙΟ',
      'ΚΟΠΟΣ',
      'ΟΙΚΟΙ',
      'ΔΟΚΟΣ',
      'ΣΠΟΡΙ',
      'ΣΠΙΤΙ',
      'ΙΙΚΟΣ',
      'ΚΡΙΟΣ',
      'ΠΟΤΟ',
      'ΡΟΔΟ',
      'ΣΚΙΤ',
      'ΣΚΟΡ',
      'ΚΟΠΙ',
      'ΠΙΤΣ',
      'ΡΟΔΙ',
      'ΤΣΙΠ',
      'ΠΡΟΣ',
      'ΤΡΙΣ',
      'ΣΟΡΙ',
      'ΚΙΤΣ',
      'ΤΣΟΚ',
      'ΠΟΣΤ',
      'ΣΠΟΡ',
      'ΠΟΣΟ',
      'ΠΟΔΙ',
      'ΣΠΟΤ',
      'ΣΤΙΚ',
      'ΣΤΟΚ',
      'ΣΤΟΠ',
      'ΟΠΟΣ',
      'ΟΔΟΣ',
      'ΤΡΙΠ',
      'ΠΙΣΙ',
      'ΟΚΙΟ',
      'ΟΠΙΟ',
      'ΤΟΠΙ',
      'ΟΣΤΟ',
      'ΟΡΟΣ',
      'ΟΡΙΟ',
      'ΤΡΙΚ',
      'ΤΟΣΟ',
      'ΙΔΙΟ',
      'ΤΡΙΟ',
      'ΣΟΙ',
      'ΤΟΠ',
      'ΔΙΣ',
      'ΤΙΣ',
      'ΤΙΠ',
      'ΤΙΚ',
      'ΣΟΚ',
      'ΣΚΙ',
      'ΣΙΚ',
      'ΙΟΣ',
      'ΡΟΚ',
      'ΙΣΟ',
      'ΟΣΟ',
      'ΠΟΤ',
      'ΚΙΤ',
      'ΠΙΟ',
      'ΠΙΚ',
      'ΟΤΙ',
      'ΤΟΡ',
      'ΠΡΟ',
    ];
    final letters = ['Ρ', 'Ο', 'Σ', 'Π', 'Ι', 'Τ', 'Ι', 'Κ', 'Δ', 'Ο'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel8Option5() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΞΕΜΠΟΥΚΩΝΩ', [
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
    ]);
    tracker.addPlacement('ΞΕΚΟΥΜΠΩΝΩ', [
      3,
      15,
      27,
      39,
      51,
      63,
      75,
      87,
      99,
      111,
    ]);
    tracker.addPlacement('ΚΟΥΜΠΩΝΩ', [27, 28, 29, 30, 31, 32, 33, 34]);
    tracker.addPlacement('ΜΠΟΥΚΩΝΩ', [30, 42, 54, 66, 78, 90, 102, 114]);
    tracker.addPlacement('ΞΕΚΟΥΝΩ', [3, 4, 5, 6, 7, 8, 9]);
    tracker.addPlacement('ΞΩΜΕΝΩ', [89, 90, 91, 92, 93, 94]);
    tracker.addPlacement('ΕΞΥΜΝΩ', [49, 61, 73, 85, 97, 109]);
    tracker.addPlacement('ΕΥΝΟΩ', [92, 104, 116, 128, 140]);
    tracker.addPlacement('ΞΥΠΝΩ', [136, 137, 138, 139, 140]);
    tracker.addPlacement('ΝΕΥΩ', [116, 117, 118, 119]);
    tracker.addPlacement('ΚΟΝΕ', [12, 13, 14, 15]);
    tracker.addPlacement('ΥΠΟ', [118, 130, 142]);
    tracker.addPlacement('ΩΟΝ', [1, 13, 25]);

    tracker.commonPositions.addAll([
      61,
      63,
      66,
      3,
      15,
      27,
      30,
      90,
      92,
      116,
      140,
      118,
      13,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΞΕΜΠΟΥΚΩΝΩ',
      'ΞΕΚΟΥΜΠΩΝΩ',
      'ΚΟΥΜΠΩΝΩ',
      'ΜΠΟΥΚΩΝΩ',
      'ΞΕΚΟΥΝΩ',
      'ΥΠΟΜΕΝΩ',
      'ΕΠΩΝΥΜΟ',
      'ΞΩΜΕΝΩ',
      'ΕΚΠΟΝΩ',
      'ΕΞΥΜΝΩ',
      'ΕΥΝΟΩ',
      'ΞΥΠΝΩ',
      'ΕΜΠΥΟ',
      'ΟΜΝΥΩ',
      'ΟΞΥΝΩ',
      'ΠΕΥΚΟ',
      'ΚΟΥΝΩ',
      'ΚΟΥΠΕ',
      'ΜΕΝΟΥ',
      'ΜΠΟΥΚ',
      'ΠΝΕΩ',
      'ΝΕΥΩ',
      'ΥΜΝΩ',
      'ΞΥΝΩ',
      'ΞΕΝΟ',
      'ΕΚΩΝ',
      'ΠΟΝΩ',
      'ΕΞΟΝ',
      'ΕΞΟΥ',
      'ΥΜΩΝ',
      'ΚΕΝΟ',
      'ΚΟΝΕ',
      'ΚΟΥΠ',
      'ΚΥΩΝ',
      'ΜΕΝΩ',
      'ΜΠΕΚ',
      'ΜΠΟΞ',
      'ΕΜΟΥ',
      'ΟΞΥ',
      'ΕΝΩ',
      'ΥΠΟ',
      'ΟΥΚ',
      'ΩΟΝ',
      'ΜΕΝ',
      'ΕΞΩ',
      'ΠΟΥ',
      'ΜΟΥ',
      'ΜΠΕ',
      'ΠΥΞ',
      'ΕΜΟ',
      'ΞΟΥ',
      'ΝΥΞ',
      'ΜΠΩ',
      'ΜΥΩ',
      'ΟΞΩ',
      'ΝΟΩ',
      'ΚΟΥ',
    ];
    final letters = ['Π', 'Κ', 'Υ', 'Μ', 'Ε', 'Ο', 'Ν', 'Ω', 'Ξ', 'Ω'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  // LEVEL: 9
  static CurrentStage _backupLevel9Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΠΑΡΑΤΣΟΥΚΛΙ', [
      60,
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
    ]);
    tracker.addPlacement('ΠΑΡΑΛΥΤΙΚΟΣ', [
      7,
      19,
      31,
      43,
      55,
      67,
      79,
      91,
      103,
      115,
      127,
    ]);
    tracker.addPlacement('ΚΑΡΠΑΤΣΙΟ', [84, 85, 86, 87, 88, 89, 90, 91, 92]);
    tracker.addPlacement('ΠΑΡΑΛΥΤΟΣ', [
      108,
      109,
      110,
      111,
      112,
      113,
      114,
      115,
      116,
    ]);
    tracker.addPlacement('ΠΑΡΛΙΑΚΟΣ', [14, 15, 16, 17, 18, 19, 20, 21, 22]);
    tracker.addPlacement('ΠΛΥΣΤΑΡΙΟ', [38, 39, 40, 41, 42, 43, 44, 45, 46]);
    tracker.addPlacement('ΙΛΑΡΟΣ', [70, 82, 94, 106, 118, 130]);
    tracker.addPlacement('ΤΣΟΥΠ', [12, 24, 36, 48, 60]);
    tracker.addPlacement('ΛΟΥ', [112, 124, 136]);
    tracker.addPlacement('ΡΟΚ', [110, 122, 134]);
    tracker.addPlacement('ΛΑΚ', [132, 133, 134]);
    tracker.addPlacement('ΥΠΟ', [136, 137, 138]);

    tracker.commonPositions.addAll([
      60,
      67,
      70,
      19,
      43,
      91,
      115,
      110,
      112,
      136,
      134,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΠΑΡΑΤΣΟΥΚΛΙ',
      'ΠΑΡΑΛΥΤΙΚΟΣ',
      'ΚΑΡΠΑΤΣΙΟ',
      'ΠΑΡΑΛΥΤΟΣ',
      'ΠΑΡΛΙΑΚΟΣ',
      'ΠΑΡΑΚΤΙΟΣ',
      'ΠΛΥΣΤΑΡΙΟ',
      'ΣΚΑΛΟΠΑΤΙ',
      'ΛΑΣΠΟΥΡΙΑ',
      'ΚΥΡΙΛΑΤΟΣ',
      'ΚΡΟΤΑΛΙΑΣ',
      'ΑΚΑΛΥΠΤΟΣ',
      'ΚΑΤΑΠΛΟΥΣ',
      'ΡΑΠΤΙΚΟΣ',
      'ΠΥΡΟΣΤΙΑ',
      'ΚΑΛΥΠΤΡΑ',
      'ΣΑΛΑΤΙΚΟ',
      'ΠΑΡΑΣΟΛΙ',
      'ΠΑΡΑΣΙΤΟ',
      'ΣΚΟΥΤΑΡΙ',
      'ΠΑΤΣΟΥΛΙ',
      'ΣΠΑΤΟΥΛΑ',
      'ΠΛΑΣΤΙΚΟ',
      'ΠΑΤΡΙΚΟΣ',
      'ΚΡΑΤΑΙΟΣ',
      'ΚΟΥΤΑΛΙΑ',
      'ΚΟΥΡΤΑΛΑ',
      'ΚΟΙΛΑΡΑΣ',
      'ΤΡΑΠΟΥΛΑ',
      'ΤΣΙΠΟΥΡΑ',
      'ΤΣΟΚΑΡΙΑ',
      'ΠΑΡΑΛΙΟΣ',
      'ΤΣΟΥΡΑΠΙ',
      'ΥΠΑΡΚΤΟΣ',
      'ΥΠΙΑΤΡΟΣ',
      'ΠΑΡΟΥΣΙΑ',
      'ΑΚΛΑΥΤΟΣ',
      'ΟΣΤΡΑΚΙΑ',
      'ΚΑΣΟΠΙΤΑ',
      'ΑΠΑΙΚΤΟΣ',
      'ΑΠΡΑΚΤΟΣ',
      'ΑΡΑΠΙΚΟΣ',
      'ΟΠΛΑΣΚΙΑ',
      'ΑΣΥΡΤΙΚΟ',
      'ΚΑΡΑΟΥΛΙ',
      'ΑΤΥΠΙΚΟΣ',
      'ΚΑΠΟΥΛΙΑ',
      'ΤΣΟΥΚΑΛΙ',
      'ΚΟΥΤΑΛΙ',
      'ΡΟΥΠΑΚΙ',
      'ΠΑΛΑΙΟΣ',
      'ΚΑΛΟΥΠΙ',
      'ΠΑΙΚΤΟΣ',
      'ΠΛΑΚΑΤΟ',
      'ΠΛΥΣΤΡΑ',
      'ΠΙΛΑΤΟΣ',
      'ΑΥΛΙΚΟΣ',
      'ΠΟΣΤΑΛΙ',
      'ΠΟΥΛΑΚΙ',
      'ΠΟΥΛΑΡΙ',
      'ΑΤΡΑΠΟΣ',
      'ΟΠΤΑΣΙΑ',
      'ΠΑΡΟΥΣΑ',
      'ΚΑΡΟΤΣΑ',
      'ΚΑΡΟΤΣΙ',
      'ΠΥΛΑΙΟΣ',
      'ΑΣΤΡΑΚΙ',
      'ΛΥΤΙΚΟΣ',
      'ΑΣΠΡΙΛΑ',
      'ΛΥΡΙΚΟΣ',
      'ΡΑΠΤΙΚΑ',
      'ΚΑΡΟΥΛΑ',
      'ΚΑΡΟΥΛΙ',
      'ΤΣΟΥΠΡΑ',
      'ΡΟΠΑΛΙΑ',
      'ΑΠΤΙΚΟΣ',
      'ΤΟΥΛΙΠΑ',
      'ΑΠΟΥΣΙΑ',
      'ΡΟΥΣΤΙΚ',
      'ΑΠΛΥΤΟΣ',
      'ΛΟΤΑΡΙΑ',
      'ΛΟΣΤΑΡΙ',
      'ΑΠΛΥΣΙΑ',
      'ΣΑΚΟΥΛΑ',
      'ΣΑΚΟΥΛΙ',
      'ΑΠΑΥΤΟΣ',
      'ΠΑΡΤΑΛΙ',
      'ΑΠΑΤΡΙΣ',
      'ΑΠΑΡΤΟΣ',
      'ΛΙΠΑΡΟΣ',
      'ΠΙΑΣΤΡΑ',
      'ΑΛΤΙΚΟΣ',
      'ΑΛΠΙΚΟΣ',
      'ΛΙΑΣΤΡΑ',
      'ΚΑΣΤΟΡΙ',
      'ΑΚΡΙΤΟΣ',
      'ΑΚΡΙΤΑΣ',
      'ΑΚΡΑΤΟΣ',
      'ΑΚΡΑΙΟΣ',
      'ΑΚΟΥΣΤΑ',
      'ΑΚΛΙΤΟΣ',
      'ΑΚΑΥΤΟΣ',
      'ΚΟΠΙΤΣΑ',
      'ΑΚΑΡΠΟΣ',
      'ΣΚΟΥΡΙΑ',
      'ΑΚΑΙΡΟΣ',
      'ΠΑΛΟΥΚΙ',
      'ΚΥΡΑΤΣΑ',
      'ΤΥΠΙΚΟΣ',
      'ΠΑΤΡΙΟΣ',
      'ΣΠΑΡΙΛΑ',
      'ΚΡΥΠΤΟΣ',
      'ΠΑΤΟΥΣΑ',
      'ΚΡΟΥΣΤΑ',
      'ΤΣΑΠΑΡΙ',
      'ΤΣΑΟΥΛΙ',
      'ΤΣΑΚΑΛΙ',
      'ΣΤΥΛΑΚΙ',
      'ΤΡΥΠΙΟΣ',
      'ΣΥΡΤΑΚΙ',
      'ΚΟΥΤΑΛΑ',
      'ΤΡΙΠΟΥΣ',
      'ΤΡΙΠΛΟΣ',
      'ΤΑΠΙΟΚΑ',
      'ΤΑΠΙΡΟΣ',
      'ΚΛΟΤΣΙΑ',
      'ΤΡΑΥΛΟΣ',
      'ΠΑΤΟΥΡΑ',
      'ΚΟΤΣΑΡΙ',
      'ΚΟΡΑΣΙΑ',
      'ΑΚΑΤΙΟΣ',
      'ΤΑΣΑΚΙ',
      'ΠΟΡΤΑΛ',
      'ΚΑΠΟΥΤ',
      'ΑΠΟΥΣΑ',
      'ΚΑΛΟΤΑ',
      'ΚΑΙΡΟΣ',
      'ΟΣΠΡΙΑ',
      'ΠΟΤΑΣΑ',
      'ΑΠΛΙΚΑ',
      'ΑΥΛΑΚΙ',
      'ΟΡΤΥΚΙ',
      'ΠΛΑΚΑΣ',
      'ΠΛΑΚΑΤ',
      'ΑΤΥΠΟΣ',
      'ΑΠΑΤΟΣ',
      'ΠΙΚΡΟΣ',
      'ΑΠΑΛΟΣ',
      'ΣΑΠΑΚΙ',
      'ΣΑΠΙΛΑ',
      'ΑΤΥΠΙΑ',
      'ΚΑΣΑΤΟ',
      'ΣΑΡΑΚΙ',
      'ΑΤΣΑΛΙ',
      'ΑΛΥΤΟΣ',
      'ΚΑΛΟΥΑ',
      'ΣΑΡΚΙΟ',
      'ΠΡΑΣΙΑ',
      'ΣΑΤΙΡΑ',
      'ΑΛΙΠΟΣ',
      'ΚΑΠΡΟΣ',
      'ΑΛΙΚΟΣ',
      'ΑΤΟΠΙΑ',
      'ΚΑΣΤΡΟ',
      'ΑΚΥΡΟΣ',
      'ΛΑΤΑΚΙ',
      'ΚΑΤΟΠΙ',
      'ΚΑΛΤΣΑ',
      'ΠΡΟΙΚΑ',
      'ΚΑΡΑΤΙ',
      'ΠΡΟΚΑΤ',
      'ΠΑΛΑΤΙ',
      'ΚΑΟΥΡΑ',
      'ΠΑΡΤΟΣ',
      'ΛΑΡΙΚΑ',
      'ΑΣΥΛΙΑ',
      'ΑΚΑΤΟΣ',
      'ΣΚΟΠΙΑ',
      'ΠΛΑΤΟΣ',
      'ΚΑΠΑΡΟ',
      'ΣΚΟΤΙΑ',
      'ΣΚΟΥΠΑ',
      'ΠΛΑΤΥΣ',
      'ΠΑΡΙΟΣ',
      'ΣΚΟΥΤΙ',
      'ΚΑΠΟΤΑ',
      'ΥΠΤΙΟΣ',
      'ΚΑΥΛΟΣ',
      'ΥΠΑΤΟΣ',
      'ΚΥΡΤΟΣ',
      'ΠΑΡΙΑΣ',
      'ΥΛΙΚΟΣ',
      'ΚΑΥΤΟΣ',
      'ΚΥΡΙΟΣ',
      'ΠΑΣΚΑΛ',
      'ΚΥΡΙΛΑ',
      'ΥΑΛΙΚΑ',
      'ΑΣΤΑΡΙ',
      'ΣΟΥΙΤΑ',
      'ΚΑΥΤΡΑ',
      'ΣΟΥΠΙΑ',
      'ΣΟΥΠΛΑ',
      'ΙΛΑΡΟΣ',
      'ΤΥΠΙΚΟ',
      'ΤΥΠΑΡΙ',
      'ΚΤΥΠΟΣ',
      'ΛΥΣΑΡΙ',
      'ΠΑΡΟΛΑ',
      'ΣΠΑΡΤΟ',
      'ΠΑΤΡΙΑ',
      'ΣΠΙΡΑΛ',
      'ΣΠΙΡΤΟ',
      'ΠΙΤΥΡΟ',
      'ΚΙΛΟΤΑ',
      'ΤΣΙΡΛΑ',
      'ΣΠΟΡΙΑ',
      'ΚΡΥΠΤΟ',
      'ΤΣΙΡΚΟ',
      'ΑΣΟΡΤΙ',
      'ΚΙΟΛΑΣ',
      'ΤΣΑΡΚΑ',
      'ΣΤΑΛΙΑ',
      'ΡΑΠΤΟΣ',
      'ΛΥΡΑΚΙ',
      'ΙΑΤΡΟΣ',
      'ΚΙΠΟΥΡ',
      'ΠΑΣΤΡΑ',
      'ΤΣΑΚΡΑ',
      'ΚΡΑΤΟΣ',
      'ΠΑΛΣΑΡ',
      'ΤΣΑΚΙΡ',
      'ΑΡΤΙΟΣ',
      'ΣΤΟΡΙΑ',
      'ΣΤΟΥΠΙ',
      'ΣΤΡΑΚΑ',
      'ΚΟΥΤΡΑ',
      'ΟΣΤΡΙΑ',
      'ΠΟΚΑΡΙ',
      'ΤΡΟΠΙΣ',
      'ΤΡΟΙΚΑ',
      'ΡΙΚΟΤΑ',
      'ΚΛΙΤΟΣ',
      'ΤΑΛΑΡΟ',
      'ΤΑΛΙΡΟ',
      'ΠΑΤΑΚΙ',
      'ΑΡΚΤΟΣ',
      'ΛΟΥΤΣΑ',
      'ΑΡΙΣΤΑ',
      'ΠΑΤΑΡΙ',
      'ΤΡΙΠΛΑ',
      'ΚΑΡΠΟΣ',
      'ΠΑΛΙΟΣ',
      'ΚΟΥΡΣΑ',
      'ΚΛΙΤΥΣ',
      'ΚΟΥΠΙΑ',
      'ΣΚΡΙΠΤ',
      'ΚΛΟΣΑΡ',
      'ΑΥΤΙΑΣ',
      'ΑΡΑΟΥΤ',
      'ΤΑΥΡΟΣ',
      'ΑΡΑΙΟΣ',
      'ΤΟΥΡΣΙ',
      'ΠΑΡΟΤΙ',
      'ΤΟΥΡΛΑ',
      'ΚΟΣΑΡΙ',
      'ΚΑΛΟΡΙ',
      'ΚΟΡΑΣΙ',
      'ΤΟΥΡΚΑ',
      'ΠΙΑΤΣΑ',
      'ΚΟΠΤΣΑ',
      'ΚΟΠΡΙΑ',
      'ΑΠΟΡΙΑ',
      'ΡΟΥΠΙΑ',
      'ΚΥΡΟΣ',
      'ΤΟΠΙΚ',
      'ΚΟΡΑΛ',
      'ΚΟΣΤΑ',
      'ΚΟΤΣΙ',
      'ΚΟΠΙΑ',
      'ΚΟΛΑΙ',
      'ΤΡΑΚΑ',
      'ΤΡΑΚΟ',
      'ΠΑΤΟΣ',
      'ΤΙΑΡΑ',
      'ΤΑΥΡΙ',
      'ΚΟΑΛΑ',
      'ΚΟΥΠΑ',
      'ΤΡΙΚΟ',
      'ΚΟΥΠΙ',
      'ΚΟΥΡΑ',
      'ΤΑΠΙΑ',
      'ΤΑΠΑΣ',
      'ΚΟΥΤΑ',
      'ΤΑΚΟΣ',
      'ΚΟΥΤΙ',
      'ΚΛΑΡΙ',
      'ΣΥΚΙΑ',
      'ΤΡΟΥΚ',
      'ΤΡΥΠΑ',
      'ΣΤΥΛΟ',
      'ΚΛΑΡΑ',
      'ΚΛΑΠΑ',
      'ΚΙΤΡΟ',
      'ΤΣΑΚΑ',
      'ΣΤΟΡΙ',
      'ΚΡΑΣΙ',
      'ΣΤΙΠΛ',
      'ΚΡΙΟΣ',
      'ΠΑΣΤΑ',
      'ΤΣΑΠΑ',
      'ΣΤΑΡΙ',
      'ΤΣΑΠΙ',
      'ΣΤΑΛΑ',
      'ΤΣΙΚΟ',
      'ΣΤΑΚΑ',
      'ΤΣΙΠΑ',
      'ΚΡΥΟΣ',
      'ΣΠΥΡΙ',
      'ΣΠΟΡΙ',
      'ΣΠΟΡΑ',
      'ΠΑΛΤΟ',
      'ΤΣΟΛΙ',
      'ΠΑΡΚΟ',
      'ΤΣΟΥΠ',
      'ΚΑΛΟΣ',
      'ΣΠΑΛΑ',
      'ΤΥΛΟΣ',
      'ΚΥΠΡΙ',
      'ΣΟΥΡΙ',
      'ΣΟΥΡΑ',
      'ΤΥΠΟΣ',
      'ΤΥΡΑΣ',
      'ΣΟΥΠΑ',
      'ΤΥΡΟΣ',
      'ΚΥΡΙΑ',
      'ΥΑΛΟΣ',
      'ΤΟΥΑΛ',
      'ΥΛΙΚΟ',
      'ΣΛΟΥΠ',
      'ΣΛΟΤΙ',
      'ΣΚΥΡΟ',
      'ΠΑΤΣΙ',
      'ΣΚΥΛΙ',
      'ΠΙΡΟΣ',
      'ΣΚΡΑΠ',
      'ΠΑΡΛΑ',
      'ΣΚΟΤΑ',
      'ΚΥΤΙΟ',
      'ΚΥΤΟΣ',
      'ΛΑΠΑΣ',
      'ΠΑΥΛΑ',
      'ΣΚΑΡΙ',
      'ΣΚΑΡΑ',
      'ΚΑΤΟΥ',
      'ΣΚΑΛΠ',
      'ΠΑΡΤΙ',
      'ΑΚΡΙΑ',
      'ΣΚΑΛΙ',
      'ΣΚΑΛΑ',
      'ΣΚΑΙΠ',
      'ΑΚΡΟΣ',
      'ΑΚΥΡΟ',
      'ΣΙΤΑΡ',
      'ΠΑΛΚΟ',
      'ΛΑΤΡΑ',
      'ΑΛΑΤΙ',
      'ΛΑΥΡΑ',
      'ΛΙΑΚΟ',
      'ΣΑΥΡΑ',
      'ΣΑΡΠΑ',
      'ΚΑΣΤΑ',
      'ΣΑΡΚΑ',
      'ΚΑΣΠΟ',
      'ΣΑΡΙΑ',
      'ΛΙΚΡΑ',
      'ΑΟΥΛΑ',
      'ΣΑΡΑΙ',
      'ΑΟΥΤΣ',
      'ΠΙΑΤΟ',
      'ΑΠΑΚΙ',
      'ΣΑΛΤΟ',
      'ΣΑΛΠΑ',
      'ΚΑΡΥΟ',
      'ΣΑΛΙΟ',
      'ΛΙΠΟΣ',
      'ΛΙΣΤΑ',
      'ΑΠΙΚΟ',
      'ΚΑΡΤΟ',
      'ΛΙΤΟΣ',
      'ΑΠΛΟΣ',
      'ΛΙΤΡΟ',
      'ΡΥΠΟΣ',
      'ΚΑΡΤΑ',
      'ΛΥΚΟΣ',
      'ΡΥΑΚΙ',
      'ΛΟΥΚΙ',
      'ΡΟΥΠΙ',
      'ΡΟΥΚΙ',
      'ΤΟΥΛΙ',
      'ΚΑΡΣΤ',
      'ΛΟΥΠΑ',
      'ΚΑΡΣΙ',
      'ΛΟΥΡΙ',
      'ΡΟΚΙΑ',
      'ΡΟΚΑΣ',
      'ΑΡΙΟΣ',
      'ΛΟΥΤΡ',
      'ΡΙΣΚΟ',
      'ΠΑΛΙΑ',
      'ΡΑΤΣΑ',
      'ΑΡΤΙΟ',
      'ΡΑΣΤΑ',
      'ΑΡΤΟΣ',
      'ΡΑΣΠΑ',
      'ΠΑΡΤΑ',
      'ΡΑΚΟΣ',
      'ΠΥΤΙΑ',
      'ΛΥΤΟΣ',
      'ΑΣΤΡΟ',
      'ΛΥΤΡΑ',
      'ΟΚΑΠΙ',
      'ΑΣΥΛΟ',
      'ΠΙΚΛΑ',
      'ΠΤΙΛΟ',
      'ΠΡΟΚΑ',
      'ΠΡΙΤΣ',
      'ΠΙΚΡΑ',
      'ΠΡΑΣΟ',
      'ΠΡΑΟΣ',
      'ΑΤΡΙΟ',
      'ΚΑΠΡΙ',
      'ΠΟΥΣΙ',
      'ΟΡΤΣΑ',
      'ΠΟΥΡΙ',
      'ΠΟΥΛΙ',
      'ΟΣΚΑΡ',
      'ΠΟΣΤΑ',
      'ΑΥΛΟΣ',
      'ΟΣΤΙΑ',
      'ΑΥΡΙΟ',
      'ΠΟΡΤΑ',
      'ΠΟΛΚΑ',
      'ΚΑΠΟΥ',
      'ΑΥΤΟΣ',
      'ΙΑΤΟΣ',
      'ΟΥΡΙΑ',
      'ΙΛΑΡΑ',
      'ΠΛΟΥΣ',
      'ΟΥΣΙΑ',
      'ΠΛΑΤΣ',
      'ΠΙΛΟΣ',
      'ΠΛΑΤΟ',
      'ΠΑΡΑΣ',
      'ΠΛΑΚΙ',
      'ΠΛΑΚΑ',
      'ΠΙΤΥΣ',
      'ΚΑΛΑΙ',
      'ΠΙΤΣΑ',
      'ΚΑΛΙΑ',
      'ΚΑΛΙΟ',
      'ΠΑΛΑΙ',
      'ΠΙΣΤΑ',
      'ΑΠΤΟΣ',
      'ΣΤΙΛΟ',
      'ΣΤΟΠ',
      'ΚΑΛΑ',
      'ΚΑΛΤ',
      'ΙΣΚΑ',
      'ΚΑΠΑ',
      'ΚΑΠΟ',
      'ΙΛΥΣ',
      'ΑΥΤΟ',
      'ΑΥΤΙ',
      'ΑΥΡΑ',
      'ΑΤΣΑ',
      'ΑΤΟΥ',
      'ΚΑΡΑ',
      'ΑΤΟΣ',
      'ΚΑΡΙ',
      'ΚΑΡΟ',
      'ΑΣΤΥ',
      'ΑΣΚΙ',
      'ΑΡΤΙ',
      'ΑΡΠΑ',
      'ΑΡΙΑ',
      'ΑΡΑΚ',
      'ΚΑΡΤ',
      'ΑΠΛΑ',
      'ΑΠΑΣ',
      'ΚΑΣΑ',
      'ΑΟΥΤ',
      'ΤΡΑΠ',
      'ΑΛΤΟ',
      'ΚΑΣΤ',
      'ΑΛΑΣ',
      'ΚΑΤΑ',
      'ΚΑΤΙ',
      'ΑΚΡΟ',
      'ΑΚΡΑ',
      'ΚΑΤΣ',
      'ΥΙΟΣ',
      'ΤΥΡΙ',
      'ΚΙΛΟ',
      'ΤΣΟΚ',
      'ΚΙΛΤ',
      'ΤΣΙΠ',
      'ΚΙΠΑ',
      'ΤΣΑΟ',
      'ΤΣΑΚ',
      'ΚΙΤΣ',
      'ΤΣΑΙ',
      'ΤΡΟΛ',
      'ΚΛΙΠ',
      'ΤΡΙΣ',
      'ΤΡΙΠ',
      'ΚΛΟΣ',
      'ΤΡΙΟ',
      'ΤΡΙΚ',
      'ΚΛΟΥ',
      'ΤΡΙΑ',
      'ΚΑΛΙ',
      'ΚΟΛΑ',
      'ΤΡΑΚ',
      'ΚΟΠΙ',
      'ΤΟΥΣ',
      'ΤΟΥΡ',
      'ΚΟΡΑ',
      'ΤΟΠΙ',
      'ΚΟΣΑ',
      'ΤΟΚΑ',
      'ΚΟΤΑ',
      'ΚΟΥΛ',
      'ΚΟΥΠ',
      'ΤΑΣΙ',
      'ΤΑΡΟ',
      'ΤΑΡΑ',
      'ΤΑΠΙ',
      'ΤΑΠΑ',
      'ΤΑΛΚ',
      'ΣΥΚΟ',
      'ΣΤΥΛ',
      'ΚΡΑΣ',
      'ΣΙΛΟ',
      'ΣΤΟΚ',
      'ΣΤΟΑ',
      'ΣΤΙΛ',
      'ΣΤΙΚ',
      'ΣΤΑΡ',
      'ΚΡΥΟ',
      'ΣΠΟΤ',
      'ΣΠΟΡ',
      'ΣΟΥΤ',
      'ΚΥΡΑ',
      'ΣΟΡΙ',
      'ΣΟΛΑ',
      'ΣΛΙΠ',
      'ΣΚΟΡ',
      'ΣΚΙΤ',
      'ΛΑΙΚ',
      'ΛΑΙΤ',
      'ΛΑΚΑ',
      'ΛΑΟΣ',
      'ΛΑΠΑ',
      'ΣΚΙΑ',
      'ΛΑΣΙ',
      'ΛΑΣΟ',
      'ΣΚΑΤ',
      'ΣΙΤΑ',
      'ΚΑΛΟ',
      'ΣΑΡΙ',
      'ΣΑΡΑ',
      'ΣΑΛΙ',
      'ΛΙΡΑ',
      'ΣΑΛΑ',
      'ΣΑΚΙ',
      'ΣΑΚΑ',
      'ΣΑΙΤ',
      'ΡΥΤΟ',
      'ΛΟΥΚ',
      'ΠΑΡΑ',
      'ΠΤΥΟ',
      'ΟΥΑΙ',
      'ΠΟΚΑ',
      'ΠΥΑΡ',
      'ΠΟΛΥ',
      'ΠΑΚΟ',
      'ΠΥΡΑ',
      'ΡΑΛΙ',
      'ΡΑΣΟ',
      'ΠΑΣΑ',
      'ΠΟΣΤ',
      'ΠΑΙΣ',
      'ΠΑΛΑ',
      'ΠΛΑΙ',
      'ΛΥΡΑ',
      'ΠΟΥΑ',
      'ΟΥΣΤ',
      'ΠΙΤΣ',
      'ΠΟΥΣ',
      'ΡΙΑΛ',
      'ΟΡΚΑ',
      'ΠΙΚΑ',
      'ΠΑΣΟ',
      'ΡΟΚΑ',
      'ΟΥΛΑ',
      'ΠΡΟΣ',
      'ΡΟΤΑ',
      'ΡΟΥΑ',
      'ΟΥΡΙ',
      'ΟΥΡΑ',
      'ΠΑΛΙ',
      'ΟΥΤΙ',
      'ΟΥΠΣ',
      'ΟΥΠΑ',
      'ΠΑΤΣ',
      'ΠΙΤΑ',
      'ΟΠΑΚ',
      'ΡΟΥΣ',
      'ΠΛΙΑ',
      'ΛΟΥ',
      'ΣΙΑ',
      'ΣΙΚ',
      'ΣΚΑ',
      'ΡΟΚ',
      'ΣΚΙ',
      'ΛΑΚ',
      'ΣΟΙ',
      'ΡΑΠ',
      'ΣΟΚ',
      'ΣΟΛ',
      'ΠΥΡ',
      'ΣΟΥ',
      'ΟΚΑ',
      'ΣΠΑ',
      'ΟΠΑ',
      'ΣΤΑ',
      'ΚΡΑ',
      'ΠΡΟ',
      'ΙΣΑ',
      'ΤΑΟ',
      'ΤΑΡ',
      'ΠΟΥ',
      'ΠΟΤ',
      'ΤΑΥ',
      'ΚΟΥ',
      'ΤΙΚ',
      'ΟΤΙ',
      'ΤΙΠ',
      'ΟΥΚ',
      'ΤΙΣ',
      'ΤΟΛ',
      'ΤΟΠ',
      'ΤΟΡ',
      'ΤΟΥ',
      'ΠΟΑ',
      'ΟΥΣ',
      'ΤΣΑ',
      'ΚΙΤ',
      'ΥΠΟ',
      'ΑΛΑ',
      'ΚΑΤ',
      'ΑΛΙ',
      'ΠΑΛ',
      'ΑΛΤ',
      'ΚΑΣ',
      'ΑΠΟ',
      'ΠΙΟ',
      'ΑΡΑ',
      'ΑΤΑ',
      'ΠΙΚ',
      'ΠΙΑ',
      'ΑΤΙ',
      'ΠΑΤ',
      'ΙΟΣ',
      'ΙΣΟ',
      'ΚΑΙ',
      'ΑΟΥ',
    ];
    final letters = ['Σ', 'Ρ', 'Κ', 'Υ', 'Α', 'Α', 'Π', 'Τ', 'Ο', 'Λ', 'Ι'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel9Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΚΟΝΤΙΣΙΟΝΕΡ', [
      60,
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
    ]);
    tracker.addPlacement('ΕΡΚΟΝΤΙΣΙΟΝ', [
      14,
      26,
      38,
      50,
      62,
      74,
      86,
      98,
      110,
      122,
      134,
    ]);
    tracker.addPlacement('ΝΕΤΡΟΝΙΚΟΣ', [
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
    ]);
    tracker.addPlacement('ΟΝΕΙΡΙΚΟΣ', [6, 18, 30, 42, 54, 66, 78, 90, 102]);
    tracker.addPlacement('ΡΟΤΕΙΣΟΝ', [16, 28, 40, 52, 64, 76, 88, 100]);
    tracker.addPlacement('ΕΟΡΤΙΝΟΣ', [121, 122, 123, 124, 125, 126, 127, 128]);
    tracker.addPlacement('ΙΟΝΤΙΚΟΣ', [44, 56, 68, 80, 92, 104, 116, 128]);
    tracker.addPlacement('ΚΡΕΤΙΝΟΣ', [58, 70, 82, 94, 106, 118, 130, 142]);
    tracker.addPlacement('ΟΙΚΕΙΟΣ', [36, 48, 60, 72, 84, 96, 108]);
    tracker.addPlacement('ΤΟΝ', [9, 21, 33]);
    tracker.addPlacement('ΤΙΣ', [113, 125, 137]);

    tracker.commonPositions.addAll([
      60,
      62,
      64,
      66,
      68,
      70,
      14,
      122,
      16,
      18,
      21,
      125,
      128,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΚΟΝΤΙΣΙΟΝΕΡ',
      'ΕΡΚΟΝΤΙΣΙΟΝ',
      'ΝΕΤΡΟΝΙΚΟΣ',
      'ΟΝΕΙΡΙΚΟΣ',
      'ΡΟΤΕΙΣΟΝ',
      'ΕΟΡΤΙΝΟΣ',
      'ΙΝΤΡΟΝΙΟ',
      'ΙΟΝΤΙΚΟΣ',
      'ΚΟΝΣΕΡΤΟ',
      'ΙΣΤΟΡΙΚΟ',
      'ΚΙΤΡΙΝΟΣ',
      'ΚΟΝΤΙΝΟΣ',
      'ΚΡΕΤΙΝΟΣ',
      'ΝΕΤΡΟΝΙΟ',
      'ΝΙΤΡΙΚΟΣ',
      'ΟΝΤΙΣΙΟΝ',
      'ΕΝΤΟΚΟΣ',
      'ΚΟΡΝΕΤΟ',
      'ΚΟΤΙΝΟΣ',
      'ΙΚΤΕΡΟΣ',
      'ΕΝΟΙΚΙΟ',
      'ΝΕΤΡΙΝΟ',
      'ΕΝΟΡΚΟΣ',
      'ΚΕΡΙΝΟΣ',
      'ΕΝΟΙΚΟΣ',
      'ΕΝΤΟΝΟΣ',
      'ΝΟΤΕΡΟΣ',
      'ΟΙΚΕΙΟΣ',
      'ΤΕΝΟΡΟΣ',
      'ΟΙΝΙΚΟΣ',
      'ΤΟΝΙΚΟΣ',
      'ΕΝΡΙΝΟΣ',
      'ΟΡΕΙΝΟΣ',
      'ΡΕΤΣΙΝΙ',
      'ΡΙΚΙΝΟΣ',
      'ΡΙΝΙΚΟΣ',
      'ΚΟΡΙΤΣΙ',
      'ΣΕΚΟΝΤΟ',
      'ΣΕΝΤΟΝΙ',
      'ΤΣΙΡΟΝΙ',
      'ΤΣΙΚΟΡΕ',
      'ΣΚΡΙΝΙΟ',
      'ΟΙΚΤΡΟΣ',
      'ΝΙΟΝΙΟ',
      'ΣΤΕΡΝΟ',
      'ΚΟΝΤΟΣ',
      'ΚΟΡΙΟΣ',
      'ΚΟΤΕΡΟ',
      'ΚΡΕΤΟΝ',
      'ΚΡΙΝΟΣ',
      'ΚΡΟΤΕΙ',
      'ΚΡΟΤΟΣ',
      'ΚΤΙΡΙΟ',
      'ΝΕΚΡΟΣ',
      'ΚΟΙΝΟΣ',
      'ΚΕΙΝΟΣ',
      'ΝΟΕΡΟΣ',
      'ΚΕΝΤΡΙ',
      'ΝΟΤΙΟΣ',
      'ΝΤΕΚΟΡ',
      'ΝΤΙΣΚΟ',
      'ΕΝΙΚΟΣ',
      'ΝΤΟΚΟΣ',
      'ΝΤΟΝΕΡ',
      'ΝΤΟΡΟΣ',
      'ΝΤΟΣΙΕ',
      'ΚΕΝΤΡΟ',
      'ΟΙΚΤΟΣ',
      'ΟΙΟΝΕΙ',
      'ΟΝΕΙΡΟ',
      'ΟΡΕΙΟΣ',
      'ΟΡΙΣΤΕ',
      'ΟΣΤΡΕΟ',
      'ΕΙΚΟΣΙ',
      'ΡΙΚΝΟΣ',
      'ΡΟΝΤΕΟ',
      'ΚΟΙΝΟΝ',
      'ΤΣΙΡΚΟ',
      'ΣΙΚΟΡΕ',
      'ΣΙΝΙΟΝ',
      'ΣΚΟΙΝΙ',
      'ΤΕΝΟΡΟ',
      'ΤΟΡΝΟΣ',
      'ΣΤΙΚΕΡ',
      'ΚΟΝΤΕΡ',
      'ΣΟΝΕΤΟ',
      'ΤΣΕΡΚΙ',
      'ΣΝΙΚΕΡ',
      'ΤΟΝΝΟΣ',
      'ΣΚΟΝΤΟ',
      'ΙΡΟΚΟ',
      'ΙΕΡΟΣ',
      'ΚΡΙΟΣ',
      'ΤΟΝΕΡ',
      'ΚΡΟΣΕ',
      'ΚΟΡΝΟ',
      'ΚΟΡΟΣ',
      'ΚΤΕΝΙ',
      'ΤΟΚΟΣ',
      'ΚΟΡΤΕ',
      'ΟΙΚΟΙ',
      'ΟΙΚΟΣ',
      'ΙΙΚΟΣ',
      'ΤΙΝΟΣ',
      'ΚΕΡΙΝ',
      'ΟΙΝΟΣ',
      'ΚΕΝΤΟ',
      'ΤΣΕΡΙ',
      'ΝΙΤΡΟ',
      'ΟΚΝΟΣ',
      'ΤΕΝΙΣ',
      'ΤΟΡΟΣ',
      'ΟΝΟΡΕ',
      'ΤΕΚΝΟ',
      'ΚΕΣΙΟ',
      'ΣΤΟΡΙ',
      'ΚΟΤΣΙ',
      'ΝΟΙΚΙ',
      'ΤΡΕΝΟ',
      'ΟΡΚΟΣ',
      'ΟΡΝΕΟ',
      'ΟΡΝΙΟ',
      'ΣΤΕΝΟ',
      'ΣΤΕΚΙ',
      'ΕΚΤΟΣ',
      'ΝΤΡΙΝ',
      'ΝΕΤΟΣ',
      'ΕΙΤΙΣ',
      'ΤΡΙΚΟ',
      'ΡΕΙΚΙ',
      'ΡΕΚΤΟ',
      'ΕΙΚΟΣ',
      'ΙΣΤΙΟ',
      'ΕΝΤΟΣ',
      'ΚΟΡΝΕ',
      'ΚΟΤΟΝ',
      'ΚΙΤΡΟ',
      'ΡΙΝΤΟ',
      'ΡΙΣΚΟ',
      'ΤΣΟΝΙ',
      'ΣΟΚΙΝ',
      'ΡΟΝΤΕ',
      'ΤΟΝΟΣ',
      'ΡΟΝΤΟ',
      'ΡΟΣΤΟ',
      'ΝΟΤΟΣ',
      'ΤΣΙΚΟ',
      'ΚΟΙΝΟ',
      'ΕΝΙΟΙ',
      'ΤΟΝΙΚ',
      'ΚΟΝΙΣ',
      'ΣΚΡΙΝ',
      'ΚΡΙΝΟ',
      'ΝΙΟΚΙ',
      'ΝΤΙΣΚ',
      'ΚΕΝΟΣ',
      'ΣΚΙΕΡ',
      'ΣΙΝΤΙ',
      'ΣΙΝΙΕ',
      'ΣΤΕΙΚ',
      'ΣΙΝΙ',
      'ΚΟΝΕ',
      'ΕΡΙΟ',
      'ΣΚΙΤ',
      'ΣΙΚΕ',
      'ΤΡΙΚ',
      'ΣΚΟΡ',
      'ΣΕΡΙ',
      'ΤΣΟΚ',
      'ΣΕΝΤ',
      'ΣΕΙΚ',
      'ΚΙΤΣ',
      'ΡΟΚΕ',
      'ΕΤΟΣ',
      'ΣΟΡΙ',
      'ΣΟΤΕ',
      'ΡΕΣΟ',
      'ΟΡΣΕ',
      'ΟΡΟΣ',
      'ΝΕΡΟ',
      'ΣΤΙΚ',
      'ΟΡΙΟ',
      'ΣΤΟΚ',
      'ΚΙΝΟ',
      'ΤΕΙΟ',
      'ΟΝΟΣ',
      'ΙΝΙΟ',
      'ΟΚΙΟ',
      'ΕΤΣΙ',
      'ΤΕΝΣ',
      'ΟΚΕΙ',
      'ΤΣΕΚ',
      'ΚΕΡΙ',
      'ΤΡΙΣ',
      'ΙΕΡΟ',
      'ΤΡΙΟ',
      'ΝΤΟΚ',
      'ΝΤΕΚ',
      'ΝΙΟΣ',
      'ΝΙΝΙ',
      'ΚΕΝΟ',
      'ΕΣΤΙ',
      'ΝΕΟΣ',
      'ΝΕΟΝ',
      'ΤΟΣΟ',
      'ΙΣΟΝ',
      'ΟΣΤΟ',
      'ΣΙΝΕ',
      'ΤΟΝ',
      'ΤΙΣ',
      'ΤΙΚ',
      'ΤΕΣ',
      'ΣΟΚ',
      'ΣΟΙ',
      'ΣΚΙ',
      'ΣΙΚ',
      'ΣΕΤ',
      'ΣΕΡ',
      'ΡΟΚ',
      'ΡΕΝ',
      'ΡΕΙ',
      'ΕΙΣ',
      'ΟΤΙ',
      'ΟΣΟ',
      'ΝΤΟ',
      'ΝΤΕ',
      'ΝΕΙ',
      'ΚΙΤ',
      'ΚΕΙ',
      'ΙΣΟ',
      'ΙΟΣ',
      'ΙΟΝ',
      'ΕΤΙ',
      'ΕΣΟ',
      'ΤΟΡ',
    ];
    final letters = ['Ι', 'Τ', 'Ν', 'Ο', 'Ν', 'Ο', 'Κ', 'Σ', 'Ι', 'Ρ', 'Ε'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel9Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΕΛΑΙΟΚΑΡΠΟΣ', [
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
      71,
    ]);
    tracker.addPlacement('ΑΠΕΙΡΟΚΑΛΟΣ', [
      5,
      17,
      29,
      41,
      53,
      65,
      77,
      89,
      101,
      113,
      125,
    ]);
    tracker.addPlacement('ΠΑΡΕΙΑΚΟΣ', [0, 1, 2, 3, 4, 5, 6, 7, 8]);
    tracker.addPlacement('ΠΑΡΛΙΑΚΟΣ', [37, 38, 39, 40, 41, 42, 43, 44, 45]);
    tracker.addPlacement('ΣΠΟΡΕΛΑΙΟ', [
      96,
      97,
      98,
      99,
      100,
      101,
      102,
      103,
      104,
    ]);
    tracker.addPlacement('ΕΙΚΟΣΑΡΑ', [121, 122, 123, 124, 125, 126, 127, 128]);
    tracker.addPlacement('ΚΟΙΛΑΡΑΣ', [58, 70, 82, 94, 106, 118, 130, 142]);
    tracker.addPlacement('ΡΑΣΟ', [68, 80, 92, 104]);
    tracker.addPlacement('ΡΟΚΑ', [2, 14, 26, 38]);
    tracker.addPlacement('ΟΠΑΚ', [7, 19, 31, 43]);
    tracker.addPlacement('ΛΑΣΟ', [62, 74, 86, 98]);
    tracker.addPlacement('ΠΡΟ', [117, 118, 119]);
    tracker.addPlacement('ΠΟΑ', [0, 12, 24]);
    tracker.addPlacement('ΠΕΣ', [21, 33, 45]);
    tracker.addPlacement('ΕΙΣ', [33, 34, 35]);
    tracker.addPlacement('ΟΣΟ', [141, 142, 143]);
    tracker.addPlacement('ΙΣΟ', [84, 96, 108]);

    tracker.commonPositions.addAll([
      62,
      65,
      68,
      70,
      5,
      41,
      101,
      125,
      0,
      2,
      7,
      38,
      43,
      45,
      96,
      98,
      104,
      118,
      142,
      33,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΕΛΑΙΟΚΑΡΠΟΣ',
      'ΑΠΕΙΡΟΚΑΛΟΣ',
      'ΠΑΡΕΙΑΚΟΣ',
      'ΠΑΡΛΙΑΚΟΣ',
      'ΣΠΟΡΕΛΑΙΟ',
      'ΑΚΕΡΑΙΟΣ',
      'ΑΡΑΠΙΚΟΣ',
      'ΕΙΚΟΣΑΡΑ',
      'ΕΠΙΟΡΚΟΣ',
      'ΚΑΠΟΕΙΡΑ',
      'ΚΟΙΛΑΡΑΣ',
      'ΟΛΑΚΕΡΟΣ',
      'ΟΠΛΑΣΚΙΑ',
      'ΠΑΡΑΛΙΟΣ',
      'ΠΑΡΑΣΟΛΙ',
      'ΠΑΡΟΙΚΟΣ',
      'ΠΕΡΙΚΑΛΑ',
      'ΣΚΑΛΙΕΡΑ',
      'ΣΚΑΡΠΕΛΟ',
      'ΑΕΡΟΣΟΛΑ',
      'ΚΟΠΕΛΙΑ',
      'ΚΡΕΟΛΟΣ',
      'ΛΙΠΑΡΟΣ',
      'ΑΠΛΕΡΟΣ',
      'ΕΚΠΑΛΑΙ',
      'ΟΠΛΙΚΟΣ',
      'ΟΡΙΑΚΟΣ',
      'ΠΑΛΑΙΟΣ',
      'ΠΑΡΑΚΕΙ',
      'ΑΠΟΙΚΟΣ',
      'ΕΠΟΙΚΟΣ',
      'ΕΣΚΑΛΟΠ',
      'ΚΑΠΕΛΑΣ',
      'ΑΠΕΙΡΟΣ',
      'ΑΚΡΑΙΟΣ',
      'ΚΑΠΟΙΟΣ',
      'ΠΕΡΚΑΛΙ',
      'ΠΛΕΡΙΟΣ',
      'ΠΟΛΙΚΟΣ',
      'ΡΕΠΛΙΚΑ',
      'ΡΟΠΑΛΙΑ',
      'ΚΕΡΑΣΙΑ',
      'ΑΣΕΡΟΛΑ',
      'ΣΠΑΡΙΛΑ',
      'ΣΠΟΙΛΕΡ',
      'ΣΠΟΡΕΙΟ',
      'ΑΛΠΙΚΟΣ',
      'ΚΟΡΑΣΙΑ',
      'ΑΚΑΙΡΟΣ',
      'ΑΚΑΡΠΟΣ',
      'ΑΣΠΡΙΛΑ',
      'ΑΚΕΡΙΟΣ',
      'ΠΕΡΑΣΙΑ',
      'ΠΑΛΙΟΣ',
      'ΑΠΟΚΕΙ',
      'ΙΛΑΡΟΣ',
      'ΚΑΙΡΟΣ',
      'ΚΑΛΕΣΑ',
      'ΚΑΛΟΡΙ',
      'ΚΑΠΑΡΟ',
      'ΑΠΟΡΙΑ',
      'ΚΑΠΕΛΟ',
      'ΑΠΟΡΟΣ',
      'ΚΑΠΡΟΣ',
      'ΚΑΡΠΟΣ',
      'ΚΑΣΕΛΑ',
      'ΚΑΣΕΡΙ',
      'ΚΕΛΑΡΙ',
      'ΚΕΡΑΙΑ',
      'ΚΕΡΑΣΑ',
      'ΚΕΡΑΣΙ',
      'ΑΡΑΙΟΣ',
      'ΚΙΟΛΑΣ',
      'ΚΛΑΣΕΡ',
      'ΚΛΟΙΟΣ',
      'ΚΛΟΣΑΡ',
      'ΚΟΙΛΟΣ',
      'ΚΟΛΑΡΟ',
      'ΚΟΛΕΟΣ',
      'ΚΟΛΙΟΣ',
      'ΚΟΛΠΟΣ',
      'ΚΟΠΕΛΑ',
      'ΚΟΠΕΛΙ',
      'ΚΟΠΛΕΡ',
      'ΚΟΠΡΙΑ',
      'ΚΟΠΡΟΣ',
      'ΚΟΡΑΣΙ',
      'ΚΟΡΙΟΣ',
      'ΚΟΣΑΡΙ',
      'ΛΑΡΙΚΑ',
      'ΛΕΟΠΑΡ',
      'ΛΕΠΡΟΣ',
      'ΛΟΙΠΟΣ',
      'ΟΛΙΚΟΣ',
      'ΟΠΑΛΙΟ',
      'ΑΡΚΕΣΑ',
      'ΟΡΕΙΟΣ',
      'ΟΣΠΡΙΑ',
      'ΑΠΛΙΚΑ',
      'ΠΟΡΕΙΑ',
      'ΠΑΛΣΑΡ',
      'ΑΣΚΕΡΙ',
      'ΑΠΛΙΚΕ',
      'ΠΑΡΕΙΑ',
      'ΠΑΡΙΑΣ',
      'ΠΑΡΙΟΣ',
      'ΠΑΡΟΛΑ',
      'ΠΑΡΟΛΟ',
      'ΠΑΡΣΕΚ',
      'ΠΑΣΚΑΛ',
      'ΠΕΙΡΟΣ',
      'ΠΕΡΑΣΑ',
      'ΠΙΚΟΛΟ',
      'ΠΙΚΡΟΣ',
      'ΠΛΑΚΑΣ',
      'ΠΛΑΣΙΕ',
      'ΠΟΚΑΡΙ',
      'ΠΟΛΙΟΣ',
      'ΑΠΕΙΡΟ',
      'ΠΡΑΣΙΑ',
      'ΠΡΟΙΚΑ',
      'ΡΕΑΛΙΑ',
      'ΡΟΠΑΛΟ',
      'ΡΟΣΟΛΙ',
      'ΣΑΛΕΠΙ',
      'ΣΑΠΑΚΙ',
      'ΣΑΠΙΛΑ',
      'ΣΑΡΑΚΙ',
      'ΣΑΡΚΙΟ',
      'ΣΕΠΑΛΟ',
      'ΣΙΚΟΡΕ',
      'ΣΚΕΛΙΑ',
      'ΣΚΙΠΕΡ',
      'ΣΚΟΠΙΑ',
      'ΣΟΚΟΛΑ',
      'ΣΟΡΟΠΙ',
      'ΣΠΑΡΕΙ',
      'ΕΛΙΚΑΣ',
      'ΣΠΕΙΡΑ',
      'ΣΠΙΚΕΡ',
      'ΑΛΙΠΟΣ',
      'ΑΟΠΛΟΣ',
      'ΑΛΙΚΟΣ',
      'ΕΣΑΡΠΑ',
      'ΑΛΙΕΑΣ',
      'ΑΚΟΠΟΣ',
      'ΑΠΟΙΟΣ',
      'ΕΠΙΚΟΣ',
      'ΑΙΟΛΟΣ',
      'ΕΠΑΚΡΟ',
      'ΑΕΡΙΟΣ',
      'ΑΕΡΙΚΟ',
      'ΑΕΡΑΚΙ',
      'ΣΠΟΡΙΟ',
      'ΣΠΟΡΙΑ',
      'ΑΠΑΛΟΣ',
      'ΣΠΙΡΑΛ',
      'ΣΕΙΡΑ',
      'ΚΡΕΠΑ',
      'ΚΡΕΠΙ',
      'ΚΡΙΟΣ',
      'ΚΡΟΣΕ',
      'ΛΑΚΕΣ',
      'ΛΑΠΑΣ',
      'ΛΕΙΟΣ',
      'ΛΕΠΡΑ',
      'ΚΟΠΟΣ',
      'ΛΕΡΟΣ',
      'ΛΙΑΚΟ',
      'ΛΙΚΕΡ',
      'ΛΙΚΡΑ',
      'ΠΙΚΛΑ',
      'ΛΙΠΟΣ',
      'ΚΑΡΣΙ',
      'ΟΙΚΟΣ',
      'ΟΚΑΠΙ',
      'ΑΡΙΟΣ',
      'ΑΠΑΚΙ',
      'ΟΛΚΟΣ',
      'ΑΚΡΟΣ',
      'ΟΠΑΙΟ',
      'ΟΠΕΡΑ',
      'ΑΡΚΕΙ',
      'ΟΡΚΟΣ',
      'ΟΣΚΑΡ',
      'ΑΚΡΙΑ',
      'ΚΑΠΡΙ',
      'ΠΑΛΑΙ',
      'ΚΑΣΠΟ',
      'ΠΑΛΙΑ',
      'ΠΑΛΚΟ',
      'ΚΟΠΙΑ',
      'ΠΑΡΑΣ',
      'ΠΑΡΕΑ',
      'ΠΑΡΕΟ',
      'ΚΕΡΑΣ',
      'ΚΑΛΑΙ',
      'ΠΑΡΚΕ',
      'ΠΑΡΚΟ',
      'ΠΑΡΛΑ',
      'ΕΙΚΟΣ',
      'ΑΠΛΟΣ',
      'ΙΕΡΟΣ',
      'ΚΕΣΙΟ',
      'ΚΟΡΑΛ',
      'ΠΕΙΡΑ',
      'ΠΕΛΟΣ',
      'ΠΕΡΑΣ',
      'ΠΕΡΚΑ',
      'ΠΕΡΛΑ',
      'ΠΕΡΣΙ',
      'ΑΡΑΣΕ',
      'ΡΑΠΕΛ',
      'ΠΙΚΡΑ',
      'ΚΙΠΕΡ',
      'ΠΙΛΟΣ',
      'ΠΙΟΛΕ',
      'ΠΙΡΟΣ',
      'ΠΛΑΚΑ',
      'ΚΛΑΠΑ',
      'ΠΛΑΚΕ',
      'ΠΛΑΚΙ',
      'ΣΚΑΙΠ',
      'ΙΡΟΚΟ',
      'ΣΚΙΕΡ',
      'ΡΟΛΟΙ',
      'ΡΟΚΙΑ',
      'ΣΚΑΛΠ',
      'ΡΟΚΑΣ',
      'ΣΠΟΡΑ',
      'ΕΛΑΙΟ',
      'ΡΙΣΚΟ',
      'ΡΕΠΟΣ',
      'ΑΕΡΑΣ',
      'ΣΚΑΛΙ',
      'ΡΕΚΛΑ',
      'ΑΠΙΚΟ',
      'ΚΑΛΙΟ',
      'ΡΑΣΠΑ',
      'ΣΟΛΕΑ',
      'ΚΟΛΙΕ',
      'ΚΡΕΑΣ',
      'ΣΚΑΛΑ',
      'ΡΟΛΟΣ',
      'ΣΚΑΡΙ',
      'ΣΠΟΡΙ',
      'ΚΡΑΣΙ',
      'ΡΑΚΟΣ',
      'ΣΕΡΑΙ',
      'ΠΡΟΚΑ',
      'ΚΛΙΣΕ',
      'ΑΕΡΙΟ',
      'ΣΠΑΛΑ',
      'ΠΡΕΣΑ',
      'ΣΕΠΙΑ',
      'ΕΛΚΟΣ',
      'ΠΡΕΚΙ',
      'ΚΑΛΟΣ',
      'ΠΡΑΣΟ',
      'ΠΡΑΟΣ',
      'ΣΠΡΕΙ',
      'ΠΟΡΟΣ',
      'ΚΛΕΟΣ',
      'ΠΟΛΟΣ',
      'ΠΟΛΚΑ',
      'ΕΛΑΙΑ',
      'ΚΑΛΙΑ',
      'ΚΟΛΑΙ',
      'ΣΑΡΚΑ',
      'ΠΟΚΕΡ',
      'ΚΛΑΡΙ',
      'ΠΟΙΟΣ',
      'ΣΑΡΙΑ',
      'ΚΟΡΟΣ',
      'ΠΛΟΙΟ',
      'ΣΑΡΑΙ',
      'ΠΛΙΣΕ',
      'ΣΛΕΠΙ',
      'ΙΛΑΡΑ',
      'ΣΑΛΠΑ',
      'ΚΛΑΡΑ',
      'ΣΚΡΑΠ',
      'ΚΟΛΠΟ',
      'ΠΛΑΣΕ',
      'ΣΚΑΡΑ',
      'ΣΑΛΙΟ',
      'ΚΟΑΛΑ',
      'ΣΑΡΠΑ',
      'ΠΛΑΙ',
      'ΚΑΡΑ',
      'ΕΚΑΣ',
      'ΠΛΙΑ',
      'ΚΙΠΑ',
      'ΠΙΚΕ',
      'ΠΙΚΑ',
      'ΑΠΛΑ',
      'ΠΟΚΑ',
      'ΠΕΣΟ',
      'ΙΣΚΑ',
      'ΚΟΣΑ',
      'ΕΚΑΙ',
      'ΕΠΟΣ',
      'ΠΟΛΟ',
      'ΠΕΡΙ',
      'ΕΙΠΑ',
      'ΚΑΛΙ',
      'ΠΟΣΕ',
      'ΠΟΣΟ',
      'ΠΕΡΑ',
      'ΚΛΙΠ',
      'ΠΕΟΣ',
      'ΚΙΛΟ',
      'ΠΑΣΟ',
      'ΠΑΣΕ',
      'ΠΑΣΑ',
      'ΚΕΡΙ',
      'ΠΡΟΣ',
      'ΚΑΛΕ',
      'ΡΑΛΙ',
      'ΚΑΡΕ',
      'ΚΟΠΙ',
      'ΡΑΣΟ',
      'ΑΚΡΑ',
      'ΡΕΑΛ',
      'ΚΑΛΑ',
      'ΑΕΡΙ',
      'ΚΕΡΑ',
      'ΡΕΛΙ',
      'ΑΣΚΙ',
      'ΡΕΠΟ',
      'ΚΕΛΙ',
      'ΡΕΣΟ',
      'ΡΙΑΛ',
      'ΠΑΡΑ',
      'ΑΡΕΙ',
      'ΡΟΚΑ',
      'ΚΟΡΑ',
      'ΡΟΚΕ',
      'ΠΑΛΙ',
      'ΡΟΛΕ',
      'ΡΟΛΟ',
      'ΠΑΛΕ',
      'ΠΑΛΑ',
      'ΕΡΙΟ',
      'ΚΛΟΣ',
      'ΚΑΛΟ',
      'ΣΑΚΑ',
      'ΣΑΚΕ',
      'ΣΑΚΙ',
      'ΣΑΛΑ',
      'ΣΑΛΕ',
      'ΠΑΚΟ',
      'ΣΑΛΙ',
      'ΠΑΙΣ',
      'ΟΡΣΕ',
      'ΑΡΑΚ',
      'ΟΡΟΣ',
      'ΣΑΡΑ',
      'ΟΡΚΑ',
      'ΚΟΛΑ',
      'ΣΑΡΙ',
      'ΟΡΙΟ',
      'ΑΡΠΑ',
      'ΚΑΕΙ',
      'ΟΠΟΣ',
      'ΟΠΛΟ',
      'ΣΕΙΚ',
      'ΙΕΡΟ',
      'ΣΕΛΑ',
      'ΚΑΣΕ',
      'ΟΠΙΟ',
      'ΚΡΑΣ',
      'ΣΕΡΑ',
      'ΟΠΕΡ',
      'ΣΕΡΙ',
      'ΚΑΣΑ',
      'ΟΠΑΚ',
      'ΣΙΚΕ',
      'ΚΑΠΑ',
      'ΣΙΛΟ',
      'ΕΛΟΣ',
      'ΑΚΡΟ',
      'ΟΛΟΣ',
      'ΟΚΙΟ',
      'ΟΚΕΙ',
      'ΑΛΑΣ',
      'ΛΙΡΑ',
      'ΛΕΣΙ',
      'ΕΛΙΑ',
      'ΛΕΡΑ',
      'ΛΕΠΙ',
      'ΣΚΙΑ',
      'ΚΑΡΟ',
      'ΑΠΑΣ',
      'ΛΕΙΑ',
      'ΣΚΟΡ',
      'ΛΑΣΟ',
      'ΛΑΣΙ',
      'ΣΛΙΠ',
      'ΣΠΟΡ',
      'ΚΑΡΙ',
      'ΛΑΠΑ',
      'ΑΡΕΣ',
      'ΣΟΛΑ',
      'ΛΑΟΣ',
      'ΣΟΛΟ',
      'ΣΟΡΙ',
      'ΛΑΚΑ',
      'ΚΡΕΠ',
      'ΑΛΕΑ',
      'ΚΑΠΟ',
      'ΛΑΙΚ',
      'ΑΡΙΑ',
      'ΣΠΑ',
      'ΣΟΛ',
      'ΣΟΚ',
      'ΣΟΙ',
      'ΣΚΙ',
      'ΕΛΟ',
      'ΣΚΑ',
      'ΣΙΚ',
      'ΣΙΑ',
      'ΣΕΡ',
      'ΣΕΑ',
      'ΑΕΙ',
      'ΡΟΚ',
      'ΕΛΑ',
      'ΡΕΙ',
      'ΡΑΠ',
      'ΠΡΟ',
      'ΑΠΟ',
      'ΠΟΑ',
      'ΠΙΟ',
      'ΠΙΚ',
      'ΠΙΑ',
      'ΠΕΣ',
      'ΕΙΣ',
      'ΠΕΙ',
      'ΕΑΡ',
      'ΠΑΛ',
      'ΟΣΟ',
      'ΟΠΑ',
      'ΟΛΟ',
      'ΑΛΑ',
      'ΟΚΑ',
      'ΛΑΚ',
      'ΑΛΙ',
      'ΚΕΙ',
      'ΚΑΣ',
      'ΑΡΑ',
      'ΚΑΙ',
      'ΙΣΟ',
      'ΙΣΑ',
      'ΙΟΣ',
      'ΕΣΟ',
      'ΑΠΕ',
      'ΚΡΑ',
    ];
    final letters = ['Ο', 'Α', 'Σ', 'Ο', 'Ρ', 'Ι', 'Α', 'Λ', 'Κ', 'Ε', 'Π'];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  // LEVEL: 10
  static CurrentStage _backupLevel10Option1() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΚΡΑΜΠΟΛΑΧΑΝΟ', [
      60,
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
      71,
    ]);
    tracker.addPlacement('ΚΑΡΜΠΟΛΑΧΑΝΟ', [
      5,
      17,
      29,
      41,
      53,
      65,
      77,
      89,
      101,
      113,
      125,
      137,
    ]);
    tracker.addPlacement('ΚΑΡΑΜΠΟΛΑ', [14, 15, 16, 17, 18, 19, 20, 21, 22]);
    tracker.addPlacement('ΠΑΝΟΡΑΜΑ', [88, 89, 90, 91, 92, 93, 94, 95]);
    tracker.addPlacement('ΑΛΜΑΝΑΚ', [39, 40, 41, 42, 43, 44, 45]);
    tracker.addPlacement('ΚΑΡΜΠΟΝ', [112, 113, 114, 115, 116, 117, 118]);
    tracker.addPlacement('ΚΟΠΡΑΝΑ', [136, 137, 138, 139, 140, 141, 142]);
    tracker.addPlacement('ΛΑΡΝΑΚΑ', [37, 49, 61, 73, 85, 97, 109]);
    tracker.addPlacement('ΡΑΠ', [84, 85, 86]);
    tracker.addPlacement('ΡΑΜ', [108, 109, 110]);
    tracker.addPlacement('ΠΑΝ', [10, 22, 34]);
    tracker.addPlacement('ΟΚΑ', [2, 14, 26]);
    tracker.addPlacement('ΜΠΑ', [110, 122, 134]);
    tracker.addPlacement('ΜΝΑ', [132, 133, 134]);

    tracker.commonPositions.addAll([
      61,
      65,
      17,
      41,
      89,
      113,
      137,
      14,
      22,
      85,
      109,
      110,
      134,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΚΡΑΜΠΟΛΑΧΑΝΟ',
      'ΚΑΡΜΠΟΛΑΧΑΝΟ',
      'ΚΑΡΑΜΠΟΛΑ',
      'ΠΑΝΟΡΑΜΑ',
      'ΑΛΜΑΝΑΚ',
      'ΚΑΡΜΠΟΝ',
      'ΚΟΠΡΑΝΑ',
      'ΜΟΝΟΠΛΑ',
      'ΛΑΡΝΑΚΑ',
      'ΜΑΚΑΡΟΝ',
      'ΜΠΑΧΑΛΟ',
      'ΜΠΛΑΝΚΟ',
      'ΚΑΜΠΑΝΑ',
      'ΡΟΜΠΟΛΑ',
      'ΧΑΡΜΑΝΑ',
      'ΑΚΡΟΑΜΑ',
      'ΑΜΠΑΡΑ',
      'ΚΟΜΠΛΑ',
      'ΚΟΜΠΡΑ',
      'ΚΟΝΟΜΑ',
      'ΚΟΠΑΝΑ',
      'ΚΟΡΟΝΑ',
      'ΚΡΑΜΠΑ',
      'ΚΡΑΜΠΛ',
      'ΛΑΜΠΡΑ',
      'ΛΑΠΑΡΑ',
      'ΛΑΧΑΝΑ',
      'ΛΑΧΑΝΟ',
      'ΜΑΚΡΑΝ',
      'ΚΑΠΑΡΟ',
      'ΜΟΛΟΧΑ',
      'ΜΟΝΑΧΑ',
      'ΜΟΝΟΚΛ',
      'ΜΠΑΝΑΛ',
      'ΜΠΑΝΚΑ',
      'ΜΠΑΡΚΟ',
      'ΜΠΑΡΟΚ',
      'ΜΠΛΟΚΟ',
      'ΝΑΠΑΛΜ',
      'ΝΟΡΜΑΛ',
      'ΚΑΝΑΡΑ',
      'ΚΑΜΑΡΑ',
      'ΚΟΛΑΡΟ',
      'ΠΑΡΟΛΑ',
      'ΑΝΟΡΑΚ',
      'ΚΟΜΑΡΑ',
      'ΑΧΑΜΝΑ',
      'ΚΟΛΟΝΑ',
      'ΡΟΠΑΛΟ',
      'ΧΑΡΑΜΑ',
      'ΡΟΧΑΛΑ',
      'ΑΝΚΟΡΑ',
      'ΡΟΚΑΝΑ',
      'ΑΝΑΚΛΑ',
      'ΠΡΟΧΟΛ',
      'ΠΟΜΟΝΑ',
      'ΠΑΡΟΛΟ',
      'ΜΑΡΚΑ',
      'ΧΑΡΜΑ',
      'ΚΑΠΝΑ',
      'ΚΛΑΜΑ',
      'ΧΑΜΟΝ',
      'ΚΡΑΜΑ',
      'ΑΛΑΝΑ',
      'ΑΚΡΟΝ',
      'ΑΝΚΟΡ',
      'ΚΟΡΝΟ',
      'ΚΡΑΝΑ',
      'ΚΛΟΜΠ',
      'ΚΟΛΟΝ',
      'ΡΟΜΠΑ',
      'ΡΟΜΑΝ',
      'ΜΠΑΚΑ',
      'ΜΠΑΛΑ',
      'ΚΟΛΠΟ',
      'ΚΡΑΝΟ',
      'ΚΛΑΜΠ',
      'ΚΑΡΜΑ',
      'ΜΠΑΡΑ',
      'ΑΝΑΜΑ',
      'ΛΟΜΠΑ',
      'ΚΟΑΛΑ',
      'ΡΑΜΠΟ',
      'ΜΠΛΟΚ',
      'ΑΜΑΡΑ',
      'ΡΑΜΠΑ',
      'ΚΑΛΜΑ',
      'ΚΛΑΡΑ',
      'ΜΠΟΡΑ',
      'ΜΠΟΧΑ',
      'ΚΛΑΠΑ',
      'ΠΡΟΜΟ',
      'ΠΡΟΚΑ',
      'ΛΑΜΠΑ',
      'ΝΟΡΜΑ',
      'ΚΟΡΑΛ',
      'ΠΡΑΜΑ',
      'ΑΜΑΚΑ',
      'ΟΜΠΡΑ',
      'ΟΝΟΜΑ',
      'ΚΟΛΑΝ',
      'ΑΛΑΡΜ',
      'ΠΟΛΚΑ',
      'ΟΡΑΜΑ',
      'ΠΛΑΝΟ',
      'ΟΡΛΟΝ',
      'ΠΛΑΚΑ',
      'ΠΑΡΟΝ',
      'ΜΑΡΚΟ',
      'ΠΑΛΚΟ',
      'ΚΟΡΝΑ',
      'ΜΑΡΟΝ',
      'ΠΑΡΛΑ',
      'ΠΑΡΚΟ',
      'ΜΠΡΑΚ',
      'ΠΑΡΑ',
      'ΠΑΝΟ',
      'ΠΑΝΚ',
      'ΠΑΝΑ',
      'ΠΑΛΑ',
      'ΚΑΜΠ',
      'ΠΑΚΟ',
      'ΟΡΚΑ',
      'ΚΑΜΑ',
      'ΠΟΚΑ',
      'ΚΡΑΧ',
      'ΠΟΛΟ',
      'ΟΠΑΚ',
      'ΚΑΝΟ',
      'ΚΑΛΟ',
      'ΝΑΠΑ',
      'ΝΑΜΑ',
      'ΜΠΟΡ',
      'ΜΠΟΛ',
      'ΜΠΟΑ',
      'ΚΟΛΑ',
      'ΜΠΑΡ',
      'ΚΑΛΑ',
      'ΡΟΚΑ',
      'ΜΠΑΝ',
      'ΡΟΛΟ',
      'ΑΧΝΑ',
      'ΜΠΑΚ',
      'ΚΑΠΑ',
      'ΜΟΡΑ',
      'ΜΟΝΟ',
      'ΜΟΛΑ',
      'ΜΟΚΟ',
      'ΧΑΜΠ',
      'ΧΑΡΑ',
      'ΜΟΚΑ',
      'ΚΑΠΟ',
      'ΜΑΡΑ',
      'ΜΑΠΑ',
      'ΧΟΜΟ',
      'ΑΡΠΑ',
      'ΑΚΡΑ',
      'ΑΚΡΟ',
      'ΜΑΝΟ',
      'ΜΑΝΑ',
      'ΑΡΟΝ',
      'ΜΑΛΑ',
      'ΜΑΚΟ',
      'ΑΛΜΑ',
      'ΜΑΚΑ',
      'ΑΡΜΑ',
      'ΛΑΠΑ',
      'ΑΜΑΝ',
      'ΛΑΜΑ',
      'ΑΜΟΚ',
      'ΑΡΑΚ',
      'ΑΠΛΑ',
      'ΛΑΚΑ',
      'ΚΑΡΑ',
      'ΚΟΡΑ',
      'ΚΑΡΟ',
      'ΚΟΜΟ',
      'ΑΠΑΝ',
      'ΟΠΛΟ',
      'ΑΠΟ',
      'ΑΡΑ',
      'ΡΑΠ',
      'ΑΡΜ',
      'ΑΜΑ',
      'ΑΛΑ',
      'ΧΟΠ',
      'ΧΟΛ',
      'ΡΟΜ',
      'ΡΟΚ',
      'ΡΑΜ',
      'ΠΡΟ',
      'ΠΟΑ',
      'ΠΑΝ',
      'ΠΑΛ',
      'ΟΠΑ',
      'ΚΑΝ',
      'ΟΛΟ',
      'ΟΚΑ',
      'ΜΠΑ',
      'ΜΟΛ',
      'ΜΝΑ',
      'ΜΑΧ',
      'ΛΑΚ',
      'ΚΡΑ',
      'ΑΝΑ',
    ];
    final letters = [
      'Ο',
      'Μ',
      'Π',
      'Α',
      'Κ',
      'Ρ',
      'Α',
      'Λ',
      'Ν',
      'Ο',
      'Α',
      'Χ',
    ];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel10Option2() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΨΥΧΟΒΙΟΛΟΓΙΑ', [
      60,
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
      71,
    ]);
    tracker.addPlacement('ΒΙΟΨΥΧΟΛΟΓΙΑ', [
      2,
      14,
      26,
      38,
      50,
      62,
      74,
      86,
      98,
      110,
      122,
      134,
    ]);
    tracker.addPlacement('ΟΛΙΓΟΨΥΧΙΑ', [
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
    ]);
    tracker.addPlacement('ΛΙΓΟΨΥΧΙΑ', [86, 87, 88, 89, 90, 91, 92, 93, 94]);
    tracker.addPlacement('ΨΥΧΟΛΟΓΙΑ', [38, 39, 40, 41, 42, 43, 44, 45, 46]);
    tracker.addPlacement('ΒΙΟΛΟΓΙΑ', [121, 122, 123, 124, 125, 126, 127, 128]);
    tracker.addPlacement('ΓΟΥΛΙ', [88, 100, 112, 124, 136]);
    tracker.addPlacement('ΑΛΟΓΟ', [94, 106, 118, 130, 142]);
    tracker.addPlacement('ΓΟΒΑ', [0, 12, 24, 36]);
    tracker.addPlacement('ΛΟΥ', [117, 118, 119]);
    tracker.addPlacement('ΑΟΥ', [141, 142, 143]);
    tracker.addPlacement('ΒΙΑ', [115, 127, 139]);
    tracker.addPlacement('ΟΛΟ', [96, 97, 98]);
    tracker.addPlacement('ΧΟΛ', [84, 96, 108]);

    tracker.commonPositions.addAll([
      62,
      14,
      38,
      86,
      98,
      122,
      12,
      88,
      94,
      124,
      127,
      118,
      142,
      96,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΨΥΧΟΒΙΟΛΟΓΙΑ',
      'ΒΙΟΨΥΧΟΛΟΓΙΑ',
      'ΟΛΙΓΟΨΥΧΙΑ',
      'ΛΙΓΟΨΥΧΙΑ',
      'ΨΥΧΟΛΟΓΙΑ',
      'ΒΙΟΛΟΓΙΑ',
      'ΓΙΟΥΛΙΑ',
      'ΙΟΛΟΓΙΑ',
      'ΨΙΧΟΥΛΟ',
      'ΒΛΟΓΙΑ',
      'ΓΙΟΥΧΑ',
      'ΓΟΥΛΙΑ',
      'ΛΟΥΒΙΑ',
      'ΒΙΟΨΙΑ',
      'ΒΟΥΑΛ',
      'ΒΟΥΛΑ',
      'ΓΛΟΙΑ',
      'ΓΟΥΒΑ',
      'ΓΟΥΛΙ',
      'ΓΥΑΛΙ',
      'ΛΟΒΙΟ',
      'ΛΟΓΙΑ',
      'ΛΟΧΙΑ',
      'ΛΥΓΙΑ',
      'ΟΒΟΛΟ',
      'ΟΥΓΙΑ',
      'ΧΟΥΛΑ',
      'ΨΙΧΙΟ',
      'ΑΛΟΓΟ',
      'ΒΙΓΛΑ',
      'ΒΙΟΛΑ',
      'ΒΙΟΛΙ',
      'ΛΙΓΟ',
      'ΓΟΒΑ',
      'ΟΥΑΙ',
      'ΒΟΛΙ',
      'ΟΥΛΑ',
      'ΟΥΛΟ',
      'ΟΥΧΙ',
      'ΟΧΙΑ',
      'ΟΧΟΥ',
      'ΧΑΛΙ',
      'ΑΥΓΟ',
      'ΧΟΥΙ',
      'ΨΙΛΑ',
      'ΨΙΧΑ',
      'ΓΑΛΙ',
      'ΑΨΟΥ',
      'ΟΒΑΛ',
      'ΒΙΛΑ',
      'ΑΧΟΥ',
      'ΛΑΙΒ',
      'ΒΟΛΑ',
      'ΑΛΙ',
      'ΛΟΥ',
      'ΑΟΥ',
      'ΧΟΛ',
      'ΓΑΒ',
      'ΓΟΥ',
      'ΒΑΙ',
      'ΒΑΧ',
      'ΒΙΑ',
      'ΒΟΥ',
      'ΧΟΥ',
      'ΧΑΙ',
      'ΟΧΙ',
      'ΓΙΑ',
      'ΟΛΟ',
    ];
    final letters = [
      'Λ',
      'Ι',
      'Β',
      'Ο',
      'Ο',
      'Γ',
      'Υ',
      'Α',
      'Χ',
      'Ι',
      'Ο',
      'Ψ',
    ];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }

  static CurrentStage _backupLevel10Option3() {
    final tracker = WordPlacementTracker();

    tracker.addPlacement('ΧΑΡΤΟΠΑΙΓΝΙΟ', [
      60,
      61,
      62,
      63,
      64,
      65,
      66,
      67,
      68,
      69,
      70,
      71,
    ]);
    tracker.addPlacement('ΠΑΙΓΝΙΟΧΑΡΤΟ', [
      7,
      19,
      31,
      43,
      55,
      67,
      79,
      91,
      103,
      115,
      127,
      139,
    ]);
    tracker.addPlacement('ΧΑΡΤΟΠΟΙΙΑ', [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
    tracker.addPlacement('ΠΑΙΧΤΡΟΝΙ', [
      110,
      111,
      112,
      113,
      114,
      115,
      116,
      117,
      118,
    ]);
    tracker.addPlacement('ΑΡΤΟΠΟΙΙΑ', [28, 40, 52, 64, 76, 88, 100, 112, 124]);
    tracker.addPlacement('ΑΓΧΙΝΟΙΑ', [28, 29, 30, 31, 32, 33, 34, 35]);
    tracker.addPlacement('ΟΧΤΑΡΙΑ', [25, 37, 49, 61, 73, 85, 97]);
    tracker.addPlacement('ΠΡΟΓΟΝΙ', [137, 138, 139, 140, 141, 142, 143]);
    tracker.addPlacement('ΓΙΝΑΤΙ', [58, 70, 82, 94, 106, 118]);
    tracker.addPlacement('ΝΙΤΡΟ', [84, 85, 86, 87, 88]);
    tracker.addPlacement('ΟΧΤΙΑ', [90, 91, 92, 93, 94]);
    tracker.addPlacement('ΠΡΟ', [110, 122, 134]);
    tracker.addPlacement('ΠΟΤ', [133, 134, 135]);
    tracker.addPlacement('ΠΟΑ', [24, 25, 26]);

    tracker.commonPositions.addAll([
      61,
      64,
      67,
      70,
      7,
      31,
      91,
      115,
      139,
      110,
      112,
      118,
      28,
      88,
      25,
      85,
      94,
      134,
    ]);

    final board = List.generate(144, (_) => '');
    tracker.placePositions(board);

    final allWords = [
      'ΧΑΡΤΟΠΑΙΓΝΙΟ',
      'ΠΑΙΓΝΙΟΧΑΡΤΟ',
      'ΧΑΡΤΟΠΟΙΙΑ',
      'ΠΑΙΧΤΡΟΝΙ',
      'ΑΡΤΟΠΟΙΙΑ',
      'ΑΓΧΙΝΟΙΑ',
      'ΤΟΠΑΡΧΙΑ',
      'ΑΡΧΟΝΤΙΑ',
      'ΟΧΤΑΡΙΑ',
      'ΟΡΙΓΑΝΟ',
      'ΠΙΝΙΑΤΑ',
      'ΠΟΡΤΟΝΙ',
      'ΠΡΟΓΟΝΙ',
      'ΠΡΟΝΟΙΑ',
      'ΓΡΑΝΙΤΑ',
      'ΓΟΝΑΤΙΑ',
      'ΤΡΙΑΙΝΑ',
      'ΠΑΙΓΝΙΟ',
      'ΤΡΟΠΑΙΟ',
      'ΧΑΓΙΑΤΙ',
      'ΧΑΡΤΟΝΙ',
      'ΑΝΟΙΧΤΑ',
      'ΑΓΟΡΙΝΑ',
      'ΑΓΡΟΤΙΑ',
      'ΑΡΙΑΝΙ',
      'ΤΑΙΝΙΑ',
      'ΠΙΟΝΙΟ',
      'ΠΙΡΟΓΑ',
      'ΝΤΑΠΙΑ',
      'ΤΑΧΙΝΙ',
      'ΠΑΓΟΝΙ',
      'ΠΑΤΡΟΝ',
      'ΠΡΙΟΝΙ',
      'ΝΑΤΡΙΟ',
      'ΓΡΙΝΙΑ',
      'ΡΑΠΑΝΙ',
      'ΡΑΧΑΤΙ',
      'ΓΟΝΑΤΟ',
      'ΠΑΡΟΤΙ',
      'ΤΑΓΑΡΙ',
      'ΑΙΠΑΝΤ',
      'ΓΙΝΑΤΙ',
      'ΓΙΑΧΝΙ',
      'ΓΑΤΟΝΙ',
      'ΑΧΤΙΝΑ',
      'ΑΧΝΑΡΙ',
      'ΤΟΙΧΙΟ',
      'ΑΤΟΠΙΑ',
      'ΑΤΟΝΙΑ',
      'ΠΑΓΑΝΟ',
      'ΠΑΤΑΡΙ',
      'ΠΑΤΙΝΑ',
      'ΠΑΤΙΝΙ',
      'ΤΡΙΧΙΑ',
      'ΟΠΟΤΑΝ',
      'ΤΡΟΧΙΑ',
      'ΑΙΠΟΝΤ',
      'ΑΠΟΡΙΑ',
      'ΧΑΝΤΡΑ',
      'ΑΠΟΝΙΑ',
      'ΑΠΝΟΙΑ',
      'ΧΑΡΤΙΑ',
      'ΧΑΤΙΡΙ',
      'ΧΙΝΑΡΙ',
      'ΧΙΟΝΙΑ',
      'ΧΡΟΝΙΑ',
      'ΑΓΝΟΙΑ',
      'ΑΓΟΝΙΑ',
      'ΑΓΡΙΝΟ',
      'ΟΡΓΑΝΟ',
      'ΠΑΤΡΙΑ',
      'ΡΙΠΙΤ',
      'ΠΟΡΤΟ',
      'ΠΙΟΤΙ',
      'ΓΙΑΤΙ',
      'ΤΑΠΙΑ',
      'ΓΙΑΠΙ',
      'ΝΙΤΡΟ',
      'ΓΑΝΤΙ',
      'ΠΙΟΤΟ',
      'ΤΑΧΙΑ',
      'ΠΑΡΤΑ',
      'ΤΙΑΡΑ',
      'ΝΙΑΤΑ',
      'ΠΡΙΟΝ',
      'ΑΤΡΙΟ',
      'ΑΤΟΠΟ',
      'ΠΑΡΤΙ',
      'ΟΠΑΙΟ',
      'ΤΟΠΙΟ',
      'ΝΤΟΠΑ',
      'ΤΡΑΓΙ',
      'ΠΑΝΤΑ',
      'ΟΡΝΙΟ',
      'ΠΡΟΤΟ',
      'ΑΡΤΙΟ',
      'ΝΑΓΙΑ',
      'ΤΡΙΧΑ',
      'ΙΝΑΤΙ',
      'ΙΑΤΑΙ',
      'ΡΑΝΤΑ',
      'ΝΤΑΡΑ',
      'ΑΡΓΙΑ',
      'ΠΙΟΝΙ',
      'ΡΑΤΑΝ',
      'ΠΟΙΝΤ',
      'ΓΡΑΠΑ',
      'ΧΑΡΙΝ',
      'ΧΑΡΤΑ',
      'ΧΑΡΤΙ',
      'ΠΑΡΟΝ',
      'ΠΑΧΝΙ',
      'ΟΡΓΙΑ',
      'ΡΙΝΤΟ',
      'ΟΧΤΙΑ',
      'ΧΙΟΝΙ',
      'ΡΙΧΤΙ',
      'ΑΝΤΡΟ',
      'ΧΝΑΡΙ',
      'ΧΝΟΤΟ',
      'ΑΝΤΙΟ',
      'ΠΟΡΤΑ',
      'ΧΟΡΤΑ',
      'ΧΟΡΤΟ',
      'ΧΡΟΙΑ',
      'ΓΡΑΙΑ',
      'ΠΙΑΝΟ',
      'ΑΓΑΝΟ',
      'ΑΝΟΙΑ',
      'ΠΟΙΟΝ',
      'ΡΟΝΤΟ',
      'ΑΓΟΡΑ',
      'ΑΓΟΡΙ',
      'ΠΙΑΤΟ',
      'ΑΙΤΙΟ',
      'ΝΟΤΙΑ',
      'ΠΟΝΤΑ',
      'ΠΙΝΤΑ',
      'ΑΙΤΙΑ',
      'ΤΑΙΡΙ',
      'ΝΙΑΤΟ',
      'ΧΟΡΙΟ',
      'ΤΟΠΙ',
      'ΑΝΙΑ',
      'ΑΓΑΡ',
      'ΑΓΑΝ',
      'ΑΝΤΑ',
      'ΑΝΤΙ',
      'ΑΠΑΝ',
      'ΧΑΡΑ',
      'ΧΑΠΙ',
      'ΧΑΝΙ',
      'ΑΡΓΑ',
      'ΑΡΓΟ',
      'ΑΡΙΑ',
      'ΤΡΙΠ',
      'ΑΡΝΙ',
      'ΑΡΟΝ',
      'ΑΡΠΑ',
      'ΑΡΤΙ',
      'ΤΡΙΟ',
      'ΤΡΙΑ',
      'ΤΡΑΠ',
      'ΠΑΝΑ',
      'ΑΧΝΑ',
      'ΑΓΡΑ',
      'ΑΧΡΙ',
      'ΑΧΤΙ',
      'ΤΑΧΑ',
      'ΓΑΙΑ',
      'ΓΑΝΑ',
      'ΤΑΡΟ',
      'ΓΑΤΑ',
      'ΓΑΤΙ',
      'ΤΑΡΑ',
      'ΤΑΠΙ',
      'ΤΑΠΑ',
      'ΓΙΟΤ',
      'ΓΟΝΑ',
      'ΡΟΤΑ',
      'ΡΟΓΙ',
      'ΓΟΠΑ',
      'ΡΟΓΑ',
      'ΡΙΝΑ',
      'ΡΙΓΑ',
      'ΠΑΝΙ',
      'ΡΑΝΤ',
      'ΡΑΙΧ',
      'ΙΝΙΟ',
      'ΑΙΓΑ',
      'ΙΤΙΑ',
      'ΡΑΓΑ',
      'ΝΑΠΑ',
      'ΠΡΙΝ',
      'ΠΟΤΟ',
      'ΝΟΤΑ',
      'ΠΟΝΙ',
      'ΠΙΧΙ',
      'ΝΤΙΠ',
      'ΠΙΤΑ',
      'ΟΠΙΟ',
      'ΠΙΝΑ',
      'ΟΡΙΟ',
      'ΠΑΡΑ',
      'ΟΤΑΝ',
      'ΟΧΙΑ',
      'ΠΑΝΟ',
      'ΓΡΙΑ',
      'ΤΙΠ',
      'ΑΠΟ',
      'ΓΙΝ',
      'ΝΑΙ',
      'ΤΑΟ',
      'ΠΡΟ',
      'ΧΙΤ',
      'ΑΝΑ',
      'ΠΟΤ',
      'ΑΡΑ',
      'ΑΤΑ',
      'ΝΤΑ',
      'ΠΟΑ',
      'ΑΤΙ',
      'ΤΟΡ',
      'ΝΤΟ',
      'ΓΑΡ',
      'ΟΠΑ',
      'ΠΙΟ',
      'ΧΟΠ',
      'ΓΡΙ',
      'ΠΙΝ',
      'ΠΙΑ',
      'ΠΑΤ',
      'ΤΟΠ',
      'ΡΑΠ',
      'ΤΟΝ',
      'ΟΤΙ',
      'ΟΧΙ',
      'ΙΝΑ',
      'ΓΙΑ',
      'ΤΑΡ',
      'ΧΑΙ',
      'ΠΑΝ',
      'ΙΟΝ',
    ];
    final letters = [
      'Ι',
      'Α',
      'Ο',
      'Α',
      'Ο',
      'Ρ',
      'Χ',
      'Τ',
      'Ν',
      'Γ',
      'Π',
      'Ι',
    ];

    final backupStage = CurrentStage(
      allWords: allWords,
      letters: letters,
      board: board,
      placementTracker: tracker,
    );

    return backupStage;
  }
}

class_name Language
extends Resource

static var _vowels = ['a', 'e', 'i', 'o', 'u']
static var _primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]
static var _fibbonacci = [1, 1, 2, 3, 5, 8, 13, 21, 34]

static func is_vowel(letter: String):
    assert(letter.length() == 1, "Letter must be a single character")
    return _vowels.has(letter)

static func is_consonant(letter: String):
    return !is_vowel(letter)

## An example harmonic sequence: (a, a, b, c, e, h ...)
static func fibonacci_harmony(sequence: Array[int]) -> int:
    if sequence.size() < 2:
        return 0
    
    var fibonacciHarmony := 0

    var baseCardinal = sequence[0]

    for ordinal in range(1, sequence.size()):
        var cardinal = sequence[ordinal]
        var harmonicCardinal = _fibbonacci[ordinal] - 1 # Account for fibbonacci starting at 1
        var currentCardinal = cardinal - baseCardinal

        if currentCardinal != harmonicCardinal:
            # Broken harmony
            fibonacciHarmony /= 2
            break

        # Inceasing harmony
        fibonacciHarmony += _fibbonacci[ordinal]
    
    if fibonacciHarmony == 0:
        return 1

    return fibonacciHarmony

## An example harmonic sequence: (a, c, e, g, ...)
static func cardinal_harmony(sequence: Array[int]) -> int:
    if sequence.size() < 2:
        return 0

    var cardinalHarmony := 0
    
    var baseCardinal = sequence[0]
    var secondCardinal = sequence[1]
    var harmonicCadence = abs(secondCardinal - baseCardinal)

    var prevCardinal = baseCardinal
    for ordinal in range(1, sequence.size()):
        var cardinal = sequence[ordinal]
        var currentCadence = abs(cardinal - prevCardinal)

        if currentCadence != harmonicCadence:
            # Broken harmony
            cardinalHarmony /= 2
            break
        
        prevCardinal = cardinal

        # Inceasing harmony
        cardinalHarmony += ordinal
    
    # 0 cadence is not harmonic
    cardinalHarmony *= harmonicCadence

    if cardinalHarmony == 0:
        return 1

    return cardinalHarmony

## An example primal sequence: (c, e, c, c, g)
static func primal_harmony(sequence: Array[int]) -> int:
    if sequence.size() < 2:
        return 0

    var primalHarmony := 1

    for val in sequence:
        if val in _primes:
            primalHarmony += 1
    
    if sequence.size() in _primes:
        primalHarmony += 1

    if primalHarmony == sequence.size():
        primalHarmony *= 2
    
    if primalHarmony in _primes:
        primalHarmony *= _primes[primalHarmony]

    return primalHarmony

static func harmony(sequence: Array[int]) -> int:
    return cardinal_harmony(sequence) * primal_harmony(sequence)

class Word:

    var _w: String

    func _init(word: String=""):
        _w = word

    func append(letters: String):
        _w += letters

    func length():
        return _w.length()

    func compute_harmony() -> int:
        var ordinalValues: Array[int] = []
        for c in _w:
            ordinalValues.append(int(c))

        var harmony = Language.harmony(ordinalValues)

        if is_palindrome():
            harmony *= 2
        
        return harmony

    func is_valid() -> bool:
        if _w.length() < 3:
            return false
        
        return true

    func is_palindrome() -> bool:
        var i = 0
        var j = _w.length() - 1
        while i < j:
            if _w[i] != _w[j]:
                return false
            i += 1
            j -= 1
        return true

    func is_anagram(other: Word):
        var a = _w
        var b = other._w
        if a.length() != b.length():
            return false
        var a_chars = {}
        var b_chars = {}
        for i in range(a.length()):
            if a_chars.has(a[i]):
                a_chars[a[i]] += 1
            else:
                a_chars[a[i]] = 1
            if b_chars.has(b[i]):
                b_chars[b[i]] += 1
            else:
                b_chars[b[i]] = 1
        for key in a_chars.keys():
            if !b_chars.has(key) or b_chars[key] != a_chars[key]:
                return false
        return true

class Spell:
    var _words: Array[Word] = []

    func _init(words: Array[Word]=[]):
        _words = words

    func add_word(word: String):
        _words.append(Word.new(word))
    
    func compute_harmony():
        var score = 0
        for word in _words:
            score += word.compute_harmony()
        
        var ordinalValues: Array[int] = []

        var anagrams: Array[Word] = []
        
        for word in _words:
            ordinalValues.append(word.length())
            for other in _words:
                if word not in anagrams and word != other and word.is_anagram(other):
                    anagrams.append(word)
                    anagrams.append(other)

        score += Language.harmony(ordinalValues)

        if anagrams.size() > 0:
            score *= anagrams.size()

        return score
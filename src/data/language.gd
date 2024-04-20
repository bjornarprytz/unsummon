class_name Language
extends Resource

static var _alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"] # , "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
static var _vowels = ['a', 'e', 'i', 'o', 'u']
static var _primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]
static var _fibbonacci = [1, 1, 2, 3, 5, 8, 13, 21, 34]

static func random_letter() -> String:
	return _alphabet.pick_random()
	
static func is_letter(letter: String):
	return _alphabet.has(letter)

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
	var c = cardinal_harmony(sequence)
	var p = primal_harmony(sequence)
	var f = fibonacci_harmony(sequence)

	print("Cardinal Harmony: ", c)
	print("Primal Harmony: ", p)
	print("Fibonacci Harmony: ", f)
	return c * p * f

class Glyph:
	var _character: String
	var _baseUnicode: int

	func _init(character: String):
		assert(character.length() == 1, "Glyph must be a single character")
		_character = character.to_lower()
		_baseUnicode = Language._alphabet[0].unicode_at(0)
	
	func get_char() -> String:
		return _character

	func is_vowel():
		return Language.is_vowel(_character)
	
	func is_consonant():
		return Language.is_consonant(_character)
	
	func cardinal() -> int:
		return (_character.unicode_at(0) - _baseUnicode)

class Word:
	var _w: Array[Glyph] = []

	func _init(word: Array[Glyph]=[]):
		_w = word

	func append(letters: Array[Glyph]=[]):
		_w.append_array(letters)

	func pop_glyph() -> Glyph:
		return _w.pop_back()

	func length():
		return _w.size()
	
	func to_chars() -> String:
		var raw = ""
		for c in _w:
			raw += c._character
		return raw

	func compute_harmony() -> int:
		var cardinalValues: Array[int] = []
		for c in _w:
			cardinalValues.append(c.cardinal())

		var harmony = Language.harmony(cardinalValues)

		if is_palindrome():
			harmony *= 2
		
		return harmony

	func is_valid() -> bool:
		if _w.size() < 3:
			return false
		
		return true

	func is_palindrome() -> bool:
		var chars = self.to_chars()
		var i = 0
		var j = chars.length() - 1
		while i < j:
			if chars[i] != chars[j]:
				return false
			i += 1
			j -= 1
		return true

	func is_anagram(other: Word):
		var a = self.to_chars()
		var b = other.to_chars()
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

	func add_word(word: Word):
		_words.append(word)
	
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
	
	func is_valid() -> bool:
		if _words.size() < 2:
			return false
		
		return true

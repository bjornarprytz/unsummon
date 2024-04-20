# unsummon

You have, for whatever reason, summoned a demon from hell. When you realize your mistake, you frantically skim the necronomicon for the unsummon spell. The demon reads over your shoulder and does all he can to confuse your studying.

- The player sees a page of the Necronomicon, but the letters are all jumbled up and make no sense
- 

## Mechanics

- Move around on the page trying to collect glyphs to make up words. Words make up spells. Spells bind the demon to your will, giving you increasingly beneficial bargains

- Reading a glyph adds it to the current word

- Words
  - Length > 3
  - Binding Power:
    - Consonants in a row give extra power
    - Follow the rules of harmony in ordinal value (a=0, b=1, etc.)
    - Anagrams are multipliers
- Spells
  - A sequence of words
- Harmony:
  - The relation between each value in the sequence follows a structure:
    - Ordinal harmony (the sequence has a harmonic relation between ordinal and cardinal value)
    - Fibbonacci
    - Primal harmony (primes appear in the sequence)
- When you are ready, *utter* the words to cast the spell

- Bargains
  - Good:
    - 2x harmony
    - Add any letter to the current word
  - Chaotic:
    - Jumble glyphs (rotate 4 glyphs positions)
    - Turn the page
    - Randomize a word
    - Randomize the order of words in a spell
  - Bad:
    - Forget a word (of committed to memory)
    - Cut your longest word in half (keep any valid words)

## Design Questions

- How does the player end a word?
  - Press space, yields the turn
- How does the player discover the rules of harmony?
  - By uttering spells
- How does the demon play?
  - Turn the page
  - Move glyphs around
  - Set up bargains on some glyphs
- What effect does uttering a spell have?
  - Add Binding Power (score)
  - Trick the demon into beneficial bargains
- Could glyphs carry extra meaning?
  - Alchemical Elements
    - Imbue spells with effects beyond the binding power

## TODO

- Game Loop
  - Player moves around the glyphs on the page to form words
  - Once they hit space, the word is committed to memory, and its  glyphs are removed from the page. New glyphs will appear, like candy crush

- Glyph (letter)
  - Could have effects applied
    - shaking, colors, particles, etc.
  - Elemental number (For alchemical purposes)
  - Could change orientation
  - Mono space
- Grid of Glyphs
  - Glyphs can change position
  - Remove glyphs
- Rules of Harmony
  - Fibonacci
  - Cardinal
  - Primal
- Player
  - Spells (at least 3 words)
  - Words (at least 3 glyphs)
  - Known Rules of Harmony
- Controls
  - Type to move around the page, traversing glyphs
  - Space: Commit to memory the current word
  - Enter: Utter the current spell
  - Backspace: Undo one glyph

- Push release with `./push_release.sh`

### Extra

- itch.io
  - Rename the game
  - Write a short description
  - Make a nice cover image (630x500)
  - Add screenshots (recommended: 3-5)
  - Pick a genre
  - Add a tag or two
  - Publish a devlog on instagram

### Meta

- Figure out how to develop for mobile
  - How to use the on-screen keyboard

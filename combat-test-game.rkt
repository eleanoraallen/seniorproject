#lang racket
(require "combat.rkt")
(require "characters.rkt")
(require "spells.rkt")
(require "items.rkt")
(require "dungeons.rkt")
(require 2htdp/image)
(require 2htdp/universe)

;; ------------------------------------------------------------------------------------------------------
;; game

;; a game is one of:
;; - combat
;; - image (splash screen/end screen)
;; - string (character select)

;; ------------------------------------------------------------------------------------------------------
;; functions

;; render: game --> image
;; renders the combat as an image
(define (render w)
  (cond
    [(image? w) w]
    [(string? w) (overlay (above
                           (text "Choose your fighter!" 50 'black)
                           (text "1) Knight" 40 'black)
                           (text "2) Mage" 40 'black)
                           (text "3) Spellsword" 40 'black))
                          (rectangle 810 630 'solid 'gray))]
    [(combat? w) (render-combat w)]
    [(dungeon? w) (render-dungeon w)]))

;; tock: game --> game
(define (tock w) 
  (cond
    [(or (image? w) (string? w)) w]
    [(combat? w) (combat-tock w)]
    [(dungeon? w) (dungeon-tock w)]))

;; handle-key : game --> game
(define (handle-key w k)
  (cond
    [(image? w)
     (if (or
          (key=? k "escape")
          (key=? k "\r"))
         "string"
         w)]
    [(string? w)
     (cond
       [(key=? k "1") (make-combat KNIGHT NPC 'p 'm empty)]
       [(key=? k "2") (make-combat MAGE NPC 'p 'm empty)]
       [(key=? k "3") (make-combat SPELLSWORD NPC 'p 'm empty)]
       [else w])]
    [(combat? w) (handle-combat-key w k)]
    [(dungeon? w) (handle-dungeon-key w k)]))

;; main
(define (main w)
  (big-bang w
            [to-draw render]
            [on-tick tock]
            [on-key handle-key]))

;; -----------------------------------------------------------------------------------
;; run
(main TESTDUNGEON1)

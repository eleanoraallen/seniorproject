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

;; ------------------------------------------------------------------------------------------------------
;; functions

;; render: game --> image
;; renders the combat as an image
(define (render w)
  (cond
    [(image? w) w]
    [(combat? w) (render-combat w)]
    [(dungeon? w) (render-dungeon w)]))

;; tock: game --> game
(define (tock w) 
  (cond
    [(or (image? w)) w]
    [(combat? w) (combat-tock w)]
    [(dungeon? w) (dungeon-tock w)]))

;; combat-tock : combat --> combat
(define (combat-tock w)
  (cond
    [(not (empty? (combat-loi w))) (make-combat (combat-player w) (combat-npc w) (combat-phase w) 'e (rest (combat-loi w)))]
    [(send (combat-player w) dead?) (overlay (above (text "'Damn it, how will I ever get out of this labyrinth?'" 20 'black) (text "Press Enter to replay" 20 'black)) (rectangle 810 630 'solid 'gray))]
    [(send (combat-npc w) dead?) (make-dungeon (combat-player w) (list TESTROOM1) (make-list 20 (overlay
                                                                                                 (text "You defeated your foe!" 20 'black)
                                                                                                 (rectangle 220 40 'outline 'black)
                                                                                                 (rectangle 220 40 'solid 'gray))))]
    [(symbol=? (combat-phase w) 'e) (npc-action w)]
    [(and (symbol=? (combat-phase w) 'ea) (empty? (combat-loi w))) (make-combat (combat-player w) (combat-npc w) 'p 'm empty)]
    [(and (symbol=? (combat-phase w) 'pa) (empty? (combat-loi w))) (make-combat (combat-player w) (combat-npc w) 'e 'e empty)]
    [(and (symbol=? (combat-phase w) 'ps) (empty? (combat-loi w))) (make-combat (combat-player w) (combat-npc w) 'e 'e empty)]
    [else w]))

;; handle-key : game --> game
(define (handle-key w k)
  (cond
    [(image? w)
     (if (or (key=? k "escape")
          (key=? k "\r")) TESTDUNGEON1 w)]
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
(main (overlay (above (text "The General's Labyrinth" 50 'black) (text "Press Enter to play" 30 'black)) (rectangle 810 630 'solid 'gray)))

#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require "combat.rkt")
(require "characters.rkt")
(require "spells.rkt")
(require "items.rkt")
(require "dungeons.rkt")
(require "music.rkt")
(provide (struct-out create)
         (all-defined-out))

#|
1) welcome
2) name
3) gender
4) bs1
5) bs2
6) bs3


Parents:
1 Farmers: +1 strength, +1 health
2 Mercenaries: +2 strength 
3 Poachers: +1 agility, +1 strength
4 Thieves: + 2 agility

Early Life:
1 School: +2 MP
2 Training: +2 strength
3 Shop Assistant: +2 health
4 Wandering the Countryside: +2 agility

Reason For Adventuring:
1 Money & Power: +2 strength
2 Search For Knowledge: +2 MP
3 Revenge: +2 health
4 Thirst for Adventure: +2 agility
|#
;; a create is a (make-create int string symbol int int int)
(define-struct create (step name gender decision1 decision2 decision3))
(define STARTINGCREATE (make-create 1 "" 'm 0 0 0))

;;;;;;;;;;;;;;;;;;;;
(define WELCOME (overlay (text "You will now create your character and select their backstory." 20 'black)
                         (rectangle 810 630 'solid 'gray)))

(define GENDER (overlay (above
                         (text "Choose your character's gender:" 20 'black)
                         (text "" 20 'black)
                         (text "1) Male" 20 'black)
                         (text "2) Female" 20 'black)) (rectangle 810 630 'solid 'gray)))

(define BS1 (overlay (above (text "Your parents were:" 20 'black)
                            (text "" 20 'black)
                            (text "1) Humble Farmers" 20 'black)
                            (text "2) Fearsome Mercenaries" 20 'black)
                            (text "3) Clever Poachers" 20 'black)
                            (text "4) Notorious Thieves" 20 'black)) (rectangle 810 630 'solid 'gray)))

(define BS1a (overlay (text "Your parents were humble farmers who taught you the value of hard work and percerverence." 12 'black) (rectangle 810 630 'solid 'gray)))
(define BS1b (overlay (text "Your parents were fearsome mercenaries who taught you to fight at an early age." 12 'black) (rectangle 810 630 'solid 'gray)))
(define BS1c (overlay (text "Your parents were clever poachers who taught you the ways of the forest" 12 'black) (rectangle 810 630 'solid 'gray)))
(define BS1d (overlay (text "Your parents were notorious theives who taught you stealth and cunning." 12 'black) (rectangle 810 630 'solid 'gray)))

(define BS2 (overlay (above (text "You spent adolecence:" 20 'black)
                            (text "" 20 'black)
                            (text "1) As a student at the local temple" 20 'black)
                            (text "2) Training with various exotic weapons" 20 'black)
                            (text "3) Working as a storekeeper" 20 'black)
                            (text "4) Wandering the countryside" 20 'black)) (rectangle 810 630 'solid 'gray)))

(define BS2a (overlay (text "You spent your adolecence as a student learning ancient and arcane magics from the priests and nuns of the temple." 12 'black) (rectangle 810 630 'solid 'gray)))
(define BS2b (overlay (text "You spent your adolecence training, eventuly surpassing your teacher to become the best figher in your village." 12 'black) (rectangle 810 630 'solid 'gray)))
(define BS2c (overlay (text "You spent your adolecence working in a store, expanding your practical knowledge and saving up some money." 12 'black) (rectangle 810 630 'solid 'gray)))
(define BS2d (overlay (text "You spent your adolecence wandering the country, gaining an apreciation for adventuring and learning how to survive on your own." 12 'black) (rectangle 810 630 'solid 'gray)))

(define BS3 (overlay (above (text "Why did you set out on this adventure?:" 20 'black)
                            (text "" 20 'black)
                            (text "1) Money and power" 20 'black)
                            (text "2) A quest for knowledge" 20 'black)
                            (text "3) Revenge!" 20 'black)
                            (text "4) A thirst for adventure" 20 'black)) (rectangle 810 630 'solid 'gray)))

(define BS3a (overlay (text "You care for nothing but money and power, and went adventuring in the hope of obtaining both." 12 'black) (rectangle 810 630 'solid 'gray)))
(define BS3b (overlay (text "Yours is a quest for knowledge. Hopefuly to uncover some lost and ancient wisdom during your wanderings." 12 'black) (rectangle 810 630 'solid 'gray)))
(define BS3c (overlay (text "You're not willing to say much now, but there's someone you need to track down and you can't do that in your village." 12 'black) (rectangle 810 630 'solid 'gray)))
(define BS3d (overlay (text "All your life you've wanted to go out and see the world and have a grand adventure. This is your chance." 12 'black) (rectangle 810 630 'solid 'gray)))

;; render-create: create --> image
(define (render-create c)
  (cond
    [(= (create-step c) 1) WELCOME]
    [(= (create-step c) 2) (overlay (above (text "Enter Name:" 20 'black)
                                           (text (create-name c) 20 'black))
                                    (rectangle 810 630 'solid 'gray))]
    [(= (create-step c) 3) GENDER]
    [(= (create-step c) 4) (cond
                             [(= (create-decision1 c) 0) BS1]
                             [(= (create-decision1 c) 1) BS1a]
                             [(= (create-decision1 c) 2) BS1b]
                             [(= (create-decision1 c) 3) BS1c]
                             [(= (create-decision1 c) 4) BS1d])]
    [(= (create-step c) 5) (cond
                             [(= (create-decision2 c) 0) BS2]
                             [(= (create-decision2 c) 1) BS2a]
                             [(= (create-decision2 c) 2) BS2b]
                             [(= (create-decision2 c) 3) BS2c]
                             [(= (create-decision2 c) 4) BS2d])]
    [(= (create-step c) 6) (cond
                             [(= (create-decision3 c) 0) BS3]
                             [(= (create-decision3 c) 1) BS3a]
                             [(= (create-decision3 c) 2) BS3b]
                             [(= (create-decision3 c) 3) BS3c]
                             [(= (create-decision3 c) 4) BS3d])]))

;; handle-create-key
(define (handle-create-key c k)
  (cond
    [(= (create-step c) 1) (make-create 2 (create-name c) (create-gender c)
                                        (create-decision1 c) (create-decision2 c)
                                        (create-decision3 c))]
    [(= (create-step c) 2) (cond
                             [(key=? k "\r") (make-create 3 (create-name c) (create-gender c)
                                        (create-decision1 c) (create-decision2 c)
                                        (create-decision3 c))]
                             [(and (> (string-length (create-name c)) 0) (key=? k "\b"))
                              (make-create 2 (substring (create-name c) 0 (- (string-length (create-name c)) 1)) (create-gender c)
                                        (create-decision1 c) (create-decision2 c)
                                        (create-decision3 c))]
                             [(and (not (key=? k "shift"))
                                   (not (key=? k "rshift"))
                                   (not (key=? k "escape"))
                                   (not (key=? k "control"))
                                   (<= (string-length (create-name c)) 12))
                              (make-create 2 (string-append (create-name c) k) (create-gender c)
                                        (create-decision1 c) (create-decision2 c)
                                        (create-decision3 c))]
                             [else c])]                   
    [(= (create-step c) 3) (cond
                             [(key=? k "1") (make-create 4 (create-name c) 'm
                                        (create-decision1 c) (create-decision2 c)
                                        (create-decision3 c))]
                             [(key=? k "2") (make-create 4 (create-name c) 'f
                                        (create-decision1 c) (create-decision2 c)
                                        (create-decision3 c))]
                             [else c])]
    [(= (create-step c) 4) (cond
                             [(and (key=? k "\r") (> (create-decision1 c) 0))
                              (make-create 5 (create-name c) (create-decision1 c)
                                        (create-decision1 c) (create-decision2 c)
                                        (create-decision3 c))]
                             [(key=? k "1") (make-create 4 (create-name c) (create-gender c)
                                        1 (create-decision2 c)
                                        (create-decision3 c))]
                             [(key=? k "2") (make-create 4 (create-name c) (create-gender c)
                                        2 (create-decision2 c)
                                        (create-decision3 c))]
                             [(key=? k "3") (make-create 4 (create-name c) (create-gender c)
                                        3 (create-decision2 c)
                                        (create-decision3 c))]
                             [(key=? k "4") (make-create 4 (create-name c) (create-gender c)
                                        4 (create-decision2 c)
                                        (create-decision3 c))]
                             [else c])]
    [(= (create-step c) 5) (cond
                             [(and (key=? k "\r") (> (create-decision2 c) 0))
                              (make-create 6 (create-name c) (create-decision1 c)
                                        (create-decision1 c) (create-decision2 c)
                                        (create-decision3 c))]
                             [(key=? k "1") (make-create 5 (create-name c) (create-gender c)
                                        (create-decision1 c) 1
                                        (create-decision3 c))]
                             [(key=? k "2") (make-create 5 (create-name c) (create-gender c)
                                        (create-decision1 c) 2
                                        (create-decision3 c))]
                             [(key=? k "3") (make-create 5 (create-name c) (create-gender c)
                                        (create-decision1 c) 3
                                        (create-decision3 c))]
                             [(key=? k "4") (make-create 5 (create-name c) (create-gender c)
                                        (create-decision1 c) 4
                                        (create-decision3 c))]
                             [else c])]
    [(= (create-step c) 6) (cond
                             [(and (key=? k "\r") (> (create-decision2 c) 0))
                              (superset dungeon-music)
                              (make-dungeon (send SPELLSWORD clone
                                                  #:name (create-name c)
                                                  #:health (+ 40
                                                              (if (= (create-decision1 c) 1) 10 0)
                                                              (if (= (create-decision2 c) 3) 20 0)
                                                              (if (= (create-decision3 c) 3) 20 0))
                                                  #:max-health (+ 40
                                                              (if (= (create-decision1 c) 1) 10 0)
                                                              (if (= (create-decision2 c) 3) 20 0)
                                                              (if (= (create-decision3 c) 3) 20 0))
                                                  #:base-agility (+ 4 
                                                                    (if (= (create-decision1 c) 4) 2 0)
                                                                    (if (= (create-decision2 c) 4) 2 0)
                                                                    (if (= (create-decision2 c) 4) 2 0))
                                                  #:agility (+ 4 
                                                                    (if (= (create-decision1 c) 4) 2 0)
                                                                    (if (= (create-decision2 c) 4) 2 0)
                                                                    (if (= (create-decision2 c) 4) 2 0))
                                                  #:base-strength (+ 4 
                                                                    (cond
                                                                      [(= (create-decision1 c) 1) 1]
                                                                      [(= (create-decision1 c) 2) 2]
                                                                      [(= (create-decision1 c) 3) 1]
                                                                      [else 0])
                                                                    (if (= (create-decision2 c) 2) 2 0)
                                                                    (if (= (create-decision2 c) 1) 2 0))
                                                  #:strength (+ 4 
                                                                    (cond
                                                                      [(= (create-decision1 c) 1) 1]
                                                                      [(= (create-decision1 c) 2) 2]
                                                                      [(= (create-decision1 c) 3) 1]
                                                                      [else 0])
                                                                    (if (= (create-decision2 c) 2) 2 0)
                                                                    (if (= (create-decision2 c) 1) 2 0))
                                                  #:max-mp (+ 4 
                                                                    (if (= (create-decision2 c) 1) 2 0)
                                                                    (if (= (create-decision2 c) 2) 2 0))
                                                  #:mp (+ 4 
                                                                    (if (= (create-decision2 c) 1) 2 0)
                                                                    (if (= (create-decision2 c) 2) 2 0)))
                                            (dungeon-rooms TESTDUNGEON1)
                                            (dungeon-images TESTDUNGEON1)
                                            (dungeon-name TESTDUNGEON1)
                                            (dungeon-menu TESTDUNGEON1))]
                             [(key=? k "1") (make-create 6 (create-name c) (create-gender c)
                                        (create-decision1 c) (create-decision2 c) 1)]
                             [(key=? k "2") (make-create 6 (create-name c) (create-gender c)
                                        (create-decision1 c) (create-decision2 c) 2)]
                             [(key=? k "3") (make-create 6 (create-name c) (create-gender c)
                                        (create-decision1 c) (create-decision2 c) 3)]
                             [(key=? k "4") (make-create 6 (create-name c) (create-gender c)
                                        (create-decision1 c) (create-decision2 c) 4)]
                             [else c])]))
    
                              
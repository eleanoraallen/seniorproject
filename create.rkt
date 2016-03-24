#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require "combat.rkt")
(require "characters.rkt")
(require "spells.rkt")
(require "items.rkt")
(require "dungeons.rkt")
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
3 Fulfillment of your life long dream: +2 health
4 Thirst for Adventure: +2 agility
|#
;; a create is a (make-create int string symbol int int int)
(define-struct create (step name gender decision1 decision2 decision3))
(define STARTINGCREATE (make-create 1 "" 'm 0 0 0))

;;;;;;;;;;;;;;;;;;;;
(define WELCOME (overlay (text "Welcome. Create character." 20 'black) (square 400 'solid 'pink)))
(define GENDER (overlay (text "Choose Character's gender: Male, Female" 20 'black) (square 400 'solid 'pink)))
(define BS1 (overlay (above (text "Parents were:" 20 'black)
                            (text "farmers" 20 'black)
                            (text "Mercenaries" 20 'black)
                            (text "poachers" 20 'black)
                            (text "thieves" 20 'black)) (square 40 'solid 'pink)))
(define BS1a (square 400 'solid 'red))
(define BS1b (square 400 'solid 'blue))
(define BS1c (square 400 'solid 'green))
(define BS1d (square 400 'solid 'yellow))
(define BS2 (overlay (above (text "Childhood:" 20 'black)
                            (text "school" 20 'black)
                            (text "training" 20 'black)
                            (text "storekeeper" 20 'black)
                            (text "wanderer" 20 'black)) (square 40 'solid 'pink)))
(define BS2a (square 400 'solid 'red))
(define BS2b (square 400 'solid 'blue))
(define BS2c (square 400 'solid 'green))
(define BS2d (square 400 'solid 'yellow))
(define BS3 (overlay (above (text "Why Adventure?:" 20 'black)
                            (text "money and power" 20 'black)
                            (text "archain knowledge" 20 'black)
                            (text "your dreams" 20 'black)
                            (text "thirst for adventure" 20 'black)) (square 40 'solid 'pink)))
(define BS3a (square 400 'solid 'red))
(define BS3b (square 400 'solid 'blue))
(define BS3c (square 400 'solid 'green))
(define BS3d (square 400 'solid 'yellow))

;; render-create: create --> image
(define (render-create c)
  (cond
    [(= (create-step c) 1) WELCOME]
    [(= (create-step c) 2) (overlay (above (text "Enter Name:" 20 'black)
                                           (text (create-name c) 20 'black))
                                    (square 1000 'solid 'white))]
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
                                   (<= (length (explode (create-name c))) 12))
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
    
                              
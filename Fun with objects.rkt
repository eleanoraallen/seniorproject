#lang racket

(require 2htdp/image)
(require 2htdp/universe)

(define piece<%>
  (interface ()
    draw
    move))

(define chess-piece%
  (class* object% (piece<%>)
    (init-field x-position)
    (init-field y-position)
    (init-field type) ; symbol that is one of: 'K 'Q 'B 'Kn 'R 'P
    (init-field color) ; symbol that is one of: 'black 'white
    (define/public (draw bg)
      (place-image (render-piece type color) 
                   (+ (* x-position 10) 1)
                   (+ (* y-position 10) 1) bg))
    (define/public (move x y)
      (new chess-piece%
           [x-position x]
           [y-position y]))))

(define (render-piece type color)
  (local [(define (not-color c)
            (if (eq? c 'black) 'white 'black))
          (define PBG (overlay (circle 20 'solid color) (circle 23 'solid (not-color color))))
          (define (textify t) (text (symbol->string t) 20 'blue))]
    (overlay (textify type) PBG)))

;; note: this should have been done more elegantly...
(define BOARD (overlay (above
   (beside (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black))
   (beside (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white))
   (beside (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black))
   (beside (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white))
   (beside (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black))
   (beside (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white))
   (beside (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black) 
           (square 50 'solid 'white) (square 50 'solid 'black))
   (beside (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white)
           (square 50 'solid 'black) (square 50 'solid 'white))) (square 402 'solid 'black)))
           
(define black-king (new chess-piece%
                        [x-position 8]
                        [y-position 4]
                        [type 'K]
                        [color 'black]))

;; Error Message: instantiate: superclass initialization not invoked by initialization class name: chess-piece%

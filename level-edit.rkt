#lang racket
(require "combat.rkt")
(require "dungeons.rkt")
(require 2htdp/image)
(require 2htdp/universe)

;; a world is one of
;; level-editer
;; level-menu

(define-struct level-menu (x y tiles sym))
(define-struct level-editer (map tiles mp))

(define (render w)
  (cond
    [(level-menu? w) (overlay (above (text (string-append "tiles across: " (number->string (level-menu-x w))) 30 'black)
                                     (text (string-append "tiles down: " (number->string (level-menu-y w))) 30 'black)
                                     (beside (text  (string-append "base tile: " (send (first (level-menu-tiles w)) get-name) "      ") 30 'black)
                                             (send (first (level-menu-tiles w)) get-image))
                                     (if (eq? (level-menu-sym w) 'x) (text "now editing x value" 20 'black)
                                         (text "now editing y value" 20 'black)))
                              (rectangle 700 800 'solid 'white))]
    [(level-editer? w) (place-image (overlay (rectangle 2 15 'solid 'red)
                                (rectangle 15 2 'solid 'red))
                       (+ (/ (/ 700 (length (first (level-editer-map w)))) 2) (* (posn-x (level-editer-mp w)) (/ 700 (length (first (level-editer-map w))))))
                       (+ 100 (/ (/ 700 (length (level-editer-map w))) 2) (* (posn-y (level-editer-mp w)) (/ 700 (length (level-editer-map w)))))
                       (above
                        (overlay (beside
                                  (text (string-append "Selected tile: " (send (first (level-editer-tiles w)) get-name) "   ") 20 'black)
                                  (scale (/ 50 (image-width (send (first (level-editer-tiles w)) get-image))) (send (first (level-editer-tiles w)) get-image)))
                                 (rectangle 700 100 'solid 'gray))
                        (overlay (scale (/ 700 (image-width (tiles->image (level-editer-map w)))) (tiles->image (level-editer-map w)))
                                 (square 700 'solid 'white))))]
    [else (circle 20 'solid 'gold)]))


;; tiles->image: lolot --> image
;; takes a list of lists of tiles and renders them as an image
(define (tiles->image t)
  (cond
    [(empty? t) (square 0 'solid 'gold)]
    [(cons? t) (above (render-tile-row (first t))
                      (tiles->image (rest t)))]))

;; render-tile-row : list-of-tiles --> image
;; renders a list of tiles as one image by putting them beside eachother
(define (render-tile-row r)
  (cond
    [(empty? r) (square 0 'solid 'red)]
    [(cons? r) (beside (overlay (square (image-width (send (first r) get-image)) 'outline 'black)
                                (send (first r) get-image))
                       (render-tile-row (rest r)))]))

;; handle-key
(define (handle-key w k)
  (cond
    [(level-menu? w) (cond
                       [(or (key=? k "\r") (key=? k " ")) (make-level-editer (make-list (level-menu-y w) (make-list (level-menu-x w) (first (level-menu-tiles w))))
                                                                             (level-menu-tiles w) (make-posn 0 0))]
                       [(key=? k "\b") (make-level-menu 0 0 (level-menu-tiles w) (level-menu-sym w))]
                       [(or (key=? k "0") (key=? k "1") (key=? k "2") (key=? k "3") (key=? k "4") (key=? k "5") (key=? k "6") (key=? k "7") (key=? k "8") (key=? k "9"))
                        (if (eq? (level-menu-sym w) 'x)
                            (make-level-menu (string->number (string-append (number->string (level-menu-x w)) k))
                                             (level-menu-y w) (level-menu-tiles w) 'x)
                            (make-level-menu (level-menu-x w) (string->number (string-append (number->string (level-menu-y w)) k))
                                             (level-menu-tiles w) 'y))]
                       [(or (key=? k "up") (key=? k "down")) (make-level-menu (level-menu-x w) (level-menu-y w)
                                                                              (append (rest (level-menu-tiles w))
                                                                                            (list (first (level-menu-tiles w)))) (level-menu-sym w))]
                       [else (if (eq? (level-menu-sym w) 'x)
                                 (make-level-menu (level-menu-x w) (level-menu-y w) (level-menu-tiles w) 'y)
                                 (make-level-menu (level-menu-x w) (level-menu-y w) (level-menu-tiles w) 'x))])]
    [(level-editer? w)
     (cond
            [(key=? k "\r") (lot->los (level-editer-map w))]
            [(key=? k "w") (make-level-editer (level-editer-map w)
                                                                     (append (rest (level-editer-tiles w))
                                                                             (list (first (level-editer-tiles w))))
                                                                     (level-editer-mp w))]
            [(key=? k "s") (make-level-editer (level-editer-map w) (append (list (first (reverse (level-editer-tiles w))))
                                                                           (reverse (rest (reverse (level-editer-tiles w)))))
                                                                     (level-editer-mp w))]
            [(key=? k "up") (make-level-editer (level-editer-map w) (level-editer-tiles w) (make-posn (posn-x (level-editer-mp w))
                                               (- (posn-y (level-editer-mp w)) 1)))]
            [(key=? k "down") (make-level-editer (level-editer-map w) (level-editer-tiles w) (make-posn (posn-x (level-editer-mp w))
                                               (+ (posn-y (level-editer-mp w)) 1)))]
            [(key=? k "left") (make-level-editer (level-editer-map w) (level-editer-tiles w) (make-posn (- (posn-x (level-editer-mp w)) 1)
                                               (posn-y (level-editer-mp w))))]
            [(key=? k "right") (make-level-editer (level-editer-map w) (level-editer-tiles w) (make-posn (+ (posn-x (level-editer-mp w)) 1)
                                               (posn-y (level-editer-mp w))))]
            [(key=? k " ") (replace-tile w)]
            [else w])]
    [else w]))

(define (lot->los l)
  (cond
    [(empty? l) empty]
    [(cons? l) (cons (t->los (first l)) (lot->los (rest l)))]))

(define (t->los l)
  (cond
    [(empty? l) empty]
    [(cons? l) (cons (send (first l) get-name) (t->los (rest l)))]))

;; handle-mouse
#|
(define (handle-mouse w x y m)
  (cond
    [(eq? m "button-down") (replace-tile w)]
    [(level-editer? w) (make-level-editer (level-editer-map w) (level-editer-tiles w) (make-posn x y))]
    [else w]))
|#

(define (replace-tile w)
  (make-level-editer (append
                      (all-before (posn-y (level-editer-mp w)) (level-editer-map w))
                      (list (append (all-before (posn-x (level-editer-mp w)) (ith (posn-y (level-editer-mp w)) (level-editer-map w)))
                                    (list (first (level-editer-tiles w)))
                                    (all-after (posn-x (level-editer-mp w)) (ith (posn-y (level-editer-mp w)) (level-editer-map w)))))
                      (all-after (posn-y (level-editer-mp w)) (level-editer-map w)))
                     (level-editer-tiles w) (level-editer-mp w)))

(define (ith n l)
  (cond
    [(= n 0) (first l)]
    [else (ith (- n 1) (rest l))]))

(define (all-before n l)
  (cond
    [(= n 0) empty]
    [else (cons (first l) (all-before (- n 1) (rest l)))]))

(define (all-after n l)
  (cond
    [(= n 0) (rest l)]
    [else (all-after (- n 1) (rest l))]))

(define (main w)
  (big-bang w
            [to-draw render]
            [on-key handle-key]))

(main (make-level-menu 0 0 TILE-DIRECTORY 'x))